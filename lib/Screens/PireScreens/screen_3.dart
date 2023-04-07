// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/question_state_prefrence.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/constants.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/PopMenuButton.dart';
import 'package:flutter_quiz_app/Screens/instruction_and_summaryPage.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_4.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_version/new_version.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/constants.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../Widgets/toast_message.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';
import '../video_player.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  String _groupValue ="";
  String name = "";
  String id = "";
  String email = "";
  String timeZone = "";
  String userType = "";
  String answerNo = "";
  List answerText = [];
  bool _isLoading = false;
  bool _isUserDataLoading = false;
  int questionIndex = 0;
  late Timer _timer;
  int _start = 30;
  bool isAnswerLoading = false;
  String errorMessage = "";
  String urlFirst = "https://www.youtube.com/watch?v=8n5-yXPEU7U";
  String urlSecond = "https://www.youtube.com/watch?v=zhRsp6NWKCE";

  late List<QuestionListResponseModel> questionListResponse;
  final GoogleSignIn googleSignIn = GoogleSignIn();
 late SharedPreferences _sharedPreferences;
  List<String> selectedAnswer = [];
  int questionListResponseLength = 0;

  List answersList = [];

  String a1 = "0";
  String a2 = "";
  String a3 = "";

  late Map answerList;

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    //_getAnswerData();
    _getQuestions();
  //  _checkNewVersion();
    super.initState();
  }

  _checkNewVersion() async {
    final newVersion = NewVersion(
      iOSId: 'com.TrueIncrease.TriggerHappy',
      androidId: 'com.ratedsolution.flutter_quiz_app',
    );

    final status = await newVersion.getVersionStatus();

    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      if(status.canUpdate) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: 'Update!',
          updateButtonText: "Update",
          dismissButtonText: "No",
          dialogText: Platform.isAndroid ? 'New version is available on play Store' : 'New version is available on App Store',
        );
      }
    }

  }

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

  setAnswerText() {
    print("Calling question Submission");
    QuestionStatePrefrence().setAnswerText(
        PireConstants.questionOneId, questionListResponse[questionIndex].id.toString(),
        PireConstants.questionOneText, selectedAnswer, PireConstants.questionOneType,
        questionListResponse[questionIndex].responseType.toString()
    );
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    setState(() {
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
        questionListResponseLength = value.values.length;
        // ignore: avoid_print
        print("List Length");
        print(questionListResponseLength);
      //  if(value.values.isNotEmpty) {
        //  questionListResponseLength = value.values.length;
          questionListResponse = value.values;
      //  } else {

       // }
      });
    }).catchError((e){
      // ignore: avoid_print
      print(e.toString());
      setState(() {
        questionListResponseLength == 0;
        _isLoading = false;
        errorMessage = e.toString();
      });
      showToastMessage(context, e.toString(),false);
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));

    return true;
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
              },
            ),
            title: Text(_isUserDataLoading ? "" : name),
            actions:  [
              PopMenuButton(true,false,id)
            ],
          ),
           // AppBarWidget().appBar(true,true,"","",true) : AppBarWidget().appBar(true,true,name,id,true),
          bottomNavigationBar: Visibility(
            visible: questionListResponseLength != 0,
            child: GestureDetector(
              child: Container(
                color: AppColors.backgroundColor,
                child: PriviousNextButtonWidget((){
                  setAnswerText();
                  _submitAnswer();
                },() {
                  Navigator.of(context).pop();

                },questionIndex == 0 ? false : true),
              ),
            ),
          ),
          body:   Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.backgroundColor,
            child: _isLoading ? const Center(child: CircularProgressIndicator())
                :  questionListResponseLength == 0 ? Center(
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorMessage,style:const TextStyle(fontSize: 25),),
                   const SizedBox(height: 5,),
                    GestureDetector(
                      onTap: () {
                        _getQuestions();
                      },
                      child: OptionMcqAnswer(
                          TextButton(onPressed: () {
                            _getQuestions();
                          }, child: const Text("Reload",style: TextStyle(fontSize:25,color: AppColors.redColor)),)
                      ),
                    )
                  ],
                )
              ),
            ) : SingleChildScrollView(
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
                                const LogoScreen(),

                                Padding(
                                  padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          String? videoId = YoutubePlayer.convertUrlToId(urlFirst);
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                                        },
                                        child: Expanded(
                                          child: Container(
                                            padding:const EdgeInsets.only(left: 10),
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Column(
                                              children: const [
                                                Text("Selecting a topic to process",style: TextStyle(fontSize: AppConstants.defaultFontSize,color: Colors.blue),),
                                                SizedBox(height: 5,),
                                                Icon(Icons.ondemand_video_sharp,size: 25,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          String? videoId = YoutubePlayer.convertUrlToId(urlSecond);
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                                        },
                                        child: Expanded(
                                          child: Container(
                                            padding:const EdgeInsets.only(left: 10),
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Column(
                                              children:const [
                                                Text("Making exercise effective",style: TextStyle(fontSize: AppConstants.defaultFontSize,color: Colors.blue),),
                                                SizedBox(height: 5,),
                                                Icon(Icons.ondemand_video_sharp,size: 25,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: QuestionTextWidget(questionListResponse[questionIndex].title)),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SummaryAndInstructions(1)));
                                        },
                                        child:const Icon(Icons.info_outline,size: 30,),
                                      ),
                                    )

                                  ],
                                ),
                                ListView.builder(
                                    physics:const NeverScrollableScrollPhysics(),
                                    itemCount: questionListResponse[questionIndex].options.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index){
                                      return OptionMcqAnswer(
                                        RadioListTile<String>(
                                          tileColor: AppColors.textWhiteColor,
                                          activeColor: AppColors.primaryColor,
                                          value: questionListResponse[questionIndex].options[index],
                                          title: Text(questionListResponse[questionIndex].options[index],style:const TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.defaultFontSize)),
                                          groupValue: _groupValue,
                                          onChanged:  (newValue) {
                                            selectedAnswer.clear();
                                            setState(() {
                                              selectedAnswer.add(questionListResponse[questionIndex].options[index]);

                                              print(answersList);
                                              _groupValue = newValue.toString();
                                            });
                                          },
                                        ),);
                                    }),
                              ],
                            )
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

    if(questionListResponseLength != 0) {
    if(selectedAnswer.isNotEmpty) {
        
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            Screen4(questionListResponse,)));

    } else {
      showToastMessage(context, "Please select any option",false);

    } } else {
      showToastMessage(context, errorMessage,false);

    }
  }

  // Future<void> _launchUrl(String url1) async {
  //   if (!await launchUrl(Uri.parse(url1))) {
  //     throw Exception('Could not launch $url1');
  //   }
  // }
}
