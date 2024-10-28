// ignore_for_file: avoid_print, unused_element, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Payment/payment_screen.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/pire_subcategory_screen.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/model/request_model/column_read_list_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_quiz_app/Screens/utill/userConstants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Widgets/colors.dart';
import '../Widgets/logo_widget_for_all_screens.dart';
import '../Widgets/option_mcq_widget.dart';
import '../model/reponse_model/skipped_list_response_model.dart';
import '../model/request_model/logout_user_request.dart';
import 'Base/base_screen.dart';
import 'Bridge/bridge_category_screen.dart';
import 'package:html/parser.dart' as parser;
import 'Column/column_screen.dart';
import 'Garden/garden_screen.dart';
import 'Ladder/Ladder_Screen.dart';
import 'PireScreens/widgets/AppBar.dart';
import 'Posts/post_reminders.dart';
import 'Sage/sage_screen.dart';
import 'TreeScreen/tree_screen111.dart';
import 'Trellis/tellis_screen.dart';
import 'Tribe/tribe_screen.dart';
import 'Widgets/footer_widget.dart';
import 'Widgets/show_notification_pop_up.dart';
import 'Widgets/toast_message.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String name = "";
  String id = "";

  bool otherUserLoggedIn = false;

  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  bool _isLoading = false;
  late bool isPhone;
  String introUrl = "https://youtu.be/O4fsrMcxRqc";
  late YoutubePlayerController youtubePlayerController;
  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";
  int badgeCount1 = 0;
  int badgeCountShared = 0;
  Timer? timer;
  bool checkbox = true;

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
    super.initState();
  }

  //here goes the function
  String? _parseHtmlString(String htmlString) {
    final document = parser.parse(htmlString);
    final String? parsedString = parser.parse(document.body?.text).documentElement?.text;

    return parsedString;
  }

  _getPckageInfo()async {
    setState(() {
      _isLoading = true;
    });
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;

    print('App version: $appVersion');

    HTTPManager().getAppVersion().then((value)  async {
      setState(() {
        _isLoading = false;
      });
      print('App version From API : ${value['data'][0]['new_updates']}');

      if(Platform.isAndroid) {
        if (appVersion != value['data'][0]['cur_playstore']) {
          showUpdate("Android",value['data'][0]['new_updates']);
        }
      } else if(appVersion != value['data'][0]['cur_apple']) {
        showUpdate("IOS",value['data'][0]['new_updates']);
      }


    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  showUpdate(String deviceType,String updates) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title:const Text('Update Available!'),
            content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(updates),
            ),
            actions: [
              // ignore: deprecated_member_use
              // TextButton(
              //   child:const Text('No'),
              //   onPressed: () {
              //     onRemindMeLaterPressed();
              //   },
              // ),
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
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => false);
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

        print("UPDATE FUNCTION CALLED FOR ANDROID");

        print(url);

        print(packageName);

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

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      _isUserDataLoading = true;
    });
  //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    // badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;
    otherUserLoggedIn = sharedPreferences.getBool(UserConstants().otherUserLoggedIn)!;

    if(otherUserLoggedIn) {

      id = sharedPreferences.getString(UserConstants().otherUserId)!;
      name = sharedPreferences.getString(UserConstants().otherUserName)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

    } else {
      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;
      _getSubscriptionDetails(id);
      _getSkippedReminderList();

    }
    if(!otherUserLoggedIn) {
      setState(() {
        _isLoading = true;
      });
      _getPckageInfo();
    }
      // timer = Timer.periodic(const Duration(seconds: 10), (Timer t) =>  _getBadgeCount());

    setState(() {
      _isUserDataLoading = false;
    });
  }

  _getBadgeCount() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    DocumentReference documentRef =
    FirebaseFirestore.instance.collection('connections').doc(id);
    DocumentSnapshot documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        badgeCount1 = data['con_request'];
        badgeCountShared = data['shared_response'];

        sharedPreferences.setInt("BadgeCount", badgeCount1);
        sharedPreferences.setInt("BadgeShareResponseCount", badgeCountShared);

      });
    } else {
      setState(() {
        badgeCount1 = 0;
        badgeCountShared = 0;
        sharedPreferences.setInt("BadgeCount", badgeCount1);
        sharedPreferences.setInt("BadgeShareResponseCount", badgeCountShared);
      });
      print('Document does not exist');
    }

  }

  String? formattedDate;
  String? formattedTime;
  late SkippedReminderNotification skippedReminderNotification;

  _getSkippedReminderList() {
    setState(() {
      // sharedPreferences.setString("Score", "");
      // _isLoading = false;
    });
    HTTPManager().getSkippedReminderListData(LogoutRequestModel(userId: id)).then((value) {
      setState(() {
        skippedReminderNotification = value;
        // sharedPreferences.setString("Score", "");
      });
      print("SKIPPED REMINDER LIST");
      print(value);

      for(int i = 0; i<skippedReminderNotification.result!.length; i++) {
        String title = "Hi $name. Did you....";
        DateTime date = DateTime.parse(skippedReminderNotification.result![i].dateTime.toString());
        formattedDate = DateFormat('MM-dd-yy').format(DateTime.parse(skippedReminderNotification.result![i].createdAt.toString()));
        formattedTime = DateFormat("hh:mm a").format(date);
        showPopupDialogueForReminderGeneral(context,skippedReminderNotification.result![i].entityId.toString(),skippedReminderNotification.result![i].id.toString(),title,skippedReminderNotification.result![i].text.toString(),formattedDate!,formattedTime!);
      }

    }).catchError((e) {
      print(e);
      setState(() {
        // sharedPreferences.setString("Score", "");
        // _isLoading = false;
      });
    });
  }

  _getSubscriptionDetails(String userId1) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });

    HTTPManager().subscriptionDetailsRead(ColumnReadRequestModel(userId: userId1)).then((value) {


      print(value);
      setState(() {
        userPremium = value['user_session']['premium'].toString();
        userPremiumType = value['user_session']['premium_type'].toString();
      });

      print("Subscription details ");
      print(userPremium);
      print(userPremiumType);

      sharedPreferences.setString(UserConstants().userAccess, value['user_session']['admin_access'].toString());

      sharedPreferences.setString(UserConstants().userPremium, value['user_session']['premium'].toString());
      sharedPreferences.setString(UserConstants().userPremiumType, value['user_session']['premium_type'].toString());
      sharedPreferences.setString(UserConstants().userCustomerId, value['user_session']['customer_id'].toString());
      sharedPreferences.setString(UserConstants().userSubscriptionId, value['user_session']['subscription_id'].toString());
      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {

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
    if(otherUserLoggedIn) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => TreeScreen1(false)),
              (Route<dynamic> route) => false
      );
    }
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
        appBar: _isUserDataLoading ? AppBar() : AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
            context,
            () {
              if(otherUserLoggedIn) {

                Navigator.of(context).pop();

              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => TreeScreen1(false)),
                        (Route<dynamic> route) => false
                );
              }
            }, true, true, true, id, true,false,badgeCount1,false,badgeCountShared,otherUserLoggedIn,name),

        // AppBar(
        //   automaticallyImplyLeading: true,
        //   centerTitle: true,
        //   leading: IconButton(
        //     icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
        //     onPressed: () {
        //
        //     },
        //   ),
        //   title: Text(_isUserDataLoading ? "" : ""),
        //   actions:  [
        //     IconButton(onPressed: () {
        //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UserActivity()));
        //     }, icon: const Icon(Icons.list_alt,color: AppColors.hoverColor,)),
        //     IconButton(onPressed: (){
        //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> StripePayment(false)));
        //     }, icon:const Icon(Icons.workspace_premium,color: AppColors.totalQuestionColor,)),
        //     IconButton(onPressed: (){
        //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const PendingConnectionList()));
        //     }, icon:const Icon(Icons.people,color: AppColors.hoverColor,)),
        //     //  IconButton(onPressed: () async {
        //     //    // await GoogleSignIn().signOut();
        //     //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  Home("")));
        //     // }, icon:const Icon(Icons.message,color: AppColors.hoverColor,)),
        //     PopMenuButton(false,true,id)
        //   ],
        // ),
        body: Container(
          color: AppColors.backgroundColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,

          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LogoScreen(""),
                        // const SizedBox(width: 20,),
                        // if(!otherUserLoggedIn)
                        // IconButton(onPressed: () {
                        //   showDialog(
                        //       barrierDismissible: false,
                        //       context: context,
                        //       builder: (context) {
                        //         return const ShareCustomAlertDialogue(responseId: "", isModule: true, responseType: "app");
                        //       }
                        //   );
                        //   // showThumbsUpDialogueForTrellis(context, _animationController, id,'app',selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
                        // }, icon: const Icon(Icons.share,color: AppColors.primaryColor,)),
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
                  ],
                ),
              ),
              _isLoading ?Container(
                  margin:const EdgeInsets.only(top: 2),child: const Center(child:  CircularProgressIndicator())) : Expanded(
                    child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,),
                child: SizedBox(
                    height: !isPhone ? MediaQuery.of(context).size.height/1.29  : MediaQuery.of(context).size.height/1.47,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.count(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        crossAxisCount:!isPhone ? 3 : 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 2.0,
                        childAspectRatio: itemHeight/itemWidth,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UserActivity()));
                          //   },
                          //   child: OptionMcqAnswer(
                          //       const Card(
                          //         color: AppColors.primaryColor,
                          //         child: Center(
                          //           child: Text("Activities",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                          //         ),
                          //       )
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen16("Mixed Emotions","")));
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
                              if(!otherUserLoggedIn) {
                                      if (userPremium == "no") {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StripePayment(true)));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ColumnScreen()));
                                      }
                                    } else {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const ColumnScreen()));
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
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const GardenScreen()));
                              if(!otherUserLoggedIn){
                                      print(userPremium);
                                      if (userPremium == "no") {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StripePayment(true)));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const GardenScreen()));
                                      }
                                    } else {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const GardenScreen()));
                              }
                                    // showToastMessage(context, "Major updates in progress...",false);

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
                            onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Posts()));
                              // showToastMessage(context, "Coming soon ...", false);
                            },
                            child: OptionMcqAnswer(
                                  const Card(
                                  color: AppColors.primaryColor,
                                  child:Center(
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
                              // showToastMessage(context, "Coming Soon...",false);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const BaseScreen()));
                              },
                            child: OptionMcqAnswer(
                                  const Card(
                                  color: AppColors.primaryColor,
                                  child: Center(
                                    child: Text("Base",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                  ),
                                )
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SageScreen()));
                                    // showToastMessage(context, "Coming Soon...",false);
                            },
                            child: OptionMcqAnswer(
                                  const Card(
                                  color: AppColors.primaryColor,
                                  child: Center(
                                    child: Text("Sage",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                  ),
                                )
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // showToastMessage(context, "Coming Soon...",false);
                              // if(!otherUserLoggedIn){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TribeScreen()));
                                    // }
                                  },
                            child: OptionMcqAnswer(
                                  const Card(
                                  color: AppColors.primaryColor,
                                  child:Center(
                                    child: Text("Tribe",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                                  ),
                                )
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if(!otherUserLoggedIn){
                                      showToastMessage(
                                          context, "Coming Soon...", false);
                                    }
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
                              if(!otherUserLoggedIn){
                                      showToastMessage(
                                          context, "Coming Soon...", false);
                                    }
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
                ),
              ),
                  ),
              Visibility(
                  visible: !_isLoading,
                  child: const Align(
                      alignment: Alignment.bottomCenter,
                      child: FooterWidget())),
            ],
          ),
        ),

      ),
    );
  }

}
