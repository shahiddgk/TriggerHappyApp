// ignore_for_file: unused_field

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/pire_listing_screen.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/pire_subcategory_screen.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_3.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../model/reponse_model/pire_naq_list_response_model.dart';
import '../../model/request_model/pire_naq_request_model.dart';
import '../../network/http_manager.dart';
import '../utill/userConstants.dart';
import '../video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  bool _isDataLoading = true;
  late bool isPhone;
  String urlFirst = "https://youtu.be/dk5vgNpIWMM";
  String urlSecond = "https://youtu.be/jkyP7pjF70k";
  String urlThird = "https://youtu.be/GvlUXJoq90c";
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  bool otherUserLoggedIn = false;

  bool _isLoading = true;

  bool isError = false;
  String errorText = "";

  List<PireNaqListItem> pireNaqListItem = <PireNaqListItem>[];


  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    otherUserLoggedIn = sharedPreferences.getBool(UserConstants().otherUserLoggedIn)!;

    badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

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
    }

    _getPireList();
    setState(() {
      _isUserDataLoading = false;
    });
  }

  _getPireList() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().pireNaqListResponse(PireNaqListRequestModel(userId: id,type: "pire")).then((value) {
      setState(() {
        pireNaqListItem = value.responses!;
        _isLoading = false;
        isError = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        isError = true;
        errorText = e.toString();
      });
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

  Future<bool> _onWillPop() async {
    if(otherUserLoggedIn) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) =>const PireCategoryScreen()),
              (Route<dynamic> route) => false
      );
    }
    // int count = 0;
    // Navigator.of(context).popUntil((_) => count++ >= 11);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
            context,
                () {
                  if(otherUserLoggedIn) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) =>const PireCategoryScreen()),
                            (Route<dynamic> route) => false
                    );
                  }
            }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared,otherUserLoggedIn,name),


        // AppBar(
        //   automaticallyImplyLeading: true,
        //   centerTitle: true,
        //   leading: IconButton(
        //     icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
        //     onPressed: () {
        //
        //     },
        //   ),
        //   title: Text(_isUserDataLoading ? "" : name),
        //   actions:  [
        //     PopMenuButton(false,false,id)
        //   ],
        // ),
        body: Container(
          color: AppColors.backgroundColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                LogoScreen("PIRE"),
                  _isDataLoading ? const CircularProgressIndicator()
                      : _isLoading ? const Center(child: CircularProgressIndicator(),) : !isPhone ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                String? videoId = YoutubePlayer.convertUrlToId(urlFirst);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: "https://img.youtube.com/vi/dk5vgNpIWMM/0.jpg",
                                          fit: BoxFit.fitWidth,
                                          progressIndicatorBuilder: (context, url, downloadProgress) {
                                            return Container(
                                                width: 60,
                                                height: 60,
                                                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
                                                child: CircularProgressIndicator(
                                                    value: downloadProgress.progress));
                                          },
                                          errorWidget: (context, url, error) => Container(
                                              alignment: Alignment.center,
                                              child:const Icon(Icons.error,color: AppColors.redColor,)),
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _launchURL();
                                              },
                                              child: Container(
                                                margin:const EdgeInsets.only(top: 10,right: 10,left: 5),
                                                height: 35,
                                                width: 35,
                                                child: ClipOval(
                                                  child: Image.network("https://yt3.googleusercontent.com/ytc/AGIKgqOMcE11tiMtTs4rMKE29ZdPkuF9vurD2CHqx-NJqz7NuAccNgbu25tHi8bICV5M=s176-c-k-c0x00ffffff-no-rj"),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                  margin:const EdgeInsets.only(top: 5),
                                                  child: const Text("Welcome to P.I.R.E",style: TextStyle(fontWeight:FontWeight.bold,fontSize: AppConstants.defaultFontSize),)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),

                                  ),
                                  const  Icon(Icons.play_circle_fill_outlined,size: 60,color: AppColors.primaryColor,)
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                String? videoId = YoutubePlayer.convertUrlToId(urlSecond);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: "https://img.youtube.com/vi/jkyP7pjF70k/0.jpg",
                                            fit: BoxFit.fitWidth,
                                            progressIndicatorBuilder: (context, url, downloadProgress) {
                                              return Container(
                                                  width: 60,
                                                  height: 60,
                                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
                                                  child: CircularProgressIndicator(
                                                      value: downloadProgress.progress));
                                            },
                                            errorWidget: (context, url, error) => Container(
                                                alignment: Alignment.center,
                                                child:const Icon(Icons.error,color: AppColors.redColor,)),
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _launchURL();
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(top: 10,right: 10,left: 5),
                                                  height: 35,
                                                  width: 35,
                                                  child: ClipOval(
                                                    child: Image.network("https://yt3.googleusercontent.com/ytc/AGIKgqOMcE11tiMtTs4rMKE29ZdPkuF9vurD2CHqx-NJqz7NuAccNgbu25tHi8bICV5M=s176-c-k-c0x00ffffff-no-rj"),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                    margin:const EdgeInsets.only(top: 5),
                                                    child: const Text("3 Guidelines to Processing Emotions Effectively",style: TextStyle(fontWeight:FontWeight.bold,fontSize: AppConstants.defaultFontSize),)),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                  ),
                                  const  Icon(Icons.play_circle_fill_outlined,size: 60,color: AppColors.primaryColor,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          String? videoId = YoutubePlayer.convertUrlToId(urlThird);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: "https://img.youtube.com/vi/GvlUXJoq90c/0.jpg",
                                      fit: BoxFit.fitWidth,
                                      progressIndicatorBuilder: (context, url, downloadProgress) {
                                        return Container(
                                            width: 60,
                                            height: 60,
                                            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
                                            child: CircularProgressIndicator(
                                                value: downloadProgress.progress));
                                      },
                                      errorWidget: (context, url, error) => Container(
                                          alignment: Alignment.center,
                                          child:const Icon(Icons.error,color: AppColors.redColor,)),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _launchURL();
                                          },
                                          child: Container(
                                            margin:const EdgeInsets.only(top: 10,right: 10,left: 5),
                                            height: 35,
                                            width: 35,
                                            child: ClipOval(
                                              child: Image.network("https://yt3.googleusercontent.com/ytc/AGIKgqOMcE11tiMtTs4rMKE29ZdPkuF9vurD2CHqx-NJqz7NuAccNgbu25tHi8bICV5M=s176-c-k-c0x00ffffff-no-rj"),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                              margin:const EdgeInsets.only(top: 5),
                                              child: const Text("Choosing a topic",style: TextStyle(fontWeight:FontWeight.bold,fontSize: AppConstants.defaultFontSize),)),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ),
                            const  Icon(Icons.play_circle_fill_outlined,size: 60,color: AppColors.primaryColor,)
                          ],
                        ),
                      ),
                    ],
                  ) : Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          String? videoId = YoutubePlayer.convertUrlToId(urlFirst);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height/4,
                                    child: CachedNetworkImage(
                                      imageUrl: "https://img.youtube.com/vi/dk5vgNpIWMM/0.jpg",
                                      fit: BoxFit.fitWidth,
                                      progressIndicatorBuilder: (context, url, downloadProgress) {
                                        return Container(
                                            width: 60,
                                            height: 60,
                                            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
                                            child: CircularProgressIndicator(
                                                value: downloadProgress.progress));
                                      },
                                      errorWidget: (context, url, error) => Container(
                                          alignment: Alignment.center,
                                          child:const Icon(Icons.error,color: AppColors.redColor,)),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _launchURL();
                                        },
                                        child: Container(
                                          margin:const EdgeInsets.only(top: 10,right: 10,left: 5),
                                          height: 35,
                                          width: 35,
                                          child: ClipOval(
                                            child: Image.network("https://yt3.googleusercontent.com/ytc/AGIKgqOMcE11tiMtTs4rMKE29ZdPkuF9vurD2CHqx-NJqz7NuAccNgbu25tHi8bICV5M=s176-c-k-c0x00ffffff-no-rj"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                            margin:const EdgeInsets.only(top: 5),
                                            child: const Text("Welcome to P.I.R.E",style: TextStyle(fontWeight:FontWeight.bold,fontSize: AppConstants.defaultFontSize),)),
                                      ),
                                    ],
                                  )

                                ],
                              ),

                            ),
                          const  Icon(Icons.play_circle_fill_outlined,size: 60,color: AppColors.primaryColor,)
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.textWhiteColor,),
                      GestureDetector(
                        onTap: () {
                          String? videoId = YoutubePlayer.convertUrlToId(urlSecond);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                               // margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height/4,
                                      child: CachedNetworkImage(
                                        imageUrl: "https://img.youtube.com/vi/jkyP7pjF70k/0.jpg",
                                        fit: BoxFit.fitWidth,
                                        progressIndicatorBuilder: (context, url, downloadProgress) {
                                          return Container(
                                              width: 60,
                                              height: 60,
                                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
                                              child: CircularProgressIndicator(
                                                  value: downloadProgress.progress));
                                        },
                                        errorWidget: (context, url, error) => Container(
                                            alignment: Alignment.center,
                                            child: const Icon(Icons.error,color: AppColors.redColor,)),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _launchURL();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 10,right: 10,left: 5),
                                            height: 35,
                                            width: 35,
                                            child: ClipOval(
                                              child: Image.network("https://yt3.googleusercontent.com/ytc/AGIKgqOMcE11tiMtTs4rMKE29ZdPkuF9vurD2CHqx-NJqz7NuAccNgbu25tHi8bICV5M=s176-c-k-c0x00ffffff-no-rj"),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                              margin:const EdgeInsets.only(top: 5),
                                              child: const Text("3 Guidelines to Processing Emotions Effectively",style: TextStyle(fontWeight:FontWeight.bold,fontSize: AppConstants.defaultFontSize),)),
                                        ),
                                      ],
                                    )
                                    // Container(
                                    //     margin:const EdgeInsets.only(top: 5),
                                    //     child: const Text(,style: TextStyle(fontSize: AppConstants.defaultFontSize),))
                                  ],
                                )
                            ),
                            const Icon(Icons.play_circle_fill_outlined,size: 60,color: AppColors.primaryColor,)
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.textWhiteColor,),
                      GestureDetector(
                        onTap: () {
                          String? videoId = YoutubePlayer.convertUrlToId(urlThird);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height/4,
                                    child: CachedNetworkImage(
                                      imageUrl: "https://img.youtube.com/vi/GvlUXJoq90c/0.jpg",
                                      fit: BoxFit.fitWidth,
                                      progressIndicatorBuilder: (context, url, downloadProgress) {
                                        return Container(
                                            width: 60,
                                            height: 60,
                                            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
                                            child: CircularProgressIndicator(
                                                value: downloadProgress.progress));
                                      },
                                      errorWidget: (context, url, error) => Container(
                                          alignment: Alignment.center,
                                          child:const Icon(Icons.error,color: AppColors.redColor,)),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _launchURL();
                                        },
                                        child: Container(
                                          margin:const EdgeInsets.only(top: 10,right: 10,left: 5),
                                          height: 35,
                                          width: 35,
                                          child: ClipOval(
                                            child: Image.network("https://yt3.googleusercontent.com/ytc/AGIKgqOMcE11tiMtTs4rMKE29ZdPkuF9vurD2CHqx-NJqz7NuAccNgbu25tHi8bICV5M=s176-c-k-c0x00ffffff-no-rj"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                            margin:const EdgeInsets.only(top: 5),
                                            child: const Text("Choosing a topic",style: TextStyle(fontWeight:FontWeight.bold,fontSize: AppConstants.defaultFontSize),)),
                                      ),
                                    ],
                                  )

                                ],
                              ),

                            ),
                            const  Icon(Icons.play_circle_fill_outlined,size: 60,color: AppColors.primaryColor,)
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.textWhiteColor,),
                    ],
                  ),
                if(!_isLoading)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  height: 40,
                  width: MediaQuery.of(context).size.width/2,
                  child: ElevatedButton(
                    onPressed: (){
                      if(otherUserLoggedIn) {
                        if(pireNaqListItem.isEmpty) {
                          showToastMessage(context, "P.I.R.E Collection not created yet", false);
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PireListScreen(isSageShare: false,)));
                        }
                      } else {
                        if(pireNaqListItem.isEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Screen3()));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PireListScreen(isSageShare: false,)));
                        }
                      }
                    },
                    style:ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text("Proceed",style: TextStyle(color: AppColors.backgroundColor),),
                  ),
                )

                // GestureDetector(
                //   onTap: () {
                //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PireListScreen()));
                //   },
                //   child: Container(
                //     margin:const EdgeInsets.symmetric(horizontal: 3),
                //     child: OptionMcqAnswer(
                //         TextButton(onPressed: () {
                //           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Screen3()));
                //           }, child: const Text("Proceed",style: TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.defaultFontSize)),)
                //     ),
                //   ),
                // )
              ],
            ),
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
