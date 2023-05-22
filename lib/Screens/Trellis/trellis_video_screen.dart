import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/PopMenuButton.dart';
import 'package:flutter_quiz_app/Screens/Trellis/tellis_screen.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../Widgets/video_thumbnail_design.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';
import '../video_player.dart';

class TrellisVideoScreen extends StatefulWidget {
  const TrellisVideoScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TrellisVideoScreenState createState() => _TrellisVideoScreenState();
}

class _TrellisVideoScreenState extends State<TrellisVideoScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  bool _isDataLoading = true;
  late bool isPhone;

  String urlFirst = "https://www.youtube.com/watch?v=GFqe2n4vnNU";
  String urlSecond = "https://www.youtube.com/watch?v=v6wVjS_w_6Q";
  String urlThird = "https://www.youtube.com/watch?v=iqUEdMLACs8";
  String urlFourth = "https://www.youtube.com/watch?v=4_9pRALrO1k";
  String urlFifth = "https://www.youtube.com/watch?v=2PqaSGRZgI0";

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  @override
  void initState() {

    _getUserData();
    // TODO: implement initState
    super.initState();
  }

  getScreenDetails() {
    setState(() {
      _isDataLoading = true;
    });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    setState(() {
      _isDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
          },
        ),
        title: Text(_isUserDataLoading ? "" : name),
        actions:  [
          PopMenuButton(false,false,id)
        ],
      ),
      body: Container(
        color: AppColors.backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              LogoScreen("Column"),
              _isDataLoading ? const CircularProgressIndicator()
                  : !isPhone ? Column(
                children: [
                  Row(
                    children: [
                      VideoThumbnailDesignForIPad((){
                        String? videoId = YoutubePlayer.convertUrlToId(urlFirst);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                      },
                          "Walking you through processing negative issues step by step",
                          "https://img.youtube.com/vi/GFqe2n4vnNU/0.jpg",(){
                            _launchURL();
                          }),
                      VideoThumbnailDesignForIPad((){
                        String? videoId = YoutubePlayer.convertUrlToId(urlSecond);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                      },
                          "Before you begin- how to select an issue to process",
                          "https://img.youtube.com/vi/v6wVjS_w_6Q/0.jpg",(){
                            _launchURL();
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      VideoThumbnailDesignForIPad((){
                        String? videoId = YoutubePlayer.convertUrlToId(urlThird);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                      },
                          "Walking you through processing negative issues step by step",
                          "https://img.youtube.com/vi/iqUEdMLACs8/0.jpg",(){
                            _launchURL();
                          }),
                      VideoThumbnailDesignForIPad((){
                        String? videoId = YoutubePlayer.convertUrlToId(urlFourth);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                      },
                          "Before you begin- how to select an issue to process",
                          "https://img.youtube.com/vi/4_9pRALrO1k/0.jpg",(){
                            _launchURL();
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      VideoThumbnailDesignForIPad((){
                        String? videoId = YoutubePlayer.convertUrlToId(urlFifth);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                      },
                          "Walking you through processing negative issues step by step",
                          "https://img.youtube.com/vi/8n5-yXPEU7U/0.jpg",(){
                            _launchURL();
                          }),
                      // VideoThumbnailDesignForIPad((){
                      //   String? videoId = YoutubePlayer.convertUrlToId(urlSecond);
                      //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                      // },
                      //     "Before you begin- how to select an issue to process",
                      //     "https://img.youtube.com/vi/zhRsp6NWKCE/0.jpg",(){
                      //       _launchURL();
                      //     }),
                    ],
                  )
                  // Expanded(
                  //   child: GestureDetector(
                  //     onTap: () {
                  //
                  //     },
                  //     child: Stack(
                  //       alignment: Alignment.center,
                  //       children: [
                  //         Container(
                  //           width: MediaQuery.of(context).size.width,
                  //           margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  //           child: Column(
                  //             children: [
                  //               CachedNetworkImage(
                  //                 imageUrl: "",
                  //                 fit: BoxFit.fill,
                  //                 progressIndicatorBuilder: (context, url, downloadProgress) {
                  //                   return Container(
                  //                       width: 60,
                  //                       height: 60,
                  //                       padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
                  //                       child: CircularProgressIndicator(
                  //                           value: downloadProgress.progress));
                  //                 },
                  //                 errorWidget: (context, url, error) => Container(
                  //                     alignment: Alignment.center,
                  //                     child: Icon(Icons.error,color: AppColors.redColor,)),
                  //               ),
                  //               Container(
                  //                   margin:const EdgeInsets.only(top: 10),
                  //                   child: const Text("",style: TextStyle(fontSize: AppConstants.defaultFontSize),)),
                  //             ],
                  //           ),
                  //
                  //         ),
                  //         Icon(Icons.play_circle_fill_outlined,size: 60,color: AppColors.primaryColor,)
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ) : Column(
                children: [
                  VideoThumbnailScreenForMobile((){
                    String? videoId = YoutubePlayer.convertUrlToId(urlFirst);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                  },
                      "Walking you through processing negative issues step by step",
                      "https://img.youtube.com/vi/GFqe2n4vnNU/0.jpg",
                      (){
                    _launchURL();
                      }),
                  const Divider(color: AppColors.textWhiteColor,),
                  VideoThumbnailScreenForMobile((){
                    String? videoId = YoutubePlayer.convertUrlToId(urlSecond);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                  },
                      "Before you begin- how to select an issue to process",
                      "https://img.youtube.com/vi/v6wVjS_w_6Q/0.jpg",
                          (){
                        _launchURL();
                      }),
                  const Divider(color: AppColors.textWhiteColor,),
                  VideoThumbnailScreenForMobile((){
                    String? videoId = YoutubePlayer.convertUrlToId(urlThird);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                  },
                      "Walking you through processing negative issues step by step",
                      "https://img.youtube.com/vi/iqUEdMLACs8/0.jpg",
                          (){
                        _launchURL();
                      }),
                  const Divider(color: AppColors.textWhiteColor,),
                  VideoThumbnailScreenForMobile((){
                    String? videoId = YoutubePlayer.convertUrlToId(urlFourth);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                  },
                      "Before you begin- how to select an issue to process",
                      "https://img.youtube.com/vi/4_9pRALrO1k/0.jpg",
                          (){
                        _launchURL();
                      }),
                  const Divider(color: AppColors.textWhiteColor,),
                  VideoThumbnailScreenForMobile((){
                    String? videoId = YoutubePlayer.convertUrlToId(urlFifth);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                  },
                      "Walking you through processing negative issues step by step",
                      "https://img.youtube.com/vi/8n5-yXPEU7U/0.jpg",
                          (){
                        _launchURL();
                      }),
                  const Divider(color: AppColors.textWhiteColor,),

                ],
              ),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TrellisScreen()));
                },
                child: Container(
                  margin:const EdgeInsets.symmetric(horizontal: 3),
                  child: OptionMcqAnswer(
                      TextButton(onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TrellisScreen()));
                      }, child: const Text("Proceed",style: TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.defaultFontSize)),)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    if (Platform.isIOS) {
      // ignore: deprecated_member_use
      if (await canLaunch('https://www.youtube.com/@Burgeonapp')) {
        // ignore: deprecated_member_use
        await launch(
            'https://www.youtube.com/@Burgeonapp', forceSafariVC: false);
      } else {
        // ignore: deprecated_member_use
        if (await canLaunch('https://www.youtube.com/@Burgeonapp')) {
          // ignore: deprecated_member_use
          await launch('https://www.youtube.com/@Burgeonapp');
        } else {
          throw 'Could not launch https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw';
        }
      }
    } else {
      const url = 'https://www.youtube.com/@Burgeonapp';
      // ignore: deprecated_member_use
      if (await canLaunch(url)) {
        // ignore: deprecated_member_use
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}
