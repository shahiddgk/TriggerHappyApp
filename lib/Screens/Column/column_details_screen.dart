// ignore_for_file: must_be_immutable, avoid_print, duplicate_ignore, unused_field



import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/reponse_model/column_read_data_model.dart';
import '../../model/reponse_model/skipped_list_response_model.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../network/http_manager.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/show_notification_pop_up.dart';
import '../utill/userConstants.dart';
import 'Widgets/column_details_widget.dart';

class ColumnDetailsScreen extends StatefulWidget {
  ColumnDetailsScreen(this.columnReadDataModel,{Key? key}) : super(key: key);
  ColumnReadDataModel columnReadDataModel;

  @override
  // ignore: library_private_types_in_public_api
  _ColumnDetailsScreenState createState() => _ColumnDetailsScreenState();
}

class _ColumnDetailsScreenState extends State<ColumnDetailsScreen> {

  String name = "";
  String id = "";
  // ignore: prefer_final_fields
  bool _isUserDataLoading = true;
  dynamic result;
  String email = "";
  String timeZone = "";
  String userType = "";
  String takeAwayPoints = "";
  List<String> takeAwayPointsList = [];
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  bool otherUserLoggedIn = false;

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
   takeAwayPoints =  widget.columnReadDataModel.entryTakeaway!.replaceAll("[", "");
   takeAwayPoints =takeAwayPoints.replaceAll("]", "");
   takeAwayPoints = takeAwayPoints.substring(1,takeAwayPoints.length);
    takeAwayPoints = takeAwayPoints.replaceAll("\n", ",");
    takeAwayPointsList = takeAwayPoints.split(",");
    super.initState();
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // ignore: avoid_print
    print("Data getting called");
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

      // _getColumnScreenData(true);
      _getSkippedReminderList();
    }
    setState(() {
      _isUserDataLoading = false;
    });
  }

  String? formattedDate;
  String? formattedTime;
  late SkippedReminderNotification skippedReminderNotification;


  _getSkippedReminderList() {
    // setState(() {
    //   // sharedPreferences.setString("Score", "");
    //   _isLoading = true;
    // });
    HTTPManager().getSkippedReminderListData(LogoutRequestModel(userId: id)).then((value) {
      setState(() {
        skippedReminderNotification = value;
        // sharedPreferences.setString("Score", "");
        // _isLoading = false;
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
      // setState(() {
      //   // sharedPreferences.setString("Score", "");
      //   _isLoading = false;
      // });
    });
  }

  getScreenDetails() {
    setState(() {});
    if (MediaQuery
        .of(context)
        .size
        .width < 650) {
      isPhone = true;
      isDesktop = false;
      isTable = false;
    } else if (MediaQuery
        .of(context)
        .size
        .width >= 650 && MediaQuery
        .of(context)
        .size
        .width < 1100) {
      isTable = true;
      isPhone = false;
      isDesktop = false;
    } else if (MediaQuery
        .of(context)
        .size
        .width >= 1100) {
      isPhone = false;
      isDesktop = true;
      isTable = false;
    }
    setState(() {});
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
        padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LogoScreen("Column"),

              Container(
                margin: EdgeInsets.symmetric(horizontal: !isPhone ? MediaQuery.of(context).size.width/4 : 10),
                child: OptionMcqAnswer(
                  // elevation: 20,
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  // color: AppColors.accordianCollapsedColor,
                   Padding(
                     padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                     child: ColumnDetailsWidget(
                       typeText: widget.columnReadDataModel.entryType!,
                       titleText: widget.columnReadDataModel.entryTitle!,
                       takeAwayText: widget.columnReadDataModel.entryTakeaway!,
                       noteText: widget.columnReadDataModel.entryDecs!,
                       dateText: widget.columnReadDataModel.entryDate!,
                     )
                     // Column(
                     //   mainAxisAlignment: MainAxisAlignment.start,
                     //   crossAxisAlignment: CrossAxisAlignment.start,
                     //   children: [
                     //     Row(
                     //       mainAxisAlignment: MainAxisAlignment.start,
                     //       crossAxisAlignment: CrossAxisAlignment.start,
                     //       children: [
                     //         const Text("Type: ",style: TextStyle(color: AppColors.connectionTypeTextColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                     //        const SizedBox(width: 5,),
                     //         Expanded(
                     //           child: Text(widget.columnReadDataModel.entryType!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),),
                     //         ),
                     //
                     //       ],
                     //     ),
                     //     const SizedBox(height: 10,),
                     //     Row(
                     //       mainAxisAlignment: MainAxisAlignment.start,
                     //       crossAxisAlignment: CrossAxisAlignment.start,
                     //       children: [
                     //        const Text("Title: ",style: TextStyle(color: AppColors.connectionTypeTextColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                     //         const SizedBox(width: 5,),
                     //         Expanded(
                     //           child: Text(widget.columnReadDataModel.entryTitle!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),),
                     //         ),
                     //
                     //
                     //       ],
                     //     ),
                     //     const SizedBox(height: 10,),
                     //     Row(
                     //       mainAxisAlignment: MainAxisAlignment.start,
                     //       crossAxisAlignment: CrossAxisAlignment.start,
                     //       children: [
                     //         const Text("Date: ",style: TextStyle(color: AppColors.connectionTypeTextColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                     //         const SizedBox(width: 5,),
                     //         Expanded(
                     //           child: Text(" ${DateFormat('MM-dd-yy').format(DateTime.parse(widget.columnReadDataModel.entryDate!.toString()))}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),
                     //         ),
                     //
                     //       ],
                     //     ),
                     //     const SizedBox(height: 10,),
                     //     Row(
                     //       mainAxisAlignment: MainAxisAlignment.start,
                     //       crossAxisAlignment: CrossAxisAlignment.start,
                     //       children: [
                     //        const Text("Note: ",style: TextStyle(color: AppColors.connectionTypeTextColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                     //         const SizedBox(width: 5,),
                     //         Expanded(
                     //           child: Text(" ${widget.columnReadDataModel.entryDecs!}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),
                     //         ),
                     //
                     //       ],
                     //     ),
                     //     const SizedBox(height: 10,),
                     //     Row(
                     //       mainAxisAlignment: MainAxisAlignment.start,
                     //       crossAxisAlignment: CrossAxisAlignment.start,
                     //       children: [
                     //         const Text("Take Away: ",style: TextStyle(color: AppColors.connectionTypeTextColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                     //         const SizedBox(width: 5,),
                     //         Expanded(
                     //           child: Text(" ${widget.columnReadDataModel.entryTakeaway!}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),
                     //         ),
                     //       ],
                     //     ),
                     //
                     //   ],
                     // ),
                   ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
