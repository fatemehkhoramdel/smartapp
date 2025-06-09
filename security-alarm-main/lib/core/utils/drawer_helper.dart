import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import '../constants/global_keys.dart';

/// Helper class to provide backward compatibility for drawer keys
class DrawerHelper {
  /// Get the current drawer key for a screen or fallback to a safe implementation
  static GlobalKey<SliderDrawerState> getDrawerKeyOrFallback(String screenName, BuildContext? context) {
    try {
      return getDrawerKey(screenName);
    } catch (e) {
      // Fallback to a new temporary key if something goes wrong
      return GlobalKey<SliderDrawerState>(debugLabel: 'FallbackKey-$screenName');
    }
  }

  /// Toggle the drawer safely, even if the key is not found
  static void toggleDrawerSafely(String screenName, [BuildContext? context]) {
    try {
      final key = getDrawerKey(screenName);
      if (key.currentState != null) {
        key.currentState!.toggle();
      }
    } catch (e) {
      // Silent fallback - just don't toggle if there's an issue
      debugPrint('Error toggling drawer: $e');
    }
  }
} 