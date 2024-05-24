
// ignore_for_file: avoid_print, unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:flutter_quiz_app/model/request_model/post_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../model/reponse_model/post_reminder_list_response_model.dart';
import '../../model/reponse_model/skipped_list_response_model.dart';
import '../../network/http_manager.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/show_notification_pop_up.dart';
import '../utill/userConstants.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  String name = "";
  String id = "";
  String email = "";
  String timeZone = "";
  String userType = "";
  bool _isLoading = true;
  // bool _isLoading1 = true;
  bool _isDataLoading = false;
  bool _isUserDataLoading = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool switchValue = false;
  bool expansionValue = false;
  bool isRepeat = true;
  String daysSelected = "Everyone";
  // String selectedValue = "P.I.R.E.";
  String errorMessage = "";
  String userPremium = "";
  String selectedRadio = "repeat";

  bool otherUserLoggedIn = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reminderTimeController = TextEditingController();
  final categoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime selectedReminderTime= DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  late PostReminderResponseListModel postReminderResponseListModel;
  List <String> dateList = <String>[];

  List<String> categoryList = <String>["P.I.R.E.","Trellis","Column","Garden","Ladder","Bridge","Other"];

   List _weekdays = [
    {"name" : "Sun", "Selected": true},
    {"name" : "Mon", "Selected": true},
    {"name" : "Tue", "Selected": true},
    {"name" : "Wed", "Selected": true},
    {"name" : "Thu", "Selected": true},
    {"name" : "Fri", "Selected": true},
    {"name" : "Sat", "Selected": true},];
   List _selectedWeekdays = [
     {"name" : "Sun", "Selected": true},
     {"name" : "Mon", "Selected": true},
     {"name" : "Tue", "Selected": true},
     {"name" : "Wed", "Selected": true},
     {"name" : "Thu", "Selected": true},
     {"name" : "Fri", "Selected": true},
     {"name" : "Sat", "Selected": true},];

   FixedExtentScrollController _scrollControllerHour = FixedExtentScrollController();
   FixedExtentScrollController _scrollControllerMin = FixedExtentScrollController();
   FixedExtentScrollController _scrollControllerAmPM = FixedExtentScrollController();

  int _selectedItemIndexForMin = 0;
  int _selectedItemIndexForHour = 0;
  int _selectedItemIndexForAmPm = 0;
  final List _itemsMin = [
    '00',
    '15',
    '30',
    '45',
  ];
  final List _itemsHour = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];

  final List _itemsAmPm = [
    'AM',
    'PM',

  ];

  int badgeCount1 = 0;
  int badgeCountShared = 0;

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context,TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1950),
        lastDate:DateTime(2101));
    if (picked != null) {
      setState(() {
        controller.text =  DateFormat('MM-dd-yy').format(picked);
      });
    }
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

      userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
      _getSkippedReminderList();
    }
    _getPostReminderList();
    setState(() {
      _isUserDataLoading = false;
    });

  }

  String? formattedDate;
  String? formattedTime;
  late SkippedReminderNotification skippedReminderNotification;

  _getSkippedReminderList() {
    setState(() {
      // sharedPreferences.setString("Score", "");
      // _isLoading1 = true;
    });
    HTTPManager().getSkippedReminderListData(LogoutRequestModel(userId: id)).then((value) {
      setState(() {
        skippedReminderNotification = value;
        // sharedPreferences.setString("Score", "");
        // _isLoading1 = false;
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
        // _isLoading1 = false;
      });
    });
  }

  showDeletePopup(String reminderId1,int index1) {

    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title:const Text('Confirm delete?'),
            content:const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text("Are you sure you want to delete this reminder!"),
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
                  _deleteReminderData(reminderId1, index1);
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setState(() {
    //   _selectedWeekdays = _weekdays;
    // });
    _getUserData();
  }

  _getPostReminderList() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().getPostReminderData(LogoutRequestModel(userId: id)).then((value) {

      setState(() {
        errorMessage = "";
        postReminderResponseListModel = value;
        _isLoading = false;
      });
      print("Post Reminder List");
      print(postReminderResponseListModel);
    }).catchError((e) {
      setState(() {
        errorMessage = e.toString();
        _isLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared,otherUserLoggedIn,name),
      floatingActionButton: Container(
        width: 60.0,
        height: 60.0,
        margin:const EdgeInsets.only(right: 10,bottom: 10),
        child: Visibility(
          visible: !otherUserLoggedIn,
          child: FloatingActionButton(
            onPressed: ()  async{
              setState(() {
                _dateController.text = "";
                _titleController.text = "";
                _endDateController.text = "";
                isRepeat = true;
                _scrollControllerHour =  FixedExtentScrollController(initialItem: 0);
                _scrollControllerMin =  FixedExtentScrollController(initialItem: 0);
                _scrollControllerAmPM =  FixedExtentScrollController(initialItem: 0);
                selectedRadio = "repeat";
                _weekdays = [
                  {"name" : "Sun", "Selected": true},
                  {"name" : "Mon", "Selected": true},
                  {"name" : "Tue", "Selected": true},
                  {"name" : "Wed", "Selected": true},
                  {"name" : "Thu", "Selected": true},
                  {"name" : "Fri", "Selected": true},
                  {"name" : "Sat", "Selected": true},];
              });
              if(userPremium == "no" && postReminderResponseListModel.singleAnswer!.length >= 2 ) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
              } else {
                reminderCreateBottomSheet(true, SingleAnswer(id: "0",
                    userId: "0",
                    dayList: "",
                    date: "",
                    time: "",
                    status: "",
                    timeType: ""), -1);
                }
              },
            child: const Icon(Icons.add,color: AppColors.backgroundColor,size: 30,),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Stack(
                alignment: Alignment.center,
                //    ignoring: isAnswerLoading,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LogoScreen("Post"),

                      _isLoading ? const Center(child: CircularProgressIndicator(),) : errorMessage != "" ? Center(
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(errorMessage,style:const TextStyle(fontSize: 25),),
                                const SizedBox(height: 5,),
                                GestureDetector(
                                  onTap: () {
                                    _getPostReminderList();
                                  },
                                  child: OptionMcqAnswer(
                                      TextButton(onPressed: () {
                                        _getPostReminderList();
                                      }, child: const Text("Reload",style: TextStyle(fontSize:25,color: AppColors.redColor)),)
                                  ),
                                )
                              ],
                            )
                        ),
                      ) : postReminderResponseListModel.singleAnswer!.isEmpty ?  const Center(child: Text("No reminder created"),) : ListView.builder(
                          itemCount: postReminderResponseListModel.singleAnswer!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context,index) {

                            List<String> sortedList = [];

                            bool isSun = false;
                            bool isMon = false;
                            bool isTue = false;
                            bool isWed = false;
                            bool isThu = false;
                            bool isFri = false;
                            bool isSat = false;
                            DateTime endDate;
                            String formattedEndDate;

                            DateTime date = DateFormat("yyyy-MM-dd").parse(postReminderResponseListModel.singleAnswer![index].date!);
                            if(postReminderResponseListModel.singleAnswer![index].endDate != "") {
                              endDate = DateFormat("yyyy-MM-dd").parse(postReminderResponseListModel.singleAnswer![index].endDate!);
                              formattedEndDate = DateFormat('MM-dd-yy').format(endDate);
                            } else {
                              formattedEndDate = "";
                            }

                            
                            DateTime time = DateFormat("hh:mm").parse(postReminderResponseListModel.singleAnswer![index].time!);
                            String formattedDate = DateFormat('MM-dd-yy').format(date); // Format the date as desired
                            
                            String formattedTime = DateFormat("hh:mm").format(time); // Format the time as desired

                            String daysList = postReminderResponseListModel.singleAnswer![index].dayList!.substring(1,postReminderResponseListModel.singleAnswer![index].dayList!.length-1);
                            daysList = daysList.replaceAll(" ", "");
                            daysList = daysList.replaceAll('"', '');

                           List<String> dayList = daysList.split(",");

                           // print("Days List");
                           //  print(dayList);

                            for(int j = 0;j<dayList.length; j++) {

                              if(dayList[j].toString().toLowerCase() == "Sun" || dayList[j].toString().toLowerCase() == "sun") {
                                  isSun = true;
                                // print("SUN");
                                // print(isSun);
                              } else if(dayList[j].toString().toLowerCase() == "Mon" || dayList[j].toString().toLowerCase() == "mon") {
                                  isMon = true;
                                // print("MON");
                                // print(isMon);
                              } else if(dayList[j].toString().toLowerCase() == "Tue" || dayList[j].toString().toLowerCase() == "tue") {

                                  isTue = true;

                                // print("TUE");
                                // print(isTue);
                              } else if(dayList[j].toString().toLowerCase() == "Wed" || dayList[j].toString().toLowerCase() == "wed") {

                                  isWed = true;

                                // print("WED");
                                // print(isWed);
                              } else if(dayList[j].toString().toLowerCase() == "Thu" || dayList[j].toString().toLowerCase() == "thu") {

                                  isThu = true;

                                // print("THU");
                                // print(isThu);
                              } else if(dayList[j].toString().toLowerCase() == "Fri" || dayList[j].toString().toLowerCase() == "fri") {
                                  isFri = true;
                                // print("FRI");
                                // print(isFri);
                              } else if(dayList[j].toString().toLowerCase() == "Sat" || dayList[j].toString().toLowerCase() == "sat") {

                                  isSat = true;
                                // print("SAT");
                                // print(isSat);
                              }
                            }

                            if(isSun) {
                              sortedList.add("Sun");
                            }
                            if(isMon) {
                              sortedList.add("Mon");
                            }
                            if(isTue) {
                                sortedList.add("Tue");
                            }
                            if(isWed) {
                                sortedList.add("Wed");
                            }
                            if(isThu) {
                                sortedList.add("Thu");
                            }
                            if(isFri) {
                                sortedList.add("Fri");
                            }
                            if(isSat) {
                                sortedList.add("Sat");
                            }

                            print(daysList);
                            print(sortedList.length);

                            postReminderResponseListModel.singleAnswer![index].dayList = sortedList.toString();

                            String sortedDaysList = postReminderResponseListModel.singleAnswer![index].dayList!.substring(1,postReminderResponseListModel.singleAnswer![index].dayList!.length-1);

                            return  GestureDetector(
                              onTap: () {
                                if(!otherUserLoggedIn) {
                                  reminderCreateBottomSheet(false,
                                      postReminderResponseListModel
                                          .singleAnswer![index], index);
                                }},
                              child: Column(
                                children: [
                                  Container(
                                    margin:const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                         Expanded(
                                          child:  Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.backgroundColor),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(formattedDate,style:const TextStyle(fontSize: AppConstants.defaultFontSize),),
                                                     Visibility(
                                                        visible: postReminderResponseListModel.singleAnswer![index].endDate != "",
                                                        child: const  Text(" - ",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                                    ),
                                                    Visibility(
                                                      visible: postReminderResponseListModel.singleAnswer![index].endDate != "",
                                                      child:  Text(formattedEndDate,style:const TextStyle(fontSize: AppConstants.defaultFontSize),),
                                                    ),
                                                    const SizedBox(width: 5,),
                                                    Text(sortedList.length == 7 ? "Everyday" : sortedDaysList.isEmpty ? "Once" : sortedDaysList ,style:const TextStyle(fontSize: AppConstants.defaultFontSize),),
                                                  ],
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(formattedTime,style:const TextStyle(fontSize: AppConstants.headingFontSize),),
                                                    const SizedBox(width: 3,),
                                                    Text(postReminderResponseListModel.singleAnswer![index].timeType!,style: const TextStyle(fontSize: AppConstants.defaultFontSize),),
                                                  ],
                                                ),
                                                const SizedBox(height: 6,),
                                                // Text("Team Meeting",style: TextStyle(fontSize: AppConstants.defaultFontSize,overflow: TextOverflow.ellipsis,),maxLines: 1,),
                                                // const SizedBox(width: 4,),
                                                 Text(postReminderResponseListModel.singleAnswer![index].text!,style: const TextStyle(fontSize: AppConstants.defaultFontSize,overflow: TextOverflow.ellipsis),maxLines: 1,),
                                                const SizedBox(height: 4,),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if(!otherUserLoggedIn)
                                        Row(
                                          children: [
                                            IconButton(onPressed: (){

                                              showDeletePopup(postReminderResponseListModel.singleAnswer![index].id!,index);
                                            }, icon:const Icon(Icons.delete,color: AppColors.redColor,)),
                                            Switch(
                                                activeColor: AppColors.primaryColor,
                                                value: postReminderResponseListModel.singleAnswer![index].status == "active",
                                                onChanged: (bool value){
                                                  String? status;
                                                  if(value) {
                                                    setState(() {
                                                      status = "active";
                                                    });
                                                  }else {
                                                    setState(() {
                                                      status = "inactive";
                                                    });
                                                  }
                                              _updateReminderStatusData(postReminderResponseListModel.singleAnswer![index].id!,index,status!);
                                            })
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: AppColors.primaryColor,
                                    thickness: 1,
                                  )
                                ],
                              ),
                            );
                          }),

                      // Container(
                      //   margin: const EdgeInsets.only(top: 10),
                      //   height: MediaQuery.of(context).size.height/1.28,
                      //   width: MediaQuery.of(context).size.width,
                      //   child: ListView(
                      //       padding: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
                      //       shrinkWrap: true,
                      //       scrollDirection: Axis.vertical,
                      //       children: [
                      //         QuestionTextWidget("Please set your push notification time here!","",(){
                      //           String urlQ1 = "https://www.youtube.com/watch?v=RHiFWm5-r3g";
                      //           String? videoId = YoutubePlayer.convertUrlToId(urlQ1);
                      //           YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                      //               initialVideoId: videoId!,
                      //               flags: const YoutubePlayerFlags(
                      //                 autoPlay: false,
                      //                 controlsVisibleAtStart: false,
                      //               )
                      //
                      //           );
                      //           videoPopupDialog(context, "Introduction to question#1", youtubePlayerController);
                      //         },false),
                      //         OptionMcqAnswer(
                      //              ExpansionTile(
                      //                onExpansionChanged: (value) {
                      //                  setState(() {
                      //                    expansionValue = value;
                      //                  });
                      //                },
                      //                initiallyExpanded: true,
                      //               collapsedIconColor: AppColors.textWhiteColor,
                      //               collapsedBackgroundColor: AppColors.primaryColor,
                      //               title:Row(
                      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                   children: [
                      //                     const Text("PIRE",style: TextStyle(fontSize: 22),),
                      //                     Switch(
                      //                         hoverColor: !expansionValue ?AppColors.backgroundColor : AppColors.primaryColor,
                      //                         activeColor:!expansionValue? AppColors.backgroundColor : AppColors.primaryColor,
                      //                         value: switchValue,
                      //                         onChanged: (value) {
                      //                           setState(() {
                      //                             switchValue = !switchValue;
                      //                           });
                      //                           //switchToggleFunction();
                      //                         }),
                      //
                      //                   ],
                      //               ),
                      //               children: [
                      //                 ExpansionTileWidget("PIRE",() {},selectedTime.format(context).toString(),switchValue,(value) {
                      //                   setState(() {
                      //                     switchValue = !switchValue;
                      //                   });}),
                      //             ],)
                      //         ),
                      //         OptionMcqAnswer(
                      //              ExpansionTile(
                      //                collapsedIconColor: AppColors.textWhiteColor,
                      //                collapsedBackgroundColor: AppColors.primaryColor,
                      //                title:const Text("Trellis",style: TextStyle(fontSize: 22),),children: [
                      //               ExpansionTileWidget("Trellis",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                      //                 setState(() {
                      //                   switchValue = !switchValue;
                      //                 });}),
                      //             ],)
                      //         ),
                      //         OptionMcqAnswer(
                      //              ExpansionTile(
                      //                collapsedIconColor: AppColors.textWhiteColor,
                      //                collapsedBackgroundColor: AppColors.primaryColor,
                      //                title:const Text("Ladder",style:  TextStyle(fontSize: 22),),children: [
                      //                ExpansionTileWidget("Ladder",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                      //                  setState(() {
                      //                    switchValue = !switchValue;
                      //                  });}),
                      //             ],)
                      //         ),
                      //         OptionMcqAnswer(
                      //              ExpansionTile(
                      //                collapsedIconColor: AppColors.textWhiteColor,
                      //                collapsedBackgroundColor: AppColors.primaryColor,
                      //                title:const Text("Bridge",style: TextStyle(fontSize: 22),),children: [
                      //                ExpansionTileWidget("Bridge",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                      //                  setState(() {
                      //                    switchValue = !switchValue;
                      //                  });}),
                      //             ],)
                      //         ),
                      //         OptionMcqAnswer(
                      //              ExpansionTile(
                      //                collapsedIconColor: AppColors.textWhiteColor,
                      //                collapsedBackgroundColor: AppColors.primaryColor,
                      //                title:const Text("Posts",style: TextStyle(fontSize: 22),),children: [
                      //                ExpansionTileWidget("Posts",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                      //                  setState(() {
                      //                    switchValue = !switchValue;
                      //                  });}),
                      //             ],)
                      //         ),
                      //         OptionMcqAnswer(
                      //              ExpansionTile(
                      //                collapsedIconColor: AppColors.textWhiteColor,
                      //                collapsedBackgroundColor: AppColors.primaryColor,
                      //                title:const Text("Base",style: TextStyle(fontSize: 22),),children: [
                      //                ExpansionTileWidget("Base",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                      //                  setState(() {
                      //                    switchValue = !switchValue;
                      //                  });}),
                      //             ],)
                      //         ),
                      //         OptionMcqAnswer(
                      //           ExpansionTile(
                      //             collapsedIconColor: AppColors.textWhiteColor,
                      //             collapsedBackgroundColor: AppColors.primaryColor,
                      //             title:const Text("Column",style: TextStyle(fontSize: 22),),children: [
                      //             ExpansionTileWidget("Column",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                      //               setState(() {
                      //                 switchValue = !switchValue;
                      //               });}),
                      //           ],)
                      //         ),
                      //         OptionMcqAnswer(
                      //              ExpansionTile(
                      //                collapsedIconColor: AppColors.textWhiteColor,
                      //                collapsedBackgroundColor: AppColors.primaryColor,
                      //                title:const Text("ORG",style: TextStyle(fontSize: 22),),children: [
                      //                ExpansionTileWidget("ORG",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                      //                  setState(() {
                      //                    switchValue = !switchValue;
                      //                  });}),
                      //             ],)
                      //         ),
                      //         OptionMcqAnswer(
                      //              ExpansionTile(
                      //                collapsedIconColor: AppColors.textWhiteColor,
                      //                collapsedBackgroundColor: AppColors.primaryColor,
                      //                title:const Text("Promenade",style: TextStyle(fontSize: 22),),children: [
                      //               ExpansionTileWidget("Promenade",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                      //                 setState(() {
                      //                   switchValue = !switchValue;
                      //                 });}),
                      //             ],)
                      //         ),
                      //         // OptionMcqAnswer(
                      //         //   const  Card(
                      //         //       color: AppColors.PrimaryColor,
                      //         //       child: Center(
                      //         //         child: Text("Reminders",style: TextStyle(fontSize: 22),),
                      //         //       ),
                      //         //     )
                      //         // ),
                      //       ]
                      //   ),
                      // )

                    ],
                  ),
                  _isDataLoading ?
                  const Center(child: CircularProgressIndicator())
                      : Container() ,
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }

  void reminderCreateBottomSheet(bool isEditReminder,SingleAnswer singleAnswer,int index1) {

    bool isSunAvailable = false;
    bool isMonAvailable = false;
    bool isTueAvailable = false;
    bool isWedAvailable = false;
    bool isThuAvailable = false;
    bool isFriAvailable = false;
    bool isSatAvailable = false;

    if(!isEditReminder) {
      DateTime endDate;
      String formattedEndDate = "";

      _selectedWeekdays.clear();
      DateTime date = DateFormat("yyyy-MM-dd").parse(singleAnswer.date!);
      if(singleAnswer.endDate != "") {

        setState(() {
          endDate = DateFormat("yyyy-MM-dd").parse(
              singleAnswer.endDate!);
          formattedEndDate = DateFormat('MM-dd-yy').format(endDate);
        });
      } else {
        setState(() {
          formattedEndDate = "";
        });
      }
      DateTime time = DateFormat("hh:mm").parse(singleAnswer.time!);
      String formattedDate = DateFormat('MM-dd-yy').format(date);
      // Format the date as desired
      // String formattedTime = DateFormat.jm().format(dateTime); // Format the time as desired

      // print("dateTimeMin: ${time.minute}");
      // print("dateTimePm: ${singleAnswer.timeType}");

      for(int i=0; i<_itemsHour.length; i++) {
        print("dateTimeHour: ${time.hour}");
        print("dateTimeHourFromList: ${_itemsHour[i]}");
        if(time.hour.toString() == _itemsHour[i].toString()) {

          setState(() {
            _selectedItemIndexForHour = i;
            _scrollControllerHour =  FixedExtentScrollController(initialItem: i);
          });
        } else if (time.hour.toString() == '0' || time.hour.toString() == '12' && _itemsHour[i].toString() == '12') {
          setState(() {
            _selectedItemIndexForHour = i;
            _scrollControllerHour =  FixedExtentScrollController(initialItem: i);
          });
        }
      }

      if(time.minute == 00) {
         setState(() {
           _selectedItemIndexForMin = 0;
           _scrollControllerMin =  FixedExtentScrollController(initialItem: 0);
         });

      } else if(time.minute == 15) {
        setState(() {
          _selectedItemIndexForMin = 1;
          _scrollControllerMin =  FixedExtentScrollController(initialItem: 1);
        });

      } else if(time.minute == 30) {
        setState(() {
          _selectedItemIndexForMin = 2;
          _scrollControllerMin =  FixedExtentScrollController(initialItem: 2);
        });

      } else if(time.minute == 45) {
        setState(() {
          _selectedItemIndexForMin = 3;
          _scrollControllerMin =  FixedExtentScrollController(initialItem: 3);
        });

      }

      if(singleAnswer.timeType == "AM") {
        setState(() {
          _selectedItemIndexForAmPm = 0;
          _scrollControllerAmPM =  FixedExtentScrollController(initialItem: 0);
        });

      } else {
        setState(() {
          _selectedItemIndexForAmPm = 1;
          _scrollControllerAmPM =  FixedExtentScrollController(initialItem: 1);
        });

      }

      String sortedDaysList = singleAnswer.dayList!.substring(1,singleAnswer.dayList!.length-1);

      sortedDaysList = sortedDaysList.replaceAll(" ", "");
      List<String> dayList = sortedDaysList.split(",");
      for(int i=0; i<dayList.length; i++) {
        // print(dayList[i]);
        if(dayList[i] == "Sun") {
        setState(() {
          isSunAvailable = true;
          _selectedWeekdays.add({
            "name": "Sun",
            "Selected": true,});
        });
        } else if(dayList[i] == "Mon") {
          setState(() {
            isMonAvailable = true;
            _selectedWeekdays.add({
              "name": "Mon",
              "Selected": true,});
          });
        } else if(dayList[i] == "Tue") {
          setState(() {
            isTueAvailable = true;
            _selectedWeekdays.add({
              "name": "Tue",
              "Selected": true,});
          });
        } else if(dayList[i] == "Wed") {
          setState(() {
            isWedAvailable = true;
            _selectedWeekdays.add({
              "name": "Wed",
              "Selected": true,});
          });
        } else if(dayList[i] == "Thu") {
          setState(() {
            isThuAvailable = true;
            _selectedWeekdays.add({
              "name": "Thu",
              "Selected": true,});
          });
        } else if(dayList[i] == "Fri") {
          setState(() {
            isFriAvailable = true;
            _selectedWeekdays.add({
              "name": "Fri",
              "Selected": true,});
          });
        } else if(dayList[i] == "Sat") {
          setState(() {
            isSatAvailable = true;
            _selectedWeekdays.add({
              "name": "Sat",
              "Selected": true,});
          });
        }

      }

      if(dayList.length == 7) {
        setState(() {
          isRepeat = true;
        });
      } else {
        setState(() {
          isRepeat = false;
        });
      }

      setState(() {
        _weekdays = [
          {"name" : "Sun", "Selected": isSunAvailable},
          {"name" : "Mon", "Selected": isMonAvailable},
          {"name" : "Tue", "Selected": isTueAvailable},
          {"name" : "Wed", "Selected": isWedAvailable},
          {"name" : "Thu", "Selected": isThuAvailable},
          {"name" : "Fri", "Selected": isFriAvailable},
          {"name" : "Sat", "Selected": isSatAvailable},];
        _titleController.text = singleAnswer.text!;
        _dateController.text = formattedDate;
        _endDateController.text = formattedEndDate;
        daysSelected = sortedDaysList;
        selectedRadio = singleAnswer.reminderType!;
      });
    }


    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0))
        ) ,
        builder: (builder) {
      return StatefulBuilder(
          builder: (BuildContext context,StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(onPressed: () {
                            Navigator.of(context).pop();
                          }, icon:const Icon(Icons.close)),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          // height: MediaQuery.of(context).size.height/5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color:AppColors.primaryColor ),
                            //color: AppColors.primaryColor,
                          ),
                          child: TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Reminder Description",
                                // isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10)
                            ),
                            validator: (value) => value!.isEmpty ? "Enter something" : null,
                            style: const TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: AppConstants.defaultFontSize,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color:AppColors.primaryColor ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: _dateController,
                            onTap: () => _selectDate(context,_dateController),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Select Start Date",
                                // isDense: true,
                                prefixIcon: Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10)
                            ),
                            validator: (value) => value!.isEmpty ? "Start Date field required" : null,
                            readOnly: true,
                            style: const TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: AppConstants.defaultFontSize,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Visibility(
                          visible: selectedRadio == 'repeat',
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color:AppColors.primaryColor ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              controller: _endDateController,
                              onTap: () => _selectDate(context,_endDateController),
                              decoration:  InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Select End Date (Optional)",
                                  // isDense: true,
                                  suffixIcon: IconButton(onPressed: () {
                                    setState(() {
                                      _endDateController.clear();
                                    });
                                  }, icon:const Icon(Icons.clear)),
                                  prefixIcon:const Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                                  contentPadding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10)
                              ),
                              readOnly: true,
                              style: const TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: AppConstants.defaultFontSize,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color:AppColors.primaryColor ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: _reminderTimeController,
                            onTap: () async {
                              final pickedTime = await showTimePicker(
                                helpText: 'Select Reminder Time',
                                context: context,
                                initialEntryMode: TimePickerEntryMode.inputOnly,
                                initialTime: TimeOfDay(hour: selectedReminderTime.hour, minute: selectedReminderTime.minute),
                              );

                              if(pickedTime != null){
                                print('Picked Time ===============> ${pickedTime.hour}:${pickedTime.minute}');
                                setState((){
                                  selectedReminderTime = DateTime(selectedReminderTime.year,selectedReminderTime.month, selectedReminderTime.day,pickedTime?.hour ?? selectedReminderTime.hour,pickedTime?.minute ?? selectedReminderTime.hour);
                                  _reminderTimeController.text = DateFormat('hh:mm a').format(selectedReminderTime);
                                });

                              }


                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Select Reminder Time",
                                // isDense: true,
                                prefixIcon: Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10)
                            ),
                            validator: (value) => value!.isEmpty ? "Reminder Time Required" : null,
                            readOnly: true,
                            style: const TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: AppConstants.defaultFontSize,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        //   height: MediaQuery.of(context).size.height/4,
                        //   child: CupertinoDatePicker(
                        //     initialDateTime: selectedReminderTime,
                        //     minuteInterval: 15,
                        //     mode: CupertinoDatePickerMode.time,
                        //     onDateTimeChanged: (value) {
                        //       print('DateTime =========> $value');

                        //       print('Hour ===========> ${DateFormat('hh:mm').format(value)}');
                        //       print('Minutes ================>${DateFormat('a').format(value)}');
                        //       setState((){
                        //         selectedReminderTime = value;
                        //       });


                        //     },
                        //   ),
                          // child: Stack(
                          //   alignment: Alignment.center,
                          //   children: [
                          //     Container(
                          //       height: MediaQuery.of(context).size.height/25,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(20),
                          //         color: AppColors.primaryColor,
                          //       ),
                          //     ),
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Expanded(
                          //             child: ListWheelScrollView(
                          //               controller: _scrollControllerHour,
                          //               itemExtent: 25,
                          //               onSelectedItemChanged: (int index) {
                          //                 // update the UI on selected item changes
                          //                 setState(() {
                          //                   _selectedItemIndexForHour = index;
                          //                 });
                          //               },
                          //               diameterRatio: 1.4,
                          //               physics: const FixedExtentScrollPhysics(),
                          //               children: _itemsHour
                          //                   .map((e) => Center(
                          //                 child: Text(
                          //                   _itemsHour.indexOf(e) == _selectedItemIndexForHour ?e + " hr" : e,
                          //                   style:  TextStyle(
                          //                       fontSize:_itemsHour.indexOf(e) == _selectedItemIndexForHour ? AppConstants.fontSizeForReminderSectionTimePicker : AppConstants.defaultFontSize),
                          //                 ),
                          //               ))
                          //                   .toList(),
                          //               // Other properties...
                          //             )
                          //         ),
                          //         Expanded(
                          //             child: ListWheelScrollView(
                          //               controller: _scrollControllerMin,
                          //               itemExtent: 25,
                          //               onSelectedItemChanged: (int index) {
                          //                 // update the UI on selected item changes
                          //                 setState(() {
                          //                   _selectedItemIndexForMin = index;
                          //                 });
                          //               },
                          //               diameterRatio: 1.4,
                          //               physics: const FixedExtentScrollPhysics(),
                          //               children: _itemsMin
                          //                   .map((e) => Center(
                          //                 child: Text(
                          //                   _itemsMin.indexOf(e) == _selectedItemIndexForMin ?e + " min" : e,
                          //                   style:  TextStyle(
                          //                       fontSize:_itemsMin.indexOf(e) == _selectedItemIndexForMin ? AppConstants.fontSizeForReminderSectionTimePicker : AppConstants.defaultFontSize),
                          //                 ),
                          //               ))
                          //                   .toList(),
                          //               // Other properties...
                          //             )
                          //         ),
                          //         Expanded(
                          //             child: ListWheelScrollView(
                          //               controller: _scrollControllerAmPM,
                          //               itemExtent: 25,
                          //               onSelectedItemChanged: (int index) {
                          //                 // update the UI on selected item changes
                          //                 setState(() {
                          //                   _selectedItemIndexForAmPm = index;
                          //                 });
                          //               },
                          //               diameterRatio: 1.4,
                          //               physics: const FixedExtentScrollPhysics(),
                          //               children: _itemsAmPm
                          //                   .map((e) => Center(
                          //                 child: Text(
                          //                   e,
                          //                   style:  TextStyle(
                          //                       fontSize:_itemsAmPm.indexOf(e) == _selectedItemIndexForAmPm ? AppConstants.fontSizeForReminderSectionTimePicker : AppConstants.defaultFontSize),
                          //                 ),
                          //               ))
                          //                   .toList(),
                          //               // Other properties...
                          //             )
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                        // ),
                        Container(
                          padding:const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme:const ListTileThemeData(
                                      horizontalTitleGap: 1,//here adjust based on your need
                                    ),
                                  ),
                                  child: RadioListTile<String>(
                                    value: 'repeat',
                                    groupValue: selectedRadio,
                                    title:const Text('Repeat',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                    onChanged: (String? val) {
                                      print(val);
                                      setState(() {
                                        selectedRadio = val!;
                                        isRepeat = true;
                                        _weekdays = [
                                          {"name" : "Sun", "Selected": true},
                                          {"name" : "Mon", "Selected": true},
                                          {"name" : "Tue", "Selected": true},
                                          {"name" : "Wed", "Selected": true},
                                          {"name" : "Thu", "Selected": true},
                                          {"name" : "Fri", "Selected": true},
                                          {"name" : "Sat", "Selected": true},];
                                      });
                                      _selectedWeekdays = _weekdays;
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme:const ListTileThemeData(
                                      horizontalTitleGap: 1,//here adjust based on your need
                                    ),
                                  ),
                                  child: RadioListTile<String>(
                                    value: 'once',
                                    groupValue: selectedRadio,
                                    title:const Text('Once',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                    onChanged: (String? val) {
                                      print(val);
                                      setState(() {
                                        selectedRadio = val!;
                                        isRepeat = false;
                                        _endDateController.clear();
                                        _weekdays = [
                                          {"name" : "Sun", "Selected": false},
                                          {"name" : "Mon", "Selected": false},
                                          {"name" : "Tue", "Selected": false},
                                          {"name" : "Wed", "Selected": false},
                                          {"name" : "Thu", "Selected": false},
                                          {"name" : "Fri", "Selected": false},
                                          {"name" : "Sat", "Selected": false},];
                                      });
                                    },
                                  ),
                                ),
                              ),
                              // Add more RadioListTile widgets for additional options
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Repeat",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                  Text(isRepeat ? "Everyday" : !isEditReminder ? daysSelected : daysSelected == "" || daysSelected == " " || selectedRadio == "once" ? "No day selected" :daysSelected.substring(0,daysSelected.length-1),style:const TextStyle(fontSize: AppConstants.defaultFontSize,color: AppColors.primaryColor),),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Select All",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                  Checkbox(
                                    value: isRepeat,
                                    checkColor: AppColors.textWhiteColor,
                                    onChanged: (bool? value) {
                                      if(!isRepeat) {
                                        setState(() {
                                          isRepeat = value!;
                                          _weekdays = [
                                            {"name" : "Sun", "Selected": true},
                                            {"name" : "Mon", "Selected": true},
                                            {"name" : "Tue", "Selected": true},
                                            {"name" : "Wed", "Selected": true},
                                            {"name" : "Thu", "Selected": true},
                                            {"name" : "Fri", "Selected": true},
                                            {"name" : "Sat", "Selected": true},];
                                        });
                                      } else {
                                        setState(() {
                                          isRepeat = value!;
                                          _weekdays = [
                                            {"name" : "Sun", "Selected": false},
                                            {"name" : "Mon", "Selected": false},
                                            {"name" : "Tue", "Selected": false},
                                            {"name" : "Wed", "Selected": false},
                                            {"name" : "Thu", "Selected": false},
                                            {"name" : "Fri", "Selected": false},
                                            {"name" : "Sat", "Selected": false},];
                                        });
                                      }
                                    },
                                  ),
                                ],
                              )

                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height/20,
                          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _weekdays.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    // if(selectedRadio == "Repeat") {
                                      // print(index);
                                      if (_weekdays[index]['Selected']) {
                                        setState(() {
                                          isRepeat = false;
                                          _weekdays[index] = {
                                            "name": _weekdays[index]['name'],
                                            "Selected": false,
                                          };
                                        });
                                        removeWeekFromList(index);
                                      } else {
                                        setState(() {
                                          _weekdays[index] = {
                                            "name": _weekdays[index]['name'],
                                            "Selected": true,
                                          };
                                        });
                                        addWeekValueToList(index);
                                      }
                                    // } else {
                                    //
                                    //   // showToastMessage(context, "Please Select repeat from option", false);
                                    // }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 30,
                                    padding:const EdgeInsets.symmetric(vertical: 10),
                                    margin:const EdgeInsets.symmetric(horizontal: 2),
                                    decoration: BoxDecoration(
                                      color:_weekdays[index]['Selected'] ? AppColors.primaryColor : AppColors.backgroundColor,
                                      border: Border.all(color: AppColors.primaryColor),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(_weekdays[index]['name'],style: TextStyle(fontSize: AppConstants.defaultFontSizeForWeekDays,color: _weekdays[index]['Selected'] ? AppColors.backgroundColor : AppColors.textWhiteColor),),
                                  ),
                                );
                              }),
                        ),
                        Container(
                          margin:const EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                              onPressed: (){
                                print('Hour ===========> ${DateFormat('hh:mm').format(selectedReminderTime)}');
                                print('Minutes ================>${DateFormat('a').format(selectedReminderTime)}');
                                dateList.clear();
                                  String reminderTitle = _titleController.text;
                                  String date1 = _dateController.text;
                                  String endDate1 = _endDateController.text;
                                  String time1 = DateFormat('hh:mm').format(selectedReminderTime);
                                  String reminderTypeTime = DateFormat('a').format(selectedReminderTime);
                                 selectedReminderTime = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
                                  for(int i = 0; i<_selectedWeekdays.length; i++) {
                                    dateList.add(_selectedWeekdays[i]["name"]);
                                  }
                                  print("DATE LIST CHECKING");
                                  print(dateList);

                                    if (isEditReminder) {
                                      _submitReminderData(
                                          date1,endDate1 ,time1, reminderTitle,selectedRadio == "repeat" ? dateList : [],
                                          reminderTypeTime, "active",selectedRadio);
                                    } else {
                                      _editReminderData(
                                          singleAnswer.id!,
                                          date1,
                                          endDate1,
                                          time1,
                                          reminderTitle,
                                          selectedRadio == "repeat" ? dateList : [],
                                          reminderTypeTime,
                                          singleAnswer.status!,
                                          index1,selectedRadio);
                                    }
                                  // } else {
                                  //   showToastMessage(context, "Select any day please", false);
                                  // }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                minimumSize: Size(MediaQuery.of(context).size.width/2, 35), // Set the minimum width and height
                                padding: EdgeInsets.zero, // Remove any default padding
                              ),
                              child:const Text("Submit",style: TextStyle(color: AppColors.backgroundColor),)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      );
    });
  }

  _updateReminderStatusData(String reminderId1,int index,String status1) {
    setState(() {
      _isDataLoading = true;
    });
    HTTPManager().postReminderUpdateStatus(UpdateReminderStatusRequestModel(reminderId: reminderId1,status: status1)).then((value) {
      setState(() {
        _isDataLoading = false;
      });
      SingleAnswer singleAnswer = SingleAnswer(
        id: value['data']['id'],
        userId: value['data']['user_id'],
        text: value['data']['text'],
        dayList : value['data']['day_list'],
        date : value['data']['date'],
        endDate: value['data']['end_date'] ?? "",
        time : value['data']['time'],
        timeType : value['data']['time_type'],
        status : value['data']['status'],
        reminderType: value['data']['reminder_type'].toString(),
      );
      postReminderResponseListModel.singleAnswer![index] = singleAnswer;
      showToastMessage(context, "Status updated successfully", true);
      print(value);
    }).catchError((e) {
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, e.toString(), false);
    });

  }

  _deleteReminderData(String reminderId1,int index) {
    setState(() {
      _isDataLoading = true;
    });
    HTTPManager().postReminderDeleteData(DeletePostReminderRequestModel(reminderId: reminderId1)).then((value) {
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, "Reminder deleted successfully", true);
      postReminderResponseListModel.singleAnswer!.removeAt(index);
    }).catchError((e) {
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, e.toString(), false);
    });

  }

  _submitReminderData(String reminderDate,String reminderEndDate,String reminderTime,String title,List<String> selectedDaysList,String reminderTimeType,String status,String radioOptionSelection) {

    // print("EDIT REMINDER DETAILS");
    //
    // print(reminderDate);
    // print(reminderEndDate);
    // print(reminderTime);
    // print(title);
    // print(selectedDaysList);
    // print(reminderTimeType);
    // print(radioOptionSelection);

    if(_formKey.currentState!.validate()) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .postReminderInsertData(
          InsertPostReminderRequestModel(userId:id, text: title, date: reminderDate,endDate: reminderEndDate,time: reminderTime,status: status, daysList: selectedDaysList.toString(),timeType: reminderTimeType,reminderType: radioOptionSelection))
          .then((value) {
        setState(() {
          _isDataLoading = false;
          _dateController.text = "";
          _endDateController.text = "";
          _titleController.text = "";
          isRepeat = true;
          _scrollControllerHour =  FixedExtentScrollController(initialItem: 0);
          _scrollControllerMin =  FixedExtentScrollController(initialItem: 0);
          _scrollControllerAmPM =  FixedExtentScrollController(initialItem: 0);
          _weekdays = [
            {"name" : "Sun", "Selected": true},
            {"name" : "Mon", "Selected": true},
            {"name" : "Tue", "Selected": true},
            {"name" : "Wed", "Selected": true},
            {"name" : "Thu", "Selected": true},
            {"name" : "Fri", "Selected": true},
            {"name" : "Sat", "Selected": true},];
        });
        print("Reminder Data Insertion Saved");
        print(value);
        SingleAnswer singleAnswer = SingleAnswer(
          id: value['post_data']['id'].toString(),
          userId: value['post_data']['user_id'].toString(),
          text: value['post_data']['text'].toString(),
          dayList : value['post_data']['day_list'].toString(),
          date : value['post_data']['date'].toString(),
          endDate: value['post_data']['end_date'] ?? "",
          time : value['post_data']['time'].toString(),
          timeType : value['post_data']['time_type'].toString(),
          status : value['post_data']['status'].toString(),
          reminderType: value['post_data']['reminder_type'].toString(),
        );
        postReminderResponseListModel.singleAnswer!.add(singleAnswer);
        showToastMessage(context, "Reminder added successfully ", true);
        Navigator.of(context).pop();
      }).catchError((e) {
        print(e);
        setState(() {
          _isDataLoading = false;
        });
        showToastMessage(context, e.toString(), false);
      });
    }
  }

  _editReminderData(String reminderIdForEditId,String reminderDate,String reminderEndDate,String reminderTime,String title,List<String> selectedDaysList,String reminderTimeTypeForEdit,String status,int index,String radioOptionSelection) {

    // print("EDIT REMINDER DETAILS");
    // print(reminderIdForEditId);
    // print(reminderDate);
    // print(reminderEndDate);
    // print(reminderTime);
    // print(title);
    // print(selectedDaysList);
    // print(reminderTimeTypeForEdit);
    // print(reminderTimeTypeForEdit);


    if(_formKey.currentState!.validate()) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .postReminderEditData(
          EditPostReminderRequestModel(reminderId: reminderIdForEditId,endDate: reminderEndDate,userId: id, text: title,time: reminderTime,status: status, date: reminderDate, daysList: selectedDaysList.toString(),timeType: reminderTimeTypeForEdit,reminderType: radioOptionSelection))
          .then((value) {
        setState(() {
          _isDataLoading = false;
          _dateController.text = "";
          _endDateController.text = "";
          _titleController.text = "";
          isRepeat = true;
          _scrollControllerHour =  FixedExtentScrollController(initialItem: 0);
          _scrollControllerMin =  FixedExtentScrollController(initialItem: 0);
          _scrollControllerAmPM =  FixedExtentScrollController(initialItem: 0);
          _weekdays = [
            {"name" : "Sun", "Selected": true},
            {"name" : "Mon", "Selected": true},
            {"name" : "Tue", "Selected": true},
            {"name" : "Wed", "Selected": true},
            {"name" : "Thu", "Selected": true},
            {"name" : "Fri", "Selected": true},
            {"name" : "Sat", "Selected": true},];
        });
        print("Reminder Data Updated");
        print(value);

        SingleAnswer singleAnswer = SingleAnswer(
            id: value['updated_data']['id'].toString(),
            userId: id,
            text: value['updated_data']['text'].toString(),
            dayList : value['updated_data']['day_list'].toString(),
            date : value['updated_data']['date'].toString(),
            endDate: value['updated_data']['end_date'] ?? "",
            time : value['updated_data']['time'].toString(),
            timeType : value['updated_data']['time_type'].toString(),
            status : value['updated_data']['status'].toString(),
            reminderType: value['updated_data']['reminder_type'].toString(),
        );
        postReminderResponseListModel.singleAnswer![index] = singleAnswer;
        showToastMessage(context, "Reminder updated successfully ", true);
        Navigator.of(context).pop();
      }).catchError((e) {
        print(e);
        setState(() {
          _isDataLoading = false;
        });
        showToastMessage(context, e.toString(), false);
      });
    }
  }

  addWeekValueToList(int index1) {
    setState(() {
      daysSelected = "";
      selectedRadio = "repeat";
    });
    _selectedWeekdays.add(_weekdays[index1]);
    if(_selectedWeekdays.length == _weekdays.length) {
      setState(() {
        isRepeat = true;
        daysSelected = "Everyone";
      });
    } else {
      for (int i = 0; i < _weekdays.length; i++) {
        if(_weekdays[i]['Selected'] == true) {
          setState(() {
            daysSelected = "${daysSelected + _weekdays[i]['name']},".toLowerCase();
            // daysSelected.re(",", "");
          });

        }
      }
    }
    print("Add value to list");
    print(daysSelected);

    print(_selectedWeekdays);
  }
  removeWeekFromList (int index2) {

    setState(() {
      daysSelected = "";
    });

    for (int i = 0; i < _selectedWeekdays.length; i++) {
      if(_weekdays[index2]['name'] ==_selectedWeekdays[i]['name'] ) {
        _selectedWeekdays.removeAt(i);
      }
    }
    for (int i = 0; i < _weekdays.length; i++) {
      if(_weekdays[i]['Selected'] == true) {
        setState(() {
          daysSelected = "${daysSelected + _weekdays[i]['name']},".toLowerCase();
          // daysSelected.re(",", "");
        });
      }
    }
    if(_selectedWeekdays.isEmpty) {
      setState(() {
        selectedRadio = "once";
      });
    } else {
      setState(() {
        selectedRadio = "repeat";
      });
    }
    print("Remove value to list");
    print(daysSelected);
    print(_selectedWeekdays);
  }
}
