import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/login_screen.dart';
import 'package:flutter_quiz_app/Screens/screen_11.dart';
import 'package:flutter_quiz_app/Screens/screen_5.dart';
import 'package:flutter_quiz_app/Widgets/answer_field_widget.dart';
import 'package:flutter_quiz_app/Widgets/answer_field_with_prefix_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/answer_reques_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/colors.dart';
import 'change_password.dart';

class Screen10 extends StatefulWidget {

  List<QuestionListResponseModel> questionListResponse;

   Screen10(this.questionListResponse,{Key? key}) : super(key: key);

  @override
  _Screen10State createState() => _Screen10State();
}

class _Screen10State extends State<Screen10> {
  TextEditingController _fieldController = TextEditingController();
  TextEditingController _fieldController1 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  List selectedAnswer = [];
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
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

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = _sharedPreferences.getString("username")!;
      id = _sharedPreferences.getString("userid")!;
      _isUserDataLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(!_isUserDataLoading ? name:""),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChangePassword()));
          }, icon: Icon(Icons.person,color: AppColors.textWhiteColor,)),
          IconButton(onPressed: () async {
            SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
            setState(() {
              _sharedPreferences.setBool("user_logged_in",false);
              googleSignIn.signOut();
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false
            );
          }, icon: Icon(Icons.logout,color: AppColors.textWhiteColor,))
        ],
      ),
      bottomNavigationBar: Container(
          color: AppColors.backgroundColor,
          child: PriviousNextButtonWidget((){
            if(_start == 0) {
              // print(widget.answersList);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Screen5(
                      widget.questionListResponse,8,
                      12)));
            } else {
              showToast(
                  "Wait for timer to complete", shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),
                  context: context,
                  fullWidth: true,
                  alignment: Alignment.topCenter,
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red
              );
            }
          },(){
            Navigator.of(context).pop();
          },true)
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text("QUESTION 1 OF 24",style: TextStyle(color: Colors.deepOrangeAccent),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LogoScreen(),

                    Align(
                        alignment: Alignment.topLeft,
                        child: QuestionTextWidget(widget.questionListResponse[7].title)),

                    // Align(
                    //     alignment: Alignment.topLeft,
                    //     child: QuestionTextWidget(widget.questionListResponse[7].subTitle)),

                    Container(
                      height: MediaQuery.of(context).size.height/2,
                      width: MediaQuery.of(context).size.width/2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.PrimaryColor,width: 5),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitAnswer(String text) {
    selectedAnswer.clear();
    if(_formKey.currentState!.validate()) {
      setState(() {
        selectedAnswer.add(text);
      });
      HTTPManager().userAnswer(AnswerRequestModel(questionId:widget.questionListResponse[7].id.toString(),options: "[]", userId: id,text: text )).then((value) {
        print("Answer Response");
        print(value);

        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen11(widget.questionListResponse)));

      }).catchError((e){
        print(e);
      });
      //print(widget.answersList);

    }
  }
}
