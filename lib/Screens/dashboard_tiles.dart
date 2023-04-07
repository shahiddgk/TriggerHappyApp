import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/AuthScreens/settings_screen.dart';
import 'package:flutter_quiz_app/Screens/utill/userConstants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/colors.dart';
import '../Widgets/logo_widget_for_all_screens.dart';
import '../Widgets/option_mcq_widget.dart';
import 'PireScreens/widgets/AppBar.dart';
import 'Posts/post_reminders.dart';
import 'TreeScreen/tree_screen.dart';
import 'Widgets/toast_message.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  late bool _isLoading;
  late bool isPhone;

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    _checkNewVersion();
    super.initState();
  }

  _checkNewVersion() async {
    final newVersion = NewVersion(
      iOSId: 'com.TrueIncrease.TriggerHappy',
      androidId: 'com.ratedsolution.flutter_quiz_app',
    );

    final status = await newVersion.getVersionStatus();

    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      if(status.canUpdate) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: 'Update!',
          updateButtonText: "Update",
          dismissButtonText: "No",
          dialogText: Platform.isAndroid ? 'New version is available on play Store' : 'New version is available on App Store',
        );
      }
    }

  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    print("Data getting called");
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

    name = _sharedPreferences.getString(UserConstants().userName)!;
    id = _sharedPreferences.getString(UserConstants().userId)!;
    email = _sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = _sharedPreferences.getString(UserConstants().timeZone)!;
    userType = _sharedPreferences.getString(UserConstants().userType)!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  getScreenDetails() {
    setState(() {
      _isLoading = true;
    });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    setState(() {
      _isLoading = false;
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
      resizeToAvoidBottomInset: true,
      appBar: _isUserDataLoading ? AppBarWidget().appBar(false,true,"","",false) : AppBarWidget().appBar(false,true,name,id,false),
      body: Container(
        color: AppColors.backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Stack(
                alignment: Alignment.center,
                //    ignoring: isAnswerLoading,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LogoScreen(),
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Container(
                      //       padding: EdgeInsets.only(top: 1),
                      //       width: MediaQuery.of(context).size.width,
                      //       child: QuestionTextWidget(widget.questionListResponse[4].subTitle)),
                      // ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                        height: MediaQuery.of(context).size.height/1.28,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.count(
                          padding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                          crossAxisCount:!isPhone ? 3 : 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 2.0,
                          childAspectRatio: itemHeight/itemWidth,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Settings("PIRE")));
                              },
                              child: OptionMcqAnswer(
                                  const Card(
                                    color: AppColors.primaryColor,
                                    child: Center(
                                      child: Text("PIRE",style: TextStyle(fontSize: 22),),
                                    ),
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showToastMessage(context, "Coming Soon...",false);
                             //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Settings()));
                              },
                              child: OptionMcqAnswer(
                                  const Card(
                                    color: AppColors.greyColor,
                                    child: Center(
                                      child: Text("Trellis",style: TextStyle(fontSize: 22),),
                                    ),
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showToastMessage(context, "Coming Soon...",false);
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Settings()));
                              },
                              child: OptionMcqAnswer(
                                  const  Card(
                                    color: AppColors.greyColor,
                                    child: Center(
                                      child: Text("Ladder",style: TextStyle(fontSize: 22),),
                                    ),
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showToastMessage(context, "Coming Soon...",false);
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Settings()));
                              },
                              child: OptionMcqAnswer(
                                  const  Card(
                                    color: AppColors.greyColor,
                                    child: Center(
                                      child: Text("Bridge",style: TextStyle(fontSize: 22),),
                                    ),
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                showToastMessage(context, "Coming soon ...", false);
                               // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Settings("Posts")));
                              },
                              child: OptionMcqAnswer(
                                  const  Card(
                                    color: AppColors.greyColor,
                                    child: Center(
                                      child: Text("Posts",style: TextStyle(fontSize: 22),),
                                    ),
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showToastMessage(context, "Coming Soon...",false);
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Settings()));
                              },
                              child: OptionMcqAnswer(
                                  const  Card(
                                    color: AppColors.greyColor,
                                    child: Center(
                                      child: Text("Column",style: TextStyle(fontSize: 22),),
                                    ),
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                             //   showToastMessage(context, "Coming Soon...",false);
                                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Settings("Garden")));
                              },
                              child: OptionMcqAnswer(
                                  const  Card(
                                    color: AppColors.primaryColor,
                                    child: Center(
                                      child: Text("Garden",style: TextStyle(fontSize: 22),),
                                    ),
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showToastMessage(context, "Coming Soon...",false);
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Settings()));
                              },
                              child: OptionMcqAnswer(
                                  const  Card(
                                    color: AppColors.greyColor,
                                    child: Center(
                                      child: Text("Base",style: TextStyle(fontSize: 22),),
                                    ),
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showToastMessage(context, "Coming Soon...",false);
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Settings()));
                              },
                              child: OptionMcqAnswer(
                                  const  Card(
                                    color: AppColors.greyColor,
                                    child: Center(
                                      child: Text("ORG",style: TextStyle(fontSize: 22),),
                                    ),
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showToastMessage(context, "Coming Soon...",false);
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Settings()));
                              },
                              child: OptionMcqAnswer(
                                  const  Card(
                                    color: AppColors.greyColor,
                                    child: Center(
                                      child: Text("Promenade",style: TextStyle(fontSize: 22),),
                                    ),
                                  )
                              ),
                            ),
                            // OptionMcqAnswer(
                            //   const  Card(
                            //       color: AppColors.PrimaryColor,
                            //       child: Center(
                            //         child: Text("Reminders",style: TextStyle(fontSize: 22),),
                            //       ),
                            //     )
                            // ),
                          ]
                        ),
                      )

                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}
