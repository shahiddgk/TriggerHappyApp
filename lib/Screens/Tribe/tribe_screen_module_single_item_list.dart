// ignore_for_file: must_be_immutable, avoid_print

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:flutter_quiz_app/Screens/Tribe/TribeShareDetailScreen.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/reponse_model/Tribe/trellis_share_response_model_all.dart';
import '../../model/reponse_model/Tribe/tribe_shared_items_lists_response_model.dart';
import '../../model/request_model/Tribe/tribe_shared_item_request.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/error_text_and_button_widget.dart';
import '../utill/userConstants.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class TribeScreenModuleSingleItemList extends StatefulWidget {
   TribeScreenModuleSingleItemList(this.otherUserName,this.otherUserId,this.connectionId,this.moduleNames,this.connectionName,{Key? key}) : super(key: key);

  String connectionId;
  String otherUserId;
  String moduleNames;
  String otherUserName;
   String connectionName;

  @override
  State<TribeScreenModuleSingleItemList> createState() => _TribeScreenModuleSingleItemListState();
}

class _TribeScreenModuleSingleItemListState extends State<TribeScreenModuleSingleItemList> {

  int badgeCount1 = 0;
  int badgeCountShared = 0;
  int selectedRadio = 1;

  String name = "";
  String id = "";
  String errorText = "";

  // bool _isLoading1 = true;
  bool _isLoading2 = true;

  late bool isPhone;

  bool otherUserLoggedIn = false;

  bool _isError = false;

  String email = "";
  String timeZone = "";
  String userType = "";

  final List<String> moduleItems = [
    'P.I.R.E',
    'NAQ',
    'Column',
    'Trellis',
    'Ladder',
  ];
  String moduleInitialItem = "P.I.R.E";

  List<NaqPireDataItem> sharePireResponseModel = <NaqPireDataItem>[];
  List<ColumnDataItem> shareColumnResponseModel = <ColumnDataItem>[];
  List<LadderDataItem> shareLadderResponseModel = <LadderDataItem>[];

  List<Trellis> trellis = <Trellis>[] ;
  List<Tribe> tribe = <Tribe>[];
  List<Ladder> ladder = <Ladder>[];
  List<Identity> identity = <Identity>[];
  List<Principles> principles = <Principles>[];

  List <Identity> trellisNeedsData = [];
  List <Identity> trellisIdentityData = [];

  List <Principles> trellisPrinciplesData = [];
  List <Principles> trellisRhythmsData = [];

  List <Tribe> trellisMenteeTribeData = [];
  List <Tribe> trellisMentorTribeData = [];
  List <Tribe> trellisPeerTribeData = [];

  List <Ladder> trellisLadderDataForGoalsFavourites = [];
  List <Ladder> trellisLadderDataForAchievementsFavourites = [];

  List<ShareSingleItem> singleItemList = <ShareSingleItem>[];

  @override
  void initState() {
    // TODO: implement initState

    _getUserData();

    print(widget.moduleNames);

    super.initState();
  }

  _getUserData() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

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
    // getSharedSingleItemDetailsList("pire");
    // getModuleDetailsListForPireNAQ("pire");

    if(widget.moduleNames.contains("pire")) {
      getModuleDetailsListForPireNAQ("pire");
    } else {
      getSharedSingleItemDetailsList("pire");
    }

