// ignore_for_file: avoid_print, must_be_immutable, unused_field, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:flutter_quiz_app/Screens/Sage/response_feedback_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import 'package:intl/intl.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../model/reponse_model/Sage/sage_feedback_list_model.dart';
import '../../model/reponse_model/Sage/shared_item_list_details.dart';
import '../../model/request_model/Sage Request/sage_feedback_list_request.dart';
import '../../model/request_model/Sage Request/shared_item_details_request.dart';
import '../../network/http_manager.dart';
import '../Column/Widgets/column_details_widget.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../PireScreens/widgets/pire_naq_details_widget.dart';
import '../Widgets/error_text_and_button_widget.dart';
import '../utill/userConstants.dart';

class SageShareDetailsScreen extends StatefulWidget {
  SageShareDetailsScreen(this.userName,this.itemId,this.entityId,this.itemType,this.isPaid,this.recieverId,{Key? key}) : super(key: key);

  String userName;
  String itemId;
  String entityId;
  String itemType;
  String recieverId;
  bool isPaid;

  @override
  State<SageShareDetailsScreen> createState() => _SageShareDetailsScreenState();
}

class _SageShareDetailsScreenState extends State<SageShareDetailsScreen> with SingleTickerProviderStateMixin {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;

  bool _isLoading = true;
  bool _isLoading1 = true;

  bool isError = false;
  String errorText = "";

  String email = "";
  String timeZone = "";
  String userType = "";
  bool isSharedByMe = false;
  late SharedItemDetailsResponse sharedItemDetailsResponse;
  late ColumnSharedItemDetail columnReadDataModel;
  late LadderSingleItemDetailsResponseModel ladderSingleItemDetailsResponseModel;
  late final AnimationController _animationController;
  List<SageFeedback> sageFeedbackList = <SageFeedback>[];


  late bool isPhone;
  late bool isTable;
  late bool isDesktop;
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  bool otherUserLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.repeat(reverse: true);

    print("RECIEVER ID");
    print(widget.recieverId);

