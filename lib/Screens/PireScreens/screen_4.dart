// ignore_for_file: must_be_immutable, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_5.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/constants.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/question_state_prefrence.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/constants.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../../model/reponse_model/question_answer_response_model.dart';
import '../Widgets/toast_message.dart';
import '../utill/userConstants.dart';

class Screen4 extends StatefulWidget {

  List<QuestionListResponseModel> questionListResponse;

   Screen4(this.questionListResponse,{Key? key}) : super(key: key);


  @override
  // ignore: library_private_types_in_public_api
  _Screen4State createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  String _groupValue ="";
  String name = "";
  String id = "";
  String answerNo = "";
  List answerText = [];
  bool _isUserDataLoading = true;
  bool isAnswerLoading = false;
  List <String> selectedAnswer = [];
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String urlQ2 = "https://youtu.be/r94TTmxEVd4";
  @override
  void initState() {
    _getUserData();
    //_getAnswerData();
    // TODO: implement initState
    super.initState();
  }

  // ignore: unused_element
  _getAnswerData() async {
    setState(() {
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      answerNo = _sharedPreferences.getString("questionId4")!;
      answerText = _sharedPreferences.getStringList("answerText4")!;
      //_groupValue = answerText[0];
    });

  }

  setAnswerText()  {
    // ignore: avoid_print
    print("Calling question Submission");
    QuestionStatePrefrence().setAnswerText(
        PireConstants.questionTwoId, widget.questionListResponse[1].id.toString(),
        PireConstants.questionTwoText, selectedAnswer,
        PireConstants.questionTwoType, widget.questionListResponse[1].responseType.toString()
    );
  }

  String email = "";
  String timeZone = "";
  String userType = "";
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    setState(() {
      _isUserDataLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget().appBarGeneralButtons(
          context,
              () {
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
            //         (Route<dynamic> route) => false
            // );
          }, true, true, true, id, false,true,badgeCount1,false,badgeCountShared),
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    LogoScreen("PIRE"),
                    Align(
                        alignment: Alignment.topLeft,
                        child: QuestionTextWidget(widget.questionListResponse[1].title,widget.questionListResponse[1].videoUrl,(){
                          String? videoId = YoutubePlayer.convertUrlToId(urlQ2);
                          YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                              initialVideoId: videoId!,
                              flags: const YoutubePlayerFlags(
                                autoPlay: false,
                                controlsVisibleAtStart: false,
                              )

                          );
                          videoPopupDialog(context, "Introduction to question#2", youtubePlayerController);
                        },true)),
                    ListView.builder(
                        physics:const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: widget.questionListResponse[1].options.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          return OptionMcqAnswer(
                            RadioListTile<String>(
                              tileColor: AppColors.textWhiteColor,
                              activeColor: AppColors.primaryColor,
                              value: widget.questionListResponse[1].options[index],
                              title: Text(widget.questionListResponse[1].options[index],style:const TextStyle(fontSize:AppConstants.defaultFontSize,color: AppColors.textWhiteColor)),
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
    //print(selectedAnswer);


     if(selectedAnswer.isNotEmpty) {

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Screen5(widget.questionListResponse,2,6)));
    } else {

       showToastMessage(context, "Please select any option",false);

    }
  }
}
