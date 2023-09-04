// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/utill/UserState.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

import 'Screens/AuthScreens/login_screen.dart';
import 'Screens/TreeScreen/tree_screen111.dart';
import 'Screens/utill/userConstants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late bool isUserLoggedIn = false;
  String introUrl = "https://youtu.be/O4fsrMcxRqc";
  late YoutubePlayerController youtubePlayerController;
  final bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    // _getPckageInfo();
    String? videoId = YoutubePlayer.convertUrlToId(introUrl);
     youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          controlsVisibleAtStart: false,
        )

    );
    // Timer(const Duration(seconds: 5),
    //         ()=>isUserLoggedIn ? Navigator.pushReplacement(context, MaterialPageRoute(builder:
    //             (context) => const TreeScreen()
    //         )) : Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder:
    //             (context) =>
    //         const LoginPage()
    //         )
    //     )
    // );

    super.initState();
  }


  Future<bool> _onWillPopForAlert() async {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (BuildContext context) => const Dashboard()),
    //         (Route<dynamic> route) => false
    // );
    // int count = 0;
    // Navigator.of(context).popUntil((_) => count++ >= 11);
    return false;
  }

  showUpdate(String deviceType,String updates) {
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: _onWillPopForAlert,
            child: AlertDialog(
              title:const Text('Update Available!'),
              content:const SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text("Things added in new version: \n - Garden functionality updated \n - New Trees added \n - UI enhancement \n - Bugs Fixation "),
              ),
              actions: [
                // ignore: deprecated_member_use
                // TextButton(
                //   child:const Text('No'),
                //   onPressed: () {
                //     // Invoke the remind me later callback
                //     onRemindMeLaterPressed();
                //   },
                // ),
                // ignore: deprecated_member_use
                TextButton(
                  child:const Text('Update Now'),
                  onPressed: () {
                    // googleSignIn.signOut();
                    setState(() {
                      UserStatePrefrence().clearAnswerText();
                    });
                    // ignore: use_build_context_synchronously
                    // Invoke the update now callback
                    onUpdateNowPressed(deviceType);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
                            (Route<dynamic> route) => false
                    );
                  },
                ),
              ],
            ),
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
    setState(() {
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isUserLoggedIn = sharedPreferences.getBool(UserConstants().userLoggedIn)!;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.backgroundColor,
          alignment: Alignment.center,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  LogoScreen(""),
                 _isLoading ?const Center(child: CircularProgressIndicator(),)  : Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: YoutubePlayer(
                        controller: youtubePlayerController,
                        showVideoProgressIndicator: true,
                        bottomActions: [
                          CurrentPosition(),
                          ProgressBar(
                            isExpanded: true,
                            colors: const ProgressBarColors(
                                playedColor: AppColors.primaryColor,
                                handleColor: AppColors.primaryColor
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  _isLoading ? Container() : SizedBox(height: MediaQuery.of(context).size.height/2.5,),
                  _isLoading ? Container() : ElevatedButton(onPressed: (){

                    isUserLoggedIn ? Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TreeScreen1(true)))
                        : Navigator.pushReplacement(context,
                        MaterialPageRoute(builder:
                            (context) =>
                        const LoginPage()
                        )
                    );

                  },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      minimumSize: Size(MediaQuery.of(context).size.width/2, 40), // Set the minimum width and height
                      padding: EdgeInsets.zero, // Remove any default padding
                    ),
                    child:const Text("Tap to Proceed"),)
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
