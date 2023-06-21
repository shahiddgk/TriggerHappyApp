// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/question_state_prefrence.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/constants.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/video_screen.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/PopMenuButton.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_4.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/Widgets/video_player_in_pop_up.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:new_version/new_version.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/constants.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../Widgets/toast_message.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
  bool isAnswerLoading = false;
  String errorMessage = "";
  String urlQ1 = "https://www.youtube.com/watch?v=8KgbGXH35Mg";
  // String urlSecond = "https://www.youtube.com/watch?v=zhRsp6NWKCE";

  late List<QuestionListResponseModel> questionListResponse;
  final GoogleSignIn googleSignIn = GoogleSignIn();
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


  void startTimer() {
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
    HTTPManager().getQuestions("Pire").then((value) {
      print(value);
      // ignore: duplicate_ignore
      setState(() {
        _isLoading = false;
        questionListResponseLength = value.values.length;
        print("List Length");
        print(questionListResponseLength);
      //  if(value.values.isNotEmpty) {
        //  questionListResponseLength = value.values.length;
          questionListResponse = value.values;
      //  } else {

       // }
      });
    }).catchError((e){
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
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const VideoScreen()));
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {

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
                Navigator.of(context).pop();
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    LogoScreen("PIRE"),
                                    // const SizedBox(width: 20,),
                                    // IconButton(onPressed: (){
                                    //   String titleColumn = "https://youtu.be/dk5vgNpIWMM";
                                    //   String? videoId = YoutubePlayer.convertUrlToId(titleColumn);
                                    //   YoutubePlayerController playerController = YoutubePlayerController(
                                    //       initialVideoId: videoId!,
                                    //       flags: const YoutubePlayerFlags(
                                    //         autoPlay: false,
                                    //         controlsVisibleAtStart: false,
                                    //       )
                                    //
                                    //   );
                                    //   videoPopupDialog(context,"Introduction to Trellis",playerController);
                                    //   //bottomSheet(context,"Trellis","Welcome to Trellis, the part of the Brugeon app designed to help you flourish and live life intentionally. Trellis is a light structure that provides structure and focus, and helps propel you towards your desired outcomes. Invest at least five minutes a day in reviewing and meditating on your Trellis. If you don't have any answers yet, spend your time meditating, praying, or journaling on the questions/sections. If you have partial answers, keep taking your time daily to consider the questions and your answers. By consistently returning to your Trellis, you will become more clear and focused on creating the outcomes you desire. Enjoy your Trellis!","");
                                    // }, icon: const Icon(Icons.video_collection_outlined,size:20,color: AppColors.infoIconColor,))
                                  ],
                                ),
                              //  LogoScreen("PIRE"),

                                // Padding(
                                //   padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                //   child: Row(
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //     children: [
                                //       GestureDetector(
                                //         onTap: () {
                                //           String? videoId = YoutubePlayer.convertUrlToId(urlFirst);
                                //           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                                //         },
                                //         child: Container(
                                //             padding:const EdgeInsets.only(left: 10),
                                //             margin: const EdgeInsets.only(top: 10),
                                //             child: Column(
                                //               children: const [
                                //                 Text("Choosing a topic",style: TextStyle(fontSize: AppConstants.defaultFontSize,color: Colors.blue),),
                                //                 SizedBox(height: 5,),
                                //                 Icon(Icons.ondemand_video_sharp,size: 25,)
                                //               ],
                                //             ),
                                //           ),
                                //       ),
                                //       GestureDetector(
                                //         onTap: () {
                                //           String? videoId = YoutubePlayer.convertUrlToId(urlSecond);
                                //           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(name,id,videoId!)));
                                //         },
                                //         child: Container(
                                //             padding:const EdgeInsets.only(left: 10),
                                //             margin: const EdgeInsets.only(top: 10),
                                //             child: Column(
                                //               children:const [
                                //                 Text("Improve Exercise Results",style: TextStyle(fontSize: AppConstants.defaultFontSize,color: Colors.blue),),
                                //                 SizedBox(height: 5,),
                                //                 Icon(Icons.ondemand_video_sharp,size: 25,)
                                //               ],
                                //             ),
                                //           ),
                                //       ),
                                //     ],
                                //   ),
                                // ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: QuestionTextWidget(questionListResponse[questionIndex].title,questionListResponse[questionIndex].videoUrl,(){
                                            String? videoId = YoutubePlayer.convertUrlToId(urlQ1);
                                            YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                                                initialVideoId: videoId!,
                                                flags: const YoutubePlayerFlags(
                                                  autoPlay: false,
                                                  controlsVisibleAtStart: false,
                                                )

                                            );
                                            videoPopupDialog(context, "Introduction to question#1", youtubePlayerController);
                                          },true)),
                                    ),
                                    // Expanded(
                                    //   flex: 1,
                                    //   child: GestureDetector(
                                    //     onTap: () {
                                    //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SummaryAndInstructions(1)));
                                    //     },
                                    //     child:const Icon(Icons.info_outline,size: 30,),
                                    //   ),
                                    // )

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
