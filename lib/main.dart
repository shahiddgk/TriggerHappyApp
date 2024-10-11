// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, depend_on_referenced_packages, unused_local_variable


import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/AuthScreens/splash_screen_update.dart';
import 'Screens/Widgets/toast_message.dart';
import 'Screens/utill/userConstants.dart';
import 'Widgets/constants.dart';
import 'model/reponse_model/skipped_list_response_model.dart';
import 'model/request_model/logout_user_request.dart';
import 'model/request_model/post_request_model.dart';
import 'network/http_manager.dart';
import 'package:intl/intl.dart';

Size mq = MediaQuery.of(NavigationService.navigatorKey.currentContext!).size;

// import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {

  // AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //       channelKey: "Burgeon_Reminder_Channel",
  //       channelName: "Burgeon Reminder",
  //       channelDescription: "Notification For Reminder",
  //     importance: NotificationImportance.Max,
  //     defaultColor: AppColors.primaryColor,
  //     ledColor: AppColors.backgroundColor,
  //     channelShowBadge: true,
  //     defaultRingtoneType: DefaultRingtoneType.Notification
  //   )]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _configureFirebase();

 // NotificationService().initNotification();
  //tz.initializeTimeZones();
  // Step 3
  SystemChrome.setPreferredOrientations(
      [ DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown, ]
  ).then((value) => runApp( MyApp()));
  // runApp( MyApp());
}

class AppLifecycleObserver with WidgetsBindingObserver {
  late bool isExecute;
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    late SkippedReminderNotification skippedReminderNotification;
   String name = sharedPreferences.getString(UserConstants().userName)!;
    String id = sharedPreferences.getString(UserConstants().userId)!;
    String? formattedDate;
    String? formattedTime;

    if (state == AppLifecycleState.resumed) {

        // HTTPManager()
        //     .getSkippedReminderListData(LogoutRequestModel(userId: id))
        //     .then((value) {
        //   skippedReminderNotification = value;
        //   // sharedPreferences.setString("Score", "");
        //   _isLoading2 = false;
        //
        //   print("SKIPPED REMINDER LIST");
        //   print(value);
        //
        //   // if (!_notificationHandled("1")) {
        //   //   _showPopUpDialogue(
        //   //       1,
        //   //       "1",
        //   //       "title",
        //   //       "skippedReminderNotification.result![i].text.toString()",
        //   //       "formattedDate!",
        //   //       "formattedTime!");
        //   // }
        //
        //   for(int i = 0; i<skippedReminderNotification.result!.length; i++) {
        //
        //     if (!_notificationHandled(skippedReminderNotification.result![i].id.toString())) {
        //       String title = "Hi $name. Did you....";
        //       DateTime date = DateTime.parse(skippedReminderNotification.result![i].dateTime.toString());
        //       formattedDate = DateFormat('MM-dd-yy').format(date);
        //       formattedTime = DateFormat("hh:mm a").format(date);
        //       _showPopUpDialogue(1,
        //           skippedReminderNotification.result![i].id.toString(),
        //           title,
        //           skippedReminderNotification.result![i].text.toString(),
        //           formattedDate!,
        //           formattedTime!
        //       );
        //     }
        //   }
        // }).catchError((e) {
        //   print(e);
        //
        //   // sharedPreferences.setString("Score", "");
        //   _isLoading2 = false;
        // });
      print("App is back in the foreground");
    } else if(state == AppLifecycleState.paused) {
      // App is back in the background
      // You can place your code to handle the app's return from the background here
      print("App is back in the background");
    }
  }
}

