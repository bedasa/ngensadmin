// Copyright 2020 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ngens/main.dart';

import 'scroll.dart';

const Duration _initialWaitingDuration = Duration(milliseconds: 1500);

const List<String> _demosWithAnimation = <String>[
  'progress-indicator@material',
  'cupertino-activity-indicator@cupertino',
];

const Duration _defaultWaitingDuration = Duration(seconds: 3);

enum DemoType {
  study,
  animatedWidget,
  unanimatedWidget,
}

DemoType typeOfDemo(String demo) {
  if (demo.contains('@study')) {
    return DemoType.study;
  } else if (_demosWithAnimation.contains(demo)) {
    return DemoType.animatedWidget;
  } else {
    return DemoType.unanimatedWidget;
  }
}

/// A class that automates the gallery.
class GalleryAutomator {
  GalleryAutomator({
    @required this.benchmarkName,
    this.shouldRunPredicate,
    this.testScrollsOnly = false,
    @required this.stopWarmingUpCallback,
  }) : assert(testScrollsOnly || shouldRunPredicate != null);

  /// The name of the current benchmark.
  final String benchmarkName;

  /// A function deciding whether a demo should be run in this benchmark.
  final bool Function(String) shouldRunPredicate;

  /// Whether we only test scrolling in this benchmark.
  final bool testScrollsOnly;

  /// A function to call when warm-up is finished.
  ///
  /// This function is intended to ask `Recorder` to mark the warm-up phase
  /// as over.
  final void Function() stopWarmingUpCallback;

  /// Whether the automation has ended.
  bool finished = false;

  /// A widget controller for automation.
  LiveWidgetController controller;

  /// The gallery widget, with automation.
  Widget createWidget() {
    // There is no `catchError` here, because all errors are caught by
    // the zone set up in `lib/web_benchmarks.dart` in `flutter/flutter`.
    Future<void>.delayed(
      _initialWaitingDuration,
      testScrollsOnly ? automateScrolls : automateDemoGestures,
    );
    return const GalleryApp();
  }

  /// Opens and quits demos that are specified by [shouldRunPredicate], twice.
  Future<void> automateDemoGestures() async {
    await warmUp();

    print('==== List of demos to be run ====');

    print('==== End of list of demos to be run ====');

    var finishedStudyDemos = false;

    print('All demos finished.');

    // At the end of the test, mark as finished.
    finished = true;
  }

  /// Scrolls various parts of the gallery.
  Future<void> automateScrolls() async {
    await warmUp();

    print('Running scrolling test.');

    var scrolled = false;

    print('Scrolling test finished.');
    finished = true;
  }

  /// Warm up the animation.
  Future<void> warmUp() async {
    print('Warming up.');

    // Let animation stop.
    await animationStops();

    // Set controller.
    controller = LiveWidgetController(WidgetsBinding.instance);
  }

  /// A function to find the category of a demo.
  String categoryOf(String demo) {
    final atSymbolIndex = demo.lastIndexOf('@');
    if (atSymbolIndex < 0) {
      return '';
    } else {
      return demo.substring(atSymbolIndex + 1);
    }
  }

  /// A function to find the first demo of each category.
  List<String> firstDemosOfCategories(Iterable<String> demoList) {
    // Select the first demo from each category.
    final coveredCategories = <String>{};
    final selectedDemos = <String>[];

    for (final demo in demoList) {
      final category = categoryOf(demo);
      if (!coveredCategories.contains(category)) {
        coveredCategories.add(category);
        selectedDemos.add(demo);
      }
    }

    return selectedDemos;
  }
}
