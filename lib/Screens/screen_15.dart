import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/change_password.dart';
import 'package:flutter_quiz_app/Screens/login_screen.dart';
import 'package:flutter_quiz_app/Screens/question_screen.dart';
import 'package:flutter_quiz_app/Screens/screen_16.dart';
import 'package:flutter_quiz_app/Screens/screen_4.dart';
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

class Screen15 extends StatefulWidget {

  List<QuestionListResponseModel> questionListResponse;

  Screen15(this.questionListResponse,{Key? key}) : super(key: key);

  @override
  _Screen15State createState() => _Screen15State();
}

class _Screen15State extends State<Screen15> {
  String _groupValue ="";
  List selectedAnswer = [];
  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
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
        child:  PriviousNextButtonWidget((){
          _submitAnswer();
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
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text("QUESTION 1 OF 24",style: TextStyle(color: Colors.deepOrangeAccent),),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LogoScreen(),

                Align(
                    alignment: Alignment.topLeft,
                    child: QuestionTextWidget(widget.questionListResponse[10].title)),
                ListView.builder(
                    physics:const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: widget.questionListResponse[10].options.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return OptionMcqAnswer(
                        RadioListTile<String>(
                          tileColor: AppColors.textWhiteColor,
                          activeColor: AppColors.PrimaryColor,
                          value: widget.questionListResponse[10].options[index],
                          title: Text(widget.questionListResponse[10].options[index],style: TextStyle(color: AppColors.textWhiteColor)),
                          groupValue: _groupValue,
                          onChanged:  (newValue) {
                            selectedAnswer.clear();
                            setState(() {
                              selectedAnswer.add(widget.questionListResponse[10].options[index]);

                            //  print(widget.answersList);
                              _groupValue = newValue.toString();
                            });
                          },
                        ),);
                    }),
                // OptionMcqAnswer(
                //   RadioListTile(
                //     tileColor: AppColors.textWhiteColor,
                //     activeColor: AppColors.textWhiteColor,
                //     value: 2,
                //     title: const Text("2 = Same",style: TextStyle(color: AppColors.textWhiteColor)),
                //     groupValue: _groupValue,
                //     onChanged:  (int? newValue) {
                //       setState(() {
                //         _groupValue = newValue!;
                //       });
                //     },
                //   ),),
                // OptionMcqAnswer(
                //   RadioListTile(
                //     tileColor: AppColors.textWhiteColor,
                //     activeColor: AppColors.textWhiteColor,
                //     value: 3,
                //     title: const Text("3 = Mixed Emotion",style: TextStyle(color: AppColors.textWhiteColor)),
                //     groupValue: _groupValue,
                //     onChanged:  (int? newValue) {
                //       setState(() {
                //         _groupValue = newValue!;
                //       });
                //     },
                //   ),),
                // OptionMcqAnswer(
                //   RadioListTile(
                //     tileColor: AppColors.textWhiteColor,
                //     activeColor: AppColors.textWhiteColor,
                //     value: 4,
                //     title: const Text("4 = Better",style: TextStyle(color: AppColors.textWhiteColor)),
                //     groupValue: _groupValue,
                //     onChanged:  (int? newValue) {
                //       setState(() {
                //         _groupValue = newValue!;
                //       });
                //     },
                //   ),),
                // OptionMcqAnswer(
                //   RadioListTile(
                //     tileColor: AppColors.textWhiteColor,
                //     activeColor: AppColors.textWhiteColor,
                //     value: 5,
                //     title: const Text("5 = Awesome",style: TextStyle(color: AppColors.textWhiteColor)),
                //     groupValue: _groupValue,
                //     onChanged:  (int? newValue) {
                //       setState(() {
                //         _groupValue = newValue!;
                //       });
                //     },
                //   ),),
              ],
            ),

            // PriviousNextButtonWidget((){
            //   if(_groupValue == -1) {
            //     showToast(
            //         "Please Select any option", shapeBorder: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10.0)
            //     ),
            //         context: context,
            //         fullWidth: true,
            //         alignment: Alignment.topCenter,
            //         duration: Duration(seconds: 3),
            //         backgroundColor: Colors.red
            //     );
            //   } else {
            //     Navigator.of(context).push(
            //         MaterialPageRoute(builder: (context) => Screen16(_groupValue)));
            //   }
            // })
          ],
        ),
      ),
    );
  }
  void _submitAnswer() {
    print(selectedAnswer);

    if(selectedAnswer.isNotEmpty) {
      // answersList.add({
      //   questionListResponse[0].id: selectedAnswer
      // });
      HTTPManager().userAnswer(AnswerRequestModel(questionId:widget.questionListResponse[10].id.toString(),options: selectedAnswer.toString(), userId: id,text: "" )).then((value) {
        print("Answer Response");
        print(value);
        print("All answer List");
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Screen16(_groupValue)));

      }).catchError((e){
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
