#
# Copyright (C) 2023 The Android Open Source Project
# Copyright (C) 2026 WandererOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/wanderer_breeze.mk \
    $(LOCAL_DIR)/clover_breeze.mk \
    $(LOCAL_DIR)/halcyon_breeze.mk \
    $(LOCAL_DIR)/infinity_breeze.mk \
    $(LOCAL_DIR)/lineage_breeze.mk

COMMON_LUNCH_CHOICES := \
    wanderer_breeze-trunk_staging-userdebug \
    wanderer_breeze-trunk_staging-user \
    clover_breeze-cp2a-user \
    clover_breeze-cp2a-userdebug \
    halcyon_breeze-cp2a-user \
    halcyon_breeze-cp2a-userdebug \
    halcyon_breeze-bp4a-user \
    halcyon_breeze-bp4a-userdebug \
    infinity_breeze-user \
    lineage_breeze-user \
    lineage_breeze-userdebug