//Too recieve FCM notification
void _configureFirebase() async {

 String? formattedDate;
 String? formattedTime;
 String? entityId;
 String? type;
 String? title;
 String? body;

  await Firebase.initializeApp();

   FirebaseMessaging.instance.requestPermission().then((value) {
     FirebaseMessaging.instance.getToken().then((token) {
       print('FCM Token ===========> $token');
     });
   });
  // await Clipboard.setData(ClipboardData(text: token));

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      print('Got a message whilst in the foreground! With INITIAL MESSAGEE TAKING ISSUE');

      debugPrint('Message data: ${message.data}');

        type = message.data['type'].toString();

      if (type != "welcome_notification") {

        DateTime date = DateTime.parse(message.data['date_time'].toString());
         formattedDate = DateFormat('MM-dd-yy').format(date);
         formattedTime = DateFormat("hh:mm a").format(date);
        title = message.notification!.title ?? 'Notification';
        body = message.notification!.body ?? 'You have a new notification';
        entityId = message.data['entity_id'].toString();
        _showPopUpDialogue(6, entityId, title,body, formattedDate, formattedTime);
      }
      // handle accordingly
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      // Handle the notification message here
      // For example, show a dialog
      print('Got a message whilst in the foreground!');

      debugPrint('Message data: ${message.data}');
      // debugPrint('Message data: ${message.notification!.title}');
      // debugPrint('Message data: ${message.notification!.body}');

      String type = message.data['type'].toString();

      if (type != "welcome_notification") {
        DateTime date = DateTime.parse(message.data['date_time'].toString());
        formattedDate = DateFormat('MM-dd-yy').format(date);
        formattedTime = DateFormat("hh:mm a").format(date);
        title = message.notification!.title ?? 'Notification';
        body = message.notification!.body ?? 'You have a new notification';
        entityId = message.data['entity_id'].toString();
        if (!_notificationHandled(entityId!)) {
          _showPopUpDialogue(
              1,
              entityId,
              title,
              body,
              formattedDate,
              formattedTime);
        }
      }
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    late SkippedReminderNotification skippedReminderNotification;
    String name = sharedPreferences.getString(UserConstants().userName)!;
    String id = sharedPreferences.getString(UserConstants().userId)!;
    String? formattedDate;
    String? formattedTime;

    if (message.notification != null) {
      // Handle the notification message here
      // For example, show a dialog
      print('Got a message whilst in the foreground!On Oppend App called');

      debugPrint('Message data: ${message.data}');

       type = message.data['type'].toString();

      if (type != "welcome_notification") {

        DateTime date = DateTime.parse(message.data['date_time'].toString());
        formattedDate = DateFormat('MM-dd-yy').format(date);
        formattedTime = DateFormat("hh:mm a").format(date);
        title = message.notification!.title ?? 'Notification';
        body = message.notification!.body ?? 'You have a new notification';
        entityId = message.data['entity_id'].toString();

        // if (!_notificationHandled(entityId!)) {
        //   _showPopUpDialogue(
        //       1,
        //       entityId,
        //       title,
        //       body,
        //       formattedDate,
        //       formattedTime);
        // }


        HTTPManager()
            .getSkippedReminderListData(LogoutRequestModel(userId: id))
            .then((value) {
          skippedReminderNotification = value;
          // sharedPreferences.setString("Score", "");

          print("SKIPPED REMINDER LIST");
          print(value);

          // if (!_notificationHandled("1")) {
          //   _showPopUpDialogue(
          //       1,
          //       "1",
          //       "title",
          //       "skippedReminderNotification.result![i].text.toString()",
          //       "formattedDate!",
          //       "formattedTime!");
          // }

          for(int i = 0; i<skippedReminderNotification.result!.length; i++) {

            if (!_notificationHandled(skippedReminderNotification.result![i].id.toString())) {
              String title = "Hi $name. Did you....";
              DateTime date = DateTime.parse(skippedReminderNotification.result![i].dateTime.toString());
              formattedDate = DateFormat('MM-dd-yy').format(date);
              formattedTime = DateFormat("hh:mm a").format(date);
              _showPopUpDialogue(1,
                  skippedReminderNotification.result![i].id.toString(),
                  title,
                  skippedReminderNotification.result![i].text.toString(),
                  formattedDate!,
                  formattedTime!
              );
            }
          }
        }).catchError((e) {
          print(e);

          // sharedPreferences.setString("Score", "");
        });


      }
    } });

}

final Set<String> _handledNotificationIds = <String>{};

bool _notificationHandled(String entityId1) {
  return _handledNotificationIds.contains(entityId1);
}

_showPopUpDialogue(int seconds,String? entityId1,String? title1,String? body1,String? formattedDate1,String? formattedTime1) {
  _handledNotificationIds.add(entityId1!);
  Future.delayed(Duration(seconds: seconds)).then((value) {
      print(value);
      showPopupDialogueForReminder(entityId1, title1!, body1!,true,formattedDate1!,formattedTime1!);
    });
  // if(notificationTapped) {
  //   showPopupDialogueForReminder(entityId1!, title1!, body1!,true,formattedDate1!,formattedTime1!);
  // }
}

