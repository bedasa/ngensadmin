// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
 DocumentList documentList = DocumentList('Tasker', labels: {
    'Complete': 'done?',
    'Date': 'date',
    'Task': 'title',
    'Priority': 'pri count',
    'Note': 'subtitle'
  });
   
  @override
  Widget build(BuildContext context) {
    return  DocumentListScaffold(documentList);
  }
}



// class _SettingsItem extends StatelessWidget {
//   const _SettingsItem(this.title);

//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       style: TextButton.styleFrom(
//         primary: Colors.white,
//         padding: EdgeInsets.zero,
//       ),
//       child: Container(
//         alignment: AlignmentDirectional.centerStart,
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
//         child: Text(title),
//       ),
//       onPressed: () {
//         Navigator.of(context).pushNamed(RallyApp.loginRoute);
//       },
//     );
//   }
// }
