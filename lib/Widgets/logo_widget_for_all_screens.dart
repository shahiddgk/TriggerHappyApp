
// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/utill/userConstants.dart';

class LogoScreen extends StatefulWidget {
  LogoScreen(this.screen,{Key? key}) : super(key: key);
  String screen;

  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  late bool isPhone;

  String name = "";
  String id = "";
  // bool _isUserDataLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";

  bool otherUserLoggedIn = false;

  getScreenDetails() {

    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    super.initState();
  }

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      // _isUserDataLoading = true;
    });
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    otherUserLoggedIn = sharedPreferences.getBool(UserConstants().otherUserLoggedIn)!;

    // if(otherUserLoggedIn) {
    //   name = sharedPreferences.getString(UserConstants().userName)!;
    //   id = sharedPreferences.getString(UserConstants().otherUserId)!;
    //   email = sharedPreferences.getString(UserConstants().userEmail)!;
    //   timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    //   userType = sharedPreferences.getString(UserConstants().userType)!;
    // } else {
    //   name = sharedPreferences.getString(UserConstants().userName)!;
    //   id = sharedPreferences.getString(UserConstants().userId)!;
    //   email = sharedPreferences.getString(UserConstants().userEmail)!;
    //   timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    //   userType = sharedPreferences.getString(UserConstants().userType)!;
    // }

    setState(() {
      // _isUserDataLoading = false;
    });
  }

  setSessionForAllAppShare(bool otherUserLogged) async {
    setState(() {
      otherUserLoggedIn = otherUserLogged;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool(UserConstants().otherUserLoggedIn, otherUserLogged);

  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
              child: widget.screen == "" ?  Text("Burgeon",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  : widget.screen == "PIRE" ?  Text("Burgeon-PIRE",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  : widget.screen == "Trellis" ?  Text("Burgeon-Trellis",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  : widget.screen == "Garden" ?  Text("Burgeon-Garden",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor) ,)
                  :  widget.screen == "Column" ?  Text("Burgeon-Column",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "Premium" ?  Text("Burgeon-Premium",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "Ladder" ?  Text("Burgeon-Ladder",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "NAQ" ?  isPhone ? Text("Neurological Alignment \nQuotient",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),) : Text("Neurological Alignment Quotient",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "Bridge" ?  Text("Burgeon-Bridge",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "Post" ?  Text("Burgeon-Post",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "Sage" ?  Text("Burgeon-Sage",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "Notifications" ?  Text("Burgeon-Notifications",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "Connections" ?  Text("Burgeon-Connections",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "Base" ?  Text("Burgeon-Base",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "Pending" ?  Text("Pending-Request",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "SearchConnection" ?  Text("Search-Connection",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "SentConnection" ?  Text("Connection-Request",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "Tribe" ?  Text("Burgeon-Tribe",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "Expertly Process One Issue" ? Text(!isPhone ? "Expertly process an issue(\$25 per issue)" : "Expertly process an issue\n (\$25 per issue)",textAlign: TextAlign.center,style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "PIRE Collection" ?  Text("PIRE Collection",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :  widget.screen == "NAQ Collection" ?  Text("NAQ Collection",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                  :Text("Burgeon",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
          // Image.asset(widget.screen == "" ? "assets/trigger_logo.png"
          //     : widget.screen == "PIRE" ? "assets/burgeon_pire.png"
          //     :widget.screen == "Trellis" ? "assets/burgeon_trellis.png" :
          //   widget.screen == "Garden" ? "assets/burgeon_garden.png" : "assets/burgeon_trellis.png" ,fit: BoxFit.fill,height: MediaQuery.of(context).size.width/4.7,width: MediaQuery.of(context).size.width,),
        ),
      ],
    );
  }
}
