// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../model/request_model/post_request_model.dart';
import '../../network/http_manager.dart';

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

showPopupDialogueForReminderGeneral(BuildContext context,String entityIdForSnooze,String notificationId,String title,String description,String date,String time) {
  bool isDataLoading = false;
  bool isYesDataLoading = false;
  bool isNoDataLoading = false;

  bool isPhone;
  if(MediaQuery.of(context).size.width<= 500) {
    isPhone = true;
  } else {
    isPhone = false;
  }
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return  StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return WillPopScope(
              onWillPop: _onWillPopForAlert,
              child: AlertDialog(
                backgroundColor: AppColors.naqFieldColor,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height/3,
                  width: !isPhone ? MediaQuery.of(context).size.width/2 : MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height/12,
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topCenter,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                  color: AppColors.alertDialogueHeaderColor),
                              // margin:const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                  margin:!isPhone ? const EdgeInsets.symmetric(vertical: 30) : const EdgeInsets.symmetric(vertical: 10),
                                  height: 50,
                                  width: 50,
                                  child: Image.asset('assets/bimage.png',)),
                            ),
                            // Align(
                            //   alignment: Alignment.topRight,
                            //   child: IconButton(onPressed: () {
                            //     Navigator.of(context).pop();
                            //   }, icon: const Icon(Icons.close)),
                            // )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        height: MediaQuery.of(context).size.height/5.5,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding:const EdgeInsets.symmetric(horizontal: 5),
                                    margin:const EdgeInsets.symmetric(vertical: 5),
                                    child:  Text("Date: $date",textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.defaultFontSize,),),
                                  ),
                                  Container(
                                    padding:const EdgeInsets.symmetric(horizontal: 5),
                                    margin:const EdgeInsets.symmetric(vertical: 5),
                                    child:  Text("Time: $time",textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.defaultFontSize,),),
                                  ),
                                ],
                              ),
                              Container(
                                padding:const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 5),
                                child:  Text(title,textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.defaultFontSize,color: AppColors.alertDialogueColor),),
                              ),
                              Container(
                                padding:const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 5),
                                child:  Text(description,textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.defaultFontSize),),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          decoration:const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                    color: AppColors.primaryColor,
                                  )
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(onPressed: () {
                                setState(() {
                                  isNoDataLoading = true;
                                });
                                // _notificationSnoozeReminderStatusData(notificationId,"yes");
                                HTTPManager().postReminderStopData(ReminderNotificationForStopRequestModel(notificationId: notificationId,reminderStop: "no")).then((value) {
                                  setState(() {
                                    isNoDataLoading = false;
                                  });
                                  // if(onAppOpen) {
                                  //   Navigator.of(context).pop();
                                  // }
                                  Navigator.of(context).pop();
                                  showToastMessage(context,"No worries, Keep moving forward!", true);
                                  print("Notification Stop API");
                                  print(value);
                                }).catchError((e) {
                                  setState(() {
                                    isNoDataLoading = false;
                                  });
                                  showToastMessage(context, e.toString(), false);
                                });
                              }, child:isNoDataLoading ? const SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: Center(child: CircularProgressIndicator(),)) : const Text("No",style: TextStyle(color: AppColors.textWhiteColor),)),
                              const SizedBox(
                                  height: 30,
                                  child:  VerticalDivider(color: AppColors.primaryColor,thickness: 2,)),
                              TextButton(onPressed: () {
                                setState(() {
                                  isYesDataLoading = true;
                                });
                                // _notificationSnoozeReminderStatusData(notificationId,"yes");
                                HTTPManager().postReminderStopData(ReminderNotificationForStopRequestModel(notificationId: notificationId,reminderStop: "yes")).then((value) {
                                  setState(() {
                                    isYesDataLoading = false;
                                  });
                                  // if(onAppOpen) {
                                  //   Navigator.of(context).pop();
                                  // }
                                  Navigator.of(context).pop();
                                  showToastMessage(context,"Well done, You nailed it!", true);
                                  print("Notification Stop API");
                                  print(value);
                                }).catchError((e) {
                                  setState(() {
                                    isYesDataLoading = false;
                                  });
                                  showToastMessage(context, e.toString(), false);
                                });
                              }, child:isYesDataLoading ? const SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: Center(child: CircularProgressIndicator(),)) : const Text("Yes",style: TextStyle(color: AppColors.textWhiteColor),)),
                              const SizedBox(
                                  height: 30,
                                  child:  VerticalDivider(color: AppColors.primaryColor,thickness: 2,)),
                              TextButton(onPressed: () {
                                setState(() {
                                  isDataLoading = true;
                                });
                                print("Snoozed Reminder Id");
                                print(notificationId);
                                print(entityIdForSnooze);
                                // _notificationSnoozeReminderStatusData(notificationId,"yes");
                                HTTPManager().postReminderSnoozeData(ReminderNotificationForSnoozeRequestModel(notificationId: entityIdForSnooze,updateId: notificationId)).then((value) {
                                  setState(() {
                                    isDataLoading = false;
                                  });
                                  // if(onAppOpen) {
                                  //   Navigator.of(context).pop();
                                  // }
                                  showToastMessage(context, "you have snoozed this reminder!", true);
                                  Navigator.of(context).pop();
                                  print("Notification Snooze API");
                                  print(value);
                                }).catchError((e) {
                                  print(e.toString());
                                  setState(() {
                                    isDataLoading = false;
                                  });
                                  showToastMessage(context, e.toString(), false);
                                });
                              }, child:isDataLoading ? const SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: Center(child: CircularProgressIndicator(),)) : const Text("Snooze",style: TextStyle(color: AppColors.textWhiteColor),)),
                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      });
}