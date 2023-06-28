import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/PopMenuButton.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../utill/userConstants.dart';

class YoutubeVideoScreen extends StatefulWidget {
  YoutubeVideoScreen(this.videoType,{Key? key}) : super(key: key);

  String videoType;

  @override
  State<YoutubeVideoScreen> createState() => _YoutubeVideoScreenState();
}

class _YoutubeVideoScreenState extends State<YoutubeVideoScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";
  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";
  String allowEmail = "";

  String bodyScanVideoUrl = "https://youtu.be/whc21PAm4tQ";
  String favPlaceOnEarth = "https://youtu.be/26ArgGvNTAE";

  late YoutubePlayerController youtubePlayerController;

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

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();

    String? videoId = YoutubePlayer.convertUrlToId(widget.videoType == "FavPlaceOnEarth" ? favPlaceOnEarth : bodyScanVideoUrl);
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          controlsVisibleAtStart: false,
        )

    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.of(context).pop();
          },
        ),
        title: Text(_isUserDataLoading ? "" : name),
        actions:  [
          PopMenuButton(false,false,id)
        ],
      ),
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
                LogoScreen("PIRE"),
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
                          child: Text(widget.videoType == "FavPlaceOnEarth" ? "Favourite Place on Earth" : "Body Scan",style: const TextStyle(fontWeight:FontWeight.bold,fontSize: AppConstants.headingFontSizeForEntriesAndSession),)),
                    ),
                  ],
                )
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
