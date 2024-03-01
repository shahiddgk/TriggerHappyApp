// ignore_for_file: file_names, unused_local_variable, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_11.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_5.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../Widgets/toast_message.dart';
import '../utill/userConstants.dart';

// ignore: must_be_immutable
class Screen10 extends StatefulWidget {

  List<QuestionListResponseModel> questionListResponse;

   Screen10(this.questionListResponse,{Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Screen10State createState() => _Screen10State();
}

class _Screen10State extends State<Screen10> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool isAnswerLoading = false;
  List selectedAnswer = [];
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late Timer _timer;
  int _start = 30;
  int badgeCountShared = 0;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    _getUserData();
    startTimer();
    // TODO: implement initState
    super.initState();
  }

  String email = "";
  String timeZone = "";
  String userType = "";
  int badgeCount1= 0;

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // ignore: avoid_print
    print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget().appBarGeneralButtons(
          context,
              () {
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
            //         (Route<dynamic> route) => false
            // );
          }, true, true, true, id, false,true,badgeCount1,false,badgeCountShared),
      bottomNavigationBar: GestureDetector(
        // onTap: () {
        //
        // },
        child: Container(
            color: AppColors.backgroundColor,
            child: PriviousNextButtonWidget((){
              if(_start == 0) {
                // print(widget.answersList);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Screen5(
                        widget.questionListResponse,8,
                        12)));
              } else {
                showToastMessage(context, "Wait for timer to complete",false);
              }
            },(){
              Navigator.of(context).pop();
            },true)
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: IgnorePointer(
              ignoring: isAnswerLoading,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text("QUESTION 1 OF 24",style: TextStyle(color: Colors.deepOrangeAccent),),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LogoScreen("PIRE"),

                      Align(
                          alignment: Alignment.topLeft,
                          child: QuestionTextWidget(widget.questionListResponse[7].title,widget.questionListResponse[7].videoUrl,(){},false)),

                      // Align(
                      //     alignment: Alignment.topLeft,
                      //     child: QuestionTextWidget(widget.questionListResponse[7].subTitle)),

                      Container(
                        height: MediaQuery.of(context).size.height/2,
                        width: MediaQuery.of(context).size.width/2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryColor,width: 5),
                          // borderRadius: BorderRadius.circular(100),
                        ),
                        child: _start == 0 ?const Text("Well done!",style: TextStyle(fontSize: 25,color: AppColors.textWhiteColor),) :Text("$_start",style: const TextStyle(fontSize: 25,color: AppColors.textWhiteColor),),
                      )

                    //  AnswerFiedlWithPrefixText(_fieldController1,"I am not sure "),
                    ],
                  ),
                  // Align(alignment: Alignment.bottomCenter,
                  //   child: Align(
                  //       alignment: Alignment.bottomCenter,
                  //       child: PriviousNextButtonWidget((){
                  //         _submitAnswer(_fieldController.text);
                  //       })
                  //   ),)
                  Align(alignment: Alignment.center,
                    child: isAnswerLoading ? const CircularProgressIndicator(): Container(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  void _submitAnswer(String text) {
    selectedAnswer.clear();
    if(_formKey.currentState!.validate()) {
      setState(() {
        selectedAnswer.add(text);
      });
      // HTTPManager().userAnswer(AnswerRequestModel(questionId:widget.questionListResponse[7].id.toString(),options: "[]", userId: id,text: text )).then((value) {
      //   print("Answer Response");
      //   print(value);

        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen11(widget.questionListResponse)));

      // }).catchError((e){
      //   print(e);
      // });
      //print(widget.answersList);

    }
  }
}
