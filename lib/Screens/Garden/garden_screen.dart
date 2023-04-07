import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../Widgets/toast_message.dart';
import '../utill/userConstants.dart';
import 'history_screen.dart';
import 'image_screen.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({Key? key}) : super(key: key);

  @override
  _GardenScreenState createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  late bool _isLoading;
  late bool isPhone;
  late String score;

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
    print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    score = sharedPreferences.getString("Score")!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  getScreenDetails() {
    setState(() {
      _isLoading = true;
    });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    getScreenDetails();
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _isUserDataLoading ? AppBarWidget().appBar(false,true,"","",false) : AppBar(
        centerTitle: true,
        title: Text(name),
        actions:  [
          PopMenuButton(false,false,id)
        ],
      ),
      body: Container(
        color: AppColors.backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoScreen(),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Container(
              //       padding: EdgeInsets.only(top: 1),
              //       width: MediaQuery.of(context).size.width,
              //       child: QuestionTextWidget(widget.questionListResponse[4].subTitle)),
              // ),

              Container(
                margin: EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height/1.28,
                width: MediaQuery.of(context).size.width,
                child: GridView.count(
                    padding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                    crossAxisCount:!isPhone ? 3 : 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: itemHeight/itemWidth,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const HistoryScreen()));
                        },
                        child: OptionMcqAnswer(
                            const Card(
                              color: AppColors.primaryColor,
                              child: Center(
                                child: Text("History",style: TextStyle(fontSize: 22),),
                              ),
                            )
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                             Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageScreen(score)));
                        },
                        child: OptionMcqAnswer(
                            const Card(
                              color: AppColors.primaryColor,
                              child: Center(
                                child: Text("PIRE",style: TextStyle(fontSize: 22),),
                              ),
                            )
                        ),
                      ),
                    ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