    _getUserData();
    super.initState();
  }


  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      _isUserDataLoading = true;
    });
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
    getFeedbackList();

    if(widget.itemType == "column") {
      getColumnSharedItemDetails();
    } else if(widget.itemType == "ladder" ) {
      getLadderShareditemDetails();
    } else {
      getSharedItemDetails();
    }

    setState(() {
      _isUserDataLoading = false;
    });
  }

  getFeedbackList() {
    setState(() {
      _isLoading1 = true;
    });
    HTTPManager().getSageFeedbackList(SageFeedbackRequestModel(sharedId: widget.itemId,)).then((value) {

      setState(() {

        sageFeedbackList = value.sageFeedback!;

        _isLoading1 = false;
      });

    }).catchError((e) {

      setState(() {
        _isLoading1 = false;
      });

    });
  }

  getSharedItemDetails() {
    print("Naq Detail");
    setState(() {
      _isLoading = true;
    });
    HTTPManager().getShareItemDetail(SharedItemDetailsRequest(entityId: widget.entityId,type: widget.itemType)).then((value) {


      setState(() {
        sharedItemDetailsResponse = value;

        _isLoading = false;
        isError = false;
      });


    }).catchError((e) {
      print(e.toString());
      setState(() {
        isError = true;
        errorText = e.toString();
        _isLoading = false;
      });
    });
  }

  getColumnSharedItemDetails() {
    print("Column Detail");
    setState(() {
      _isLoading = true;
    });
    HTTPManager().getShareItemDetailForColumn(SharedItemDetailsRequest(entityId: widget.entityId,type: widget.itemType)).then((value) {


      setState(() {
        columnReadDataModel = value;

        _isLoading = false;
        isError = false;
      });


    }).catchError((e) {
      print(e.toString());
      setState(() {
        isError = true;
        errorText = e.toString();
        _isLoading = false;
      });
    });
  }

  getLadderShareditemDetails() {
    print("ladder Detail");
    setState(() {
      _isLoading = true;
    });
    HTTPManager().getShareItemDetailForLadder(SharedItemDetailsRequest(entityId: widget.entityId,type: widget.itemType)).then((value) {


      setState(() {
        ladderSingleItemDetailsResponseModel = value;

        _isLoading = false;
        isError = false;
      });


    }).catchError((e) {
      print(e.toString());
      setState(() {
        isError = true;
        errorText = e.toString();
        _isLoading = false;
      });
    });
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

  // showFeedbackDialogue(BuildContext context) {
  //
  //   final isPhone = MediaQuery.of(context).size.width <= 500;
  //   final dialogWidth = isPhone ? MediaQuery.of(context).size.width : 400.0;
  //   final dialogHeight = isPhone
  //       ? MediaQuery.of(context).size.height * 0.8
  //       : MediaQuery.of(context).size.height * 0.6;
  //
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(25))),
  //           contentPadding: const EdgeInsets.all(2),
  //           backgroundColor: AppColors.hoverColor,
  //           actionsAlignment: MainAxisAlignment.center,
  //           actionsPadding: const EdgeInsets.only(left: 30,right: 30,bottom: 5),
  //           content: SizedBox(
  //                   height: dialogHeight/1.5,
  //                   width: dialogWidth,
  //                 child: Column(
  //                   children: [
  //                     Container(
  //                       margin:const EdgeInsets.only(bottom: 5),
  //                       decoration: const BoxDecoration(color: AppColors.primaryColor,
  //                           borderRadius: BorderRadius.only(topLeft: Radius.circular(150),topRight: Radius.circular(150))
  //                       ),
  //                       width: MediaQuery.of(context).size.width,
  //                       alignment: Alignment.topCenter,
  //                       child:  const Text("Coach Feedback",style: TextStyle(color:AppColors.hoverColor,fontSize: AppConstants.headingFontSize,fontWeight: FontWeight.bold),),
  //                     ),
  //                     Visibility(
  //                         visible: true,
  //                         child:  widget.recieverId == "96" ? Column(
  //                           children: [
  //                             Container(
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(150),
  //                                 border: Border.all(color: AppColors.primaryColor),
  //                               ),
  //                               width: 50,
  //                               height: 50,
  //                               margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
  //                               child: const CircleAvatar(
  //                                   backgroundImage: NetworkImage("https://trueincrease.com/wp-content/uploads/2023/02/Aaron-Brown-Bio-Headshot-2023-300x300.jpg")),
  //                             ),
  //                             const Text(
  //                               "Aaron Brown",
  //                               overflow: TextOverflow.ellipsis,
  //                               style: TextStyle(
  //                                 fontSize: AppConstants.userActivityFontSize,color: AppColors.textWhiteColor,
  //                               ),
  //                             ),
  //                           ],
  //                         ) : Column(
  //                           children: [
  //                             Container(
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(150),
  //                                 border: Border.all(color: AppColors.primaryColor),
  //                               ),
  //                               width: 50,
  //                               height: 50,
  //                               margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
  //                               child: const CircleAvatar(
  //                                   backgroundImage: NetworkImage("https://trueincrease.com/wp-content/uploads/2023/02/Chris-Williams-Bio-Headshot-2023-300x300.jpg")),
  //                             ),
  //                             const Text(
  //                               "Chris Williams",
  //                               overflow: TextOverflow.ellipsis,
  //                               style: TextStyle(
  //                                 fontSize: AppConstants.userActivityFontSize,color: AppColors.textWhiteColor,
  //                               ),
  //                             ),
  //                           ],
  //                         )),
  //                     Expanded(
  //                       child: Container(
  //                         margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
  //                         child: const SingleChildScrollView(
  //                           scrollDirection: Axis.vertical,
  //                           child: Text("In this example, we use a Stack to layer the background or content and the two widgets. The Align widget is used to position the widgets at the top-center and top-right of the screen. You can replace the Text widgets with any other widgets or content that you want to display in those positions In this example, we use a Stack to layer the background or content and the two widgets. The Align widget is used to position the widgets at the top-center and top-right of the screen. You can replace the Text widgets with any other widgets or content that you want to display in those positions In this example, we use a Stack to layer the background or content and the two widgets. The Align widget is used to position the widgets at the top-center and top-right of the screen. You can replace the Text widgets with any other widgets or content that you want to display in those positions In this example, we use a Stack to layer the background or content and the two widgets. The Align widget is used to position the widgets at the top-center and top-right of the screen. You can replace the Text widgets with any other widgets or content that you want to display in those positions In this example, we use a Stack to layer the background or content and the two widgets. The Align widget is used to position the widgets at the top-center and top-right of the screen. You can replace the Text widgets with any other widgets or content that you want to display in those positions In this example, we use a Stack to layer the background or content and the two widgets. The Align widget is used to position the widgets at the top-center and top-right of the screen. You can replace the Text widgets with any other widgets or content that you want to display in those positions"),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //
  //                 ),
  //           ),
  //           actions: [
  //             InkWell(
  //               onTap: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: OptionMcqAnswer(
  //                 Container(
  //
  //                   alignment: Alignment.center,
  //                   child: const Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text("OK",style: TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.headingFontSize),)
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //           );
  //         }
  //       );
  //
  // }

  @override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      backgroundColor: AppColors.hoverColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared,otherUserLoggedIn,name),
      body: Stack(
        children: [
          // Container(
          //   margin: const EdgeInsets.only(top: 2),
          //   alignment: Alignment.topCenter,
          //   width: MediaQuery.of(context).size.width,
          //   // height:!isPhone ? MediaQuery.of(context).size.height/10 : MediaQuery.of(context).size.height/5,
          //   decoration: const BoxDecoration(
          //     color: AppColors.primaryColor,
          //     // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
          //   ),
          //   child: Column(
          //     children: [
          //       Stack(
          //         children: [
          //         Align(
          //           alignment: Alignment.topCenter,
          //           child: Column(
          //             children: [
          //               Container(
          //                   margin: const EdgeInsets.symmetric(vertical: 12),
          //                   child: Text(widget.itemType == "pire" ? "P.I.R.E"
          //                       : widget.itemType == "ladder" ? "Ladder"
          //                       : widget.itemType == "trellis" ? "Trellis"
          //                       : widget.itemType == "column" ? "Column" : "NAQ",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.headingFontSizeForCreation,fontWeight: FontWeight.w700,color: AppColors.hoverColor),)),
          //              widget.isPaid ? Text("Coach",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForMobile : AppConstants.userActivityCardRadius,fontWeight: FontWeight.w700,color: AppColors.hoverColor),) :  Text(widget.userName,style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForMobile : AppConstants.userActivityCardRadius,fontWeight: FontWeight.w700,color: AppColors.hoverColor),),
          //             ],
          //           )
          //         ),
          //       ],),
          //     ],
          //   ),
          // ),
          Column(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(widget.itemType == "pire" ? "P.I.R.E"
                      : widget.itemType == "ladder" ? "Ladder"
                      : widget.itemType == "trellis" ? "Trellis"
                      : widget.itemType == "column" ? "Column" : "NAQ",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.headingFontSizeForCreation,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)),
              widget.isPaid ? Text("Coach",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForMobile : AppConstants.userActivityCardRadius,fontWeight: FontWeight.w700,color: AppColors.primaryColor),) :  Text(widget.userName,style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForMobile : AppConstants.userActivityCardRadius,fontWeight: FontWeight.w700,color: AppColors.hoverColor),),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50)),
                  ),
                  child: Column(
                    children: [
                      _isLoading || _isLoading1 ?const Expanded(child:  Center(child: CircularProgressIndicator(),))
                          : isError ? Expanded(
                        child: ErrorTextAndButtonWidget(
                          errorText: errorText,onTap: (){
                          if(widget.itemType == "column") {
                            getColumnSharedItemDetails();
                          } else if(widget.itemType == "ladder" ) {
                            getLadderShareditemDetails();
                          } else {
                            getSharedItemDetails();
                          }
                        },
                        )
                      ) : Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin:  const EdgeInsets.only(left: 20,right: 20,top: 15),
                                  child: Row(

                                    children: [
                                      Text("Shared Response:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: !isPhone ? AppConstants.defaultFontSize : AppConstants.columnDetailsScreenFontSize),),
                                      const SizedBox(width: 20,),
                                    ],
                                  ),
                                ),
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
                                  child: widget.itemType == "column" ? ColumnDetailsWidget(
                                    typeText: columnReadDataModel.data!.entryType!,
                                    titleText: columnReadDataModel.data!.entryTitle!,
                                    takeAwayText: columnReadDataModel.data!.entryTakeaway!,
                                    noteText: columnReadDataModel.data!.entryDecs!,
                                    dateText: columnReadDataModel.data!.entryDate!,
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
                                  //               alignment: Alignment.centerLeft,
                                  //               child: Text(columnReadDataModel.data!.entryType!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
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
                                  //               alignment: Alignment.centerLeft,
                                  //               child: Text(columnReadDataModel.data!.entryTitle!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
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
                                  //               alignment: Alignment.centerLeft,
                                  //               child: Text(" ${DateFormat('MM-dd-yy').format(DateTime.parse(columnReadDataModel.data!.entryDate!.toString()))}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),)),
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
                                  //             alignment: Alignment.centerLeft,
                                  //             child: Text(" ${columnReadDataModel.data!.entryDecs!}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),),
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
                                  //             alignment: Alignment.centerLeft,
                                  //             child: Text(" ${columnReadDataModel.data!.entryTakeaway!}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // )
                                      : widget.itemType == "ladder" ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin:const EdgeInsets.symmetric(vertical: 3),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const  Expanded(
                                                flex:1,
                                                child: Text("Type: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                                            Expanded(
                                                flex: 2,
                                                child: Text(ladderSingleItemDetailsResponseModel.data!.type!)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:const EdgeInsets.symmetric(vertical: 3),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Expanded(
                                                flex:1,
                                                child: Text("Category: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                                            Expanded(
                                                flex: 2,
                                                child: Text(ladderSingleItemDetailsResponseModel.data!.option1!.capitalize())),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:const EdgeInsets.symmetric(vertical: 3),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Expanded(
                                                flex:1,
                                                child: Text("Date: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                                            Expanded(
                                                flex: 2,
                                                child: Text(ladderSingleItemDetailsResponseModel.data!.option2! == "Challenges" ? "" :DateFormat('MM-dd-yy').format(DateTime.parse(ladderSingleItemDetailsResponseModel.data!.date.toString())))),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:const EdgeInsets.symmetric(vertical: 3),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Expanded(
                                                flex:1,
                                                child: Text("Title: ",style: TextStyle(fontWeight: FontWeight.bold),)),

                                            Expanded(
                                                flex: 2,
                                                child: Text(ladderSingleItemDetailsResponseModel.data!.text!)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:const EdgeInsets.symmetric(vertical: 3),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Expanded(
                                                flex:1,
                                                child:  Text("Description: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                                            Expanded(
                                                flex: 2,
                                                child: Text(ladderSingleItemDetailsResponseModel.data!.description!)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ) : ListView.builder(
                                      padding:const EdgeInsets.symmetric(vertical: 5),
                                      shrinkWrap: true,
                                      itemCount:  sharedItemDetailsResponse.data!.length,
                                      physics:const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return PireNaqDetailsWidget(
                                          listIndex: index,
                                          answerText: sharedItemDetailsResponse.data![index].answer!.text!,
                                          optionText: sharedItemDetailsResponse.data![index].answer!.options!,
                                          questionText: sharedItemDetailsResponse.data![index].question!.title!,
                                        );
                                        //   Column(
                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: [
                                        //     Html(data: sharedItemDetailsResponse.data![index].question!.title,style: {
                                        //       "#" : Style(
                                        //         color: AppColors.textWhiteColor,
                                        //         fontSize: FontSize(AppConstants.defaultFontSize),
                                        //         textAlign: TextAlign.start,
                                        //
                                        //       ),
                                        //     },),
                                        //     if(sharedItemDetailsResponse.data![index].answer!.options!="")
                                        //       Row(
                                        //         children: [
                                        //           const Text("   Answer: ",style:  TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                                        //           Expanded(
                                        //             child: Html(data: sharedItemDetailsResponse.data![index].answer!.options!,style: {
                                        //               "#" : Style(
                                        //                 color: AppColors.textWhiteColor,
                                        //                 fontSize: FontSize(AppConstants.defaultFontSize),
                                        //                 textAlign: TextAlign.start,
                                        //
                                        //               ),
                                        //             },),
                                        //           ),
                                        //         ],),
                                        //     if(sharedItemDetailsResponse.data![index].answer!.text!="")
                                        //       Row(
                                        //         children: [
                                        //           const Text("   Answer: ",style:  TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                                        //           // Text(sharedItemDetailsResponse.data![index]..type == "naq" && newGardenHistoryResponseDetailsModel.data![index].options! == "yes" ? "  Why Yes:" : "   Answer: ",style:  const TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                                        //           Expanded(
                                        //             child: Html(data: sharedItemDetailsResponse.data![index].answer!.text!,style: {
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
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
          if(!otherUserLoggedIn)
          _isLoading || _isLoading1 ?  Container() : Visibility(
            visible: widget.isPaid,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(right: 5,top: 5),
                child: widget.recieverId == "96" ? Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150),
                        border: Border.all(color: AppColors.totalQuestionColor),
                      ),
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                      child: const CircleAvatar(
                          backgroundImage: NetworkImage("https://trueincrease.com/wp-content/uploads/2023/02/Aaron-Brown-Bio-Headshot-2023-300x300.jpg")),
                    ),
                    const Text(
                      "Aaron Brown",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppConstants.userActivityFontSize,color: AppColors.hoverColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ResponseFeedbackScreen(widget.recieverId,widget.itemId,widget.itemType == "pire" ? "P.I.R.E"
                            : widget.itemType == "ladder" ? "Ladder"
                            : widget.itemType == "trellis" ? "Trellis"
                            : widget.itemType == "column" ? "Column" : "NAQ")));
                      },
                      child: FadeTransition(
                        opacity: _animationController,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: AppColors.totalQuestionColor,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(sageFeedbackList.isNotEmpty ? " Feedback " : " Feedback awaiting " ,style: const TextStyle(color: AppColors.containerBorder,fontSize: AppConstants.columnDetailsScreenFontSize),),
                        ),
                      ),
                    ),
                  ],
                ) : Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150),
                        border: Border.all(color: AppColors.totalQuestionColor),
                      ),
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                      child: const CircleAvatar(
                          backgroundImage: NetworkImage("https://trueincrease.com/wp-content/uploads/2023/02/Chris-Williams-Bio-Headshot-2023-300x300.jpg")),
                    ),
                    const Text(
                      "Chris Williams",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppConstants.userActivityFontSize,color: AppColors.hoverColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ResponseFeedbackScreen(widget.recieverId,widget.itemId,widget.itemType == "pire" ? "P.I.R.E"
                            : widget.itemType == "ladder" ? "Ladder"
                            : widget.itemType == "trellis" ? "Trellis"
                            : widget.itemType == "column" ? "Column" : "NAQ")));
                      },
                      child: FadeTransition(
                        opacity: _animationController,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: AppColors.totalQuestionColor,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child:  Text(sageFeedbackList.isNotEmpty ? " Feedback " : " Feedback awaiting ",style: const TextStyle(color: AppColors.containerBorder,fontSize: AppConstants.columnDetailsScreenFontSize),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),

    );
  }
}
