import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Screen_10.dart';
import 'package:flutter_quiz_app/Screens/change_password.dart';
import 'package:flutter_quiz_app/Screens/login_screen.dart';
import 'package:flutter_quiz_app/Widgets/answer_field_widget.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/request_model/answer_reques_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/colors.dart';
import '../model/reponse_model/question_answer_response_model.dart';

class Screen9 extends StatefulWidget {

  List<QuestionListResponseModel> questionListResponse;

  Screen9(this.questionListResponse,{Key? key}) : super(key: key);

  @override
  _Screen9State createState() => _Screen9State();
}

class _Screen9State extends State<Screen9> {
  TextEditingController _fieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  List selectedAnswer = [];
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    _getUserData();
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
          _submitAnswer(_fieldController.text);
        },(){

          // widget.answersList.removeAt(widget.answersList.length-1);
          // print(widget.answersList);
          Navigator.of(context).pop();

        },true),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor,
        child: Form(
          key: _formKey,
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
                      child: QuestionTextWidget(widget.questionListResponse[6].title)),
                  // Align(
                  //     alignment: Alignment.topLeft,
                  //     child: QuestionTextWidget(widget.questionListResponse[6].subTitle)),

                  AnswerFieldWidget(_fieldController,int.parse(widget.questionListResponse[6].textLength.toString())),
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
    );
  }

  void _submitAnswer(String text) {
    selectedAnswer.clear();
    if(_formKey.currentState!.validate()) {
      setState(() {
        selectedAnswer.add(text);
      });
      HTTPManager().userAnswer(AnswerRequestModel(questionId:widget.questionListResponse[6].id.toString(),options: "[]", userId: id,text: text )).then((value) {
        print("Answer Response");
        print(value);

        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen10(widget.questionListResponse)));

      }).catchError((e){
        print(e);
      });
      //print(widget.answersList);

    }
  }

  // void _submitAnswer(String text) {
  //   selectedAnswer.clear();
  //   if(_formKey.currentState!.validate()) {
  //     setState(() {
  //       selectedAnswer.add(text);
  //       // widget.answersList.add({
  //       //   widget.questionListResponse[6].id: selectedAnswer
  //       // });
  //     });
  //
  //  //   print(widget.answersList);
  //
  //
  //   }
  // }
}
