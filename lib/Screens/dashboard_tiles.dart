import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/AuthScreens/login_screen.dart';
import 'package:flutter_quiz_app/Screens/Payment/payment_screen.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/pire_subcategory_screen.dart';
import 'package:flutter_quiz_app/Screens/TreeScreen/tree_screen.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/model/request_model/column_read_list_request.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_data_saving_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_quiz_app/Screens/Garden/garden_screen.dart';
import 'package:flutter_quiz_app/Screens/utill/userConstants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Widgets/colors.dart';
import '../Widgets/logo_widget_for_all_screens.dart';
import '../Widgets/option_mcq_widget.dart';
import 'Bridge/bridge_category_screen.dart';
import 'Column/column_screen.dart';
import 'Ladder/Ladder_Screen.dart';
import 'PireScreens/video_screen.dart';
import 'PireScreens/widgets/AppBar.dart';
import 'PireScreens/widgets/PopMenuButton.dart';
import 'Trellis/tellis_screen.dart';
import 'Widgets/toast_message.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
  bool _isLoading = true;
  late bool isPhone;
  String introUrl = "https://youtu.be/O4fsrMcxRqc";
  late YoutubePlayerController youtubePlayerController;
  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";

  @override
  void initState() {
    // TODO: implement initState

    // String? videoId = YoutubePlayer.convertUrlToId(introUrl);
    // youtubePlayerController = YoutubePlayerController(
    //     initialVideoId: videoId!,
    //     flags: const YoutubePlayerFlags(
    //       autoPlay: false,
    //       controlsVisibleAtStart: false,
    //     )
    //
    // );

    _getUserData();
    _getPckageInfo();
    super.initState();
  }

  _getPckageInfo()async {
    setState(() {
      _isLoading = true;
    });
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    // ignore: avoid_print
    print('App version: $appVersion');



    HTTPManager().getAppVersion().then((value)  async {
      setState(() {
        _isLoading = false;
      });
      // final newVersion = NewVersion(
      //   iOSId: 'com.TrueIncrease.TriggerHappy',
      //   androidId: 'com.ratedsolution.flutter_quiz_app',
      // );
      // final status = await newVersion.getVersionStatus();
      // print("App Version");
      // print(appVersion);
      // print(value);
      if(Platform.isAndroid) {
        if (appVersion != value['data'][0]['cur_playstore']) {
          showUpdate("Android",value['data'][0]['new_updates']);
        }
      } else if(appVersion != value['data'][0]['cur_apple']) {
        showUpdate("IOS",value['data'][0]['new_updates']);
      }


    }).catchError((e) {
     // print(e);
      setState(() {
        _isLoading = false;
      });
    });
  }

  showUpdate(String deviceType,String updates) {

    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title:const Text('Update Available!'),
            content:const SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text("Things added in new version: \n - Ladder section added \n - Trellis functionality updated \n - Bridge Tile added \n - Bugs Fixation \n - UI Enhancement"),
                // Html(data: updates,style: {
                //   "#" : Style(
                //     color: AppColors.textWhiteColor,
                //     fontSize: FontSize(AppConstants.defaultFontSize),
                //     textAlign: TextAlign.start,
                //
                //   ),
                // },),
            ),
            actions: [
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('No'),
                onPressed: () {
                  // Invoke the remind me later callback
                  onRemindMeLaterPressed();
                },
              ),
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('Update Now'),
                onPressed: () {

                  // Invoke the update now callback
                  onUpdateNowPressed(deviceType);
                },
              ),
            ],
          );
        });
  }


  void onUpdateNowPressed(String deviceType) {
    // Handle update now action here
    if (deviceType == "Android") {
      // ignore: deprecated_member_use
      launch('https://play.google.com/store/apps/details?id=com.ratedsolution.flutter_quiz_app');
    } else if (deviceType == "IOS") {
      // ignore: deprecated_member_use
      launch('https://apps.apple.com/us/app/your-app/id1666301888');
    }
    // After update, dismiss the update pop-up
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => false);
  }

  void onRemindMeLaterPressed() {
    // Handle remind me later action here
    // Dismiss the update pop-up
    Navigator.of(context).pop();
    // Schedule a reminder if needed
    // ...
  }

  Future<void> showUpdatePopup(BuildContext context) async {

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    // ignore: use_build_context_synchronously
    String? appStoreVersion = await getAppStoreVersion(context);
    // print("UPDATE FUNCTION CALLED");
    // print(appStoreVersion);
    // print(currentVersion);
    // print(kAppStoreId);
    if (appStoreVersion != null && currentVersion.compareTo(appStoreVersion) < 0) {

    }
  }

  Future<String?> getAppStoreVersion(BuildContext context) async {
    String? version;
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String packageName = packageInfo.packageName;

    if (Platform.isAndroid) {
      // Android uses Google Play Store
      final url = 'https://play.google.com/store/apps/details?id=$packageName';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // ignore: avoid_print
        print("UPDATE FUNCTION CALLED FOR ANDROID");
        // ignore: avoid_print
        print(url);
        // ignore: avoid_print
        print(packageName);
        // ignore: avoid_print
        print(version);
        version = RegExp('Current Version.*?>([0-9.]+)<').firstMatch(response.body)?.group(1);

      }
    } else if (Platform.isIOS) {
      // iOS uses App Store
      final url = 'https://itunes.apple.com/lookup?bundleId=$packageName';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        if (json['resultCount'] == 1) {
          version = json['results'][0]['version'];
        }
      }
    }
    return version;
  }







  // _checkNewVersion() async {
  //   final newVersion = NewVersion(
  //     iOSId: 'com.TrueIncrease.TriggerHappy',
  //     androidId: 'com.ratedsolution.flutter_quiz_app',
  //   );
  //
  //   final status = await newVersion.getVersionStatus();
  //
  //   if (status != null) {
  //     debugPrint(status.releaseNotes);
  //     debugPrint(status.appStoreLink);
  //     debugPrint(status.localVersion);
  //     debugPrint(status.storeVersion);
  //     debugPrint(status.canUpdate.toString());
  //     if(status.canUpdate) {
  //       newVersion.showUpdateDialog(
  //         context: context,
  //         versionStatus: status,
  //         dialogTitle: 'Update!',
  //         updateButtonText: "Update",
  //         dismissButtonText: "No",
  //         dialogText: Platform.isAndroid ? 'New version is available on play Store' : 'New version is available on App Store',
  //       );
  //     }
  //   }
  //
  // }

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      _isUserDataLoading = true;
    });
  //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    _getSubscriptionDetails(id);
    setState(() {
      _isUserDataLoading = false;
    });
  }

  _getSubscriptionDetails(String userId1) {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().subscriptionDetailsRead(ColumnReadRequestModel(userId: userId1)).then((value) {

      setState(() {
        _isLoading = false;
      });
      // ignore: avoid_print
      print("Subscription details ");
      // ignore: avoid_print
      print(value);
      setState(() {
        userPremium = value['user_session']['premium'].toString();
        userPremiumType = value['user_session']['premium_type'].toString();
      });

      _sharedPreferences.setString(UserConstants().userPremium, value['user_session']['premium'].toString());
      _sharedPreferences.setString(UserConstants().userPremiumType, value['user_session']['premium_type'].toString());
      _sharedPreferences.setString(UserConstants().userCustomerId, value['user_session']['customer_id'].toString());
      _sharedPreferences.setString(UserConstants().userSubscriptionId, value['user_session']['subscription_id'].toString());

    }).catchError((e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        _isLoading = false;
      });
    });
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

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => TreeScreen(false)),
            (Route<dynamic> route) => false
    );
    // int count = 0;
    // Navigator.of(context).popUntil((_) => count++ >= 11);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    getScreenDetails();
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => TreeScreen(false)),
                      (Route<dynamic> route) => false
              );
            },
          ),
          title: Text(_isUserDataLoading ? "" : name),
          actions:  [
            IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> StripePayment(false)));
            }, icon:const Icon(Icons.workspace_premium,color: AppColors.totalQuestionColor,)),
            PopMenuButton(false,false,id)
          ],
        ),
        body: Container(
          color: AppColors.backgroundColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child:  SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LogoScreen(""),
                            // const SizedBox(width: 20,),
                            // IconButton(onPressed: (){
                            //   String? videoId = YoutubePlayer.convertUrlToId(introUrl);
                            //   YoutubePlayerController playerController = YoutubePlayerController(
                            //       initialVideoId: videoId!,
                            //       flags: const YoutubePlayerFlags(
                            //         autoPlay: false,
                            //         controlsVisibleAtStart: false,
                            //       )
                            //
                            //   );
                            //   videoPopupDialog(context,"Introduction to Trellis",playerController);
                            //   //bottomSheet(context,"Trellis","Welcome to Trellis, the part of the Brugeon app designed to help you flourish and live life intentionally. Trellis is a light structure that provides structure and focus, and helps propel you towards your desired outcomes. Invest at least five minutes a day in reviewing and meditating on your Trellis. If you don't have any answers yet, spend your time meditating, praying, or journaling on the questions/sections. If you have partial answers, keep taking your time daily to consider the questions and your answers. By consistently returning to your Trellis, you will become more clear and focused on creating the outcomes you desire. Enjoy your Trellis!","");
                            // }, icon: const Icon(Icons.ondemand_video,size:30,color: AppColors.infoIconColor,))
                          ],
                        ),
                      //  LogoScreen(""),
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //   child: Container(
                        //       padding: EdgeInsets.only(top: 1),
                        //       width: MediaQuery.of(context).size.width,
                        //       child: QuestionTextWidget(widget.questionListResponse[4].subTitle)),
                        // ),
                        // Card(
                        //   elevation: 10,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(20)
                        //   ),
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(15),
                        //     child: YoutubePlayer(
                        //       controller: youtubePlayerController,
                        //       showVideoProgressIndicator: true,
                        //       bottomActions: [
                        //         CurrentPosition(),
                        //         ProgressBar(
                        //           isExpanded: true,
                        //           colors: const ProgressBarColors(
                        //               playedColor: AppColors.primaryColor,
                        //               handleColor: AppColors.primaryColor
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        _isLoading ?Container(
                            margin:const EdgeInsets.only(top: 10),child: const Center(child:  CircularProgressIndicator())) : Container(
                            margin: const EdgeInsets.only(top: 10),
                          height: MediaQuery.of(context).size.height/1.28,
                          width: MediaQuery.of(context).size.width,
                          child: GridView.count(
                            padding: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
                            crossAxisCount:!isPhone ? 3 : 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 2.0,
                            childAspectRatio: itemHeight/itemWidth,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PireCategoryScreen()));
                                },
                                child: OptionMcqAnswer(
                                    const Card(
                                      color: AppColors.primaryColor,
                                      child: Center(
                                        child: Text("P.I.R.E.",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                      ),
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //  showToastMessage(context, "Coming Soon...",false);
                                  // _saveTrellisTriggerResponse();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const TrellisScreen()));
                               //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Settings()));
                                },
                                child: OptionMcqAnswer(
                                    const Card(
                                      color: AppColors.primaryColor,
                                      child: Center(
                                        child: Text("Trellis",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                      ),
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if(userPremium == "no") {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                  } else {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ColumnScreen()));
                                  }
                                  // showToastMessage(context, "Coming Soon...",false);

                                },
                                child: OptionMcqAnswer(
                                    const  Card(
                                      color: AppColors.primaryColor,
                                      child: Center(
                                        child: Text("Column",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                      ),
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // ignore: avoid_print
                                  print(userPremium);
                                  if(userPremium == "no") {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                  } else {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const GardenScreen()));
                                  }
                                  //   showToastMessage(context, "Coming Soon...",false);

                                },
                                child: OptionMcqAnswer(
                                    const  Card(
                                      color: AppColors.primaryColor,
                                      child: Center(
                                        child: Text("Garden",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                      ),
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // showToastMessage(context, "Coming Soon...",false);
                                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LadderTileSection()));
                                },
                                child: OptionMcqAnswer(
                                    const  Card(
                                      color: AppColors.primaryColor,
                                      child: Center(
                                        child: Text("Ladder",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                      ),
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // showToastMessage(context, "Coming Soon...",false);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));
                                },
                                child: OptionMcqAnswer(
                                    const  Card(
                                      color: AppColors.primaryColor,
                                      child: Center(
                                        child: Text("Bridge",style: TextStyle(fontSize: AppConstants.headingFontSize),),
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
                                        child: Text("Posts",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                      ),
                                    )
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //    // showToastMessage(context, "Coming Soon...",false);
                              //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ColumnScreen()));
                              //   },
                              //   child: OptionMcqAnswer(
                              //       const  Card(
                              //         color: AppColors.primaryColor,
                              //         child: Center(
                              //           child: Text("Column",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                              //         ),
                              //       )
                              //   ),
                              // ),
                              // GestureDetector(
                              //   onTap: () {
                              //  //   showToastMessage(context, "Coming Soon...",false);
                              //        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const GardenScreen()));
                              //   },
                              //   child: OptionMcqAnswer(
                              //       const  Card(
                              //         color: AppColors.primaryColor,
                              //         child: Center(
                              //           child: Text("Garden",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                              //         ),
                              //       )
                              //   ),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  showToastMessage(context, "Coming Soon...",false);
                                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Settings()));
                                },
                                child: OptionMcqAnswer(
                                    const  Card(
                                      color: AppColors.greyColor,
                                      child: Center(
                                        child: Text("Base",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                      ),
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showToastMessage(context, "Coming Soon...",false);
                                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));
                                },
                                child: OptionMcqAnswer(
                                    const  Card(
                                      color: AppColors.greyColor,
                                      child: Center(
                                        child: Text("ORG",style: TextStyle(fontSize: AppConstants.headingFontSize),),
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
                                        child: Text("Promenade",style: TextStyle(fontSize: AppConstants.headingFontSize),),
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
                                        child: Text("Tribe",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                      ),
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                //  showToastMessage(context, "Coming Soon...",false);
                                },
                                child: OptionMcqAnswer(
                                    const  Card(
                                      color: AppColors.greyColor,
                                      child: Center(
                                        child: Text("Sage",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                      ),
                                    )
                                ),
                              ),
                              // OptionMcqAnswer(
                              //   const  Card(
                              //       color: AppColors.PrimaryColor,
                              //       child: Center(
                              //         child: Text("Reminders",style: TextStyle(fontSize: AppConstants.headingFontSize),),
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

      ),
    );
  }

}
