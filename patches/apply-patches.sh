#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2026 Project Infinity-X
# SPDX-License-Identifier: Apache-2.0
#
# Automated patch applicator for Xiaomi Breeze (Redmi 13 5G / POCO M6 Plus 5G)
# Supports: Infinity-X, crDroid, LineageOS, PixelOS, RisingOS
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
if [[ "$(basename "${SCRIPT_DIR}")" == "patches" ]]; then
    PATCHES_ROOT="${SCRIPT_DIR}"
else
    PATCHES_ROOT="${SCRIPT_DIR}/patches"
fi
ANDROID_BUILD_TOP="$(cd "${PATCHES_ROOT}/../../../.." && pwd)"

# Detect target ROM profile: argument, environment variable, or source tree detection
ROM_TARGET="${1:-}"

if [ -z "${ROM_TARGET}" ]; then
    if [ -n "${INFINITY_BUILD}" ] || [ -d "${ANDROID_BUILD_TOP}/vendor/infinity" ]; then
        ROM_TARGET="infinityx"
    elif [ -n "${CRDROID_BUILD}" ] || [ -d "${ANDROID_BUILD_TOP}/vendor/crdroid-priv" ] || [ -d "${ANDROID_BUILD_TOP}/vendor/crDroidOTA" ]; then
        ROM_TARGET="crdroid"
    elif [ -n "${CUSTOM_BUILD}" ] || [ -d "${ANDROID_BUILD_TOP}/vendor/custom" ] || [ -d "${ANDROID_BUILD_TOP}/vendor/pixel" ]; then
        ROM_TARGET="pixelos"
    elif [ -d "${ANDROID_BUILD_TOP}/vendor/rising" ]; then
        ROM_TARGET="risingos"
    elif [ -n "${LINEAGE_BUILD}" ] || [ -d "${ANDROID_BUILD_TOP}/vendor/lineage" ]; then
        ROM_TARGET="lineage"
    else
        echo "[!] No ROM specified and could not auto-detect."
        echo "    Usage: $0 [crdroid|infinityx|lineage|pixelos|risingos|all]"
        exit 1
    fi
fi

echo "=========================================================="
echo " Applying Patches for Xiaomi Breeze"
echo " Target ROM : ${ROM_TARGET}"
echo " Build Root : ${ANDROID_BUILD_TOP}"
echo " Patches Dir: ${PATCHES_ROOT}"
echo "=========================================================="

applied=0
skipped=0
failed=0

apply_patch_dir() {
    local patch_subdir="$1"
    local target_rel="$2"
    local target_repo="${ANDROID_BUILD_TOP}/${target_rel}"

    if [ ! -d "${patch_subdir}" ]; then
        return 0
    fi

    if [ ! -d "${target_repo}" ]; then
        echo "[-] Skipping ${target_rel}: Target directory ${target_repo} does not exist"
        return 0
    fi

    echo "[*] Repository: ${target_rel}"

    for patch_file in "${patch_subdir}"/*.patch; do
        [ -e "${patch_file}" ] || continue
        local patch_name="$(basename "${patch_file}")"

        if git -C "${target_repo}" apply --check --reverse "${patch_file}" >/dev/null 2>&1; then
            echo "    [ALREADY APPLIED] ${patch_name}"
            skipped=$((skipped + 1))
            continue
        fi

        if git -C "${target_repo}" apply --check "${patch_file}" >/dev/null 2>&1; then
            if git -C "${target_repo}" am -3 "${patch_file}" >/dev/null 2>&1; then
                echo "    [APPLIED via git am] ${patch_name}"
                applied=$((applied + 1))
            elif git -C "${target_repo}" apply "${patch_file}" >/dev/null 2>&1; then
                echo "    [APPLIED via git apply] ${patch_name}"
                applied=$((applied + 1))
            else
                echo "    [FAILED] ${patch_name}"
                failed=$((failed + 1))
            fi
        else
            echo "    [CONFLICT / CANNOT APPLY] ${patch_name}"
            failed=$((failed + 1))
        fi
    done
}

apply_patch_folder() {
    local target_flavor="$1"
    local flavor_dir="${PATCHES_ROOT}/${target_flavor}"

    applied=0
    skipped=0
    failed=0

    echo ""
    echo ">>> Applying [${target_flavor}] patches..."

    # Common ConsumerIr patch applies to all supported ROMs
    apply_patch_dir "${PATCHES_ROOT}/common/hardware_lineage_interfaces" "hardware/lineage/interfaces"

    if [ "${target_flavor}" == "infinityx" ]; then
        apply_patch_dir "${PATCHES_ROOT}/common/system_update_engine" "system/update_engine"
        apply_patch_dir "${flavor_dir}/device_lineage_sepolicy" "device/lineage/sepolicy"
        apply_patch_dir "${flavor_dir}/frameworks_base" "frameworks/base"
        apply_patch_dir "${flavor_dir}/packages_apps_Settings" "packages/apps/Settings"
        apply_patch_dir "${flavor_dir}/packages_apps_WallpaperPicker2" "packages/apps/WallpaperPicker2"
        apply_patch_dir "${flavor_dir}/vendor_extras" "vendor/extras"
        apply_patch_dir "${flavor_dir}/vendor_infinity" "vendor/infinity"
        apply_patch_dir "${flavor_dir}/vendor_pixel_gms" "vendor/pixel/gms"
        apply_patch_dir "${flavor_dir}/vendor_pixel_sounds" "vendor/pixel/sounds"
        apply_patch_dir "${flavor_dir}/vendor_pixel_themepicker" "vendor/pixel/themepicker"
    elif [ "${target_flavor}" == "lineage" ]; then
        apply_patch_dir "${PATCHES_ROOT}/common/system_update_engine" "system/update_engine"
        apply_patch_dir "${flavor_dir}/bootable_recovery" "bootable/recovery"
    fi

    echo "--- Summary [${target_flavor}]: ${applied} applied, ${skipped} already applied, ${failed} failed ---"
    if [ ${failed} -gt 0 ]; then
        return 1
    fi
    return 0
}

case "${ROM_TARGET}" in
    crdroid|infinityx|lineage|pixelos|risingos)
        apply_patch_folder "${ROM_TARGET}"
        ;;
    all)
        for flavor in crdroid infinityx lineage pixelos risingos; do
            apply_patch_folder "${flavor}"
        done
        ;;
    *)
        echo "[!] Unknown target: ${ROM_TARGET}"
        echo "    Valid options: crdroid, infinityx, lineage, pixelos, risingos, all"
        exit 1
        ;;
esac

echo ""
echo "=========================================================="
echo " Patch application process completed successfully!"
echo "=========================================================="
