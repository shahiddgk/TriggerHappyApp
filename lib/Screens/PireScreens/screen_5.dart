
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_15.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_6.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/constants.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/question_state_prefrence.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/answer_field_widget.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/video_player_in_pop_up.dart';
import '../utill/userConstants.dart';

// ignore: must_be_immutable
class Screen5 extends StatefulWidget {
   Screen5(this.questionListResponse,this.index,this.screen,{Key? key}) : super(key: key);

 // String question;
  int screen;
  int index;
   List<QuestionListResponseModel> questionListResponse;

  @override
  // ignore: library_private_types_in_public_api
  _Screen5State createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {

  final TextEditingController _fieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String id = "";
  String answerNo3 = "";
  String answerText3 = "";
  bool _isUserDataLoading = true;
  bool isAnswerLoading = false;
  List <String> selectedAnswer = [];
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String urlQ3 = "https://www.youtube.com/watch?v=0sqBsbiVjUQ";
  String urlQ11 = "https://youtu.be/T4-coEpZvgY";
  String urlQ12 = "https://youtu.be/-0ajZdKJWsw";

  @override
  void initState() {
    _getUserData();
   // _getAnswerData();
    // TODO: implement initState
    super.initState();
  }

  // ignore: unused_element
  _getAnswerData() async {
    setState(() {
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      answerNo3 = _sharedPreferences.getString("answerType${widget.index}")!;
      answerText3 = _sharedPreferences.getString("answerText${widget.index}")!;
    });

  }

  setAnswerText() async {
    // print("Screen Data");
    // print(widget.screen);
    // print(widget.index);
    _sharedPreferences = await SharedPreferences.getInstance();

    if(widget.screen == 6) {

     // print("Calling question Submission");
      QuestionStatePrefrence().setAnswerText(
          PireConstants.questionThreeId, widget.questionListResponse[widget.index].id.toString(),
          PireConstants.questionThreeText, selectedAnswer,
          PireConstants.questionThreeType,widget.questionListResponse[widget.index].responseType.toString()
      );

    } else if(widget.screen == 12) {

    //  print("Calling question Submission");
      QuestionStatePrefrence().setAnswerText(
          PireConstants.questionEightId, widget.questionListResponse[widget.index].id.toString(),
          PireConstants.questionEightText, selectedAnswer,
          PireConstants.questionEightType, widget.questionListResponse[widget.index].responseType.toString()
      );

    } else if(widget.screen == 13) {

     // print("Calling question Submission");
      QuestionStatePrefrence().setAnswerText(
          PireConstants.questionNineId, widget.questionListResponse[widget.index].id.toString(),
          PireConstants.questionNineText, selectedAnswer,
          PireConstants.questionNineType, widget.questionListResponse[widget.index].responseType.toString()
      );
    }



    // _sharedPreferences.setString("answerNo${widget.index}", "${widget.index}");
    // _sharedPreferences.setString("answerText${widget.index}", selectedAnswer.toString());
  }

  String email = "";
  String timeZone = "";
  String userType = "";

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
   // print("Data getting called");
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  _isUserDataLoading ? AppBarWidget().appBar(false,false,"","",false) : AppBarWidget().appBar(false,false,name,id,false),
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
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       LogoScreen("PIRE"),
                       Align(
                           alignment: Alignment.topLeft,
                           child: QuestionTextWidget(widget.questionListResponse[widget.index].title,widget.questionListResponse[widget.index].videoUrl,(){
                             String? videoId = YoutubePlayer.convertUrlToId(widget.screen == 6 ? urlQ3 : widget.screen == 12 ? urlQ11 : urlQ12);
                             YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                                 initialVideoId: videoId!,
                                 flags: const YoutubePlayerFlags(
                                   autoPlay: false,
                                   controlsVisibleAtStart: false,
                                 )

                             );
                             videoPopupDialog(context, "Introduction to question#2", youtubePlayerController);
                           },true)),
                       AnswerFieldWidget(_fieldController,int.parse(widget.questionListResponse[widget.index].textLength.toString())),
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
      ),
    );
  }

  void _submitAnswer(String text) {
    selectedAnswer.clear();

    if(_formKey.currentState!.validate()) {
      setState(() {
        selectedAnswer.add(text);
      });

        if(widget.screen == 6) {

          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Screen6(widget.questionListResponse)));
        } else if(widget.screen == 12) {

          //print(widget.screen);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen5(widget.questionListResponse,9,13)));
        } else if(widget.screen ==13) {

         // print(widget.screen);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Screen15(widget.questionListResponse)));
        }

    }
  }
}
