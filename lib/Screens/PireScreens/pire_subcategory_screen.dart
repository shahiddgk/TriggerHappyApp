// ignore_for_file: unnecessary_import, avoid_print, prefer_final_fields

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/video_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/sub_categoy_border.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../Widgets/footer_widget.dart';
import '../Widgets/toast_message.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';

class PireCategoryScreen extends StatefulWidget {
  const PireCategoryScreen({Key? key}) : super(key: key);

  @override
  State<PireCategoryScreen> createState() => _PireCategoryScreenState();
}

class _PireCategoryScreenState extends State<PireCategoryScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isLoading = false;
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
  String bodyScanVideoUrl = "https://youtu.be/whc21PAm4tQ";
  String favPlaceOnEarth = "https://youtu.be/26ArgGvNTAE";

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

    // _getNAQResonseList(id);
    //
    setState(() {
      _isUserDataLoading = false;
    });
  }

  // _getNAQResonseList(String id) {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   HTTPManager().naqResponseList(LogoutRequestModel(userId: id)).then((value) {
  //     print(value);
  //     setState(() {
  //       _isLoading = false;
  //       // naqListResponse = value.values;
  //       naqListLength = value.values.length.toString();
  //     });
  //     print("Naq list length");
  //     print(naqListLength);
  //   }).catchError((e){
  //     print(e);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()),
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
              LogoScreen("PIRE"),
              Container(
                margin: const EdgeInsets.only(top: 10),
                height:!isPhone ? MediaQuery.of(context).size.height/1.27  : MediaQuery.of(context).size.height/1.43,
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (
                              context) => const VideoScreen()));

                      },
                      child: OptionMcqAnswerSubCategory(
                          const Card(
                            elevation: 0,
                            color: AppColors.backgroundColor,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text("P.I.R.E. Challenge",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                              ),
                            ),
                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showToastMessage(context, "Coming Soon...",false);
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PireCategoryScreen()));
                      },
                      child: OptionMcqAnswerSubCategory(
                          const  Card(
                            elevation: 0,
                            color: AppColors.greyColor,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text("P.I.R.E. Positive",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                              ),
                            ),
                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // showToastMessage(context, "Coming Soon...",false);
                        String? videoId = YoutubePlayer.convertUrlToId(bodyScanVideoUrl);
                        YoutubePlayerController playerController0 = YoutubePlayerController(
                            initialVideoId: videoId!,
                            flags: const YoutubePlayerFlags(
                              autoPlay: false,
                              controlsVisibleAtStart: false,
                            )

                        );
                        videoPopupDialog(context,"Body Scan",playerController0);
                      },
                      child: OptionMcqAnswerSubCategory(
                          const  Card(
                            elevation: 0,
                            color: AppColors.backgroundColor,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text("Body Scan",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                              ),
                            ),
                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // showToastMessage(context, "Coming Soon...",false);
                        String? videoId = YoutubePlayer.convertUrlToId(favPlaceOnEarth);
                        YoutubePlayerController playerController0 = YoutubePlayerController(
                            initialVideoId: videoId!,
                            flags: const YoutubePlayerFlags(
                              autoPlay: false,
                              controlsVisibleAtStart: false,
                            )

                        );
                        videoPopupDialog(context,"Favourite Place on Earth",playerController0);
                      },
                      child: OptionMcqAnswerSubCategory(
                          const  Card(
                            elevation: 0,
                            color: AppColors.backgroundColor,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text("Favorite Place on Earth",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
