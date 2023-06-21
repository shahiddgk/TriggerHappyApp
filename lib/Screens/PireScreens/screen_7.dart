
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_8.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/constants.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/question_state_prefrence.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/constants.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../Widgets/toast_message.dart';
import '../utill/userConstants.dart';


// ignore: must_be_immutable
class Screen7 extends StatefulWidget {
   Screen7(this.questionListResponse,{Key? key}) : super(key: key);

  List<QuestionListResponseModel> questionListResponse;

  @override
  // ignore: library_private_types_in_public_api
  _Screen7State createState() => _Screen7State();
}

class _Screen7State extends State<Screen7> {

  List <String> selectedAnswer = [];
  // ignore: unused_field
  final String _groupValue ="";

  String name = "";
  String id = "";
  String answerNo5 = "";
  String answerText5 = "";
  bool _isUserDataLoading = true;
  bool _isDataLoading = true;
  bool isAnswerLoading = false;
  List answersList = [];
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String a1 = "0";
  String email = "";
  String timeZone = "";
  String userType = "";
  late bool isPhone;

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    //print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  setListOptions() {
    setState(() {
      _isDataLoading = true;
    });
    for(int i = 0;i<widget.questionListResponse[4].options.length;i++) {
      answersList.add({
        "answer": widget.questionListResponse[4].options[i],
        "selected": "0",
      });
    }
    // setState(() {
    //   answersList.sort((a, b)=>a['answer'].compareTo(b['answer']));
    //   print(answersList);
      _isDataLoading = false;
    //});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
  //  _getAnswerData();
    setListOptions();
  }


  setAnswerText() async {

    //print("Calling question Submission");
    QuestionStatePrefrence().setAnswerText(
        PireConstants.questionFiveId, widget.questionListResponse[4].id.toString(),
        PireConstants.questionFiveText, selectedAnswer,
        PireConstants.questionFiveType, widget.questionListResponse[4].responseType.toString()
    );

  }

  getScreenDetails() {
    setState(() {
      _isDataLoading = true;
    });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    setState(() {
      _isDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    getScreenDetails();
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _isUserDataLoading ? AppBarWidget().appBar(context,false,false,"","",false) : AppBarWidget().appBar(context,false,false,name,id,false),
      bottomNavigationBar: GestureDetector(
        // onTap: () {
        //   setAnswerText();
        //   _submitAnswer();
        // },
        child: Container(
          height: MediaQuery.of(context).size.height/10,
          width: MediaQuery.of(context).size.width,
          color: AppColors.backgroundColor,
          child: Align(
              alignment: Alignment.bottomCenter,
              child: PriviousNextButtonWidget((){
                setAnswerText();
              _submitAnswer();
              },(){

                // widget.answersList.removeAt(widget.answersList.length-1);
                // print(widget.answersList);
                Navigator.of(context).pop();

              },true)
          ),
        ),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
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
                      LogoScreen("PIRE"),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            padding: const EdgeInsets.only(top: 1),
                            width: MediaQuery.of(context).size.width,
                            child: QuestionTextWidget(widget.questionListResponse[4].title,widget.questionListResponse[4].videoUrl,(){
                              String urlQ7 = "https://www.youtube.com/watch?v=s59egGceFMA";
                              String? videoId = YoutubePlayer.convertUrlToId(urlQ7);
                              YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                                  initialVideoId: videoId!,
                                  flags: const YoutubePlayerFlags(
                                    autoPlay: false,
                                    controlsVisibleAtStart: false,
                                  )

                              );
                              videoPopupDialog(context, "Introduction to question#7", youtubePlayerController);
                            },true)),
                      ),
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Container(
                      //       padding: EdgeInsets.only(top: 1),
                      //       width: MediaQuery.of(context).size.width,
                      //       child: QuestionTextWidget(widget.questionListResponse[4].subTitle)),
                      // ),

                      !_isDataLoading ?  Container(
                        height: MediaQuery.of(context).size.height/1.66,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height,top: 5),
                        child: GridView.count(
                          padding: EdgeInsets.only(bottom:MediaQuery.of(context).size.height/13,left: 10,right: 10),
                          crossAxisCount: !isPhone ? 5 : 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 2.0,
                          childAspectRatio: itemHeight/itemWidth,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: List.generate(answersList.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                // print("item Clicked");
                                // print(a1);

                                if(answersList[index]["selected"] == "0") {

                                  if(a1 == "0" && selectedAnswer.length < 3) {
                                    setState(() {
                                      a1 = "1";
                                    });
                                    answersList[index]["selected"] = "1";
                                    addAnswersToList(answersList[index]['answer']);

                                  } else if(a1 == "1" && selectedAnswer.length < 3) {
                                    setState(() {
                                      a1 = "2";
                                    });
                                    answersList[index]["selected"] = "2";
                                    addAnswersToList(answersList[index]['answer']);
                                  } else if(a1 == "2" && selectedAnswer.length < 3) {
                                    setState(() {
                                      a1 = "3";
                                    });
                                    answersList[index]["selected"] = "3";
                                    addAnswersToList(answersList[index]['answer']);
                                  } else {
                                    for(int i = 0 ; i<answersList.length; i++) {
                                      setState(() {
                                        a1 = "0";
                                        answersList[i]['selected'] = "0";
                                        selectedAnswer.clear();
                                      });
                                    }
                                  }

                                } else {

                                  if(answersList[index]['selected'] == "1") {
                                    setState(() {
                                      a1 = "0";
                                      answersList[index]['selected'] = "0";
                                      removeAnswerFromList(answersList[index]['answer']);
                                    });

                                  } else if(answersList[index]['selected'] == "2") {
                                    setState(() {
                                      a1 = "1";
                                      answersList[index]['selected'] = "0";
                                      removeAnswerFromList(answersList[index]['answer']);
                                    });

                                  } else if(answersList[index]['selected'] == "3") {
                                    setState(() {
                                      a1 = "2";

                                      answersList[index]['selected'] = "0";
                                      removeAnswerFromList(answersList[index]['answer']);
                                    });
                                  }
                                }

                              },
                              child: OptionMcqAnswer(( Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.primaryColor,width: 2)
                                    ),
                                    alignment: Alignment.center,
                                    height: 20,
                                    width: 20,
                                    child:answersList[index]["selected"] == "0" ? const Text("") : Text(answersList[index]["selected"],style: const TextStyle(color: AppColors.textWhiteColor,fontWeight: FontWeight.bold,fontSize: AppConstants.defaultFontSize)),
                                  ),
                                  Text(answersList[index]['answer'],style: const TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.defaultFontSize)),
                                ],
                              ))),
                            );
                          }),
                        ),
                      ) : Container(),

                    ],
                  ),
                  Align(alignment: Alignment.center,
                    child: isAnswerLoading ? const CircularProgressIndicator(): Container(),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  void addAnswersToList(answerSelect) {
    selectedAnswer.add(answerSelect);
   // print(selectedAnswer);
  }

  void removeAnswerFromList(answerSelect) {
    if(selectedAnswer.isNotEmpty) {
      for(int i =0; i<selectedAnswer.length; i++) {
        if(selectedAnswer[i] == answerSelect) {
          selectedAnswer.removeAt(i);
        }
      }
     // print(selectedAnswer);
    }
  }

  void _submitAnswer() {

  //  print(selectedAnswer);

    if(selectedAnswer.isNotEmpty) {
      // if(selectedAnswer.length<3) {
      //   showToastMessage(context, "Please select 3 options",false);
      // } else {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => Screen8(widget.questionListResponse)));
   //   }

    } else {
      showToastMessage(context, "Please select any option",false);
    }
  }
}
