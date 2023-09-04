// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../splash_screen.dart';
import '../utill/userConstants.dart';
import 'login_screen.dart';

class SplashScreenUpdate extends StatefulWidget {
  const SplashScreenUpdate({Key? key}) : super(key: key);

  @override
  State<SplashScreenUpdate> createState() => _SplashScreenUpdateState();
}

class _SplashScreenUpdateState extends State<SplashScreenUpdate> {

  bool isUserLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    Timer(const Duration(seconds: 3),
            ()=>isUserLoggedIn ? Navigator.pushReplacement(context, MaterialPageRoute(builder:
                (context) => const SplashScreen()
            )) : Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
            const LoginPage()
            )
        )
    );
    super.initState();
  }

  _getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isUserLoggedIn = sharedPreferences.getBool(UserConstants().userLoggedIn)!;
    });
  }

  // _getUserData() async {
  //   setState(() {
  //   });
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     isUserLoggedIn = sharedPreferences.getBool(UserConstants().userLoggedIn)!;
  //   });
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
