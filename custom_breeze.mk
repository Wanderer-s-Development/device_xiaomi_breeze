#
# Copyright (C) 2023 The Android Open Source Project
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

# Inherit common PixelOS configurations
$(call inherit-product, vendor/custom/config/common_full_phone.mk)

TARGET_SCREEN_WIDTH := 1080

## Device identifier
PRODUCT_DEVICE := breeze
PRODUCT_NAME := custom_breeze
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := 2406ERN9CI
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="breeze_in-user 16 BP2A.250605.031.A3 OS3.0.303.0.WNUINXM release-keys" \
    BuildFingerprint=Redmi/breeze_in/breeze:16/BP2A.250605.031.A3/OS3.0.303.0.WNUINXM:user/release-keys \
    DeviceName=breeze \
    DeviceProduct=breeze_in

# GMS
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# Quick Settings Dialogs
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.qs_bt_show_dialog=1 \
    persist.sys.qs_data_show_dialog=1
