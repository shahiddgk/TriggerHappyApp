// ignore_for_file: unused_field, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/model/request_model/Sage%20Request/sage_feedback_list_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/reponse_model/Sage/sage_feedback_list_model.dart';
import '../../model/request_model/Sage Request/sage_feedback_add_request.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../utill/userConstants.dart';

class ResponseFeedbackScreen extends StatefulWidget {
  ResponseFeedbackScreen(this.recieverId,this.sharedItemId,this.sharedItemType,{Key? key}) : super(key: key);

  String recieverId;
  String sharedItemId;
  String sharedItemType;

  @override
  State<ResponseFeedbackScreen> createState() => _ResponseFeedbackScreenState();
}

class _ResponseFeedbackScreenState extends State<ResponseFeedbackScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isLoading = true;
  bool _isQuestionSendingLoading = false;

  bool _isError = false;
  String isError = "";

  String email = "";
  String timeZone = "";
  String userType = "";
  int badgeCountShared = 0;
  int badgeCount1 = 0;

  List<SageFeedback> sageFeedbackList = <SageFeedback>[];

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;

  final TextEditingController _textcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
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

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    getFeedbackList();

    setState(() {
      _isUserDataLoading = false;
    });
  }

  getFeedbackList() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().getSageFeedbackList(SageFeedbackRequestModel(sharedId: widget.sharedItemId,)).then((value) {

      setState(() {

        sageFeedbackList = value.sageFeedback!;
        // sageFeedbackList = sageFeedbackList.reversed.toList();
        sageFeedbackList.sort((a,b) => b.createdAt!.compareTo(a.createdAt.toString()));

        _isLoading = false;
        _isError = false;
        isError = "";
      });

    }).catchError((e) {

      setState(() {
        isError = e.toString();
        _isLoading = false;
        _isError = true;
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

  @override
  Widget build(BuildContext context) {
    getScreenDetails();

    return Scaffold(
      appBar: AppBarWidget().appBarGeneralButtons(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            _isLoading ? const Center(child: CircularProgressIndicator(),) : Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20) ,bottomRight: Radius.circular(20))
                  ),
                  margin: const EdgeInsets.only(bottom: 5,top: 1),
                  child: widget.recieverId == "96" ? Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150),
                          border: Border.all(color: AppColors.totalQuestionColor),
                        ),
                        width: 45,
                        height: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        child: const CircleAvatar(
                            backgroundImage: NetworkImage("https://trueincrease.com/wp-content/uploads/2023/02/Aaron-Brown-Bio-Headshot-2023-300x300.jpg")),
                      ),
                       Container(
                         margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                         alignment: Alignment.center,
                         child: const Text(
                           "Aaron Brown",
                           overflow: TextOverflow.ellipsis,
                           style: TextStyle(
                             fontSize: AppConstants.headingFontSizeForEntriesAndSession,color: AppColors.hoverColor,
                           ),
                         ),
                       ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                        alignment: Alignment.center,
                        child: Text(
                          "(${widget.sharedItemType})",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: AppConstants.headingFontSizeForEntriesAndSession,color: AppColors.hoverColor,
                          ),
                        ),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(150),
                      //     border: Border.all(color: AppColors.totalQuestionColor),
                      //   ),
                      //   width: 50,
                      //   height: 50,
                      //   margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      //   child: const CircleAvatar(
                      //       backgroundImage: NetworkImage("https://trueincrease.com/wp-content/uploads/2023/02/Aaron-Brown-Bio-Headshot-2023-300x300.jpg")),
                      // ),
                    ],
                  ) : Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150),
                          border: Border.all(color: AppColors.totalQuestionColor),
                        ),
                        width: 45,
                        height: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        child: const CircleAvatar(
                            backgroundImage: NetworkImage("https://trueincrease.com/wp-content/uploads/2023/02/Chris-Williams-Bio-Headshot-2023-300x300.jpg")),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        alignment: Alignment.center,
                        child: const Text(
                          "Chris Williams",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppConstants.headingFontSizeForEntriesAndSession,color: AppColors.hoverColor,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                        alignment: Alignment.center,
                        child: Text(
                          "(${widget.sharedItemType})",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: AppConstants.headingFontSizeForEntriesAndSession,color: AppColors.hoverColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: sageFeedbackList.isEmpty ?const Center(
                        child: Text("No Feedback yet"),
                      ) : ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          itemCount: sageFeedbackList.length,
                          itemBuilder: (context,index) {
                            final isSentByMe = sageFeedbackList[index].senderId == id;
                            // DateTime dateTime = DateTime.parse(sageFeedbackList[index].createdAt!);
                            // String formattedTime = DateFormat.jm().format(dateTime);

                            return Align(
                              alignment: isSentByMe ? Alignment.topRight : Alignment.topLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isSentByMe ? AppColors.primaryColor : AppColors.highlightColor,
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          sageFeedbackList[index].message!,
                                          style: const TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.userActivityFontSize),
                                        ),
                                      ),
                                      // const SizedBox(height: 3,),
                                      // Align(
                                      //   alignment: Alignment.bottomRight,
                                      //   child: Text(
                                      //     formattedTime,
                                      //     style:const TextStyle(fontSize:AppConstants.defaultFontSizeForWeekDays,color: AppColors.backgroundColor),
                                      //   ),
                                      // )
                                    ],
                                  )
                              ),
                            );
                            //     : ChatBubble(
                            //   clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                            //   backGroundColor: AppColors.highlightColor,
                            //   margin: const EdgeInsets.only(top: 20),
                            //   child: Container(
                            //     padding: const EdgeInsets.only(left: 5),
                            //     constraints: BoxConstraints(
                            //       maxWidth: MediaQuery.of(context).size.width * 0.7,
                            //     ),
                            //     child:  Column(
                            //       children: [
                            //         Align(
                            //           alignment: Alignment.centerLeft,
                            //           child: Text(
                            //             sageFeedbackList[index].message!,
                            //             style:const TextStyle(color: AppColors.textWhiteColor),
                            //           ),
                            //         ),
                            //         // const SizedBox(height: 3,),
                            //         // Align(
                            //         //   alignment: Alignment.bottomRight,
                            //         //   child: Text(
                            //         //     formattedTime,
                            //         //     style:const TextStyle(fontSize:AppConstants.defaultFontSizeForWeekDays,color: AppColors.textWhiteColor),
                            //         //   ),
                            //         // )
                            //       ],
                            //     )
                            //   ),
                            // );

                          }),
                    )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3,vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child:ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 150.0,
                          ),
                          child: TextFormField(
                            controller: _textcontroller,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration:  InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                              focusColor:  AppColors.primaryColor,
                              border: OutlineInputBorder(
                                borderSide:  const BorderSide(
                                    color: AppColors.primaryColor
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  const BorderSide(
                                    color: AppColors.primaryColor
                                ),
                                borderRadius:  BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintText: 'Enter you question here..',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      MaterialButton(
                        onPressed: (){

                          if(sageFeedbackList.length >= 5) {
                            showToastMessage(context,
                                "You can't ask questions anymore",
                                false);
                          } else {
                            if (_textcontroller.text.isNotEmpty) {
                              if (sageFeedbackList.isNotEmpty) {
                                if (sageFeedbackList[0].senderId != id) {
                                  sendQuestionOnFeedback();
                                } else {
                                  showToastMessage(context,
                                      "Please wait for coach's feedback...",
                                      false);
                                }
                              } else {
                                showToastMessage(context,
                                    "Please wait for coach's feedback...",
                                    false);
                              }
                            } else {
                              showToastMessage(
                                  context, "Enter your question please...",
                                  false);
                            }
                          }
                        },
                        shape: const CircleBorder(),
                        minWidth: 0,
                        padding: const EdgeInsets.all(10),
                        color: AppColors.primaryColor,
                        child: Icon( sageFeedbackList.length >= 5 ? Icons.lock : sageFeedbackList.isEmpty ? Icons.lock : sageFeedbackList[0].senderId == id ? Icons.lock : Icons.send,color: Colors.white,size: 28,),),

                    ],
                  ),
                ),
                SizedBox(height: Platform.isAndroid ? 8 : 15,),
              ],
            ),
            if(_isQuestionSendingLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        )
      ),
    );
  }

  sendQuestionOnFeedback() {
    setState(() {
      _isQuestionSendingLoading = true;
    });
    HTTPManager().addSageFeedback(SageFeedbackAddRequest(shareId: widget.sharedItemId,senderId: id,recieverId: widget.recieverId,message: _textcontroller.text,)).then((value) {
      setState(() {

        SageFeedback sageFeedback = value;

        sageFeedbackList.insert(0, sageFeedback);

        _textcontroller.clear();
        _textcontroller.text == "";

        _isQuestionSendingLoading = false;
      });
      showToastMessage(context, "Question sent successfully", true);

    }).catchError((e) {

      setState(() {
        _isQuestionSendingLoading = false;
      });

    });
  }
}