// showPopupDialogueForReminder(String notificationId,String title,String description,bool onAppOpen) {
//   bool isDataLoading = false;
//   bool isYesDataLoading = false;
//   bool isNoDataLoading = false;
//
//   bool isPhone;
//   if(MediaQuery.of(NavigationService.navigatorKey.currentContext!).size.width<= 500) {
//     isPhone = true;
//   } else {
//     isPhone = false;
//   }
//   showDialog(
//       barrierDismissible: false,
//       context: NavigationService.navigatorKey.currentContext!,
//       builder: (context) {
//         return  StatefulBuilder(
//           builder: (BuildContext context, void Function(void Function()) setState) {
//             return AlertDialog(
//               backgroundColor: AppColors.naqFieldColor,
//               contentPadding: EdgeInsets.zero,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               content: SizedBox(
//                 height: MediaQuery.of(context).size.height/4,
//                 width: !isPhone ? MediaQuery.of(context).size.height/4 : MediaQuery.of(context).size.width,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Stack(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width,
//                             alignment: Alignment.topCenter,
//                             decoration: const BoxDecoration(
//                                 borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
//                                 color: AppColors.alertDialogueHeaderColor),
//                             // margin:const EdgeInsets.symmetric(vertical: 10),
//                             child: Container(
//                                 margin:!isPhone ? const EdgeInsets.symmetric(vertical: 30) : const EdgeInsets.symmetric(vertical: 10),
//                                 height: 50,
//                                 width: 50,
//                                 child: Image.asset('assets/bimage.png',)),
//                           ),
//                           Align(
//                             alignment: Alignment.topRight,
//                             child: IconButton(onPressed: () {
//                               Navigator.of(context).pop();
//                             }, icon: const Icon(Icons.close)),
//                           )
//                         ],
//                       ),
//                       Container(
//                         padding:const EdgeInsets.symmetric(horizontal: 10),
//                         margin:const EdgeInsets.symmetric(vertical: 10),
//                         child:  Text(title,textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.defaultFontSize,color: AppColors.alertDialogueColor),),
//                       ),
//                       Container(
//                         padding:const EdgeInsets.symmetric(horizontal: 10),
//                         margin:const EdgeInsets.symmetric(vertical: 10),
//                         child:  Text(description,textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.defaultFontSize),),
//                       ),
//                       Container(
//                           height: 30,
//                           margin:!isPhone ? const EdgeInsets.only(top: 100) : const EdgeInsets.only(top: 20),
//                           width: MediaQuery.of(context).size.width,
//                           decoration:const BoxDecoration(
//                               border: Border(
//                                   top: BorderSide(
//                                     color: AppColors.primaryColor,
//                                   )
//                               )
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               TextButton(onPressed: () {
//                                 setState(() {
//                                   isNoDataLoading = true;
//                                 });
//                                 // _notificationSnoozeReminderStatusData(notificationId,"yes");
//                                 HTTPManager().postReminderStopData(ReminderNotificationForStopRequestModel(notificationId: notificationId,reminderStop: "no")).then((value) {
//                                   setState(() {
//                                     isNoDataLoading = false;
//                                   });
//                                   // if(onAppOpen) {
//                                   //   Navigator.of(context).pop();
//                                   // }
//                                   Navigator.of(context).pop();
//                                   print("Notification Stop API");
//                                   print(value);
//                                 }).catchError((e) {
//                                   setState(() {
//                                     isNoDataLoading = false;
//                                   });
//                                   showToastMessage(NavigationService.navigatorKey.currentContext!, e.toString(), false);
//                                 });
//                               }, child:isNoDataLoading ? const SizedBox(
//                                   height: 15,
//                                   width: 15,
//                                   child: Center(child: CircularProgressIndicator(),)) : const Text("No",style: TextStyle(color: AppColors.textWhiteColor),)),
//                               const SizedBox(
//                                   height: 30,
//                                   child:  VerticalDivider(color: AppColors.primaryColor,thickness: 2,)),
//                               TextButton(onPressed: () {
//                                 setState(() {
//                                   isYesDataLoading = true;
//                                 });
//                                 // _notificationSnoozeReminderStatusData(notificationId,"yes");
//                                 HTTPManager().postReminderStopData(ReminderNotificationForStopRequestModel(notificationId: notificationId,reminderStop: "yes")).then((value) {
//                                   setState(() {
//                                     isYesDataLoading = false;
//                                   });
//                                   // if(onAppOpen) {
//                                   //   Navigator.of(context).pop();
//                                   // }
//                                   Navigator.of(context).pop();
//                                   print("Notification Stop API");
//                                   print(value);
//                                 }).catchError((e) {
//                                   setState(() {
//                                     isYesDataLoading = false;
//                                   });
//                                   showToastMessage(NavigationService.navigatorKey.currentContext!, e.toString(), false);
//                                 });
//                               }, child:isYesDataLoading ? const SizedBox(
//                                   height: 15,
//                                   width: 15,
//                                   child: Center(child: CircularProgressIndicator(),)) : const Text("Yes",style: TextStyle(color: AppColors.textWhiteColor),)),
//                               const SizedBox(
//                                   height: 30,
//                                   child:  VerticalDivider(color: AppColors.primaryColor,thickness: 2,)),
//                               TextButton(onPressed: () {
//                                 setState(() {
//                                   isDataLoading = true;
//                                 });
//                                 // _notificationSnoozeReminderStatusData(notificationId,"yes");
//                                 HTTPManager().postReminderSnoozeData(ReminderNotificationForSnoozeRequestModel(notificationId: notificationId,snooze: "yes")).then((value) {
//                                   setState(() {
//                                     isDataLoading = false;
//                                   });
//                                   // if(onAppOpen) {
//                                   //   Navigator.of(context).pop();
//                                   // }
//                                   showToastMessage(NavigationService.navigatorKey.currentContext!, "Reminder Snoozed for 15 minutes", true);
//                                   Navigator.of(context).pop();
//                                   print("Notification Snooze API");
//                                   print(value);
//                                 }).catchError((e) {
//                                   setState(() {
//                                     isDataLoading = false;
//                                   });
//                                   showToastMessage(NavigationService.navigatorKey.currentContext!, e.toString(), false);
//                                 });
//                               }, child:isDataLoading ? const SizedBox(
//                                   height: 15,
//                                   width: 15,
//                                   child: Center(child: CircularProgressIndicator(),)) : const Text("Snooze",style: TextStyle(color: AppColors.textWhiteColor),)),
//                             ],
//                           )
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       });
// }

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

