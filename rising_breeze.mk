#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Configure core_64_bit.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Configure full_base_telephony.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Builder / Maintainer
BUILD_USERNAME := Wanderer

# Inherit device configurations
$(call inherit-product, device/xiaomi/breeze/device.mk)

# Inherit from the proprietary version
$(call inherit-product, vendor/xiaomi/breeze/breeze-vendor.mk)

# Inherit common Lineage / RisingOS configurations
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

## Device identifier
PRODUCT_DEVICE := breeze
PRODUCT_NAME := rising_breeze
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

# Quick Settings Dialogs
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.qs_bt_show_dialog=1 \
    persist.sys.qs_data_show_dialog=1

# RisingOS Specific Flags
RISING_MAINTAINER := Wanderer
PRODUCT_BUILD_PROP_OVERRIDES += \
    RisingChipset="Snapdragon 4 Gen 2 AE" \
    RisingMaintainer="Wanderer"

# GApps: Pico / Core
WITH_GMS := true
TARGET_USES_PICO_GAPPS := true
TARGET_CORE_GMS := true

# Camera: Aperture
PRODUCT_NO_CAMERA := false
PRODUCT_PACKAGES += \
    Aperture

# Display & Features
TARGET_ENABLE_BLUR := true
TARGET_HAS_UDFPS := false
