import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/change_password.dart';
import 'package:flutter_quiz_app/Screens/login_screen.dart';
import 'package:flutter_quiz_app/Screens/question_screen.dart';
import 'package:flutter_quiz_app/Screens/screen_4.dart';
import 'package:flutter_quiz_app/Widgets/answer_field_widget.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/answer_reques_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/option_mcq_widget.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  String _groupValue ="";
  String name = "";
  String id = "";
  String answerNo = "";
  String answerText = "";
  bool _isLoading = false;
  bool _isUserDataLoading = false;
  bool _isAnswerDataLoading = false;
  int questionIndex = 0;
  late Timer _timer;
  int _start = 30;
  bool isAnswerLoading = false;

  late List<QuestionListResponseModel> questionListResponse;
  TextEditingController _fieldController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
 late SharedPreferences _sharedPreferences;
  List<String> selectedAnswer = [];

  List answersList = [];

  String a1 = "0";
  String a2 = "";
  String a3 = "";

  late Map answerList;


  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    _getAnswerData();
    _getQuestions();
    super.initState();
  }

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

  _getAnswerData() async {
    setState(() {
      _isAnswerDataLoading = true;
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      answerNo = _sharedPreferences.getString("answerNo0")!;
      answerText = _sharedPreferences.getString("answerText0")!;
      _isAnswerDataLoading = false;
    });

  }

  setAnswerText() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _sharedPreferences.setString("answerNo0", "0");
    _sharedPreferences.setString("answerText0", selectedAnswer.toString());
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = _sharedPreferences.getString("username")!;
      id = _sharedPreferences.getString("userid")!;
      _isUserDataLoading = false;
    });

  }

  _getQuestions(){
    setState(() {
      _isLoading = true;
    });
    HTTPManager().getQuestions().then((value) {
      print(value);
      setState(() {
        _isLoading = false;
        questionListResponse = value.values;
      });
    }).catchError((e){
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
      showToast(
          e.toString(), shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
          context: context,
          fullWidth: true,
          isHideKeyboard: true,
          alignment: Alignment.topCenter,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red
      );
    });
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
          title: Text(!_isUserDataLoading? name : ""),
          actions: [
            IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChangePassword()));
            }, icon: Icon(Icons.person,color: AppColors.textWhiteColor,)),
            IconButton(onPressed: () async {
              SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
              //googleSignIn.disconnect();
              googleSignIn.signOut();
              setState(() {
                _sharedPreferences.setBool("user_logged_in",false);
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
            },() {
              Navigator.of(context).pop();
              // if(questionIndex < questionListResponse.length) {
              //   setState(() {
              //     questionIndex = questionIndex - 1;
              //   });
              // }
            },questionIndex == 0 ? false : true),
          ),
        ),
        body:   Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: AppColors.backgroundColor,
          child: _isLoading ?const Center(child: CircularProgressIndicator()) :  questionListResponse.isEmpty ? const Center(child: Text("No questions yet"),) : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              alignment: Alignment.center,
             // ignoring: isAnswerLoading,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
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
                                  child: QuestionTextWidget(questionListResponse[questionIndex].title)),
                              ListView.builder(
                                  physics:const NeverScrollableScrollPhysics(),
                                  itemCount: questionListResponse[questionIndex].options.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index){
                                    return questionListResponse[questionIndex].responseType == "radio_btn" ? OptionMcqAnswer(
                                      RadioListTile<String>(
                                        tileColor: AppColors.textWhiteColor,
                                        activeColor: AppColors.PrimaryColor,
                                        value: questionListResponse[questionIndex].options[index],
                                        title: Text(questionListResponse[questionIndex].options[index],style: TextStyle(color: AppColors.textWhiteColor)),
                                        groupValue: _groupValue,
                                        onChanged:  (newValue) {
                                          selectedAnswer.clear();
                                          setState(() {
                                            selectedAnswer.add(questionListResponse[questionIndex].options[index]);

                                            print(answersList);
                                            _groupValue = newValue.toString();
                                          });
                                        },
                                      ),) : questionListResponse[questionIndex].responseType == "open_text"
                                        ? AnswerFieldWidget(_fieldController,int.parse(questionListResponse[questionIndex].textLength.toString()))
                                        : questionListResponse[questionIndex].responseType == "check_box" ? GestureDetector(
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
                                    ) : Container(
                                      height: MediaQuery.of(context).size.height/2,
                                      width: MediaQuery.of(context).size.width/2,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.textWhiteColor,width: 5),
                                        // borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: _start == 0 ?const Text("Well done!",style: TextStyle(fontSize: 25,color: AppColors.textWhiteColor),) :Text("$_start",style: const TextStyle(fontSize: 25,color: AppColors.textWhiteColor),),
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),

                    ]),
                Align(alignment: Alignment.center,
                  child: isAnswerLoading ? const CircularProgressIndicator(): Container(),
                )
              ]
            ),
          ),
        )
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

    // if(questionIndex < questionListResponse.length) {
    //   setState(() {
    //     questionIndex = questionIndex + 1;
    //   });
    // }
    //
    // if(questionListResponse[questionIndex].responseType == "timer") {
    //   startTimer();
    // }

    if(selectedAnswer.isNotEmpty) {
      setState(() {
        isAnswerLoading = true;
      });
      // answersList.add({
      //   questionListResponse[0].id: selectedAnswer
      // });
      HTTPManager().userAnswer(AnswerRequestModel(questionId:questionListResponse[questionIndex].id.toString(),options: selectedAnswer.toString(), userId: id,text: "" )).then((value) {
        print("Answer Response");
        print(value);
        // setState(() {
        //   _sharedPreferences.setStringList("$questionIndex", selectedAnswer);
        // });
        setState(() {
          isAnswerLoading = false;
        });
        
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            Screen4(questionListResponse,)));

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
