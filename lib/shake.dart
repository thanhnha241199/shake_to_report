library shake;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'report_screen.dart';

/// ShakeDetector class for phone shake functionality
class ShakeDetector {
  /// User callback for phone shake
  final Function(List<XFile> images, String reason) onReport;

  /// Shake detection threshold
  final double shakeThresholdGravity;

  /// Minimum time between shake
  final int shakeSlopTimeMS;

  /// Time before shake count resets
  final int shakeCountResetTime;

  /// Number of shakes required before shake is triggered
  final int minimumShakeCount;

  int mShakeTimestamp = DateTime.now().millisecondsSinceEpoch;
  int mShakeCount = 0;

  /// StreamSubscription for Accelerometer events
  StreamSubscription? streamSubscription;

  /// This constructor waits until [startListening] is called
  ShakeDetector.waitForStart({
    required this.onReport,
    this.shakeThresholdGravity = 2.7,
    this.shakeSlopTimeMS = 500,
    this.shakeCountResetTime = 3000,
    this.minimumShakeCount = 1,
  });

  /// Starts listening to accelerometer events
  void startListening(BuildContext context) {
    streamSubscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        double x = event.x;
        double y = event.y;
        double z = event.z;

        double gX = x / 9.80665;
        double gY = y / 9.80665;
        double gZ = z / 9.80665;

        // gForce will be close to 1 when there is no movement.
        double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

        if (gForce > shakeThresholdGravity) {
          var now = DateTime.now().millisecondsSinceEpoch;
          // ignore shake events too close to each other (500ms)
          if (mShakeTimestamp + shakeSlopTimeMS > now) {
            return;
          }

          // reset the shake count after 3 seconds of no shakes
          if (mShakeTimestamp + shakeCountResetTime < now) {
            mShakeCount = 0;
          }

          mShakeTimestamp = now;
          mShakeCount++;

          if (mShakeCount >= minimumShakeCount) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => ReportScreen(onReport: onReport),
              ),
            );
          }
        }
      },
    );
  }

  /// Stops listening to accelerometer events
  void stopListening() {
    streamSubscription?.cancel();
  }
}
