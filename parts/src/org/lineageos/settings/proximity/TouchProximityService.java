/*
 * Copyright (C) 2026 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package org.lineageos.settings.proximity;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.os.IBinder;
import android.telephony.TelephonyCallback;
import android.telephony.TelephonyManager;
import android.util.Log;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.Executor;

public class TouchProximityService extends Service {
    private static final String TAG = "TouchProximityService";
    private static final String PROXIMITY_SWITCH_NODE = "/proc/touchscreen/proximity_switch";

    private AudioManager mAudioManager;
    private TelephonyManager mTelephonyManager;

    private boolean mInCall = false;
    private boolean mInAudioCommunication = false;
    private boolean mProximityEnabled = false;

    private final AudioManager.OnModeChangedListener mModeListener = new AudioManager.OnModeChangedListener() {
        @Override
        public void onModeChanged(int mode) {
            updateAudioMode(mode);
        }
    };

    private class CallStateListenerCompat extends TelephonyCallback implements TelephonyCallback.CallStateListener {
        @Override
        public void onCallStateChanged(int state) {
            updateCallState(state);
        }
    }

    private CallStateListenerCompat mCallStateListener;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(TAG, "Starting TouchProximityService");

        mAudioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        mTelephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);

        Executor executor = getMainExecutor();

        if (mAudioManager != null) {
            mAudioManager.addOnModeChangedListener(executor, mModeListener);
            updateAudioMode(mAudioManager.getMode());
        }

        if (mTelephonyManager != null) {
            mCallStateListener = new CallStateListenerCompat();
            mTelephonyManager.registerTelephonyCallback(executor, mCallStateListener);
            updateCallState(mTelephonyManager.getCallState());
        }
    }

    private synchronized void updateAudioMode(int mode) {
        boolean inCommunication = (mode == AudioManager.MODE_IN_CALL
                || mode == AudioManager.MODE_IN_COMMUNICATION
                || mode == AudioManager.MODE_RINGTONE);
        Log.d(TAG, "Audio mode updated: " + mode + " (inCommunication=" + inCommunication + ")");
        if (mInAudioCommunication != inCommunication) {
            mInAudioCommunication = inCommunication;
            evaluateProximitySwitch();
        }
    }

    private synchronized void updateCallState(int state) {
        boolean inCall = (state == TelephonyManager.CALL_STATE_OFFHOOK
                || state == TelephonyManager.CALL_STATE_RINGING);
        Log.d(TAG, "Call state updated: " + state + " (inCall=" + inCall + ")");
        if (mInCall != inCall) {
            mInCall = inCall;
            evaluateProximitySwitch();
        }
    }

    private synchronized void evaluateProximitySwitch() {
        boolean shouldEnable = mInCall || mInAudioCommunication;
        if (mProximityEnabled != shouldEnable) {
            mProximityEnabled = shouldEnable;
            setProximitySwitch(shouldEnable);
        }
    }

    private static void setProximitySwitch(boolean enable) {
        String value = enable ? "1" : "0";
        try (FileOutputStream fos = new FileOutputStream(PROXIMITY_SWITCH_NODE)) {
            fos.write(value.getBytes(StandardCharsets.UTF_8));
            fos.flush();
            Log.i(TAG, "Successfully wrote " + value + " to " + PROXIMITY_SWITCH_NODE);
        } catch (IOException e) {
            Log.e(TAG, "Failed to write " + value + " to " + PROXIMITY_SWITCH_NODE + ": " + e.getMessage());
        }
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        Log.i(TAG, "Destroying TouchProximityService");
        if (mAudioManager != null) {
            mAudioManager.removeOnModeChangedListener(mModeListener);
        }
        if (mTelephonyManager != null && mCallStateListener != null) {
            mTelephonyManager.unregisterTelephonyCallback(mCallStateListener);
        }
        setProximitySwitch(false);
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
