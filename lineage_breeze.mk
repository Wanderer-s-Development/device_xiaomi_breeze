#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Configure core_64_bit.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Configure full_base_telephony.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit common lineage configurations
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

$(call inherit-product, vendor/lineage/config/BoardConfigReservedSize.mk)

# Inherit device configurations
$(call inherit-product, device/xiaomi/breeze/device.mk)

# Inherit from the proprietary version
$(call inherit-product, vendor/xiaomi/breeze/breeze-vendor.mk)

## Device identifier
PRODUCT_DEVICE := breeze
PRODUCT_NAME := lineage_breeze
PRODUCT_BRAND := POCO
PRODUCT_MODEL := 24066PC95I
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="breeze-user 15 AQ3A.240912.001 OS2.0.201.0.VNUINXM release-keys" \
    BuildFingerprint=POCO/breeze_p_in/breeze:15/AQ3A.240912.001/OS2.0.201.0.VNUINXM:user/release-keys \
    DeviceName=breeze \
    DeviceProduct=breeze_p_in

# GMS
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
