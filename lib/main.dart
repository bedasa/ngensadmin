// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngens/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ngens/models/user.dart';
import 'package:ngens/models/organization.dart';

Future<void> main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const RallyApp());
  await initializeDB();
}

Future initializeDB() async {
  await Firebase.initializeApp();
  var timestamp = DateTime.now();
  //orgid = 629bd30a-0e4f-5a81-bc9e-6fafd44dc2e6
  //userid =27f35724-0560-5b3c-b415-2ebe54b3c8ad

  var superadmin = User(
      id: '27f35724-0560-5b3c-b415-2ebe54b3c8ad',
      orgId: '629bd30a-0e4f-5a81-bc9e-6fafd44dc2e6',
      context: 'en-US',
      createdBy: 'system',
      createdTime: timestamp,
      lastUpdatedBy: 'system',
      lastUpdatedTime: timestamp,
      bio: '',
      displayName: 'Beda',
      email: 'beda@xnihilo.co.in',
      photoUrl: '',
      username: 'bedasa');

  var opsOrg = Organization(
      id: '629bd30a-0e4f-5a81-bc9e-6fafd44dc2e6',
      orgId: '629bd30a-0e4f-5a81-bc9e-6fafd44dc2e6',
      context: 'en-US',
      createdBy: 'system',
      createdTime: timestamp,
      lastUpdatedBy: 'system',
      lastUpdatedTime: timestamp,
      displayName: 'XnihiloOps',
      logoUrl: '',
      email: 'support@xnihilo.co.in',
      name: 'xnihilo');
  superadmin = await superadmin.getById();
  opsOrg = await opsOrg.getById();
  if (!superadmin.exists || !opsOrg.exists) {
    await superadmin.upsert();
    await opsOrg.upsert();
  }
}

// class GalleryApp extends StatelessWidget {
//   const GalleryApp({
//     Key key,
//     this.initialRoute,
//     this.isTestMode = false,
//   }) : super(key: key);

//   final bool isTestMode;
//   final String initialRoute;

//   @override
//   Widget build(BuildContext context) {
//     return ModelBinding(
//       initialModel: GalleryOptions(
//         themeMode: ThemeMode.system,
//         textScaleFactor: systemTextScaleFactorOption,
//         customTextDirection: CustomTextDirection.localeBased,
//         locale: null,
//         timeDilation: timeDilation,
//         platform: defaultTargetPlatform,
//         isTestMode: isTestMode,
//       ),
//       child: Builder(
//         builder: (context) {
//           return MaterialApp(
//             restorationScopeId: 'rootGallery',
//             title: 'Flutter Gallery',
//             debugShowCheckedModeBanner: false,
//             themeMode: GalleryOptions.of(context).themeMode,
//             theme: GalleryThemeData.lightThemeData.copyWith(
//               platform: GalleryOptions.of(context).platform,
//             ),
//             darkTheme: GalleryThemeData.darkThemeData.copyWith(
//               platform: GalleryOptions.of(context).platform,
//             ),
//             localizationsDelegates: const [
//               ...GalleryLocalizations.localizationsDelegates,
//               LocaleNamesLocalizationsDelegate()
//             ],
//             initialRoute: initialRoute,
//             supportedLocales: GalleryLocalizations.supportedLocales,
//             locale: GalleryOptions.of(context).locale,
//             localeResolutionCallback: (locale, supportedLocales) {
//               deviceLocale = locale;
//               return locale;
//             },
//             onGenerateRoute: RouteConfiguration.onGenerateRoute,
//           );
//         },
//       ),
//     );
//   }
// }
