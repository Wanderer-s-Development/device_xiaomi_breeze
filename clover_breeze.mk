#
# Copyright (C) 2024-2026 The LineageOS Project
# Copyright (C) 2025-2026 The Clover Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Configure core_64_bit.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Configure full_base_telephony.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Clover target device
CLOVER_BUILD := breeze

# Core GApps configuration matching Infinity-X profile
TARGET_CORE_GAPPS := true

# Inherit common Clover configurations
$(call inherit-product, vendor/clover/config/common_full_phone.mk)
$(call inherit-product, vendor/clover/config/BoardConfigReservedSize.mk)

# Inherit device configurations
$(call inherit-product, device/xiaomi/breeze/device.mk)

# Inherit from the proprietary version
$(call inherit-product, vendor/xiaomi/breeze/breeze-vendor.mk)

# Ensure clean app bundle matching Infinity-X profile
PRODUCT_PACKAGES += \
    DeskClock \
    ExactCalculator \
    LatinIME \
    libjni_latinime \
    ThemePicker \
    WallpaperPicker2 \
    Photos \
    CloverUpdaterOverlayBreeze

## Device identifier
PRODUCT_DEVICE := breeze
PRODUCT_NAME := clover_breeze
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := 2406ERN9CI
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="breeze_in-user 16 BP2A.250605.031.A3 OS3.0.303.0.WNUINXM release-keys" \
    BuildFingerprint=Redmi/breeze_in/breeze:16/BP2A.250605.031.A3/OS3.0.303.0.WNUINXM:user/release-keys \
    DeviceName=breeze \
    DeviceProduct=breeze_in

# GMS Client ID
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