    print(widget.otherUserId);
    print(widget.connectionId);
  }

  /// This is Api call for single item

  getSharedSingleItemDetailsList(String moduleType) {
    print(widget.connectionId);
    print(moduleType);
    print(id);
    setState(() {
        _isLoading2 = true;
    });
    HTTPManager().getTribeShareSingleItemDetailForPireNaq(TribeSingleSharedRequestModel(connectionId: widget.connectionId,dataType: moduleType,requesterId: id)).then((value) {
      setState(() {
        sharePireResponseModel = value.data!;
        _isLoading2 = false;
        _isError = false;
      });

    }).catchError((e) {
      print("single type list");
      print(e.toString());
      setState(() {
        _isLoading2 = false;
        _isError = true;
        errorText = e.toString();
      });
    });

  }

  getSharedSingleItemDetailsListForColumn(String moduleType) {
    setState(() {
      _isLoading2 = true;
    });
    HTTPManager().getTribeShareSingleItemDetailForColumn(TribeSingleSharedRequestModel(connectionId: widget.connectionId,dataType: moduleType,requesterId: id)).then((value) {
      setState(() {
        shareColumnResponseModel = value.columnDataItem!;
        _isLoading2 = false;
        _isError = false;
      });

    }).catchError((e) {
      setState(() {
        _isLoading2 = false;
        _isError = true;
        errorText = e.toString();
      });
    });

  }

  // getSharedSingleItemDetailsListForTrellis(String moduleType) {
  //   setState(() {
  //     _isLoading2 = true;
  //   });
  //   HTTPManager().trellisShareScreenRead(LogoutRequestModel(connectionId: widget.connectionId,dataType: moduleType)).then((value) {
  //     setState(() {
  //       shareLadderResponseModel = value.columnDataItem!;
  //       _isLoading2 = false;
  //       _isError = false;
  //     });
  //
  //   }).catchError((e) {
  //     setState(() {
  //       _isLoading2 = false;
  //       _isError = true;
  //       errorText = e.toString();
  //     });
  //   });
  //
  // }

  getSharedSingleItemDetailsListForLadder(String moduleType) {
    setState(() {
      _isLoading2 = true;
    });
    HTTPManager().getTribeShareSingleItemDetailForLadder(TribeSingleSharedRequestModel(connectionId: widget.connectionId,dataType: moduleType,requesterId: id )).then((value) {
      setState(() {
        shareLadderResponseModel = value.ladderDataItemList!;
        _isLoading2 = false;
        _isError = false;
      });

    }).catchError((e) {
      setState(() {
        _isLoading2 = false;
        _isError = true;
        errorText = e.toString();
      });
    });

  }

