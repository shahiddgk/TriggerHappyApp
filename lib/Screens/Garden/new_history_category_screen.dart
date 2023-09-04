// ignore_for_file: library_private_types_in_public_api, must_be_immutable, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Garden/new_history_response_record_list_screen.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/model/reponse_model/level_response_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../utill/userConstants.dart';
import 'image_screen.dart';

class NewHistoryCategoryScreen extends StatefulWidget {
   NewHistoryCategoryScreen(this.responseData,this.dateHistory,{Key? key}) : super(key: key);

   ResponseData responseData;
   String dateHistory;

  @override
  _NewHistoryCategoryScreenState createState() => _NewHistoryCategoryScreenState();
}

class _NewHistoryCategoryScreenState extends State<NewHistoryCategoryScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  late bool isPhone;
  late String score;

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

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    score = sharedPreferences.getString("Score")!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  getScreenDetails() {
    setState(() {
    });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    /*24 is for notification bar on Android*/
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _isUserDataLoading ? AppBarWidget().appBar(context,false,true,"","",false) : AppBar(
        centerTitle: true,
        title: Text(name),
        actions:  [
          PopMenuButton(false,false,id)
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color: AppColors.backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Column(
                    children: [
                      LogoScreen("Garden"),
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Container(
                      //       padding: EdgeInsets.only(top: 1),
                      //       width: MediaQuery.of(context).size.width,
                      //       child: QuestionTextWidget(widget.questionListResponse[4].subTitle)),
                      // ),

                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.only(top: 10),
                          height:!isPhone ? MediaQuery.of(context).size.height/1.28  : MediaQuery.of(context).size.height/1.45,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                              padding: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
                              // crossAxisCount:!isPhone ? 1 : 1,
                              // crossAxisSpacing: 4.0,
                              // mainAxisSpacing: 2.0,
                              // childAspectRatio: itemHeight/itemWidth,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if(widget.responseData.pireCount!.isNotEmpty) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewHistoryResponseRecordListScreen(
                                                      widget.responseData
                                                          .pireCount,"PIRE",widget.dateHistory)));
                                      } else {
                                      showToastMessage(context, "No Record available on this date", false);
                                    }
                                    },
                                  child: Visibility(
                                    visible: widget.responseData.pireCount!.isNotEmpty,
                                    child: Card(
                                          elevation: 10,
                                          color: AppColors.backgroundColor,
                                          child: Padding(
                                            padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                            child: Center(
                                              child: Text("P.I.R.E. History (${widget.responseData.pireCount!.length})",style: const TextStyle(fontSize: AppConstants.defaultFontSize),textAlign: TextAlign.center,),
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(widget.responseData.trellisCount!.isNotEmpty) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewHistoryResponseRecordListScreen(
                                                      widget.responseData
                                                          .trellisCount,"trellis",widget.dateHistory)));
                                    } else {
                                      showToastMessage(context, "No Record available on this date", false);
                                    }
                                  },
                                  child: Visibility(
                                    visible: widget.responseData.trellisCount!.isNotEmpty,
                                    child: Card(
                                      elevation: 10,
                                      color: AppColors.backgroundColor,
                                      child: Padding(
                                        padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                        child: Center(
                                          child: Text("Trellis History (${widget.responseData.trellisCount!.length})",style: const TextStyle(fontSize: AppConstants.defaultFontSize),textAlign: TextAlign.center,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(widget.responseData.ladderCount!.isNotEmpty) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewHistoryResponseRecordListScreen(
                                                      widget.responseData
                                                          .ladderCount,"ladder",widget.dateHistory)));
                                    } else {
                                      showToastMessage(context, "No Record available on this date", false);
                                    }
                                  },
                                  child: Visibility(
                                    visible: widget.responseData.ladderCount!.isNotEmpty,
                                    child: Card(
                                      elevation: 10,
                                      color: AppColors.backgroundColor,
                                      child: Padding(
                                        padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                        child: Center(
                                          child: Text("Ladder History (${widget.responseData.ladderCount!.length})",style: const TextStyle(fontSize: AppConstants.defaultFontSize),textAlign: TextAlign.center,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(widget.responseData.columnCount!.isNotEmpty) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewHistoryResponseRecordListScreen(
                                                      widget.responseData
                                                          .columnCount,"column",widget.dateHistory)));
                                    } else {
                                      showToastMessage(context, "No Record available on this date", false);
                                    }
                                  },
                                  child: Visibility(
                                    visible: widget.responseData.columnCount!.isNotEmpty,
                                    child: Card(
                                      elevation: 10,
                                      color: AppColors.backgroundColor,
                                      child: Padding(
                                        padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                        child: Center(
                                          child: Text("Column History (${widget.responseData.columnCount!.length})",style: const TextStyle(fontSize: AppConstants.defaultFontSize),textAlign: TextAlign.center,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(widget.responseData.naqCount!.isNotEmpty) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewHistoryResponseRecordListScreen(
                                                      widget.responseData
                                                          .naqCount,"NAQ",widget.dateHistory)));
                                    } else {
                                      showToastMessage(context, "No Record available on this date", false);
                                    }
                                  },
                                  child: Visibility(
                                    visible: widget.responseData.naqCount!.isNotEmpty,
                                    child: Card(
                                          elevation: 10,
                                          color: AppColors.backgroundColor,
                                          child: Padding(
                                            padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                            child: Center(
                                              child: Text("Naq History (${widget.responseData.naqCount!.length})",style: const TextStyle(fontSize: AppConstants.defaultFontSize),textAlign: TextAlign.center,),
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageScreen(!isPhone ? widget.responseData.ipadImageUrl! : widget.responseData.mobileImageUrl!)));
                                  },
                                  child: const Card(
                                        elevation: 10,
                                        color: AppColors.backgroundColor,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                          child: Center(
                                            child: Text("Garden Status",style: TextStyle(fontSize: AppConstants.defaultFontSize),textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      ),
                                ),
                              ]
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                // const FooterWidget(),
              ],
            )
        ),
      ),
    );
  }
}
