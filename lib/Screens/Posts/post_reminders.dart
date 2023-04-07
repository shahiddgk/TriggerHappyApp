import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Posts/widgets/expansion_tile_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../utill/userConstants.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  String name = "";
  String id = "";
  String email = "";
  String timeZone = "";
  String userType = "";
  bool _isUserDataLoading = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool switchValue = false;

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    print("Data getting called");
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

    name = _sharedPreferences.getString(UserConstants().userName)!;
    id = _sharedPreferences.getString(UserConstants().userId)!;
    email = _sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = _sharedPreferences.getString(UserConstants().timeZone)!;
    userType = _sharedPreferences.getString(UserConstants().userType)!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:_isUserDataLoading ? AppBarWidget().appBar(true,false,"","",true) : AppBarWidget().appBar(true,false,name,id,true),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
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
                      LogoScreen(),

                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: MediaQuery.of(context).size.height/1.28,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                            padding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              QuestionTextWidget("Please set your push notification time here!"),
                              OptionMcqAnswer(
                                   ExpansionTile(
                                     initiallyExpanded: true,
                                    collapsedIconColor: AppColors.textWhiteColor,
                                    collapsedBackgroundColor: AppColors.primaryColor,
                                    title:const Text("PIRE",style: TextStyle(fontSize: 22),),
                                    children: [
                                      ExpansionTileWidget("PIRE",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                                        setState(() {
                                          switchValue = !switchValue;
                                        });}),
                                  ],)
                              ),
                              OptionMcqAnswer(
                                   ExpansionTile(
                                     collapsedIconColor: AppColors.textWhiteColor,
                                     collapsedBackgroundColor: AppColors.primaryColor,
                                     title:Text("Trellis",style: TextStyle(fontSize: 22),),children: [
                                    ExpansionTileWidget("Trellis",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                                      setState(() {
                                        switchValue = !switchValue;
                                      });}),
                                  ],)
                              ),
                              OptionMcqAnswer(
                                   ExpansionTile(
                                     collapsedIconColor: AppColors.textWhiteColor,
                                     collapsedBackgroundColor: AppColors.primaryColor,
                                     title:Text("Ladder",style: TextStyle(fontSize: 22),),children: [
                                     ExpansionTileWidget("Ladder",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                                       setState(() {
                                         switchValue = !switchValue;
                                       });}),
                                  ],)
                              ),
                              OptionMcqAnswer(
                                   ExpansionTile(
                                     collapsedIconColor: AppColors.textWhiteColor,
                                     collapsedBackgroundColor: AppColors.primaryColor,
                                     title:Text("Bridge",style: TextStyle(fontSize: 22),),children: [
                                     ExpansionTileWidget("Bridge",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                                       setState(() {
                                         switchValue = !switchValue;
                                       });}),
                                  ],)
                              ),
                              OptionMcqAnswer(
                                   ExpansionTile(
                                     collapsedIconColor: AppColors.textWhiteColor,
                                     collapsedBackgroundColor: AppColors.primaryColor,
                                     title:Text("Posts",style: TextStyle(fontSize: 22),),children: [
                                     ExpansionTileWidget("Posts",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                                       setState(() {
                                         switchValue = !switchValue;
                                       });}),
                                  ],)
                              ),
                              OptionMcqAnswer(
                                   ExpansionTile(
                                     collapsedIconColor: AppColors.textWhiteColor,
                                     collapsedBackgroundColor: AppColors.primaryColor,
                                     title:Text("Base",style: TextStyle(fontSize: 22),),children: [
                                     ExpansionTileWidget("Base",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                                       setState(() {
                                         switchValue = !switchValue;
                                       });}),
                                  ],)
                              ),
                              OptionMcqAnswer(
                                ExpansionTile(
                                  collapsedIconColor: AppColors.textWhiteColor,
                                  collapsedBackgroundColor: AppColors.primaryColor,
                                  title:Text("Column",style: TextStyle(fontSize: 22),),children: [
                                  ExpansionTileWidget("Column",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                                    setState(() {
                                      switchValue = !switchValue;
                                    });}),
                                ],)
                              ),
                              OptionMcqAnswer(
                                   ExpansionTile(
                                     collapsedIconColor: AppColors.textWhiteColor,
                                     collapsedBackgroundColor: AppColors.primaryColor,
                                     title:Text("ORG",style: TextStyle(fontSize: 22),),children: [
                                     ExpansionTileWidget("ORG",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                                       setState(() {
                                         switchValue = !switchValue;
                                       });}),
                                  ],)
                              ),
                              OptionMcqAnswer(
                                   ExpansionTile(
                                     collapsedIconColor: AppColors.textWhiteColor,
                                     collapsedBackgroundColor: AppColors.primaryColor,
                                     title:Text("Promenade",style: TextStyle(fontSize: 22),),children: [
                                    ExpansionTileWidget("Promenade",() {_selectTime(context);},selectedTime.format(context).toString(),switchValue,(value) {
                                      setState(() {
                                        switchValue = !switchValue;
                                      });}),
                                  ],)
                              ),
                              // OptionMcqAnswer(
                              //   const  Card(
                              //       color: AppColors.PrimaryColor,
                              //       child: Center(
                              //         child: Text("Reminders",style: TextStyle(fontSize: 22),),
                              //       ),
                              //     )
                              // ),
                            ]
                        ),
                      )

                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,

    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        print("Time Test");
        print(timeOfDay.format(context).toString());
        selectedTime = timeOfDay;
      });
    }
  }
}
