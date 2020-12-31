// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:ngens/layout/adaptive.dart';
import 'package:ngens/colors.dart';
import 'package:ngens/models/root.dart';

import '../app.dart';

class MastersView extends StatefulWidget {
  @override
  _MastersViewState createState() => _MastersViewState();
}

class _MastersViewState extends State<MastersView> {
  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Container(
        padding: EdgeInsets.only(top: isDisplayDesktop(context) ? 24 : 0),
        child: ListView(
          shrinkWrap: true,
          children: [
            for (String title in Root.getMastersTitles()) ...[
              _MastersItem(title),
              const Divider(
                color: RallyColors.dividerColor,
                height: 1,
              )
            ]
          ],
        ),
      ),
    );
  }
}

class _MastersItem extends StatelessWidget {
  const _MastersItem(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: RallyColors.primaryBackground,
        padding: EdgeInsets.zero,
      ),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
        child: Text(title),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(RallyApp.masterRoute, arguments: title);
      },
    );
  }
}
