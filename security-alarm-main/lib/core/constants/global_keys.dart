import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

/// Global keys
// Remove the single global drawer key and replace with a factory
Map<String, GlobalKey<SliderDrawerState>> _drawerKeys = {};

// Get a unique drawer key for each screen
GlobalKey<SliderDrawerState> getDrawerKey(String screenName) {
  if (!_drawerKeys.containsKey(screenName)) {
    _drawerKeys[screenName] = GlobalKey<SliderDrawerState>(debugLabel: 'DrawerKey-$screenName');
  }
  return _drawerKeys[screenName]!;
}

List<GlobalKey<ExpansionTileCardState>> kHomePageExpansionKeys = [];
GlobalKey<NavigatorState> kNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
