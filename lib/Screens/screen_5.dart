import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/change_password.dart';
import 'package:flutter_quiz_app/Screens/login_screen.dart';
import 'package:flutter_quiz_app/Screens/screen_15.dart';
import 'package:flutter_quiz_app/Screens/screen_6.dart';
import 'package:flutter_quiz_app/Widgets/answer_field_widget.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/answer_reques_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen5 extends StatefulWidget {
   Screen5(this.questionListResponse,this.index,this.screen,{Key? key}) : super(key: key);

 // String question;
  int screen;
  int index;
   List<QuestionListResponseModel> questionListResponse;

  @override
  _Screen5State createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {

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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LogoScreen(),
              Align(
                  alignment: Alignment.topLeft,
                  child: QuestionTextWidget(widget.questionListResponse[widget.index].title)),
              AnswerFieldWidget(_fieldController,int.parse(widget.questionListResponse[widget.index].textLength.toString())),
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
        // widget.answersList.add({
        //   widget.questionListResponse[widget.index].id: selectedAnswer
        // });
      });
      HTTPManager().userAnswer(AnswerRequestModel(questionId:widget.questionListResponse[widget.index].id.toString(),options: "[]", userId: id,text: text )).then((value) {
        print("Answer Response");
        print(value);

        if(widget.screen == 6) {
          // setState(() {
          //   selectedAnswer.add(text);
          //   // widget.answersList.add({
          //   //   widget.questionListResponse[widget.index].id: selectedAnswer
          //   // });
          // });
          // print(widget.answersList);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Screen6(widget.questionListResponse)));
        } else if(widget.screen == 12) {
          // setState(() {
          //   selectedAnswer.add(text);
          //   // widget.answersList.add({
          //   //   widget.questionListResponse[widget.index].id: selectedAnswer
          //   // });
          // });
          print(widget.screen);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen5(widget.questionListResponse,9,13)));
        } else if(widget.screen ==13) {
          // setState(() {
          //   selectedAnswer.add(text);
          //   // widget.answersList.add({
          //   //   widget.questionListResponse[widget.index].id: selectedAnswer
          //   // });
          // });
          print(widget.screen);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen15(widget.questionListResponse)));
        } else if(widget.screen ==14) {
          // setState(() {
          //   selectedAnswer.add(text);
          //   // widget.answersList.add({
          //   //   widget.questionListResponse[widget.index].id: selectedAnswer
          //   // });
          // });
          print(widget.screen);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen15(widget.questionListResponse)));
        } else {
          // setState(() {
          //   selectedAnswer.add(text);
          //   // widget.answersList.add({
          //   //   widget.questionListResponse[widget.index].id: selectedAnswer
          //   // });
          // });
          print(widget.screen);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen15(widget.questionListResponse)));
        }

      }).catchError((e){
        print(e);
      });
    }
  }
}
