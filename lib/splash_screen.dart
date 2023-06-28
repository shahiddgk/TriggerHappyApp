// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/TreeScreen/tree_screen.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'Screens/AuthScreens/login_screen.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
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
                  Card(
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
                  SizedBox(height: MediaQuery.of(context).size.height/2.5,),
                  ElevatedButton(onPressed: (){

                    isUserLoggedIn ? Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TreeScreen(true)))
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
