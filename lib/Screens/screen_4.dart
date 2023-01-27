import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/change_password.dart';
import 'package:flutter_quiz_app/Screens/login_screen.dart';
import 'package:flutter_quiz_app/Screens/question_screen.dart';
import 'package:flutter_quiz_app/Screens/screen_5.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/request_model/answer_reques_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/option_mcq_widget.dart';
import '../model/reponse_model/question_answer_response_model.dart';

class Screen4 extends StatefulWidget {

  List<QuestionListResponseModel> questionListResponse;

   Screen4(this.questionListResponse,{Key? key}) : super(key: key);


  @override
  _Screen4State createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  String _groupValue ="";
  String name = "";
  String id = "";
  String answerNo = "";
  String answerText = "";
  bool _isUserDataLoading = true;
  bool _isAnswerDataLoading = true;
  bool isAnswerLoading = false;
  List selectedAnswer = [];
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    _getUserData();
    _getAnswerData();
    // TODO: implement initState
    super.initState();
  }

  _getAnswerData() async {
    setState(() {
      _isAnswerDataLoading = true;
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      answerNo = _sharedPreferences.getString("answerNo1")!;
      answerText = _sharedPreferences.getString("answerText1")!;
      _isAnswerDataLoading = false;
    });

  }

  setAnswerText() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _sharedPreferences.setString("answerNo1", "1");
    _sharedPreferences.setString("answerText1", selectedAnswer.toString());
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
      bottomNavigationBar: GestureDetector(
        // onTap: () {
        //   setAnswerText();
        //   _submitAnswer();
        // },
        child: Container(
          color: AppColors.backgroundColor,
          child: PriviousNextButtonWidget((){
              setAnswerText();
              _submitAnswer();
          },(){
            setState(() {

              Navigator.of(context).pop();
            });
          },true),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor,
        child: Stack(
         alignment: Alignment.center,
          children: [
            Column(
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
                        child: QuestionTextWidget(widget.questionListResponse[1].title)),
                    ListView.builder(
                        physics:const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: widget.questionListResponse[1].options.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          return OptionMcqAnswer(
                            RadioListTile<String>(
                              tileColor: AppColors.textWhiteColor,
                              activeColor: AppColors.PrimaryColor,
                              value: widget.questionListResponse[1].options[index],
                              title: Text(widget.questionListResponse[1].options[index],style: TextStyle(color: AppColors.textWhiteColor)),
                              groupValue: _groupValue,
                              onChanged:  (newValue) {
                                selectedAnswer.clear();
                                setState(() {
                                  selectedAnswer.add(widget.questionListResponse[1].options[index]);

                                  _groupValue = newValue.toString();
                                });
                              },
                            ),);
                        }),

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
    );
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
      HTTPManager().userAnswer(AnswerRequestModel(questionId:widget.questionListResponse[1].id.toString(),options: selectedAnswer.toString(), userId: id,text: "" )).then((value) {
        print("Answer Response");
        print(value);
        setState(() {
          isAnswerLoading = false;
        });

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Screen5(widget.questionListResponse,2,6)));

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
