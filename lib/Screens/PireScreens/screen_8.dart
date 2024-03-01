// ignore_for_file: must_be_immutable, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_9.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/constants.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/question_state_prefrence.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/answer_field_widget.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../../model/reponse_model/question_answer_response_model.dart';
import '../utill/userConstants.dart';


class Screen8 extends StatefulWidget {
   Screen8(this.questionListResponse,{Key? key}) : super(key: key);

  List<QuestionListResponseModel> questionListResponse;

  @override
  // ignore: library_private_types_in_public_api
  _Screen8State createState() => _Screen8State();
}

class _Screen8State extends State<Screen8> {
  // ignore: prefer_final_fields
  TextEditingController _fieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String id = "";
  String answerNo6 = "";
  String answerText6 = "";
  bool _isUserDataLoading = true;
  bool isAnswerLoading = false;
  List<String> selectedAnswer = [];
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
      answerNo6 = _sharedPreferences.getString("answerType8")!;
      answerText6 = _sharedPreferences.getString("answerText8")!;
    });

  }

  setAnswerText() async {

    QuestionStatePrefrence().setAnswerText(
        PireConstants.questionSixId, widget.questionListResponse[5].id.toString(),
        PireConstants.questionSixText, selectedAnswer,
        PireConstants.questionSixType, widget.questionListResponse[5].responseType.toString()
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
    //print("Data getting called");
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
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor,
        child: Form(
          key: _formKey,
          child: Stack(
              alignment: Alignment.center,
             // ignoring: isAnswerLoading,
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
                        LogoScreen("PIRE"),
                        //  QuestionTextWidget("Tell me...."),
                        Align(alignment:Alignment.topLeft,
                            child: QuestionTextWidget(widget.questionListResponse[5].title,widget.questionListResponse[5].videoUrl,(){
                              String urlQ8 = "https://youtu.be/1Eo1G96P29c";
                              String? videoId = YoutubePlayer.convertUrlToId(urlQ8);
                              YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                                  initialVideoId: videoId!,
                                  flags: const YoutubePlayerFlags(
                                    autoPlay: false,
                                    controlsVisibleAtStart: false,
                                  )

                              );
                              videoPopupDialog(context, "Introduction to question#8", youtubePlayerController);
                            },true)),
                        // QuestionTextWidget("or"),
                        // Align(
                        //     alignment: Alignment.topLeft,
                        //     child: QuestionTextWidget(widget.questionListResponse[5].subTitle)),

                        AnswerFieldWidget(_fieldController,int.parse(widget.questionListResponse[5].textLength.toString())),
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
                Align(alignment: Alignment.center,
                  child: isAnswerLoading ? const CircularProgressIndicator(): Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitAnswer(String text) {
    selectedAnswer.clear();

    if(_formKey.currentState!.validate()) {
      setState(() {
      //  isAnswerLoading = true;
        selectedAnswer.add(text);
      });

        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen9(widget.questionListResponse)));

    }
  }
}
