import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/login_screen.dart';
import 'package:flutter_quiz_app/Screens/screen_8.dart';
import 'package:flutter_quiz_app/Widgets/check_box_widget.dart';
import 'package:flutter_quiz_app/Widgets/circular_button_widget.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/answer_reques_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_password.dart';

class Screen7 extends StatefulWidget {
   Screen7(this.questionListResponse,{Key? key}) : super(key: key);

  List<QuestionListResponseModel> questionListResponse;

  @override
  _Screen7State createState() => _Screen7State();
}

class _Screen7State extends State<Screen7> {

  List selectedAnswer = [];
  String _groupValue ="";

  String name = "";
  String id = "";
  String answerNo5 = "";
  String answerText5 = "";
  bool _isUserDataLoading = true;
  bool _isAnswerDataLoading = true;
  bool _isDataLoading = true;
  bool isAnswerLoading = false;
  List answersList = [];
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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

  setListOptions() {
    setState(() {
      _isDataLoading = true;
    });
    for(int i = 0;i<widget.questionListResponse[4].options.length;i++) {
      answersList.add({
        "answer": widget.questionListResponse[4].options[i],
        "selected": false,
      });
    }
    setState(() {
      print(answersList);
      _isDataLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
    _getAnswerData();
    setListOptions();
  }

  _getAnswerData() async {
    setState(() {
      _isAnswerDataLoading = true;
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      answerNo5 = _sharedPreferences.getString("answerNo4")!;
      answerText5 = _sharedPreferences.getString("answerText4")!;
      _isAnswerDataLoading = false;
    });

  }

  setAnswerText() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _sharedPreferences.setString("answerNo4", "4");
    _sharedPreferences.setString("answerText4", selectedAnswer.toString());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
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
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
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
                      LogoScreen(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            padding: EdgeInsets.only(top: 1),
                            width: MediaQuery.of(context).size.width,
                            child: QuestionTextWidget(widget.questionListResponse[4].title)),
                      ),
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Container(
                      //       padding: EdgeInsets.only(top: 1),
                      //       width: MediaQuery.of(context).size.width,
                      //       child: QuestionTextWidget(widget.questionListResponse[4].subTitle)),
                      // ),

                      !_isDataLoading ?  Container(
                        height: MediaQuery.of(context).size.height/1.58,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.count(
                          padding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                          crossAxisCount: ResponsiveWrapper.of(context).isMobile || ResponsiveWrapper.of(context).isPhone ? 3 : 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 2.0,
                          childAspectRatio: itemHeight/itemWidth,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: List.generate(answersList.length, (index) {
                            return OptionMcqAnswer(
                              RadioListTile<String>(
                                tileColor: AppColors.textWhiteColor,
                                activeColor: AppColors.PrimaryColor,
                                value: widget.questionListResponse[4].options[index],
                                title: Text(widget.questionListResponse[4].options[index],style: TextStyle(color: AppColors.textWhiteColor)),
                                groupValue: _groupValue,
                                onChanged:  (newValue) {
                                  selectedAnswer.clear();
                                  setState(() {
                                    selectedAnswer.add(widget.questionListResponse[4].options[index]);

                                    _groupValue = newValue.toString();
                                  });
                                },
                              ),);
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
    print(selectedAnswer);
  }

  void removeAnswerFromList(answerSelect) {
    if(selectedAnswer.isNotEmpty) {
      for(int i =0; i<selectedAnswer.length; i++) {
        if(selectedAnswer[i] == answerSelect) {
          selectedAnswer.removeAt(i);
        }
      }
      print(selectedAnswer);
    }
  }

  void _submitAnswer() {

    print(selectedAnswer);

    if(selectedAnswer.isNotEmpty) {
      setState(() {
        isAnswerLoading = true;
      });
      // answersList.add({
      //   questionListResponse[0].id: selectedAnswer
      // });
      HTTPManager().userAnswer(AnswerRequestModel(questionId:widget.questionListResponse[4].id.toString(),options: selectedAnswer.toString(), userId: id,text: "" )).then((value) {
        print("Answer Response");
        print(value);
        setState(() {
          isAnswerLoading = false;
        });
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Screen8(widget.questionListResponse)));

      }).catchError((e){
        setState(() {
          isAnswerLoading = false;
        });
        print(e);
      });
      //print(answersList);
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
      //     Screen4(questionListResponse, answersList)));
    } else {
      showToast(
          "Please select any option", shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
          context: context,
          fullWidth: true,
          isHideKeyboard: true,
          alignment: Alignment.topCenter,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red
      );
    }
  }
}
