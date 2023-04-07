import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/utill/userConstants.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/constants.dart';

class SummaryAndInstructions extends StatefulWidget {
   SummaryAndInstructions(this.instructionSummary,{Key? key}) : super(key: key);
    int instructionSummary;

  @override
  _SummaryAndInstructionsState createState() => _SummaryAndInstructionsState();
}

class _SummaryAndInstructionsState extends State<SummaryAndInstructions> {

  bool _isUserDataLoading = true;
  late String name;
  late String id;
  late SharedPreferences _sharedPreferences;

  @override
  void initState() {
    _getUserData();
    // TODO: implement initState
    super.initState();
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = _sharedPreferences.getString(UserConstants().userName)!;
      id = _sharedPreferences.getString(UserConstants().userId)!;

      _isUserDataLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // automaticallyImplyLeading: false,
        title: const Text("Summary & Instruction",style: TextStyle(fontSize: 30,),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(top: 20),
            color: AppColors.hoverColor,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(height: 20,),
                    Text("Summary",style: TextStyle(fontSize: 40,color: AppColors.primaryColor),),
                  Padding(padding: EdgeInsets.only(
                    top: 20,bottom: 20,left: 20,right: 20,
                  ),
                    child: Text("Burgeon is a neuroscientific based app with one purpose, to help human beings flourish through great relating and creating. Whether you are a high-capacity leader, an individual recovering from trauma, or somewhere in between, this app will help you get to your next level of flourishing by integrating the different parts of yourself and aligning your life around what you need and want. \n\nThe transformation begins by integrating your thoughts (both conscious and subconscious), your body (five senses and nervous system), emotions and the memory cells in every major organ in your body (see Candace Pert PHD), and your soul.\n\nIf you invest an honest and distraction-free five minutes a day in Burgeon you will begin to see the undeniable rewards of better relating (self-awareness, intuition, peace, connectivity, influence, and more) and creating (ingenuity, problem-solving, artistry, and more).",textAlign: TextAlign.start,style: TextStyle(fontSize: AppConstants.defaultFontSize),)),
                  SizedBox(height: 20,),
                   Text("Instruction", style: TextStyle(fontSize: 40,color: AppColors.primaryColor),),
                  Padding(padding: EdgeInsets.only(
                    top: 20,bottom: 20,left: 20,right: 20,
                  ),
                    child: Text("P.I.R.E. (Process, Integrate, and Regulate Emotion) ‘Pire’ is “an obsolete form of the word ‘pier’”. The definition of ‘Pier’ is “A platform used to secure, protect and provide access…” or a “reinforcing and supporting structure.” Take the next step in your journey to flourishing through greater relating and creating. To begin, take a minimum of five minutes in a quiet, safe, and distraction-free place.\n\nThink of one person, comment, or event/situation, that you experienced as negative or has brought up a negative emotion, then proceed by responding to the prompts accordingly. At the end of the experience, you will be sent an email record of your experience. Repeat the process daily, dealing with negative experiences or emotions as they arise. At first, leveraging the Burgeon P.I.R.E. experience often feels awkward or confusing.\n\nThat said, If you engage the P.I.R.E. experience openly and honestly, daily for 30 days, among other major benefits, you will start to unlock greater ability to relate/connect to yourself and others, and you will unlock and enhance your creativity and problem-solving ability. Pay close attention to what you experience over the next 30 days in each area of your life and work and you will notice that like exercising a muscle, these two abilities (connecting and creating) will develop rapidly. Enjoy as you begin to “Burgeon”!",textAlign: TextAlign.start,style: TextStyle(fontSize: AppConstants.defaultFontSize),),)
                ],
              ),
          ),
        ),

      ),
    );
  }
}
