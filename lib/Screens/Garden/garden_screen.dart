// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../Widgets/footer_widget.dart';
import '../utill/userConstants.dart';
import 'image_screen.dart';
import 'new_history_screen.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({Key? key}) : super(key: key);

  @override
  _GardenScreenState createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  late bool isPhone;
  late String score;
  late String treeType;
  late String mobileImageUrl;
  late String ipadImageUrl;

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
    // print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    score = sharedPreferences.getString("Score")!;
    mobileImageUrl = sharedPreferences.getString("MobileImageURL")!;
    ipadImageUrl = sharedPreferences.getString("IpadImageURL")!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  getScreenDetails() {
    setState(() {
    });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    setState(() {
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
      appBar: _isUserDataLoading ? AppBarWidget().appBar(context,false,true,"","",false) : AppBar(
        centerTitle: true,
        title: Text(name),
        actions:  [
          PopMenuButton(false,false,id)
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color: AppColors.backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Column(
                  children: [
                    LogoScreen("Garden"),
                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: Container(
                    //       padding: EdgeInsets.only(top: 1),
                    //       width: MediaQuery.of(context).size.width,
                    //       child: QuestionTextWidget(widget.questionListResponse[4].subTitle)),
                    // ),

                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.only(top: 10),
                        height:!isPhone ? MediaQuery.of(context).size.height/1.28  : MediaQuery.of(context).size.height/1.45,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.count(
                            padding: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
                            crossAxisCount:!isPhone ? 3 : 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 2.0,
                            childAspectRatio: itemHeight/itemWidth,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const NewHistoryScreen()));
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
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageScreen(!isPhone ? ipadImageUrl : mobileImageUrl)));
                                },
                                child: OptionMcqAnswer(
                                    const Card(
                                      color: AppColors.primaryColor,
                                      child: Center(
                                        child: Text("Current",style: TextStyle(fontSize: 22),),
                                      ),
                                    )
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              const FooterWidget(),
            ],
          )
        ),
      ),
    );
  }
}
