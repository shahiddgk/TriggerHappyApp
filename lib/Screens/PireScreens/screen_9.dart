import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/constants.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/question_state_prefrence.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/PopMenuButton.dart';
import 'package:flutter_quiz_app/Widgets/answer_field_widget.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../model/reponse_model/question_answer_response_model.dart';
import '../AuthScreens/login_screen.dart';
import '../utill/userConstants.dart';
import 'Screen_10.dart';

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
  String answerNo7 = "";
  String answerText7 = "";
  bool _isUserDataLoading = true;
  bool _isAnswerDataLoading = true;
  bool isAnswerLoading = false;
  List<String> selectedAnswer = [];
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    _getUserData();
  //  _getAnswerData();
    // TODO: implement initState
    super.initState();
  }

  _getAnswerData() async {
    setState(() {
      _isAnswerDataLoading = true;
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      answerNo7 = _sharedPreferences.getString("answerType9")!;
      answerText7 = _sharedPreferences.getString("answerText9")!;
      _isAnswerDataLoading = false;
    });

  }

  setAnswerText() async {

    QuestionStatePrefrence().setAnswerText(
        PireConstants.questionSevenId, widget.questionListResponse[6].id.toString(),
        PireConstants.questionSevenText, selectedAnswer,
        PireConstants.questionSevenType, widget.questionListResponse[6].responseType.toString()
    );

  }

  String email = "";
  String timeZone = "";
  String userType = "";

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    print("Data getting called");
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

    name = _sharedPreferences.getString(UserConstants().userName)!;
    id = _sharedPreferences.getString(UserConstants().userId)!;
    email = _sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = _sharedPreferences.getString(UserConstants().timeZone)!;
    userType = _sharedPreferences.getString(UserConstants().userType)!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _isUserDataLoading ? AppBarWidget().appBar(false,false,"","",false) : AppBarWidget().appBar(false,false,name,id,false),
      bottomNavigationBar: GestureDetector(
        // onTap: () {
        //   setAnswerText();
        //   _submitAnswer(_fieldController.text);
        // },
        child: Container(
          color: AppColors.backgroundColor,
          child: PriviousNextButtonWidget((){
            setAnswerText();
            _submitAnswer(_fieldController.text);
          },(){

            // widget.answersList.removeAt(widget.answersList.length-1);
            // print(widget.answersList);
            Navigator.of(context).pop();

          },true),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:  Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor,
        child: Form(
          key: _formKey,
          child: Stack(
            alignment: Alignment.center,
          //  ignoring: isAnswerLoading,
           children: [
             Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.center,
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

               ],
             ),
             Align(alignment: Alignment.center,
               child: isAnswerLoading ? const CircularProgressIndicator(): Container(),
             )],
            ),
          ),
        ),
      )
    );
  }

  void _submitAnswer(String text) {
    selectedAnswer.clear();

    if(_formKey.currentState!.validate()) {
      setState(() {
        //isAnswerLoading = true;
        selectedAnswer.add(text);
      });

        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen10(widget.questionListResponse)));

    }
  }

}
