#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/custom_breeze.mk \
    $(LOCAL_DIR)/halcyon_breeze.mk \
    $(LOCAL_DIR)/infinity_breeze.mk \
    $(LOCAL_DIR)/lineage_breeze.mk \
    $(LOCAL_DIR)/rising_breeze.mk

COMMON_LUNCH_CHOICES := \
    custom_breeze-cp2a-user \
    custom_breeze-cp2a-userdebug \
    halcyon_breeze-cp2a-user \
    halcyon_breeze-cp2a-userdebug \
    halcyon_breeze-bp4a-user \
    halcyon_breeze-bp4a-userdebug \
    infinity_breeze-user \
    lineage_breeze-user \
    lineage_breeze-userdebug \
    rising_breeze-cp2a-user \
    rising_breeze-cp2a-userdebug
