import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReviewService {
  static Box? _box;

  static Future<Box> _openBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }

    final deviceInfo = DeviceInfoPlugin();

    String serial = "unknown";

    if (defaultTargetPlatform == TargetPlatform.android) {
      final info = await deviceInfo.androidInfo;

      serial = info.id;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final info = await deviceInfo.iosInfo;

      serial = info.identifierForVendor ?? "ios";
    }

    _box = await Hive.openBox("review_$serial");

    return _box!;
  }

  static Future<void> increaseLaunchCount() async {
    final box = await _openBox();

    int count = box.get("launch_count", defaultValue: 0) + 1;

    await box.put("launch_count", count);

    box.put("install_date", () => DateTime.now().toIso8601String());
  }

  static Future<int> launchCount() async {
    final box = await _openBox();

    return box.get("launch_count", defaultValue: 0);
  }

  static Future<void> neverAskAgain() async {
    final box = await _openBox();

    await box.put("never_ask_again", true);
  }

  static Future<bool> isNeverAskAgain() async {
    final box = await _openBox();

    return box.get("never_ask_again", defaultValue: false);
  }

  static Future<void> markReviewRequested() async {
    final box = await _openBox();

    await box.put("review_requested", true);

    await box.put("last_request", DateTime.now().toIso8601String());
  }

  static Future<bool> wasReviewRequested() async {
    final box = await _openBox();

    return box.get("review_requested", defaultValue: false);
  }

  static Future<bool> shouldAskReview() async {
    final box = await _openBox();

    if (box.get("never_ask_again", defaultValue: false)) {
      return false;
    }

    if (box.get("review_requested", defaultValue: false)) {
      return false;
    }

    final launches = box.get("launch_count", defaultValue: 0);

    return launches >= 5;
  }
}
