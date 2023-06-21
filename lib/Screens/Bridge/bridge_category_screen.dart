// ignore_for_file: unnecessary_import, avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Bridge/naq_screen_q1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/sub_categoy_border.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../network/http_manager.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../Widgets/toast_message.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';

class BridgeCategoryScreen extends StatefulWidget {
  const BridgeCategoryScreen({Key? key}) : super(key: key);

  @override
  State<BridgeCategoryScreen> createState() => _BridgeCategoryScreenState();
}

class _BridgeCategoryScreenState extends State<BridgeCategoryScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";


  bool isTextField = true;
  bool isYesNo = false;
  bool isOptions = false;

  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";
  String allowEmail = "";

  String naqListLength = "";

  late bool isPhone;

  @override
  void initState() {
    // TODO: implement initState

    _getUserData();
    super.initState();
  }

  getScreenDetails() {
    // setState(() {
    //   _isLoading = true;
    // });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    allowEmail = sharedPreferences.getString(UserConstants().allowEmail)!;
    userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
    userPremiumType = sharedPreferences.getString(UserConstants().userPremiumType)!;
    userCustomerId = sharedPreferences.getString(UserConstants().userCustomerId)!;
    userSubscriptionId = sharedPreferences.getString(UserConstants().userSubscriptionId)!;

    _getNAQResonseList(id);

    setState(() {
      _isUserDataLoading = false;
    });
  }

  _getNAQResonseList(String id) {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().naqResponseList(LogoutRequestModel(userId: id)).then((value) {
      print(value);
      setState(() {
        _isLoading = false;
       // naqListResponse = value.values;
        naqListLength = value.values.length.toString();
      });
      print("Naq list length");
      print(naqListLength);
    }).catchError((e){
      print(e);
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    getScreenDetails();
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
          onPressed: () {
            // if(nameController.text.isNotEmpty || descriptionController.text.isNotEmpty || purposeController.text.isNotEmpty || mentorNameController.text.isNotEmpty  || peerNameController.text.isNotEmpty || menteeNameController.text.isNotEmpty ) {
            //   _setTrellisData();
            // }
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
          },
        ),
        title: Text(_isUserDataLoading ? "" : name),
        actions:  [
          PopMenuButton(false,false,id)
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LogoScreen("Bridge"),
              Container(
              margin: const EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height/1.28,
              width: MediaQuery.of(context).size.width,
              child: _isLoading ? const Center(child: CircularProgressIndicator(),) : GridView.count(
                padding:  EdgeInsets.symmetric(vertical:10,horizontal: MediaQuery.of(context).size.width/5),
                crossAxisCount:!isPhone ? 2 : 1,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: itemHeight/itemWidth,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  GestureDetector(
                    onTap: () {
                    if(userPremium == "no" && naqListLength == "0") {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (
                          context) => const NaqScreen1()));
                      }
                    },
                    child: OptionMcqAnswerSubCategory(
                        const Card(
                          elevation: 0,
                          color: AppColors.backgroundColor,
                          child: Center(
                            child: Text("NAQ",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                          ),
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showToastMessage(context, "Coming Soon...",false);
                      //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));
                    },
                    child: OptionMcqAnswerSubCategory(
                        const  Card(
                          elevation: 0,
                          color: AppColors.greyColor,
                          child: Center(
                            child: Text("Team Assessment",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                          ),
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showToastMessage(context, "Coming Soon...",false);
                      //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));
                    },
                    child: OptionMcqAnswerSubCategory(
                        const  Card(
                          elevation: 0,
                          color: AppColors.greyColor,
                          child: Center(
                            child: Text("Exec Skill Assessment",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                          ),
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showToastMessage(context, "Coming Soon...",false);
                      //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));
                    },
                    child: OptionMcqAnswerSubCategory(
                        const  Card(
                          elevation: 0,
                          color: AppColors.greyColor,
                          child: Center(
                            child: Text("Emotional Maturity",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                          ),
                        )
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
