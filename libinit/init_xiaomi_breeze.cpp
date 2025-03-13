/*
 * Copyright (C) 2021-2022 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libinit_variant.h>
#include <libinit_utils.h>

#include "vendor_init.h"

#define FINGERPRINT_POCO_IN "POCO/breeze_p_in/breeze:15/AQ3A.240912.001/OS2.0.3.0.VNUINXM:user/release-keys"
#define FINGERPRINT_REDMI_IN "Redmi/breeze_in/breeze:15/AQ3A.240912.001/OS2.0.3.0.VNUINXM:user/release-keys"
#define FINGERPRINT_CHINA "Redmi/breeze/breeze:15/AQ3A.240912.001/OS2.0.3.0.VNUINXM:user/release-keys"

static const variant_info_t breeze_poco_info = {
    .hwc_value = "India",

    .brand = "POCO",
    .device = "breeze",
    .marketname = "POCO M6 Plus 5G",
    .model = "24066PC95I",
    .mod_device = "breeze_global",
    .build_fingerprint = FINGERPRINT_POCO_IN,
};

static const variant_info_t breeze_redmi_info = {
    .hwc_value = "India",

    .brand = "Redmi",
    .device = "breeze",
    .marketname = "Redmi 13 5G",
    .model = "2406ERN9CI",
    .mod_device = "breeze_global",
    .build_fingerprint = FINGERPRINT_REDMI_IN,
};

static const variant_info_t breeze_china_info = {
    .hwc_value = "CN",

    .brand = "Redmi",
    .device = "breeze",
    .marketname = "Redmi Note 13R",
    .model = "2406ERN9CC",
    .mod_device = "breeze_global",
    .build_fingerprint = FINGERPRINT_CHINA,
};

static const std::vector<variant_info_t> variants = {
    breeze_poco_info,
    breeze_redmi_info,
    breeze_china_info,
};

void vendor_load_properties() {
    search_variant(variants);
}
