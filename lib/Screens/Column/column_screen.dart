// ignore_for_file: unused_local_variable, avoid_print, duplicate_ignore, unused_element, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/column_read_data_model.dart';
import 'package:flutter_quiz_app/model/request_model/admin_access_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/column_delete_request.dart';
import 'package:flutter_quiz_app/model/request_model/column_read_list_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/share_custom_alert_dialogue.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../../model/reponse_model/skipped_list_response_model.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../model/request_model/session_entry_request.dart';
import '../../network/http_manager.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/share_pop_up_dialogue.dart';
import '../Widgets/show_notification_pop_up.dart';
import '../Widgets/toast_message.dart';
import '../utill/userConstants.dart';
import 'column_details_screen.dart';
import 'create_column_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ColumnScreen extends StatefulWidget {
  const ColumnScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ColumnScreenState createState() => _ColumnScreenState();
}

class _ColumnScreenState extends State<ColumnScreen> {

  String name = "";
  String id = "";
  String userAccess = "";
  // ignore: prefer_final_fields
  bool _isUserDataLoading = true;
  bool _isDeleteDataLoading = false;

  bool otherUserLoggedIn = false;

  dynamic result;
  String email = "";
  String timeZone = "";
  String userType = "";
  String selectedValue = "All";
  // ignore: prefer_final_fields
  // ignore: prefer_final_fields
  bool _isDataLoading = false;
  late bool isPhone;
  bool isSearch = false;
  int badgeCount1 = 0;

  // ignore: unnecessary_new
  List<ColumnReadDataModel> columnReadDataModel = [];
  List<ColumnReadDataModel> columnReadDataModelForSearch = [];
  List<ColumnReadDataModel> columnReadDataModelForMeeting = [];
  List<ColumnReadDataModel> columnReadDataModelForAll = [];
  List<ColumnReadDataModel> columnReadDataModelForEntry = [];
  List<ColumnReadDataModel> columnReadDataModelForTask = [];
  List<ColumnReadDataModel> columnReadDataModelForSession = [];
  final TextEditingController _searchController =  TextEditingController();

  String titleColumn = "https://youtu.be/zhhv_BVSXgI";
  int badgeCountShared = 0;

  bool checkbox = true;

  bool taskCheckbox = false;

  @override
  void initState() {
    // TODO: implement initState

    _getUserData();

    super.initState();
  }

  _getColumnScreenData(bool status) {
    setState(() {
      _isDataLoading  = status;
    });
    HTTPManager().sessionRead(ColumnReadRequestModel(userId: id)).then((value) {

      // ignore: avoid_print
      print(value.toString());
      ColumnReadResponseListModel columnReadResponseListModel = ColumnReadResponseListModel.fromJson(value['data']);

      setState(() {
        columnReadDataModelForAll.clear();
        columnReadDataModelForSearch.clear();
        columnReadDataModelForEntry.clear();
        columnReadDataModelForSession.clear();
        columnReadDataModelForMeeting.clear();
        columnReadDataModelForTask.clear();

        columnReadDataModel = columnReadResponseListModel.values;
        columnReadDataModelForAll = columnReadResponseListModel.values;
        columnReadDataModelForSearch = columnReadResponseListModel.values;

        columnReadDataModel.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
        columnReadDataModelForAll.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
        columnReadDataModelForSearch.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
      });
      for(int i = 0; i<columnReadDataModel.length; i++) {
        if(columnReadDataModel[i].entryType == "entry") {
          columnReadDataModelForEntry.add(columnReadDataModel[i]);
          columnReadDataModelForEntry.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
        }else if(columnReadDataModel[i].entryType == "meeting") {
          columnReadDataModelForMeeting.add(columnReadDataModel[i]);
          columnReadDataModelForMeeting.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
        } else if(columnReadDataModel[i].entryType == "session"){
          columnReadDataModelForSession.add(columnReadDataModel[i]);
          columnReadDataModelForSession.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
        } else {
          columnReadDataModelForTask.add(columnReadDataModel[i]);
          columnReadDataModelForTask.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
        }
      }
      setState(() {
        _isDataLoading = false;
      });
    }).catchError((e){
      setState(() {
        _isDataLoading  = false;
      });
    });
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

      name = sharedPreferences.getString(UserConstants().otherUserName)!;
      id = sharedPreferences.getString(UserConstants().otherUserId)!;

    } else {

      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

      userAccess = sharedPreferences.getString(UserConstants().userAccess)!;

      _getSkippedReminderList();

      if(userAccess == "no") {
        showAdminAccessPopUp();
      }
    }

    _getColumnScreenData(true);

