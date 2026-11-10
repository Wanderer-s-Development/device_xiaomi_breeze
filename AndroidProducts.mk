#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/halcyon_breeze.mk \
    $(LOCAL_DIR)/infinity_breeze.mk \
    $(LOCAL_DIR)/lineage_breeze.mk

COMMON_LUNCH_CHOICES := \
    halcyon_breeze-bp4a-user \
    halcyon_breeze-bp4a-userdebug \
    infinity_breeze-user
