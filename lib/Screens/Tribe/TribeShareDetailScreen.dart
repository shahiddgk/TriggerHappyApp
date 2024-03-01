// ignore_for_file: depend_on_referenced_packages, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/constants.dart';
import '../../model/reponse_model/Tribe/tribe_shared_items_lists_response_model.dart';
import '../Column/Widgets/column_details_widget.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../PireScreens/widgets/pire_naq_details_widget.dart';
import '../utill/userConstants.dart';
import 'package:intl/intl.dart';

class ShareDetailScreen extends StatefulWidget {
   ShareDetailScreen(this.score,this.date,this.connectionName,this.otherUserName,this.pageTitle,this.naqPireDataItemDetail,this.columnDataItem,this.shareLadderDataItem,{Key? key}) : super(key: key);

  String pageTitle;
   List<NaqPireDataItemDetail> naqPireDataItemDetail;
   ColumnDataItem columnDataItem;
   LadderDataItem shareLadderDataItem;
   String otherUserName;
   String connectionName;
   String date;
   String score;

  @override
  State<ShareDetailScreen> createState() => _ShareDetailScreenState();
}

class _ShareDetailScreenState extends State<ShareDetailScreen> {

  String name = "";
  String id = "";

  bool isError = false;
  String errorText = "";

  String email = "";
  String timeZone = "";
  String userType = "";

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  bool otherUserLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    super.initState();
  }

  _getUserData() async {
    //showUpdatePopup(context);
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    // badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

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
    }
  }

  getScreenDetails() {
    setState(() {
    });
    if(MediaQuery.of(context).size.width< 650) {
      isPhone = true;
      isDesktop = false;
      isTable = false;
    } else if (MediaQuery.of(context).size.width >= 650 && MediaQuery.of(context).size.width < 1100) {
      isTable = true;
      isPhone = false;
      isDesktop = false;
    } else if(MediaQuery.of(context).size.width >= 1100) {
      isPhone = false;
      isDesktop = true;
      isTable = false;
    }
    setState(() {
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
      body: Column(
        children: [
          Container(
            color: AppColors.hoverColor,
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(widget.pageTitle,style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),),
                  Text("${widget.otherUserName} (${widget.connectionName.capitalize()})",style: const TextStyle(fontSize: AppConstants.headingFontSize,fontWeight: FontWeight.w700,color: AppColors.primaryColor),),
                  Text(DateFormat('MM-dd-yy').format(DateTime.parse(widget.date)),style: const TextStyle(fontSize: AppConstants.headingFontSize,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)

                ],
              )),
          Expanded(child: Container(
            padding: const EdgeInsets.only(top: 5,left: 2,right: 2),
            decoration:  const BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   margin:  const EdgeInsets.only(left: 20,right: 20,top: 15),
                  //   child: Row(
                  //
                  //     children: [
                  //       Text("Shared Response:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: !isPhone ? AppConstants.defaultFontSize : AppConstants.columnDetailsScreenFontSize),),
                  //       const SizedBox(width: 20,),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    margin:  const EdgeInsets.only(left: 20,right: 20,top: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor,width: 3),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(20)
                        )
                    ),
                    child: widget.pageTitle == "Column" ? ColumnDetailsWidget(
                      typeText: widget.columnDataItem.entryType!,
                      titleText: widget.columnDataItem.entryTitle!,
                      takeAwayText: widget.columnDataItem.entryTakeaway!,
                      noteText: widget.columnDataItem.entryDecs!,
                      dateText: widget.columnDataItem.entryDate!,
                    )
                    // Column(
                    //   children: [
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Text("Type: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                    //         Expanded(
                    //           child: Container(
                    //               padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                    //               alignment: Alignment.topLeft,
                    //               child: Text(widget.columnDataItem.entryType!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
                    //         ),
                    //
                    //       ],
                    //     ),
                    //
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Text("Title: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                    //         Expanded(
                    //           child: Container(
                    //               padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                    //               alignment: Alignment.topLeft,
                    //               child: Text(widget.columnDataItem.entryTitle!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
                    //         ),
                    //
                    //
                    //       ],
                    //     ),
                    //
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Text("Date: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                    //         Expanded(
                    //           child: Container(
                    //               padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                    //               alignment: Alignment.topLeft,
                    //               child: Text(" ${DateFormat('MM-dd-yy').format(DateTime.parse(widget.columnDataItem.entryDate!.toString()))}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),)),
                    //         ),
                    //
                    //       ],
                    //     ),
                    //
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Text("Note: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                    //         Expanded(
                    //           child: Container(
                    //             padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                    //             alignment: Alignment.topLeft,
                    //             child: Text(" ${widget.columnDataItem.entryDecs!}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),),
                    //         ),
                    //
                    //       ],
                    //     ),
                    //
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Text("Take Away: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                    //         Expanded(
                    //           child: Container(
                    //             padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                    //             alignment: Alignment.topLeft,
                    //             child: Text(" ${widget.columnDataItem.entryTakeaway!}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // )
                        : widget.pageTitle == "Ladder" ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Type: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                            Expanded(
                              child: Container(
                                  padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                                  alignment: Alignment.topLeft,
                                  child: Text(widget.shareLadderDataItem.type!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
                            ),

                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Description: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                            Expanded(
                              child: Container(
                                  padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                                  alignment: Alignment.topLeft,
                                  child: Text(widget.shareLadderDataItem.description!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
                            ),

                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Category: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                            Expanded(
                              child: Container(
                                  padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                                  alignment: Alignment.topLeft,
                                  child: Text(widget.shareLadderDataItem.option1!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
                            ),


                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Option2: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                            Expanded(
                              child: Container(
                                  padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                                  alignment: Alignment.topLeft,
                                  child: Text(widget.shareLadderDataItem.option2!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
                            ),


                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Date: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                            Expanded(
                              child: Container(
                                  padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                                  alignment: Alignment.topLeft,
                                  child: Text(" ${DateFormat('MM-dd-yy').format(DateTime.parse(widget.shareLadderDataItem.date!.toString()))}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),)),
                            ),

                          ],
                        ),
                      ],
                    ) : Column(
                      children: [
                        if(widget.pageTitle == "naq" || widget.pageTitle == "NAQ")
                           Text("NAQ Score : ${widget.score}/100",style: const TextStyle(fontWeight: FontWeight.bold),),
                        if(widget.pageTitle == "naq" || widget.pageTitle == "NAQ")
                          const Divider(color: AppColors.primaryColor,),
                        ListView.builder(
                            padding:const EdgeInsets.symmetric(vertical: 5),
                            shrinkWrap: true,
                            itemCount:  widget.naqPireDataItemDetail.length,
                            physics:const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return PireNaqDetailsWidget(
                                listIndex: index,
                                answerText: widget.naqPireDataItemDetail[index].answer!.text!,
                                optionText: widget.naqPireDataItemDetail[index].answer!.options!,
                                questionText: widget.naqPireDataItemDetail[index].question!.title!,
                              );
                              //   Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Row(
                              //       children: [
                              //         Text(" Question ${index + 1} : "),
                              //         Expanded(
                              //           child: Html(data: widget.naqPireDataItemDetail[index].question!.title!.replaceAll("Q${index + 1}:", ""),style: {
                              //             "#" : Style(
                              //               color: AppColors.textWhiteColor,
                              //               fontSize: FontSize(AppConstants.defaultFontSize),
                              //               textAlign: TextAlign.start,
                              //
                              //             ),
                              //           },),
                              //         ),
                              //       ],
                              //     ),
                              //     if(widget.naqPireDataItemDetail[index].answer!.options!="")
                              //       Row(
                              //         children: [
                              //           const Text(" Answer: ",style:  TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                              //           Expanded(
                              //             child: Html(data: widget.naqPireDataItemDetail[index].answer!.options!.capitalize().replaceAll("Never", "1 - Never").replaceAll("Rarely", "2 - Rarely").replaceAll("Often", "3 - Often").replaceAll("Always", "4 - Always"),style: {
                              //               "#" : Style(
                              //                 color: AppColors.textWhiteColor,
                              //                 fontSize: FontSize(AppConstants.defaultFontSize),
                              //                 textAlign: TextAlign.start,
                              //
                              //               ),
                              //             },),
                              //           ),
                              //         ],),
                              //     if(widget.naqPireDataItemDetail[index].answer!.text!="")
                              //       Row(
                              //         children: [
                              //           const Text(" Answer: ",style:  TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                              //           // Text(sharedItemDetailsResponse.data![index]..type == "naq" && newGardenHistoryResponseDetailsModel.data![index].options! == "yes" ? "  Why Yes:" : "   Answer: ",style:  const TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                              //           Expanded(
                              //             child: Html(data: widget.naqPireDataItemDetail[index].answer!.text!,style: {
                              //               "#" : Style(
                              //                 color: AppColors.textWhiteColor,
                              //                 fontSize: FontSize(AppConstants.defaultFontSize),
                              //                 textAlign: TextAlign.start,
                              //
                              //               ),
                              //             },),
                              //           ),
                              //         ],),
                              //     const Divider(color: AppColors.primaryColor,height: 2,)
                              //   ],
                              // );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
