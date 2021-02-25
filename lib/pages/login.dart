// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:ngens/data/gallery_options.dart';
import 'package:ngens/layout/adaptive.dart';
import 'package:ngens/layout/text_scale.dart';
import 'package:ngens/widgets/common.dart';

import 'package:ngens/app.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ngens/models/user.dart';
import 'package:ngens/pages/create_account.dart';

import 'package:ngens/service/authenticationService.dart';
import 'package:ngens/widgets/googleSigninButton.dart';

final StorageReference storageRef = FirebaseStorage.instance.ref();
bool isGoogleAuthenticated = false;
final AuthenticationService auth = AuthenticationService();

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ApplyTextOptions(
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
        body: SafeArea(
          child: _MainView(
            usernameController: _usernameController,
            passwordController: _passwordController,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _MainView extends StatelessWidget {
  const _MainView({
    Key key,
    this.usernameController,
    this.passwordController,
  }) : super(key: key);

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  Future _login(BuildContext context) async {
    var email = usernameController.text;
    var password = passwordController.text;
    await auth.signIn(email: email, password: password);
  }

  Future login(BuildContext context) async {
    isGoogleAuthenticated = await auth.signInGoogle();
    print('in login');
    if (!isGoogleAuthenticated) {
      await auth.login();
    }
    // 1) check if user exists in users collection in database (according to their id)
    final user = googleSignIn.currentUser;
    // ignore: missing_required_param
    currentUser = await RUser(id: user.id).getById();

    if (currentUser != null &&
        currentUser.exists &&
        currentUser.username == null) {
      String username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      await auth.createUserInFirestore(
          user.id, user.displayName, user.email, user.photoUrl, username);
    }

    await Navigator.of(context).pushNamed(ReflectApp.homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    List<Widget> listViewChildren;

    if (isDesktop) {
      final desktopMaxWidth = 400.0 + 100.0 * (cappedTextScale(context) - 1);
      listViewChildren = [
        UsernameInput(
          maxWidth: desktopMaxWidth,
          usernameController: usernameController,
        ),
        const SizedBox(height: 12),
        PasswordInput(
          maxWidth: desktopMaxWidth,
          passwordController: passwordController,
        ),
        LoginButton(
          maxWidth: desktopMaxWidth,
          onTap: () {
            _login(context);
          },
        ),
        const SizedBox(width: 100),
        const Divider(
          thickness: 5,
        ),
        const SizedBox(height: 12),
        GoogleSignInButton(
          maxWidth: desktopMaxWidth,
          onTap: () async {
            await login(context);
          },
        )
      ];
    } else {
      listViewChildren = [
        const SmallLogo(),
        UsernameInput(
          usernameController: usernameController,
        ),
        const SizedBox(height: 12),
        PasswordInput(
          passwordController: passwordController,
        ),
        LoginButton(
          onTap: () {
            _login(context);
          },
        ),
        const Divider(
          thickness: 5,
        ),
        const SizedBox(height: 12),
        GoogleSignInButton(
          onTap: () {
            login(context);
          },
        ),
      ];
    }

    return Column(
      children: [
        if (isDesktop) const TopBar(),
        Expanded(
          child: Align(
            alignment: isDesktop ? Alignment.center : Alignment.topCenter,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: listViewChildren,
            ),
          ),
        ),
      ],
    );
  }
}
