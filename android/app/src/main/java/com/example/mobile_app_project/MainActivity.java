package com.example.mobile_app_project;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.flutter.crypto/crypto";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("Printy")) {
                                result.success(Printy());
//                                int batteryLevel = getBatteryLevel();
//
//                                if (batteryLevel != -1) {
//                                    result.success(batteryLevel);
//                                } else {
//                                    result.error("UNAVAILABLE", "Battery level not available.", null);
//                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private String Printy(){
        return "Yoooo";
    }
}
