
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_7.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/constants.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/question_state_prefrence.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/constants.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../../model/reponse_model/question_answer_response_model.dart';
import '../Widgets/toast_message.dart';
import '../utill/userConstants.dart';

// ignore: must_be_immutable
class Screen6 extends StatefulWidget {

  List<QuestionListResponseModel> questionListResponse;

   Screen6(this.questionListResponse,{Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Screen6State createState() => _Screen6State();
}

class _Screen6State extends State<Screen6> {

  List<String> selectedAnswer = [];
  String name = "";
  String id = "";
  String answerNo4 = "";
  String answerText4 = "";
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
    for(int i = 0;i<widget.questionListResponse[3].options.length;i++) {
      answersList.add({
        "answer": widget.questionListResponse[3].options[i],
        "selected":"0",
      });
    }
    setState(() {
      answersList.sort((a, b)=>a['answer'].compareTo(b['answer']));
     // print(answersList);
      _isDataLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setListOptions();
   // _getAnswerData();
    _getUserData();

  }


  setAnswerText() async {

    //print("Calling question Submission");
    QuestionStatePrefrence().setAnswerText(
        PireConstants.questionFourId, widget.questionListResponse[3].id.toString(),
        PireConstants.questionFourText, selectedAnswer,
        PireConstants.questionFourType, widget.questionListResponse[3].responseType.toString()
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
      appBar:  _isUserDataLoading ? AppBarWidget().appBar(false,false,"","",false) : AppBarWidget().appBar(false,false,name,id,false),
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
          physics: const NeverScrollableScrollPhysics(),
          //scrollDirection: Axis.vertical,
          child: Stack(
            alignment: Alignment.center,
         //   ignoring: isAnswerLoading,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LogoScreen("PIRE"),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            child: QuestionTextWidget(widget.questionListResponse[3].title,widget.questionListResponse[3].videoUrl,(){
                              String urlQ1 = "https://www.youtube.com/watch?v=G4UOqUucvXc&t=16s";
                              String? videoId = YoutubePlayer.convertUrlToId(urlQ1);
                              YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                                  initialVideoId: videoId!,
                                  flags: const YoutubePlayerFlags(
                                    autoPlay: false,
                                    controlsVisibleAtStart: false,
                                  )

                              );
                              videoPopupDialog(context, "Introduction to question#1", youtubePlayerController);
                            },true)),
                      ),

                      !_isDataLoading ? Container(
                        height: MediaQuery.of(context).size.height/1.66,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height,top: 5),
                        child: GridView.count(
                          padding: EdgeInsets.only(bottom:MediaQuery.of(context).size.height/13,left: 10,right: 10),
                          crossAxisCount: !isPhone ? 5 : 3,
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
                              child: OptionMcqAnswer(Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: ( Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex:1,
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 7),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: AppColors.primaryColor,width: 2)
                                        ),
                                        alignment: Alignment.center,
                                        height: 20,
                                        width: 20,
                                        child:answersList[index]["selected"] == "0" ? const Text("") : Text(
                                            answersList[index]["selected"],
                                            style: const TextStyle(color: AppColors.textWhiteColor,fontWeight: FontWeight.bold,fontSize: AppConstants.defaultFontSize)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                            answersList[index]['answer'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.defaultFontSize)),
                                      ),
                                    ),
                                  ],
                                )),
                              )),
                            );


                          }),
                        ),
                      ) : Container(),

                    ],
                  ),
                ],
              ),
              Align(alignment: Alignment.center,
                child: isAnswerLoading ? const CircularProgressIndicator(): Container(),
              )
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
      //print(selectedAnswer);
    }
  }

  void _submitAnswer() {
   // print(selectedAnswer);

    if(selectedAnswer.isNotEmpty) {
      // if(selectedAnswer.length<3) {
      //   showToastMessage(context, "Please select 3 options",false);
      // } else {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => Screen7(widget.questionListResponse)));
    //  }
    } else {
      showToastMessage(context, "Please select any option",false);
    }
  }
}
