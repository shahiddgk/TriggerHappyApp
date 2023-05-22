import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/PopMenuButton.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/reponse_model/column_read_data_model.dart';
import '../utill/userConstants.dart';

class ColumnDetailsScreen extends StatefulWidget {
  ColumnDetailsScreen(this.columnReadDataModel,{Key? key}) : super(key: key);
  ColumnReadDataModel columnReadDataModel;

  @override
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

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

   // _getColumnScreenData(true);
    setState(() {
      _isUserDataLoading = false;
    });
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
           // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
          },
        ),
        title: Text(_isUserDataLoading ? "" : name),
        actions:  [
          IconButton(onPressed: (){

          }, icon:const Icon(Icons.search,)),
          PopMenuButton(false,false,id)
        ],
      ),
      body: Container(
        padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoScreen("Column"),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: AppColors.lightGreyColor,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("Type: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                        Container(
                            padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            alignment: Alignment.centerLeft,
                            margin:const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(widget.columnReadDataModel.entryType!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),

                      ],
                    ),

                    Row(
                      children: [
                       const Text("Title: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: Container(
                              padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                              alignment: Alignment.centerLeft,
                              margin:const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(widget.columnReadDataModel.entryTitle!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
                        ),


                      ],
                    ),

                    Row(
                      children: [
                        const Text("Date: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                        Container(
                            padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            alignment: Alignment.centerLeft,
                            margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                            child: Text(" ${DateFormat('MM-dd-yy').format(DateTime.parse(widget.columnReadDataModel.entryDate!.toString()))}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),)),

                      ],
                    ),

                    Row(
                      children: [
                       const Text("Note: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: Container(
                            padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            alignment: Alignment.centerLeft,
                            margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                            child: Text(" ${widget.columnReadDataModel.entryDecs!}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),),
                        ),

                      ],
                    ),

                    Row(
                      children: [
                        const Text("Take Away: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: Container(
                            padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            alignment: Alignment.centerLeft,
                            margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                            child: Text(" ${widget.columnReadDataModel.entryTakeaway!}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),),
                        ),
                        // OptionMcqAnswer(
                        //   ListView.builder(
                        //       shrinkWrap: true,
                        //       itemCount: takeAwayPointsList.length,
                        //       itemBuilder: (context,index) {
                        //         return Container(
                        //             padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        //             alignment: Alignment.centerLeft,
                        //             margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        //             child: Text(takeAwayPointsList[index],style: const TextStyle(fontSize: AppConstants.defaultFontSize),));
                        //       }),
                        // )
                      ],
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
