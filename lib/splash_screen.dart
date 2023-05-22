import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/TreeScreen/tree_screen.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/AuthScreens/login_screen.dart';
import 'Screens/utill/userConstants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _isUserDataLoading = false;
  late bool isUserLoggedIn = false;


  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    Timer(const Duration(seconds: 5),
            ()=>isUserLoggedIn ? Navigator.pushReplacement(context, MaterialPageRoute(builder:
                (context) => const TreeScreen()
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
    setState(() {
      _isUserDataLoading = true;
    });
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isUserLoggedIn = _sharedPreferences.getBool(UserConstants().userLoggedIn)!;
      _isUserDataLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.backgroundColor,
        alignment: Alignment.center,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset("assets/trigger_logo.png",fit: BoxFit.fitWidth,),
          ),
        ),
      ),
    );
  }
}
