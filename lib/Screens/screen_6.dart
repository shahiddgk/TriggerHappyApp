import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/change_password.dart';
import 'package:flutter_quiz_app/Screens/login_screen.dart';
import 'package:flutter_quiz_app/Screens/screen_7.dart';
import 'package:flutter_quiz_app/Widgets/check_box_widget.dart';
import 'package:flutter_quiz_app/Widgets/circular_button_widget.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/request_model/answer_reques_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/reponse_model/question_answer_response_model.dart';

class Screen6 extends StatefulWidget {

  List<QuestionListResponseModel> questionListResponse;

   Screen6(this.questionListResponse,{Key? key}) : super(key: key);

  @override
  _Screen6State createState() => _Screen6State();
}

class _Screen6State extends State<Screen6> {

  List selectedAnswer = [];
  String name = "";
  String id = "";
  String answerNo4 = "";
  String answerText4 = "";
  bool _isUserDataLoading = true;
  bool _isAnswerDataLoading = true;
  bool _isDataLoading = true;
  bool isAnswerLoading = false;
  List answersList = [];
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String a1 = "0";

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
    for(int i = 0;i<widget.questionListResponse[3].options.length;i++) {
      answersList.add({
        "answer": widget.questionListResponse[3].options[i],
        "selected":"0",
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
    setListOptions();
    _getAnswerData();
    _getUserData();

  }

  _getAnswerData() async {
    setState(() {
      _isAnswerDataLoading = true;
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      answerNo4 = _sharedPreferences.getString("answerNo3")!;
      answerText4 = _sharedPreferences.getString("answerText3")!;
      _isAnswerDataLoading = false;
    });

  }

  setAnswerText() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _sharedPreferences.setString("answerNo3", "3");
    _sharedPreferences.setString("answerText3", selectedAnswer.toString());
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
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
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
                      LogoScreen(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            padding: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            child: QuestionTextWidget(widget.questionListResponse[3].title)),
                      ),

                      !_isDataLoading ? Container(
                        height: MediaQuery.of(context).size.height/1.66,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height,top: 5),
                        child: GridView.count(
                          padding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                          crossAxisCount: ResponsiveWrapper.of(context).isMobile || ResponsiveWrapper.of(context).isPhone ? 4 : 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 2.0,
                          childAspectRatio: itemHeight/itemWidth,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: List.generate(answersList.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                print("item Clicked");
                                print(a1);

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
                                        border: Border.all(color: AppColors.PrimaryColor,width: 2)
                                    ),
                                    alignment: Alignment.center,
                                    height: 20,
                                    width: 20,
                                    child:answersList[index]["selected"] == "0" ? Text("") : Text(answersList[index]["selected"],style: TextStyle(color: AppColors.textWhiteColor,fontWeight: FontWeight.bold)),
                                  ),
                                  Text(answersList[index]['answer'],style: TextStyle(color: AppColors.textWhiteColor)),
                                ],
                              ))),
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
      HTTPManager().userAnswer(AnswerRequestModel(questionId:widget.questionListResponse[3].id.toString(),options: selectedAnswer.toString(), userId: id,text: "" )).then((value) {
        print("Answer Response");
        print(value);
        setState(() {
          isAnswerLoading = false;
        });

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Screen7(widget.questionListResponse)));

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