/// This is Api call for complete module

  getModuleDetailsListForPireNAQ(String moduleType) {
    setState(() {
      _isLoading2 = true;
      sharePireResponseModel.clear();
    });
    HTTPManager().getTribeShareItemDetailForPireNaq(TribeSharedRequestModel(userId: widget.otherUserId,dataType: moduleType)).then((value) {
      setState(() {
        sharePireResponseModel = value.data!;
        _isLoading2 = false;
        _isError = false;
      });

    }).catchError((e) {
      setState(() {
        _isLoading2 = false;
        _isError = true;
        errorText = e.toString();
      });
    });
  }

  getModuleDetailsListForColumn(String moduleType) {
    setState(() {
      _isLoading2 = true;
      shareColumnResponseModel.clear();
    });
    HTTPManager().getTribeShareItemDetailForColumn(TribeSharedRequestModel(userId: widget.otherUserId,dataType: moduleType)).then((value) {
      setState(() {
        shareColumnResponseModel = value.columnDataItem!;
        _isLoading2 = false;
        _isError = false;
      });

    }).catchError((e) {
      setState(() {
        _isLoading2 = false;
        _isError = true;
        errorText = e.toString();
      });
    });
  }

  getModuleDetailsListForTrellis(String moduleType) {
    setState(() {
      _isLoading2 = true;
      shareColumnResponseModel.clear();
    });
    HTTPManager().trellisShareScreenRead(LogoutRequestModel(userId: widget.otherUserId)).then((value) {
      setState(() {
        trellis =  value.trellisDetailsItem!.trellis!;
        tribe = value.trellisDetailsItem!.tribe!;
        ladder = value.trellisDetailsItem!.ladder!;
        identity = value.trellisDetailsItem!.identity!;
         principles = value.trellisDetailsItem!.principles!;

        for(int i=0; i<principles.length;i++) {
          if (principles[i].type.toString() == "principles") {
            trellisPrinciplesData.add(principles[i]);
          } else {
            trellisRhythmsData.add(principles[i]);
          }
        }

        for(int i=0; i<identity.length;i++) {
          if (identity[i].text != "") {
            if (identity[i].type.toString() == "identity") {
              trellisIdentityData.add(identity[i]);
            } else {
              trellisNeedsData.add(identity[i]);
            }
          }
        }

        for(int i=0; i<ladder.length;i++) {
          if(ladder[i].favourite == "yes") {
            if (ladder[i].type.toString() ==
                "goal") {
              if(ladder[i].favourite!="no" ) {
                trellisLadderDataForGoalsFavourites.add(ladder[i]);
              }
            } else {
              if(ladder[i].favourite!="no" ) {
                trellisLadderDataForAchievementsFavourites.add(ladder[i]);
              }
            }
          }

        }

        for(int i = 0; i<tribe.length; i++ ) {
          if(tribe[i].type == "peer") {
            trellisPeerTribeData.add(tribe[i]);
          } else if(tribe[i].type == "mentor") {
            trellisMentorTribeData.add(tribe[i]);
          } else {
            trellisMenteeTribeData.add(tribe[i]);
          }
        }

        _isLoading2 = false;
        _isError = false;
      });

    }).catchError((e) {
      setState(() {
        _isLoading2 = false;
        _isError = true;
        errorText = e.toString();
      });
    });
  }

  getModuleDetailsListForLadder(String moduleType) {
    setState(() {
      _isLoading2 = true;
      shareColumnResponseModel.clear();
    });
    HTTPManager().getTribeShareItemDetailForLadder(TribeSharedRequestModel(userId: widget.otherUserId,dataType: moduleType)).then((value) {
      setState(() {
        shareLadderResponseModel = value.ladderDataItemList!;
        _isLoading2 = false;
        _isError = false;
      });

    }).catchError((e) {
      setState(() {
        _isLoading2 = false;
        _isError = true;
        errorText = e.toString();
      });
    });
  }

  getScreenDetails() {

    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }

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
                  Text("Burgeon-Tribe",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),),
                  Text("${widget.otherUserName} (${widget.connectionName.capitalize()})",style: const TextStyle(fontSize: AppConstants.headingFontSize,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
                ],
              )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(top: 5,left: 2,right: 2),
            decoration:  const BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )
            ),
            child: Column(
              children: [
               Container(
                 margin: const EdgeInsets.symmetric(horizontal: 10),
                 child: Row(
                   children: [
                     Expanded(
                       child: OptionMcqAnswer(
                         DropdownButtonHideUnderline(
                           child: DropdownButton2 <String>(
                             isExpanded: true,
                             value: moduleInitialItem,
                             onChanged: (String? value) {
                               setState(() {
                                 moduleInitialItem = value!;
                               });
                               if(moduleInitialItem == "P.I.R.E") {

                                 if(widget.moduleNames.contains("pire")) {
                                 getModuleDetailsListForPireNAQ("pire");
                                 } else {
                                   getSharedSingleItemDetailsList("pire");
                                 }
                               } else if(moduleInitialItem == "NAQ") {
                                 if(widget.moduleNames.contains("naq")) {
                                   getModuleDetailsListForPireNAQ("naq");
                                 } else {
                                   getSharedSingleItemDetailsList("naq");
                                 }
                                 // getModuleDetailsListForPireNAQ("naq");
                               } else if(moduleInitialItem == "Trellis") {
                                 if(widget.moduleNames.contains("trellis")) {
                                   getModuleDetailsListForTrellis("trellis");
                                 } else {
                                   setState(() {
                                     _isLoading2 = false;
                                   });
                                 }
                                 // getModuleDetailsListForPireNAQ("naq");
                               } else if(moduleInitialItem == "Ladder") {
                                 if(widget.moduleNames.contains("ladder")) {
                                   getModuleDetailsListForLadder("ladder");
                                 } else {
                                   getSharedSingleItemDetailsListForLadder("ladder");
                                 }
                                 // getModuleDetailsListForPireNAQ("naq");
                               } else {
                                 if(widget.moduleNames.contains("column")) {
                                   getModuleDetailsListForColumn("column");
                                 } else {
                                   getSharedSingleItemDetailsListForColumn("column");
                                 }
                                 // getModuleDetailsListForColumn("column");
                               }
                             },
                             items: moduleItems.map((e) => DropdownMenuItem<String>(
                               value: e.toString(),
                               child: Text(
                                 e.toString(),
                                 style: const TextStyle(
                                   fontSize: AppConstants.defaultFontSize,
                                 ),
                               ),
                             )).toList(),),
                         ),
                       ),
                     ),
                     const SizedBox(width: 5,),
                     const Icon(Icons.sort,color: AppColors.primaryColor,),
                     const Text("Sort by")
                   ],
                 ),
               ),
                // if(moduleInitialItem == "P.I.R.E")
                // Text(widget.moduleNames.contains("pire") ? "P.I.R.E Module Instances" : "P.I.R.E Limited Instances",style: const TextStyle(color: AppColors.primaryColor,),),
                // if(moduleInitialItem == "NAQ")
                //   Text(widget.moduleNames.contains("naq") ? "NAQ Module Instances" : "NAQ Limited Instances",style: const TextStyle(color: AppColors.primaryColor,),),
                // if(moduleInitialItem == "Trellis")
                //   Text(widget.moduleNames.contains("trellis") ? "Trellis Module Instances" : "Trellis Limited Instances",style: const TextStyle(color: AppColors.primaryColor,),),
                // if(moduleInitialItem == "Ladder")
                //   Text(widget.moduleNames.contains("ladder") ? "Ladder Module Instances" : "Ladder Limited Instances",style: const TextStyle(color: AppColors.primaryColor,),),
                // if(moduleInitialItem == "Column")
                //   Text(widget.moduleNames.contains("column") ? "Column Module Instances" : "Column Limited Instances",style: const TextStyle(color: AppColors.primaryColor,),),
                // const Divider(color: AppColors.primaryColor,),
                Expanded(
                  child: Container(
                    padding:const EdgeInsets.symmetric(horizontal: 2),
                    child: _isLoading2 ? const Center(child: CircularProgressIndicator())
                        : _isError ? ErrorTextAndButtonWidget(
                      errorText: errorText,onTap: (){
                      if(moduleInitialItem == "P.I.R.E") {
                        if(widget.moduleNames.contains("pire")) {
                          getModuleDetailsListForPireNAQ("pire");
                        } else {
                          getSharedSingleItemDetailsList("pire");
                        }
                      } else if(moduleInitialItem == "NAQ") {
                        if(widget.moduleNames.contains("naq")) {
                          getModuleDetailsListForPireNAQ("naq");
                        } else {
                          getSharedSingleItemDetailsList("naq");
                        }
                        // getModuleDetailsListForPireNAQ("naq");
                      } else if(moduleInitialItem == "Trellis") {
                        // if(widget.moduleNames.contains("trellis")) {
                        if(widget.moduleNames.contains("trellis")) {
                          getModuleDetailsListForTrellis("trellis");
                        } else {
                          setState(() {
                            _isLoading2 = false;
                          });
                        }
                        // }
                        // getModuleDetailsListForPireNAQ("naq");
                      } else if(moduleInitialItem == "Garden") {
                        if(widget.moduleNames.contains("garden")) {
                          getModuleDetailsListForPireNAQ("garden");
                        } else {
                          getSharedSingleItemDetailsList("garden");
                        }
                        // getModuleDetailsListForPireNAQ("naq");
                      } else if(moduleInitialItem == "Ladder") {
                        if(widget.moduleNames.contains("ladder")) {
                          getModuleDetailsListForLadder("ladder");
                        } else {
                          getSharedSingleItemDetailsListForLadder("ladder");
                        }
                        // getModuleDetailsListForPireNAQ("naq");
                      } else {
                        if(widget.moduleNames.contains("column")) {
                          getModuleDetailsListForColumn("column");
                        } else {
                          getSharedSingleItemDetailsListForColumn("column");
                        }
                        // getModuleDetailsListForColumn("column");
                      }
                    },
                    ) : moduleInitialItem == "P.I.R.E" ||  moduleInitialItem == "NAQ" ? sharePireResponseModel.isEmpty ? Center(child: Text(moduleInitialItem == "NAQ" ? "No NAQ shared yet" : "No P.I.R.E shared yet"),) :
                    GridView.count(
                        crossAxisCount: !isPhone ? 3 : 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 2.0,
                        childAspectRatio: 3,
                        scrollDirection: Axis.vertical,
                        children: List.generate(sharePireResponseModel.length, (index) {
                          return InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShareDetailScreen(sharePireResponseModel[index].score!??"",sharePireResponseModel[index].createdAt!,widget.connectionName,widget.otherUserName,moduleInitialItem, sharePireResponseModel[index].response!, ColumnDataItem(),LadderDataItem())));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: AppColors.primaryColor,width: 3)
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(sharePireResponseModel[index].createdAt!))),
                              )
                          );
                        }))

                    // ListView.builder(
                    //     shrinkWrap: true,
                    //     scrollDirection: Axis.vertical,
                    //     itemCount: sharePireResponseModel.length,
                    //     itemBuilder: (context, index) {
                    //   return InkWell(
                    //     onTap: (){
                    //
                    //     },
                    //     child: Container(
                    //       padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                    //       margin: const EdgeInsets.symmetric(vertical: 2),
                    //       decoration: BoxDecoration(
                    //           border: Border.all(color: AppColors.primaryColor,width: 1),
                    //           borderRadius: BorderRadius.circular(8)
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Column(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text(moduleInitialItem == "P.I.R.E" ? "P.I.R.E" : "NAQ",style: const TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSize),),
                    //              const SizedBox(height: 5,),
                    //               Row(
                    //                 children: [
                    //                   const Text("Date : ",style: TextStyle(fontSize: AppConstants.defaultFontSize)),
                    //               Text("",style: const TextStyle(fontSize: AppConstants.defaultFontSize, fontWeight: FontWeight.bold)),
                    //             ],
                    //               )
                    //             ],
                    //           ),
                    //           // const Text("Oct 20,2023")
                    //         ],
                    //       ),
                    //     ),
                    //   );
                    // })
                          : moduleInitialItem == "Column" ? shareColumnResponseModel.isEmpty ? const Center(child: Text("No Column shared yet"),)
                        : GridView.count(
                        crossAxisCount: !isPhone ? 3 : 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 2.0,
                        childAspectRatio: 3,
                        scrollDirection: Axis.vertical,
                        children: List.generate(shareColumnResponseModel.length, (index) {
                          return InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShareDetailScreen("",shareColumnResponseModel[index].createdAt!,widget.connectionName,widget.otherUserName,moduleInitialItem,const <NaqPireDataItemDetail>[] , shareColumnResponseModel[index],LadderDataItem())));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: AppColors.primaryColor,width: 3)
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(shareColumnResponseModel[index].createdAt!))),
                              )
                          );
                        }))
                    // ListView.builder(
                    //     shrinkWrap: true,
                    //     scrollDirection: Axis.vertical,
                    //     itemCount: shareColumnResponseModel.length,
                    //     itemBuilder: (context, index) {
                    //       return InkWell(
                    //         onTap: () {
                    //           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShareDetailScreen(moduleInitialItem,const <NaqPireDataItemDetail>[] , shareColumnResponseModel[index],LadderDataItem())));
                    //         },
                    //         child: Container(
                    //           padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                    //           margin: const EdgeInsets.symmetric(vertical: 2),
                    //           decoration: BoxDecoration(
                    //               border: Border.all(color: AppColors.primaryColor,width: 1),
                    //               borderRadius: BorderRadius.circular(8)
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Column(
                    //                 mainAxisAlignment: MainAxisAlignment.start,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(moduleInitialItem,style: const TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSize),),
                    //                   const SizedBox(height: 5,),
                    //                   Row(
                    //                     children: [
                    //                       const Text("Shared by: ",style: TextStyle(fontSize: AppConstants.defaultFontSize)),
                    //                       Text(widget.otherUserName,style: const TextStyle(fontSize: AppConstants.defaultFontSize, fontWeight: FontWeight.bold)),
                    //                     ],
                    //                   )
                    //                 ],
                    //               ),
                    //               // const Text("Oct 20,2023")
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     })
                          : moduleInitialItem == "Ladder" ? shareLadderResponseModel.isEmpty ? const Center(child: Text("No Ladder shared yet"),)
                  : GridView.count(
                        crossAxisCount: !isPhone ? 3 : 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 2.0,
                        childAspectRatio: 3,
                        scrollDirection: Axis.vertical,
                        children: List.generate(shareLadderResponseModel.length, (index) {
                          return InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShareDetailScreen("",shareLadderResponseModel[index].createdAt!,widget.connectionName,widget.otherUserName,moduleInitialItem,const <NaqPireDataItemDetail>[] , ColumnDataItem(),shareLadderResponseModel[index])));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: AppColors.primaryColor,width: 3)
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(shareLadderResponseModel[index].createdAt!))),
                              )
                          );
                        }))


              //       ListView.builder(
              // shrinkWrap: true,
              // scrollDirection: Axis.vertical,
              // itemCount: shareLadderResponseModel.length,
              // itemBuilder: (context, index) {
              //   return InkWell(
              //     onTap: () {
              //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShareDetailScreen(moduleInitialItem,const <NaqPireDataItemDetail>[] , ColumnDataItem(),shareLadderResponseModel[index])));
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
              //       margin: const EdgeInsets.symmetric(vertical: 2),
              //       decoration: BoxDecoration(
              //           border: Border.all(color: AppColors.primaryColor,width: 1),
              //           borderRadius: BorderRadius.circular(8)
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(moduleInitialItem,style: const TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSize),),
              //               const SizedBox(height: 5,),
              //               Row(
              //                 children: [
              //                   const Text("Shared by: ",style: TextStyle(fontSize: AppConstants.defaultFontSize)),
              //                   Text(widget.otherUserName,style: const TextStyle(fontSize: AppConstants.defaultFontSize, fontWeight: FontWeight.bold)),
              //                 ],
              //               )
              //             ],
              //           ),
              //           // const Text("Oct 20,2023")
              //         ],
              //       ),
              //     ),
              //   );
              // })
                        : SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: trellis.isEmpty && tribe.isEmpty && ladder.isEmpty && identity.isEmpty && principles.isEmpty ? const Center(child: Text("Trellis Not shared yet"),) : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView.builder(
                                itemCount: trellis.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                      const Text("Name: ",style: TextStyle(fontSize: AppConstants.userActivityFontSize,color: AppColors.primaryColor),),
                                      Text(trellis[index].name!,style: const TextStyle(fontSize: AppConstants.defaultFontSize),)
                                    ],),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                      const Text("Description: ",style: TextStyle(fontSize: AppConstants.userActivityFontSize,color: AppColors.primaryColor),),
                                      Text(trellis[index].nameDesc!,style: const TextStyle(fontSize: AppConstants.defaultFontSize),)
                                    ],),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                      const Text("Purpose: ",style: TextStyle(fontSize: AppConstants.userActivityFontSize,color: AppColors.primaryColor),),
                                      Text(trellis[index].purpose!,style: const TextStyle(fontSize: AppConstants.defaultFontSize),)
                                    ],),
                                  ),
                                ],
                              );
                            }),
                            const SizedBox(height: 5,),
                            const Divider(),
                            const Text("Ladder Highlights:",style: TextStyle(fontSize: AppConstants.userActivityFontSize,color: AppColors.primaryColor),),
                            const SizedBox(height: 5,),
                            const Text("Goals/Challenges",style: TextStyle(
                                fontSize: AppConstants.defaultFontSize,
                                color: AppColors.primaryColor
                            ),),
                            trellisLadderDataForGoalsFavourites.isEmpty ? const Center(child: Text("No Goals/Challenges Added"))  : ListView.builder(
                                itemCount: trellisLadderDataForGoalsFavourites.length > 3 ? 3 : trellisLadderDataForGoalsFavourites.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 10,
                                    color: AppColors.lightGreyColor,
                                    child: Container(

                                        decoration: BoxDecoration(
                                            color: AppColors.lightGreyColor,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("${trellisLadderDataForGoalsFavourites[index].option1} | ${trellisLadderDataForGoalsFavourites[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            // Align(alignment: Alignment.topRight,
                                            //   child: IconButton(
                                            //     onPressed: () {},
                                            //     icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                            //   ),),
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child:  Text("${trellisLadderDataForGoalsFavourites[index].date!.isEmpty ? "" : DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForGoalsFavourites[index].date.toString()))} ${trellisLadderDataForGoalsFavourites[index].date!.isEmpty ? "" : "|"} ${trellisLadderDataForGoalsFavourites[index].text} | ${trellisLadderDataForGoalsFavourites[index].description}"))
                                          ],
                                        )),
                                  );
                                }),
                            const SizedBox(height: 5,),
                            const Text("Memories/Achievements",style: TextStyle(
                                fontSize: AppConstants.defaultFontSize,
                                color: AppColors.primaryColor
                            ),),
                            const SizedBox(height: 5,),
                            trellisLadderDataForAchievementsFavourites.isEmpty ? const Center(child: Text("No Memories/Achievements"))  : ListView.builder(
                                itemCount: trellisLadderDataForAchievementsFavourites.length > 3 ? 3 : trellisLadderDataForAchievementsFavourites.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 10,
                                    color: AppColors.lightGreyColor,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.lightGreyColor,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("${trellisLadderDataForAchievementsFavourites[index].option1}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: Text( "${trellisLadderDataForAchievementsFavourites[index].date!.isEmpty ? "" :DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForAchievementsFavourites[index].date.toString()))} ${trellisLadderDataForAchievementsFavourites[index].date!.isEmpty ? "" : "|"} ${trellisLadderDataForAchievementsFavourites[index].text}"))
                                          ],
                                        )),
                                  );
                                }),
                            const SizedBox(height: 5,),
                            const Divider(),
                            const Text("Organizing Principle:",style: TextStyle(fontSize: AppConstants.userActivityFontSize,color: AppColors.primaryColor),),
                            const SizedBox(height: 5,),
                            trellisPrinciplesData.isEmpty ? const Center(child:Text("No Organizing Principles Shared")): ListView.builder(
                                itemCount: trellisPrinciplesData.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 10,
                                    color: AppColors.lightGreyColor,
                                    child: Container(
                                      color: AppColors.lightGreyColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                            Row(
                                              children: [
                                                Image.asset("assets/arm.png"),
                                                Expanded(child: Text(" : ${trellisPrinciplesData[index].empTruths}",style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),)),
                                              ],
                                            ),
                                         const SizedBox(height: 8,),
                                          Row(
                                            children: [
                                              Image.asset("assets/emoji.png"),
                                              Expanded(child: Text(" : ${trellisPrinciplesData[index].powerlessBelieves}",style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize))),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(height: 5,),
                            const Divider(),
                            const Text("Rhythms:",style: TextStyle(fontSize: AppConstants.userActivityFontSize,color: AppColors.primaryColor),),
                            const SizedBox(height: 5,),
                            trellisRhythmsData.isEmpty ? const Center(child:Text("No Rhythms Shared")): ListView.builder(
                                itemCount: trellisRhythmsData.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 10,
                                    color: AppColors.lightGreyColor,
                                    child: Container(
                                      color: AppColors.lightGreyColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset("assets/arm.png"),
                                              Expanded(child: Text(" : ${trellisRhythmsData[index].empTruths}",style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize))),
                                            ],
                                          ),
                                          const SizedBox(height: 8,),
                                          Row(
                                            children: [
                                              Image.asset("assets/emoji.png"),
                                              Expanded(child: Text(" : ${trellisRhythmsData[index].powerlessBelieves}",style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize))),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(height: 5,),
                            const Divider(),
                            const Text("Needs:",style: TextStyle(fontSize: AppConstants.userActivityFontSize,color: AppColors.primaryColor),),
                            const SizedBox(height: 5,),
                            trellisNeedsData.isEmpty ? const Center(child:Text("No Needs Shared")):ListView.builder(
                                itemCount: trellisNeedsData.length,
                                shrinkWrap: true,
                                physics:const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: AppColors.lightGreyColor,
                                    elevation: 10,
                                    child: Container(
                                      color: AppColors.lightGreyColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                            Text(trellisNeedsData[index].text!,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(height: 5,),
                            const Divider(),
                            const Text("Identity:",style: TextStyle(fontSize: AppConstants.userActivityFontSize,color: AppColors.primaryColor),),
                            const SizedBox(height: 5,),
                            trellisIdentityData.isEmpty ? const Center(child:Text("No Identity Shared")): ListView.builder(
                                itemCount: trellisIdentityData.length,
                                shrinkWrap: true,
                                physics:const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 10,
                                    color: AppColors.lightGreyColor,
                                    child: Container(
                                      color: AppColors.lightGreyColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(trellisIdentityData[index].text!,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(height: 5,),
                            const Divider(),
                            const Text("Tribe:",style: TextStyle(fontSize: AppConstants.userActivityFontSize,color: AppColors.primaryColor),),
                            const SizedBox(height: 5,),
                            const Text("Mentor",style: TextStyle(
                                fontSize: AppConstants.columnDetailsScreenFontSize,
                                color: AppColors.primaryColor
                            ),),
                            trellisMentorTribeData.isEmpty ? const Center(child:Text("No Mentor Shared")): ListView.builder(
                                itemCount: trellisMentorTribeData.length,
                                shrinkWrap: true,
                                physics:const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 10,
                                    color: AppColors.lightGreyColor,
                                    child: Container(
                                      color: AppColors.lightGreyColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                            // Text("Name: ${tribe[index].type!.capitalize()}",style: const TextStyle(fontSize: AppConstants.defaultFontSize,color: AppColors.primaryColor),),
                                          Text(trellisMentorTribeData[index].text!,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(height: 5,),
                            const Text("Peer",style: TextStyle(
                                fontSize: AppConstants.columnDetailsScreenFontSize,
                                color: AppColors.primaryColor
                            ),),
                            trellisPeerTribeData.isEmpty ? const Center(child:Text("No Peer Shared")): ListView.builder(
                                itemCount: trellisPeerTribeData.length,
                                shrinkWrap: true,
                                physics:const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 10,
                                    color: AppColors.lightGreyColor,
                                    child: Container(
                                      color: AppColors.lightGreyColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          // Text("Name: ${tribe[index].type!.capitalize()}",style: const TextStyle(fontSize: AppConstants.defaultFontSize,color: AppColors.primaryColor),),
                                          Text(trellisPeerTribeData[index].text!,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(height: 5,),
                            const Text("Mentee",style: TextStyle(
                                fontSize: AppConstants.columnDetailsScreenFontSize,
                                color: AppColors.primaryColor
                            ),),
                            trellisMenteeTribeData.isEmpty ? const Center(child:Text("No Mentee Shared")): ListView.builder(
                                itemCount: trellisMenteeTribeData.length,
                                shrinkWrap: true,
                                physics:const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 10,
                                    color: AppColors.lightGreyColor,
                                    child: Container(
                                      color: AppColors.lightGreyColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          // Text("Name: ${tribe[index].type!.capitalize()}",style: const TextStyle(fontSize: AppConstants.defaultFontSize,color: AppColors.primaryColor),),
                                          Text(trellisMenteeTribeData[index].text!,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                    ),
                        ),
                      ),

                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
