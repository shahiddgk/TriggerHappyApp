// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Column/Widgets/search_text_field.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/column_read_data_model.dart';
import 'package:flutter_quiz_app/model/request_model/column_delete_request.dart';
import 'package:flutter_quiz_app/model/request_model/column_read_list_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../../network/http_manager.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../Widgets/toast_message.dart';
import '../dashboard_tiles.dart';
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
  // ignore: prefer_final_fields
  bool _isUserDataLoading = true;
  bool _isDeleteDataLoading = false;
  dynamic result;
  String email = "";
  String timeZone = "";
  String userType = "";
  String selectedValue = "All";
  // ignore: prefer_final_fields
  // ignore: prefer_final_fields
  bool _isDataLoading = false;
  late bool isPhone;
  bool isSearch = true;
  // ignore: unnecessary_new
  List<ColumnReadDataModel> columnReadDataModel = [];
  List<ColumnReadDataModel> columnReadDataModelForSearch = [];
  List<ColumnReadDataModel> columnReadDataModelForMeeting = [];
  List<ColumnReadDataModel> columnReadDataModelForAll = [];
  List<ColumnReadDataModel> columnReadDataModelForEntry = [];
  List<ColumnReadDataModel> columnReadDataModelForSession = [];
  final TextEditingController _searchController =  TextEditingController();

  String titleColumn = "https://youtu.be/zhhv_BVSXgI";

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
        columnReadDataModel = columnReadResponseListModel.values;
        columnReadDataModelForAll = columnReadResponseListModel.values;
        columnReadDataModelForSearch = columnReadResponseListModel.values;
      });
      for(int i = 0; i<columnReadDataModel.length; i++) {
        if(columnReadDataModel[i].entryType == "entry") {
          columnReadDataModelForEntry.add(columnReadDataModel[i]);
        }else if(columnReadDataModel[i].entryType == "meeting") {
          columnReadDataModelForMeeting.add(columnReadDataModel[i]);
        } else {
          columnReadDataModelForSession.add(columnReadDataModel[i]);
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

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    _getColumnScreenData(true);
    setState(() {
      _isUserDataLoading = false;
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
      // ignore: avoid_print
      print(DateFormat('MM-dd-yy').format(DateTime.parse(columnReadDataModel[0].entryDate.toString())));
      columnReadDataModelForSearch = columnReadDataModel
          .where((ColumnReadDataModel item) => ("${DateFormat('MM-dd-yy').format(DateTime.parse(item.entryDate.toString()))} ${item.entryTitle.toString()} ${item.entryDecs.toString()}").toLowerCase().contains(query.toLowerCase()))
          .toList();
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
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
          },
        ),
        title: Text(_isUserDataLoading ? "" : name),
        actions:  [
          // IconButton(onPressed: (){
          //   setState(() {
          //     columnReadDataModelForSearch = columnReadDataModel;
          //     isSearch = !isSearch ;
          //   });
          // }, icon: Icon(isSearch ? Icons.search_off: Icons.search,)),
          PopMenuButton(false,false,id)
        ],
      ),
      floatingActionButton: Container(
        width: 60.0,
        height: 60.0,
        margin:const EdgeInsets.only(right: 10,bottom: 10),
        child: FloatingActionButton(
          onPressed: ()  async{
          final result = await  Navigator.push(context,MaterialPageRoute(builder: (context)=>const CreateColumnScreen()));

           _getColumnScreenData(false);

          },
          child: const Icon(Icons.add,color: AppColors.backgroundColor,size: 30,),
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
                  isSearch ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OptionMcqAnswer(
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              elevation: 0,
                              alignment: Alignment.centerRight,
                              value: selectedValue,
                              onChanged: (String? newValue) {
                                //columnReadDataModel.clear();
                                // columnReadDataModelForSearch.clear();
                                // print(columnReadDataModelForAll);
                                // print(columnReadDataModelForEntry);
                                // print(columnReadDataModelForSession);

                                setState(() {
                                  _searchController.text = "";
                                  selectedValue = newValue!;
                                  if(selectedValue == "All") {
                                    columnReadDataModelForSearch = columnReadDataModelForAll;
                                    columnReadDataModel = columnReadDataModelForAll;
                                  } else if(selectedValue == "Entry") {
                                    columnReadDataModelForSearch = columnReadDataModelForEntry;
                                    columnReadDataModel = columnReadDataModelForEntry;
                                  } else if(selectedValue == "Meeting") {
                                    columnReadDataModelForSearch = columnReadDataModelForMeeting;
                                    columnReadDataModel = columnReadDataModelForMeeting;
                                  } else {
                                    columnReadDataModelForSearch = columnReadDataModelForSession;
                                    columnReadDataModel = columnReadDataModelForSession;
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),

                      Expanded(
                        flex: 3,
                        child: SearchTextField((value) {
                          filterSearchResults(value);
                        }, _searchController, 1, false, "search here with title"),
                      ),
                    ],
                  ) :
                  Container(
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/1.5),
                    alignment: Alignment.centerRight,
                    child: OptionMcqAnswer(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          elevation: 0,
                          alignment: Alignment.centerRight,
                          value: selectedValue,
                          onChanged: (String? newValue) {
                            // columnReadDataModel.clear();
                            // ignore: avoid_print
                            print(columnReadDataModelForAll);
                            // ignore: avoid_print
                            print(columnReadDataModelForEntry);
                            // ignore: avoid_print
                            print(columnReadDataModelForSession);

                            setState(() {
                              _searchController.text = "";
                              selectedValue = newValue!;
                              if(selectedValue == "All") {
                                columnReadDataModel = columnReadDataModelForAll;
                              } else if(selectedValue == "Entry") {
                                columnReadDataModel = columnReadDataModelForEntry;
                              } else if(selectedValue == "Meeting") {
                                columnReadDataModel = columnReadDataModelForMeeting;
                              } else {
                                columnReadDataModel = columnReadDataModelForSession;
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  _isDataLoading ? const Center(child: CircularProgressIndicator(),) : columnReadDataModel.isNotEmpty  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: isSearch ? columnReadDataModelForSearch.length : columnReadDataModel.length,
                      itemBuilder: (context,index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ColumnDetailsScreen(isSearch ? columnReadDataModelForSearch[index] :columnReadDataModel[index])));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              color: AppColors.lightGreyColor,
                              child: Column(

                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/1.3,
                                        child: Text(isSearch ? columnReadDataModelForSearch[index].entryTitle! :columnReadDataModel[index].entryTitle!,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: AppConstants.headingFontSizeForEntriesAndSession),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            _deleteColumnData(isSearch ? columnReadDataModelForSearch[index].id :columnReadDataModel[index].id,index);
                                          },
                                          child: const Icon(Icons.delete,color: AppColors.redColor,)),
                                      // IconButton(onPressed: (){
                                      //
                                      // }, icon: Icon(Icons.delete,color: AppColors.redColor,))
                                    ],

                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(isSearch ? columnReadDataModelForSearch[index].entryDate.toString() :columnReadDataModel[index].entryDate.toString())),style: const TextStyle(fontSize: AppConstants.defaultFontSize),))
                                ],
                              ),
                            ),
                          ),
                        );
                      }) : const Center(
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