showPopupDialogueForReminder(String notificationId,String title,String description,bool onAppOpen,String date,String time) {
  bool isDataLoading = false;
  bool isYesDataLoading = false;
  bool isNoDataLoading = false;

  print("Set of IDs");
  print(_handledNotificationIds);

  bool isPhone;
  if(MediaQuery.of(NavigationService.navigatorKey.currentContext!).size.width<= 500) {
    isPhone = true;
  } else {
    isPhone = false;
  }
  showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
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
                  width: !isPhone ? MediaQuery.of(context).size.width/3 : MediaQuery.of(context).size.width,
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

                                  _handledNotificationIds.remove(notificationId);
                                  print("Set of IDs After NO");
                                  print(_handledNotificationIds);
                                  showToastMessage(context,"Reminder status updated!", true);
                                  Navigator.of(context).pop();

                                }).catchError((e) {
                                  setState(() {
                                    isNoDataLoading = false;
                                  });
                                  showToastMessage(NavigationService.navigatorKey.currentContext!, e.toString(), false);
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

                                  _handledNotificationIds.remove(notificationId);
                                  print("Set of IDs After Yes");
                                  print(_handledNotificationIds);
                                  showToastMessage(context,"Reminder status updated!", true);
                                  Navigator.of(context).pop();

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
                              TextButton(
                                  onPressed: () {
                                setState(() {
                                  isDataLoading = true;
                                });
                                // HTTPManager().postReminderSnoozeData(ReminderNotificationForSnoozeRequestModel(notificationId: notificationId,snooze: "yes")).then((value) {
                                //   setState(() {
                                //     isDataLoading = false;
                                //   });
                                //   _handledNotificationIds.remove(notificationId);
                                //   print("Set of IDs After Snooze");
                                //   print(_handledNotificationIds);
                                //   showToastMessage(context, "Reminder Snoozed!", true);
                                //   Navigator.of(context).pop();
                                //
                                // }).catchError((e) {
                                //   setState(() {
                                //     isDataLoading = false;
                                //   });
                                //   showToastMessage(context, e.toString(), false);
                                // });
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


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print('Got a message whilst in the background!');

  debugPrint('Message data: ${message.data}');

  if (message.notification != null) {

  }
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

   final AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(appLifecycleObserver);
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Burgeon',
      theme: ThemeData(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryColor
        ),
        primaryColor: buildMaterialColor(AppColors.primaryColor),
        textButtonTheme: TextButtonThemeData(style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(color: AppColors.textWhiteColor)),
        )),
        appBarTheme:  const AppBarTheme(color: AppColors.primaryColor),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
          textStyle:  MaterialStateProperty.all<TextStyle>(
            const TextStyle(
              color: AppColors.textWhiteColor,
            )
          )
        )),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primaryColor),
        primarySwatch: buildMaterialColor(AppColors.primaryColor),
      ),
      home: const SplashScreenUpdate(),
    );
  }

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}

