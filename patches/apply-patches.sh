#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2026 Project Infinity-X & The Clover Project
# SPDX-License-Identifier: Apache-2.0
#
# Automated patch applicator for Xiaomi Breeze (Redmi 13 5G / POCO M6 Plus 5G)
# Supports: Clover and Infinity-X
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
    if [ -n "${CLOVER_BUILD}" ] || [ -d "${ANDROID_BUILD_TOP}/vendor/clover" ]; then
        ROM_TARGET="clover"
    elif [ -n "${INFINITY_BUILD}" ] || [ -d "${ANDROID_BUILD_TOP}/vendor/infinity" ]; then
        ROM_TARGET="infinityx"
    elif [ -n "${LINEAGE_BUILD}" ] || [ -d "${ANDROID_BUILD_TOP}/vendor/lineage" ]; then
        ROM_TARGET="lineage"
    else
        echo "[!] No ROM specified and could not auto-detect."
        echo "    Usage: $0 [clover|infinityx|lineage|all]"
        exit 1
    fi
fi

echo "=========================================================="
echo " Applying Patches for Xiaomi Breeze"
echo " Target ROM : ${ROM_TARGET}"
echo " Build Root : ${ANDROID_BUILD_TOP}"
echo " Patches Dir: ${PATCHES_ROOT}"
echo "=========================================================="

apply_patch_folder() {
    local target_flavor="$1"
    local flavor_dir="${PATCHES_ROOT}/${target_flavor}"

    if [ ! -d "${flavor_dir}" ]; then
        echo "[-] Flavor directory ${flavor_dir} not found, skipping."
        return 0
    fi

    echo ""
    echo ">>> Applying [${target_flavor}] patches..."

    declare -A PATCH_MAP=()

    if [ "${target_flavor}" == "clover" ]; then
        PATCH_MAP=(
            ["hardware_clover_interfaces"]="hardware/clover/interfaces"
            ["system_update_engine"]="system/update_engine"
            ["vendor_pixel_gms"]="vendor/pixel/gms"
            ["vendor_pixel_sounds"]="vendor/pixel/sounds"
            ["vendor_pixel_themepicker"]="vendor/pixel/themepicker"
            ["vendor_prebuilts"]="vendor/prebuilts"
        )
    elif [ "${target_flavor}" == "infinityx" ]; then
        PATCH_MAP=(
            ["frameworks_base"]="frameworks/base"
            ["hardware_lineage_interfaces"]="hardware/lineage/interfaces"
            ["packages_apps_Settings"]="packages/apps/Settings"
            ["packages_apps_WallpaperPicker2"]="packages/apps/WallpaperPicker2"
            ["system_update_engine"]="system/update_engine"
            ["vendor_extras"]="vendor/extras"
            ["vendor_infinity"]="vendor/infinity"
            ["vendor_pixel_gms"]="vendor/pixel/gms"
            ["vendor_pixel_sounds"]="vendor/pixel/sounds"
            ["vendor_pixel_themepicker"]="vendor/pixel/themepicker"
        )
    elif [ "${target_flavor}" == "lineage" ]; then
        PATCH_MAP=(
            ["hardware_lineage_interfaces"]="hardware/lineage/interfaces"
        )
    fi

    local applied=0
    local skipped=0
    local failed=0

    for dir_key in "${!PATCH_MAP[@]}"; do
        local target_repo="${ANDROID_BUILD_TOP}/${PATCH_MAP[$dir_key]}"
        local patch_subdir="${flavor_dir}/${dir_key}"

        if [ ! -d "${target_repo}" ]; then
            echo "[-] Skipping ${dir_key}: Target directory ${target_repo} does not exist"
            continue
        fi

        if [ ! -d "${patch_subdir}" ]; then
            continue
        fi

        echo "[*] Repository: ${PATCH_MAP[$dir_key]}"

        for patch_file in "${patch_subdir}"/*.patch; do
            [ -e "${patch_file}" ] || continue
            local patch_name="$(basename "${patch_file}")"

            # Check if already applied (reverse applies cleanly)
            if git -C "${target_repo}" apply --check --reverse "${patch_file}" >/dev/null 2>&1; then
                echo "    [ALREADY APPLIED] ${patch_name}"
                skipped=$((skipped + 1))
                continue
            fi

            # Check if can apply forward
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
    done

    echo "--- Summary [${target_flavor}]: ${applied} applied, ${skipped} already applied, ${failed} failed ---"
    if [ ${failed} -gt 0 ]; then
        return 1
    fi
    return 0
}

case "${ROM_TARGET}" in
    clover)
        apply_patch_folder "clover"
        ;;
    infinityx)
        apply_patch_folder "infinityx"
        ;;
    lineage)
        apply_patch_folder "lineage"
        ;;
    all)
        apply_patch_folder "clover"
        apply_patch_folder "infinityx"
        apply_patch_folder "lineage"
        ;;
    *)
        echo "[!] Unknown target: ${ROM_TARGET}"
        echo "    Valid options: clover, infinityx, lineage, all"
        exit 1
        ;;
esac

echo ""
echo "=========================================================="
echo " Patch application process completed successfully!"
echo "=========================================================="