    setState(() {
      _isUserDataLoading = false;
    });
  }

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

  showAdminAccessPopUp() {
    bool isPhone;
    bool isLadingAdminAccess = false;
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding:const EdgeInsets.symmetric(horizontal: 5),
                                  margin:const EdgeInsets.symmetric(vertical: 5),
                                  child:  Text("Admin want to make changes to you column section in future.",textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.defaultFontSize,color: AppColors.alertDialogueColor),),
                                ),
                                Container(
                                    padding:const EdgeInsets.symmetric(horizontal: 5),
                                    margin:const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: checkbox,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              checkbox = !checkbox;
                                            });
                                          },
                                        ),
                                        Expanded(child: Text("By Checking the check box you are allowing admin for changes",textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.defaultFontSize),),)
                                      ],
                                    )


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
                                TextButton(onPressed: () async {
                                  String userAccessNew = "";
                                  setState(() {
                                    isLadingAdminAccess = true;

                                    if(checkbox) {
                                      userAccessNew = "yes";
                                    } else {
                                      userAccessNew = "no";
                                    }

                                  });
                                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  HTTPManager().adminAccess(AdminAccessRequestModel(userId: id,adminAccess: userAccessNew)).then((value){
                                    setState(() {
                                      isLadingAdminAccess = false;
                                    });
                                    sharedPreferences.setString(UserConstants().userAccess, value['data']['admin_access'].toString());
                                    Navigator.of(context).pop();
                                  }).catchError((e) {
                                    setState(() {
                                      isLadingAdminAccess = false;
                                    });
                                  });


                                }, child:isLadingAdminAccess ?const Center(child: CircularProgressIndicator(),) : const Text("Save",style: TextStyle(color: AppColors.textWhiteColor),)),
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


  String? formattedDate;
  String? formattedTime;
  late SkippedReminderNotification skippedReminderNotification;

  _getSkippedReminderList() {
    setState(() {
      // sharedPreferences.setString("Score", "");
      // _isDataLoading = true;
    });
    HTTPManager().getSkippedReminderListData(LogoutRequestModel(userId: id)).then((value) {
      setState(() {
        skippedReminderNotification = value;
        // sharedPreferences.setString("Score", "");
        // _isDataLoading = false;
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
      setState(() {
        // sharedPreferences.setString("Score", "");
        // _isDataLoading = false;
      });
    });
  }

  void filterSearchResults(String query) {
    // ignore: avoid_print
    print(query);
    // for(int i = 0;i<columnReadDataModel.length;i++) {
    //   if(columnReadDataModel[i].entryTitle.toString().toLowerCase().contains(query.toLowerCase()) ||
    //       columnReadDataModel[i].entryDate.toString().toLowerCase().contains(query.toLowerCase())||
    //       columnReadDataModel[i].entryDecs.toString().toLowerCase().contains(query.toLowerCase()) ) {
    //     setState(() {
    //       columnReadDataModelForSearch.add(columnReadDataModel[i]);
    //     });
    //   }
    // }
    setState(() {
      isSearch = true;
      // ignore: avoid_print
      print(DateFormat('MM-dd-yy').format(DateTime.parse(columnReadDataModel[0].entryDate.toString())));
      columnReadDataModelForSearch = columnReadDataModel
          .where((ColumnReadDataModel item) => ("${DateFormat('MM-dd-yy').format(DateTime.parse(item.entryDate.toString()))} ${item.entryTitle.toString()} ${item.entryDecs.toString()}").toLowerCase().contains(query.toLowerCase()))
          .toList();
      columnReadDataModelForSearch.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
    });
  }

  showDeletePopup(String? recordId,int index1) {

    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title:const Text('Confirm delete?'),
            content:const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text("Are you sure you want to delete!"),
            ),
            actions: [
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteColumnData(recordId, index1);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
                Navigator.of(context).pop();

            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
            //         (Route<dynamic> route) => false
            // );
          }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared,otherUserLoggedIn,name),
      floatingActionButton: Container(
        width: 60.0,
        height: 60.0,
        margin:const EdgeInsets.only(right: 10,bottom: 10),
        child: Visibility(
          visible: !otherUserLoggedIn,
          child: FloatingActionButton(
            onPressed: () {

                ColumnReadDataModel columnReadDataModelSample = ColumnReadDataModel(id:"",
                    userId : "",
                    entryTitle : "",
                    entryDecs :"",
                    entryDate :"",
                    entryType : "",
                    entryTakeaway : "",
                    createdAt :"",);
                Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateColumnScreen(false,columnReadDataModelSample))).then((value) {
                  _getColumnScreenData(false);
                }).catchError((e) {
                  print(e.toString());
                });



            },
            child: const Icon(Icons.add,color: AppColors.backgroundColor,size: 30,),
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _isDataLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LogoScreen("Column"),
                          const SizedBox(width: 20,),
                          IconButton(onPressed: (){
                            String? videoId = YoutubePlayer.convertUrlToId(titleColumn);
                            YoutubePlayerController playerController = YoutubePlayerController(
                                initialVideoId: videoId!,
                                flags: const YoutubePlayerFlags(
                                  autoPlay: false,
                                  controlsVisibleAtStart: false,
                                )

                            );
                            videoPopupDialog(context,"Introduction to Column",playerController);
                            //bottomSheet(context,"Trellis","Welcome to Trellis, the part of the Brugeon app designed to help you flourish and live life intentionally. Trellis is a light structure that provides structure and focus, and helps propel you towards your desired outcomes. Invest at least five minutes a day in reviewing and meditating on your Trellis. If you don't have any answers yet, spend your time meditating, praying, or journaling on the questions/sections. If you have partial answers, keep taking your time daily to consider the questions and your answers. By consistently returning to your Trellis, you will become more clear and focused on creating the outcomes you desire. Enjoy your Trellis!","");
                          }, icon: const Icon(Icons.ondemand_video,size:30,color: AppColors.infoIconColor,))
                        ],
                      ),
                      // SizedBox(width: 20,),
                      // IconButton(onPressed: (){
                      //   bottomSheet(context,"Trellis","Welcome to Trellis, the part of the Brugeon app designed to help you flourish and live life intentionally. Trellis is a light structure that provides structure and focus, and helps propel you towards your desired outcomes. Invest at least five minutes a day in reviewing and meditating on your Trellis. If you don't have any answers yet, spend your time meditating, praying, or journaling on the questions/sections. If you have partial answers, keep taking your time daily to consider the questions and your answers. By consistently returning to your Trellis, you will become more clear and focused on creating the outcomes you desire. Enjoy your Trellis!","");
                      // }, icon: const Icon(Icons.info_outline,size:20,color: AppColors.infoIconColor,))
                    ],
                  ),
                  // isSearch ?
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: OptionMcqAnswer(
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  alignment: Alignment.centerRight,
                                  value: selectedValue,
                                  borderRadius: BorderRadius.circular(10),
                                  onChanged: (String? newValue) {

                                    setState(() {
                                      columnReadDataModel = [];
                                      columnReadDataModelForSearch = [];
                                      _searchController.text = "";
                                      selectedValue = newValue!;
                                      if(selectedValue == "All") {
                                        columnReadDataModelForSearch = columnReadDataModelForAll;
                                        columnReadDataModel = columnReadDataModelForAll;
                                        columnReadDataModel.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
                                      } else if(selectedValue == "Entry") {
                                        columnReadDataModelForSearch = columnReadDataModelForEntry;
                                        columnReadDataModel = columnReadDataModelForEntry;
                                        columnReadDataModel.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
                                      } else if(selectedValue == "Meeting") {
                                        columnReadDataModelForSearch = columnReadDataModelForMeeting;
                                        columnReadDataModel = columnReadDataModelForMeeting;
                                        columnReadDataModel.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
                                      } else if(selectedValue == "Task") {
                                        columnReadDataModelForSearch = columnReadDataModelForTask;
                                        columnReadDataModel = columnReadDataModelForTask;
                                        columnReadDataModel.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
                                      } else {
                                        columnReadDataModelForSearch = columnReadDataModelForSession;
                                        columnReadDataModel = columnReadDataModelForSession;
                                        columnReadDataModel.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
                                      }
                                    });
                                  },
                                  items: const <DropdownMenuItem<String>>[
                                    DropdownMenuItem<String>(
                                      value: 'All',
                                      child: Text('All'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Entry',
                                      child: Text('Entry'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Session',
                                      child: Text('Session'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Meeting',
                                      child: Text('Meeting'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Task',
                                      child: Text('Task'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(width: 5,),
                        //
                        // Expanded(
                        //   flex: 2,
                        //   child: SearchTextField((value) {
                        //     if(value.isEmpty) {
                        //       setState(() {
                        //         isSearch = false;
                        //       });
                        //     } else {
                        //       filterSearchResults(value);
                        //     }
                        //   }, _searchController, 1, false, "search here with title"),
                        // ),
                      ],
                    ),
                  ),
                      // :
                  // Container(
                  //   margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/1.5),
                  //   alignment: Alignment.centerRight,
                  //   child: OptionMcqAnswer(
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 10),
                  //       child: DropdownButton<String>(
                  //         isExpanded: true,
                  //         elevation: 0,
                  //         alignment: Alignment.centerRight,
                  //         value: selectedValue,
                  //         onChanged: (String? newValue) {
                  //           // columnReadDataModel.clear();
                  //           // ignore: avoid_print
                  //           print(columnReadDataModelForAll);
                  //           // ignore: avoid_print
                  //           print(columnReadDataModelForEntry);
                  //           // ignore: avoid_print
                  //           print(columnReadDataModelForSession);
                  //
                  //           setState(() {
                  //             columnReadDataModel = [];
                  //             columnReadDataModelForSearch = [];
                  //             _searchController.text = "";
                  //             selectedValue = newValue!;
                  //             if(selectedValue == "All") {
                  //               columnReadDataModelForSearch = columnReadDataModelForAll;
                  //               columnReadDataModel = columnReadDataModelForAll;
                  //               columnReadDataModel.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
                  //             } else if(selectedValue == "Entry") {
                  //               columnReadDataModelForSearch = columnReadDataModelForEntry;
                  //               columnReadDataModel = columnReadDataModelForEntry;
                  //               columnReadDataModel.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
                  //             } else if(selectedValue == "Meeting") {
                  //               columnReadDataModelForSearch = columnReadDataModelForMeeting;
                  //               columnReadDataModel = columnReadDataModelForMeeting;
                  //               columnReadDataModel.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
                  //             } else if(selectedValue == "Task") {
                  //               columnReadDataModelForSearch = columnReadDataModelForTask;
                  //               columnReadDataModel = columnReadDataModelForTask;
                  //               columnReadDataModel.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
                  //             } else {
                  //               columnReadDataModelForSearch = columnReadDataModelForSession;
                  //               columnReadDataModel = columnReadDataModelForSession;
                  //               columnReadDataModel.sort((a,b) => b.entryDate!.compareTo(a.entryDate.toString()));
                  //             }
                  //           });
                  //         },
                  //         items: const <DropdownMenuItem<String>>[
                  //           DropdownMenuItem<String>(
                  //             value: 'All',
                  //             child: Text('All'),
                  //           ),
                  //           DropdownMenuItem<String>(
                  //             value: 'Entry',
                  //             child: Text('Entry'),
                  //           ),
                  //           DropdownMenuItem<String>(
                  //             value: 'Session',
                  //             child: Text('Session'),
                  //           ),
                  //           DropdownMenuItem<String>(
                  //             value: 'Meeting',
                  //             child: Text('Meeting'),
                  //           ),
                  //           DropdownMenuItem<String>(
                  //             value: 'Task',
                  //             child: Text('Task'),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  _isDataLoading ? const Center(child: CircularProgressIndicator(),) : columnReadDataModel.isNotEmpty  ?

                  Column(
                    children: [
                      Visibility(
                        visible: isSearch,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // reverse: true,
                            itemCount: isSearch ? columnReadDataModelForSearch.length : columnReadDataModel.length,
                            itemBuilder: (context,index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ColumnDetailsScreen(isSearch ? columnReadDataModelForSearch[index] :columnReadDataModel[index])));
                                },
                                child: Card(
                                  color: isSearch ? columnReadDataModelForSearch[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor : columnReadDataModel[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                   decoration: BoxDecoration(
                                     color: isSearch ? columnReadDataModelForSearch[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor : columnReadDataModel[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                     borderRadius: BorderRadius.circular(10.0),
                                   ),
                                    child: Row(
                                      children: [
                                        if(!otherUserLoggedIn)
                                        if(isSearch ? columnReadDataModelForSearch[index].entryType == "task" : columnReadDataModel[index].entryType == "task")
                                        Checkbox(
                                          value: isSearch ? columnReadDataModelForSearch[index].completed == "no" ? false : true : columnReadDataModel[index].completed == "no" ? false : true ,
                                          onChanged: (bool? value) {
                                            _completeTask( index,isSearch,isSearch ? columnReadDataModelForSearch[index] : columnReadDataModel[index]);
                                          },
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(isSearch ? columnReadDataModelForSearch[index].entryTitle!.trim() :columnReadDataModel[index].entryTitle!.trim(),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: AppConstants.headingFontSizeForEntriesAndSession),
                                                    ),
                                                  ),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: () async {
                                                        showDialog(
                                                            barrierDismissible: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return ShareCustomAlertDialogue(responseId: columnReadDataModelForSearch[index].id.toString(), isModule: false, responseType: "column");
                                                            }
                                                        );
                                                        // showThumbsUpDialogue(context, _animationController, id, 'column', columnReadDataModelForSearch[index].id.toString(), selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
                                                        },
                                                      child: const Icon(Icons.share,color: AppColors.primaryColor,)),
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: ()  {
                                                       Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateColumnScreen(true,isSearch ? columnReadDataModelForSearch[index] :columnReadDataModel[index]))).then((value) {
                                                         _getColumnScreenData(false);
                                                        }).catchError((e) {

                                                        });


                                                        // showDeletePopup(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                      },
                                                      child: const Icon(Icons.edit,color: AppColors.primaryColor,)),
                                                  if(!otherUserLoggedIn)
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  if(isSearch ? columnReadDataModelForSearch[index].definedBy == "user" : columnReadDataModel[index].definedBy == "user")
                                                  GestureDetector(
                                                      onTap: () {
                                                        showDeletePopup(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                      },
                                                      child: const Icon(Icons.delete,color: AppColors.redColor,)),
                                                  // IconButton(onPressed: (){
                                                  //
                                                  // }, icon: Icon(Icons.delete,color: AppColors.redColor,))
                                                ],

                                              ),
                                              Row(
                                                children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(isSearch ? columnReadDataModelForSearch[index].entryDate.toString() :columnReadDataModel[index].entryDate.toString())),style: const TextStyle(fontSize: AppConstants.defaultFontSize),)),
                                                  // const SizedBox(width: 20,),
                                                  // if(isSearch ? columnReadDataModelForSearch[index].definedBy != "user" : columnReadDataModel[index].definedBy != "user")
                                                  // Text("Added by: "),
                                                  // Text("Admin"),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Visibility(
                        visible: selectedValue == "All" && !isSearch,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // reverse: true,
                            itemCount:  columnReadDataModelForAll.length,
                            itemBuilder: (context,index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ColumnDetailsScreen(columnReadDataModelForAll[index])));
                                },
                                child: Card(
                                  color: columnReadDataModelForAll[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    decoration: BoxDecoration(
                                      color: columnReadDataModelForAll[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        if(!otherUserLoggedIn)
                                        if( columnReadDataModelForAll[index].entryType == "task")
                                          Checkbox(
                                            value:columnReadDataModelForAll[index].completed == "no" ? false : true,
                                            onChanged: (bool? value) {
                                              _completeTask( index,isSearch, columnReadDataModelForAll[index]);
                                            },
                                          ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(columnReadDataModelForAll[index].entryTitle!,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: AppConstants.headingFontSizeForEntriesAndSession),
                                                    ),
                                                  ),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: () async {
                                                        showDialog(
                                                            barrierDismissible: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return ShareCustomAlertDialogue(responseId: columnReadDataModelForAll[index].id.toString(), isModule: false, responseType: "column");
                                                            }
                                                        );
                                                        // showThumbsUpDialogue(context, _animationController, id, 'column', columnReadDataModelForAll[index].id.toString(), selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
                                                      },
                                                      child: const Icon(Icons.share,color: AppColors.primaryColor,)),
                                                  if(!otherUserLoggedIn)
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: ()  {
                                                        Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateColumnScreen(true,columnReadDataModelForAll[index]))).then((value) {
                                                          _getColumnScreenData(false);
                                                        }).catchError((e) {

                                                        });


                                                        // showDeletePopup(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                      },
                                                      child: const Icon(Icons.edit,color: AppColors.primaryColor,)),
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  if(columnReadDataModelForAll[index].definedBy == "user")
                                                    GestureDetector(
                                                        onTap: () {
                                                          showDeletePopup(columnReadDataModelForAll[index].id,index);
                                                          // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        },
                                                        child: const Icon(Icons.delete,color: AppColors.redColor,)),
                                                  // IconButton(onPressed: (){
                                                  //
                                                  // }, icon: Icon(Icons.delete,color: AppColors.redColor,))
                                                ],

                                              ),
                                              Row(
                                                children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(columnReadDataModelForAll[index].entryDate.toString())),style: const TextStyle(fontSize: AppConstants.defaultFontSize),)),
                                                  // const SizedBox(width: 20,),
                                                  // if(isSearch ? columnReadDataModelForSearch[index].definedBy != "user" : columnReadDataModel[index].definedBy != "user")
                                                  // Text("Added by: "),
                                                  // Text("Admin"),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Visibility(
                        visible: selectedValue == "Entry" && !isSearch,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // reverse: true,
                            itemCount:  columnReadDataModelForEntry.length,
                            itemBuilder: (context,index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ColumnDetailsScreen(columnReadDataModelForEntry[index])));
                                },
                                child: Card(
                                  color: columnReadDataModelForEntry[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    decoration: BoxDecoration(
                                      color: columnReadDataModelForEntry[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        if(!otherUserLoggedIn)
                                        if( columnReadDataModelForEntry[index].entryType == "task")
                                          Checkbox(
                                            value:columnReadDataModelForEntry[index].completed == "no" ? false : true,
                                            onChanged: (bool? value) {
                                              _completeTask( index,isSearch, columnReadDataModelForEntry[index]);
                                            },
                                          ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(columnReadDataModelForEntry[index].entryTitle!,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: AppConstants.headingFontSizeForEntriesAndSession),
                                                    ),
                                                  ),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: () async {
                                                        showDialog(
                                                            barrierDismissible: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return ShareCustomAlertDialogue(responseId: columnReadDataModelForEntry[index].id.toString(), isModule: false, responseType: "column");
                                                            }
                                                        );
                                                        // showThumbsUpDialogue(context, _animationController, id, 'column', columnReadDataModelForEntry[index].id.toString(), selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
                                                      },
                                                      child: const Icon(Icons.share,color: AppColors.primaryColor,)),
                                                  if(!otherUserLoggedIn)
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: ()  {
                                                        Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateColumnScreen(true,columnReadDataModelForEntry[index]))).then((value) {
                                                          _getColumnScreenData(false);
                                                        }).catchError((e) {

                                                        });


                                                        // showDeletePopup(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                      },
                                                      child: const Icon(Icons.edit,color: AppColors.primaryColor,)),
                                                  if(!otherUserLoggedIn)
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  if(columnReadDataModelForEntry[index].definedBy == "user")
                                                    GestureDetector(
                                                        onTap: () {
                                                          showDeletePopup(columnReadDataModelForEntry[index].id,index);
                                                          // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        },
                                                        child: const Icon(Icons.delete,color: AppColors.redColor,)),
                                                  // IconButton(onPressed: (){
                                                  //
                                                  // }, icon: Icon(Icons.delete,color: AppColors.redColor,))
                                                ],

                                              ),
                                              Row(
                                                children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(columnReadDataModelForEntry[index].entryDate.toString())),style: const TextStyle(fontSize: AppConstants.defaultFontSize),)),
                                                  // const SizedBox(width: 20,),
                                                  // if(isSearch ? columnReadDataModelForSearch[index].definedBy != "user" : columnReadDataModel[index].definedBy != "user")
                                                  // Text("Added by: "),
                                                  // Text("Admin"),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Visibility(
                        visible: selectedValue == "Session" && !isSearch,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // reverse: true,
                            itemCount:  columnReadDataModelForSession.length,
                            itemBuilder: (context,index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ColumnDetailsScreen(columnReadDataModelForSession[index])));
                                },
                                child: Card(
                                  color: columnReadDataModelForSession[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    decoration: BoxDecoration(
                                      color: columnReadDataModelForSession[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        if(!otherUserLoggedIn)
                                        if( columnReadDataModelForSession[index].entryType == "task")
                                          Checkbox(
                                            value:columnReadDataModelForSession[index].completed == "no" ? false : true,
                                            onChanged: (bool? value) {
                                              _completeTask( index,isSearch, columnReadDataModelForSession[index]);
                                            },
                                          ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(columnReadDataModelForSession[index].entryTitle!,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: AppConstants.headingFontSizeForEntriesAndSession),
                                                    ),
                                                  ),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: () async {
                                                        showDialog(
                                                            barrierDismissible: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return ShareCustomAlertDialogue(responseId: columnReadDataModelForSession[index].id.toString(), isModule: false, responseType: "column");
                                                            }
                                                        );
                                                        // showThumbsUpDialogue(context, _animationController, id, 'column', columnReadDataModelForSession[index].id.toString(), selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
                                                      },
                                                      child: const Icon(Icons.share,color: AppColors.primaryColor,)),
                                                  if(!otherUserLoggedIn)
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: ()  {
                                                        Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateColumnScreen(true,columnReadDataModelForSession[index]))).then((value) {
                                                          _getColumnScreenData(false);
                                                        }).catchError((e) {

                                                        });


                                                        // showDeletePopup(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                      },
                                                      child: const Icon(Icons.edit,color: AppColors.primaryColor,)),
                                                  if(!otherUserLoggedIn)
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  if(columnReadDataModelForSession[index].definedBy == "user")
                                                    GestureDetector(
                                                        onTap: () {
                                                          showDeletePopup(columnReadDataModelForSession[index].id,index);
                                                          // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        },
                                                        child: const Icon(Icons.delete,color: AppColors.redColor,)),
                                                  // IconButton(onPressed: (){
                                                  //
                                                  // }, icon: Icon(Icons.delete,color: AppColors.redColor,))
                                                ],

                                              ),
                                              Row(
                                                children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(columnReadDataModelForSession[index].entryDate.toString())),style: const TextStyle(fontSize: AppConstants.defaultFontSize),)),
                                                  // const SizedBox(width: 20,),
                                                  // if(isSearch ? columnReadDataModelForSearch[index].definedBy != "user" : columnReadDataModel[index].definedBy != "user")
                                                  // Text("Added by: "),
                                                  // Text("Admin"),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Visibility(
                        visible: selectedValue == "Meeting" && !isSearch,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // reverse: true,
                            itemCount:  columnReadDataModelForMeeting.length,
                            itemBuilder: (context,index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ColumnDetailsScreen(columnReadDataModelForMeeting[index])));
                                },
                                child: Card(
                                  color: columnReadDataModelForMeeting[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    decoration: BoxDecoration(
                                      color: columnReadDataModelForMeeting[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        if(!otherUserLoggedIn)
                                        if( columnReadDataModelForMeeting[index].entryType == "task")
                                          Checkbox(
                                            value:columnReadDataModelForMeeting[index].completed == "no" ? false : true,
                                            onChanged: (bool? value) {
                                              _completeTask( index,isSearch, columnReadDataModelForMeeting[index]);
                                            },
                                          ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(columnReadDataModelForMeeting[index].entryTitle!,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: AppConstants.headingFontSizeForEntriesAndSession),
                                                    ),
                                                  ),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: () async {
                                                        showDialog(
                                                            barrierDismissible: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return ShareCustomAlertDialogue(responseId: columnReadDataModelForMeeting[index].id.toString(), isModule: false, responseType: "column");
                                                            }
                                                        );
                                                        // showThumbsUpDialogue(context, _animationController, id, 'column', columnReadDataModelForMeeting[index].id.toString(), selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
                                                      },
                                                      child: const Icon(Icons.share,color: AppColors.primaryColor,)),
                                                  if(!otherUserLoggedIn)
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: ()  {
                                                        Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateColumnScreen(true,columnReadDataModelForMeeting[index]))).then((value) {
                                                          _getColumnScreenData(false);
                                                        }).catchError((e) {

                                                        });


                                                        // showDeletePopup(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                      },
                                                      child: const Icon(Icons.edit,color: AppColors.primaryColor,)),
                                                  if(!otherUserLoggedIn)
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  if(columnReadDataModelForMeeting[index].definedBy == "user")
                                                    GestureDetector(
                                                        onTap: () {
                                                          showDeletePopup(columnReadDataModelForMeeting[index].id,index);
                                                          // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        },
                                                        child: const Icon(Icons.delete,color: AppColors.redColor,)),
                                                  // IconButton(onPressed: (){
                                                  //
                                                  // }, icon: Icon(Icons.delete,color: AppColors.redColor,))
                                                ],

                                              ),
                                              Row(
                                                children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(columnReadDataModelForMeeting[index].entryDate.toString())),style: const TextStyle(fontSize: AppConstants.defaultFontSize),)),
                                                  // const SizedBox(width: 20,),
                                                  // if(isSearch ? columnReadDataModelForSearch[index].definedBy != "user" : columnReadDataModel[index].definedBy != "user")
                                                  // Text("Added by: "),
                                                  // Text("Admin"),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Visibility(
                        visible: selectedValue == "Task" && !isSearch,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // reverse: true,
                            itemCount:  columnReadDataModelForTask.length,
                            itemBuilder: (context,index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ColumnDetailsScreen(columnReadDataModelForTask[index])));
                                },
                                child: Card(
                                  color: columnReadDataModelForTask[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    decoration: BoxDecoration(
                                      color: columnReadDataModelForTask[index].definedBy != "user" ? AppColors.highlightColor : AppColors.lightGreyColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        if(!otherUserLoggedIn)
                                        if( columnReadDataModelForTask[index].entryType == "task")
                                          Checkbox(
                                            value:columnReadDataModelForTask[index].completed == "no" ? false : true,
                                            onChanged: (bool? value) {
                                              _completeTask( index,isSearch, columnReadDataModelForTask[index]);
                                            },
                                          ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(columnReadDataModelForTask[index].entryTitle!,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: AppConstants.headingFontSizeForEntriesAndSession),
                                                    ),
                                                  ),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: () async {
                                                        showDialog(
                                                            barrierDismissible: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return ShareCustomAlertDialogue(responseId: columnReadDataModelForTask[index].id.toString(), isModule: false, responseType: "column");
                                                            }
                                                        );
                                                        // showThumbsUpDialogue(context, _animationController, id, 'column', columnReadDataModelForTask[index].id.toString(), selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
                                                      },
                                                      child: const Icon(Icons.share,color: AppColors.primaryColor,)),
                                                  if(!otherUserLoggedIn)
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  GestureDetector(
                                                      onTap: ()  {
                                                        Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateColumnScreen(true,columnReadDataModelForTask[index]))).then((value) {
                                                          _getColumnScreenData(false);
                                                        }).catchError((e) {

                                                        });


                                                        // showDeletePopup(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                      },
                                                      child: const Icon(Icons.edit,color: AppColors.primaryColor,)),
                                                  if(!otherUserLoggedIn)
                                                  const SizedBox(width: 5,),
                                                  if(!otherUserLoggedIn)
                                                  if(columnReadDataModelForTask[index].definedBy == "user")
                                                    GestureDetector(
                                                        onTap: () {
                                                          showDeletePopup(columnReadDataModelForTask[index].id,index);
                                                          // _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                                        },
                                                        child: const Icon(Icons.delete,color: AppColors.redColor,)),
                                                  // IconButton(onPressed: (){
                                                  //
                                                  // }, icon: Icon(Icons.delete,color: AppColors.redColor,))
                                                ],

                                              ),
                                              Row(
                                                children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(columnReadDataModelForTask[index].entryDate.toString())),style: const TextStyle(fontSize: AppConstants.defaultFontSize),)),
                                                  // const SizedBox(width: 20,),
                                                  // if(isSearch ? columnReadDataModelForSearch[index].definedBy != "user" : columnReadDataModel[index].definedBy != "user")
                                                  // Text("Added by: "),
                                                  // Text("Admin"),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ) : const Center(
                    child: Text("No Data Available"),
                  )
                ],
              ),
              _isDeleteDataLoading ? const Align(
                alignment: Alignment.center,
              child: Center(
                child: CircularProgressIndicator(),
              ),
              ) : Container(),
            ],
          )
        ),
      ),
    );
  }

  _completeTask(int index,bool isSear,ColumnReadDataModel columnReadDataModel1) {
    String? complete;
    setState(() {
      _isDeleteDataLoading = true;

      if(columnReadDataModel1.completed == "no") {
        complete = "yes";
      } else {
        complete = "no";
      }

    });

    HTTPManager().sessionTaskComplete(ColumnTaskCompleteRequestModel(sessionId: columnReadDataModel1.id,completed: complete)).then((value) {
      showToastMessage(context, "Task status updated successfully", true);
      setState(() {
        _isDeleteDataLoading = false;
      });
      ColumnReadDataModel columnReadDataModel2 = value;



        // if(isSear) {
        //   columnReadDataModelForSearch[index] = columnReadDataModel2;
        // } else {
        //   columnReadDataModel[index] = columnReadDataModel2;
        // }
      for(int i=0;i<columnReadDataModelForTask.length;i++) {
        if(columnReadDataModelForTask[i].id.toString() == columnReadDataModel1.id) {
          columnReadDataModelForTask[i] = columnReadDataModel2;
        }
      }
      for(int i=0;i<columnReadDataModelForAll.length;i++) {
        if(columnReadDataModelForAll[i].id.toString() == columnReadDataModel1.id) {
          columnReadDataModelForAll[i] = columnReadDataModel2;
        }
      }

    }).catchError((e) {
      setState(() {
        _isDeleteDataLoading = false;
      });
      showToastMessage(context, e.toString(), false);
    });
  }

  _deleteColumnData(String? id,int index) {
    setState(() {
      _isDeleteDataLoading = true;
    });
      HTTPManager().sessionDelete(ColumnDeleteRequestModel(recordId: id)).then((value) {
        // ignore: avoid_print
        print(value);
        showToastMessage(context, "Data deleted Successfully add", true);
        //Navigator.of(context).pop();
        for(int i=0;i<columnReadDataModelForAll.length;i++) {
          if(columnReadDataModelForAll[i].id == id) {
            columnReadDataModelForAll.removeAt(i);
          }
        }
        for(int i=0;i<columnReadDataModel.length;i++) {
          if(columnReadDataModel[i].id == id) {
            columnReadDataModel.removeAt(i);
          }
        }
        for(int i=0;i<columnReadDataModelForSearch.length;i++) {
          if(columnReadDataModelForSearch[i].id == id) {
            columnReadDataModelForSearch.removeAt(i);
          }
        }
        for(int i=0;i<columnReadDataModelForEntry.length;i++) {
          if(columnReadDataModelForEntry[i].id == id) {
            columnReadDataModelForEntry.removeAt(i);
          }
        }
        for(int i=0;i<columnReadDataModelForSession.length;i++) {
          if(columnReadDataModelForSession[i].id == id) {
            columnReadDataModelForSession.removeAt(i);
          }
        }
        for(int i=0;i<columnReadDataModelForMeeting.length;i++) {
          if(columnReadDataModelForMeeting[i].id == id) {
            columnReadDataModelForMeeting.removeAt(i);
          }
        }
        for(int i=0;i<columnReadDataModelForTask.length;i++) {
          if(columnReadDataModelForTask[i].id == id) {
            columnReadDataModelForTask.removeAt(i);
          }
        }
        setState(() {
          _isDeleteDataLoading = false;
        });
      }).catchError((e) {
        // ignore: avoid_print
        print(e);
        setState(() {
          _isDeleteDataLoading = false;
        });
        showToastMessage(context, e.toString(), false);
      });
    }
}


