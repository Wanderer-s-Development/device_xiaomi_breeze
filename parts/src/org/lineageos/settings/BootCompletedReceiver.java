/*
 * Copyright (C) 2026 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package org.lineageos.settings;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import org.lineageos.settings.proximity.TouchProximityService;

public class BootCompletedReceiver extends BroadcastReceiver {
    private static final String TAG = "XiaomiParts";

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.i(TAG, "Received broadcast: " + (intent != null ? intent.getAction() : "null"));
        Intent serviceIntent = new Intent(context, TouchProximityService.class);
        context.startService(serviceIntent);
    }
}
