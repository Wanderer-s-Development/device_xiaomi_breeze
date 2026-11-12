/*
 * Copyright (C) 2026 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package org.lineageos.settings;

import android.app.Application;
import android.content.Intent;
import android.util.Log;

import org.lineageos.settings.proximity.TouchProximityService;

public class XiaomiPartsApplication extends Application {
    private static final String TAG = "XiaomiParts";

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(TAG, "Initializing XiaomiPartsApplication...");
        Intent serviceIntent = new Intent(this, TouchProximityService.class);
        startService(serviceIntent);
    }
}
