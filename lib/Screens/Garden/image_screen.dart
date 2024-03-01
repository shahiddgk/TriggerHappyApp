
// ignore_for_file: avoid_print, unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../utill/userConstants.dart';

// ignore: must_be_immutable
class ImageScreen extends StatefulWidget {
   ImageScreen(this.imageUrl,{Key? key}) : super(key: key);

   String imageUrl;

  @override
  // ignore: library_private_types_in_public_api
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  late bool _isLoading;
  late bool isPhone;
  late String countNumber;
  String errorMessage = "";
  String url = "";
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  bool otherUserLoggedIn = false;

  @override
  void initState() {
    _getUserData();
    // TODO: implement initState
    super.initState();
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
   // print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

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
      // _getTreeGrowth();
    }
    setState(() {
      _isUserDataLoading = false;
    });
  }

  // _getTreeGrowth() {
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   // HTTPManager().treeGrowth(LogoutRequestModel(userId: id)).then((value) {
  //   //   int count = value["response_count"];
  //   //   countNumber = value["response_count"];
  //
  //     // // ignore: unrelated_type_equality_checks
  //     // if(widget.responseScore == "0") {
  //     //   setState(() {
  //     //     countNumber = "1";
  //     //   });
  //     //   //print(countNumber);
  //     //   if(!isPhone) {
  //     //     if( widget.responseTreeType == "apple") {
  //     //       url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}apple_tree/apple_ipad/$countNumber.png";
  //     //     } else if(widget.responseTreeType == "tomato") {
  //     //       url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}tomato_tree/tomato_ipad/$countNumber.png";
  //     //     } else {
  //     //       url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}rose_tree/rose_ipad/$countNumber.png";
  //     //     }
  //     //   } else {
  //     //     if( widget.responseTreeType == "apple") {
  //     //       url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}apple_tree/apple_mobile/$countNumber.png";
  //     //     } else if(widget.responseTreeType == "tomato") {
  //     //       url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}tomato_tree/tomato_mobile/$countNumber.png";
  //     //     } else {
  //     //       url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}rose_tree/rose_mobile/$countNumber.png";
  //     //     }
  //     //   }
  //     //  print(url);
  //     // } else {
  //     //   setState(() {
  //     //       countNumber = widget.responseScore;
  //     //    // print(countNumber);
  //     //       if(!isPhone) {
  //     //         if( widget.responseTreeType == "apple") {
  //     //           url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}apple_tree/apple_ipad/$countNumber.png";
  //     //         } else if(widget.responseTreeType == "tomato") {
  //     //           url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}tomato_tree/tomato_ipad/$countNumber.png";
  //     //         } else {
  //     //           url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}rose_tree/rose_ipad/$countNumber.png";
  //     //         }
  //     //       } else {
  //     //         if( widget.responseTreeType == "apple") {
  //     //           url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}apple_tree/apple_mobile/$countNumber.png";
  //     //         } else if(widget.responseTreeType == "tomato") {
  //     //           url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}tomato_tree/tomato_mobile/$countNumber.png";
  //     //         } else {
  //     //           url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}rose_tree/rose_mobile/$countNumber.png";
  //     //         }
  //     //       }
  //     //    print(url);
  //     //   });
  //     // }
  //     //
  //     // setState(() {
  //     //   errorMessage = "";
  //     //   _isLoading = false;
  //     // });
  //     //  showToastMessage(context, value['message'].toString(),true);
  //   // }).catchError((e) {
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //     errorMessage = e.toString();
  //   //   });
  //   //   showToastMessage(context, e.toString(),false);
  //   // });
  //
  // }

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
    getScreenDetails();
    return Scaffold(
      appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
                Navigator.of(context).pop();
          }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared,otherUserLoggedIn,name),
      body: Container(
        child: _isLoading ? Container(
          color: Colors.white,
          child:const Center(
            child: CircularProgressIndicator(),
          ),
        ) : Container(
          color: Colors.white,
          alignment: Alignment.bottomCenter,
          child:widget.imageUrl == "" ? Container(
              color: Colors.white,
              child:const Center(
                child: CircularProgressIndicator(),
              ),
            ) : CachedNetworkImage(
            imageUrl: widget.imageUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Container(
                  margin: const EdgeInsets.only(
                      top: 100,
                      bottom: 100
                  ),
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      color: AppColors.primaryColor
                  ),
                ),
            errorWidget: (context, url, error) =>  const Center(child: Icon(Icons.error,color: AppColors.redColor,)),
          )
          // Center(
          //     child: CachedNetworkImage(
          //       imageUrl: url,
          //       progressIndicatorBuilder: (context, url, downloadProgress) =>
          //           CircularProgressIndicator(value: downloadProgress.progress),
          //       errorWidget: (context, url, error) => Icon(Icons.error,color: AppColors.redColor,),
          //     ),
          //   ),
          ),
        ),
    );
  }
}
