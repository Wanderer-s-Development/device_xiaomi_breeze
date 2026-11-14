#
# Copyright (C) 2026 WandererOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Configure core_64_bit.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Configure full_base_telephony.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Target device identifier
WANDERER_BUILD := breeze

# Inherit WandererOS common configuration (incorporates vendor_gapps, strips AudioFX/Eleven)
$(call inherit-product, vendor/wanderer/config/common_full_phone.mk)
$(call inherit-product, vendor/wanderer/config/BoardConfigReservedSize.mk)

# Inherit device configurations
$(call inherit-product, device/xiaomi/breeze/device.mk)

# Inherit proprietary vendor blobs
$(call inherit-product, vendor/xiaomi/breeze/breeze-vendor.mk)

## Device identifier
PRODUCT_DEVICE := breeze
PRODUCT_NAME := wanderer_breeze
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := 2406ERN9CI
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="breeze_in-user 14 UKQ1.231003.002 V816.0.4.0.UNUINXM release-keys" \
    BuildFingerprint=Redmi/breeze_in/breeze:14/UKQ1.231003.002/V816.0.4.0.UNUINXM:user/release-keys \
    DeviceName=breeze \
    DeviceProduct=breeze_in

# GMS Client ID
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# Quick Settings Dialogs
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.qs_bt_show_dialog=1 \
    persist.sys.qs_data_show_dialog=1
