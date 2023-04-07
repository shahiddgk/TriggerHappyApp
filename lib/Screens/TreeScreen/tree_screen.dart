
import 'dart:io';
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Screens/dashboard_tiles.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:flutter_quiz_app/network/api_urls.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../utill/userConstants.dart';

class TreeScreen extends StatefulWidget {
  const TreeScreen({Key? key}) : super(key: key);

  @override
  _TreeScreenState createState() => _TreeScreenState();
}

class _TreeScreenState extends State<TreeScreen> with SingleTickerProviderStateMixin{

 // late AnimationController controllerReverse;
  late AnimationController controllerForward;

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isLoading = true;
  late int countNumber;
  bool _showFirstImage = true;
  String errorMessage = "";
  late final _random;
  var element;
  String url = "";
  late bool isPhone;

  bool get isForwardAnimation =>
      controllerForward.status == AnimationStatus.forward ||
          controllerForward.status == AnimationStatus.completed;

  // bool get isReversAnimation =>
  //     controllerReverse.status == AnimationStatus.reverse ||
  //         controllerReverse.status == AnimationStatus.completed;

  List quoteList = <String> [
    "You can’t heal what isn’t real or true, we must first see the pain.",
    "Empathy is a superpower",
    "One of the problems with being a victim is we inevitably become the persecutor",
    "Feeling empowered always leads to creativity and connectivity giving life to all",
    "One of the problems with being the rescuer is we inevitably become the persecutor",
    "Leadership is about vision, seeing what’s needed or missing, and helping people act",
    "Be quick to listen, slow to speak, and slow to be angry",
    "There is no love without forgiveness, and there is no forgiveness without love. If we really want to love, we must learn how to forgive.",
    "Forgiving isn't something you do for someone else. It's something you do for yourself.",
    "Learn to grieve well, then do it do it regularly.",
    "Be yourself; everyone else is already taken.",
    "You only live once, but if you do it right, once is enough.",
    "You shall know the truth and the truth shall set you free",
    "There is a way that seems right to a man but in the end it leads to death",
    "What some intended for evil God intended for good",
    "Ask and it will be given, seek and you shall find, knock and the door will be opened",
    "Consider what a great forest is set on fire by a small spark. The tongue also is a fire…",
    "A prudent man sees danger and takes refuge but the simple keep on going and suffer",
    "A person of wisdom and understanding maintains balance and order",
    "The purposes of a person’s heart are deep waters but a person of understanding draws them out",
    "It is not good to have zeal without knowledge or to be hasty and miss the way",
    "A cheerful heart is good medicine, but a crushed spirit dries up the bones",
    "A generous person will prosper, he who refreshes others will himself be refreshed",
    "Whoever loves discipline loves knowledge",
    "Train a child in the way that they should go and when they are old they will not depart",
    "Let another praise you and not your own lips",
    "As iron sharpens iron so one man sharpens another",
    "There is a time and a season for everything under the sun",
    "Most people want to avoid pain, and discipline is usually painful.",
    "We must all suffer one of two things: the pain of discipline or the pain of regret or disappointment.",
    "We often want mercy for ourselves but just for others",
  ];

  @override
  void initState() {

    _random = Random();
    element = quoteList[_random.nextInt(quoteList.length)];
    _getUserData();
    // controllerForward = AnimationController(
    //   value: 1,
    //   duration: Duration(milliseconds: 2000),
    //   reverseDuration: Duration(milliseconds: 2000),
    //   vsync: this,
    // )..addStatusListener((status) => setState(() {}));

    controllerForward = AnimationController(
      value: 1,
      duration:const Duration(milliseconds: 6000),
      reverseDuration:const Duration(milliseconds: 6000),
      vsync: this,
    )..addStatusListener((status) => setState(() {}));
    // _getAnswerData();
    // TODO: implement initState
    super.initState();
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
  void dispose() {
   // controllerReverse.dispose();
    controllerForward.dispose();
    super.dispose();
  }


  void _changeImage(int count) {
    print("COUNT NUMBER");
    print(count);

    if(count == 0) {
      setState(() {
        countNumber = 1;
        controllerForward.forward();
      });
      print(countNumber);
      if(!isPhone) {
        url = "${ApplicationURLs.BASE_URL_FOR_IPAD_IMAGES}$countNumber.png";
      } else {
        url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}$countNumber.png";
      }
      print(url);
    } else {
      setState(() {
        controllerForward.reverse();
        if (_showFirstImage) {
          countNumber = count - 1;
        } else {
          countNumber = count;
        }
        print(countNumber);
        if(!isPhone) {
          url = "${ApplicationURLs.BASE_URL_FOR_IPAD_IMAGES}$countNumber.png";
        } else {
          url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}$countNumber.png";
        }
        print(url);
        Future.delayed(const Duration(seconds: 6)).then((value) {
          setState(() {
            _showFirstImage = false;
            if (_showFirstImage) {
              countNumber = count - 1;
            } else {
              countNumber = count;
            }
            print(countNumber);
            if(!isPhone) {
              url = "${ApplicationURLs.BASE_URL_FOR_IPAD_IMAGES}$countNumber.png";
            } else {
              url = "${ApplicationURLs.BASE_URL_FOR_MOBILE_IMAGES}$countNumber.png";
            }
            print(url);
            controllerForward.forward();
          });
        });
      });
    }
  }

  _getTreeGrowth() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("Score", "");
      _isLoading = true;
    });

    HTTPManager().treeGrowth(LogoutRequestModel(userId: id)).then((value)  {



      int count = value["response_count"];
      countNumber = value["response_count"];

      setState(() {
        sharedPreferences.setString("Score", countNumber.toString());
      });

     //  if(count == 0) {
     //    countNumber = 0;
     // //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
     //  } else {
        _changeImage(count);
      //}
      setState(() {
        errorMessage = "";
        _isLoading = false;
      });
    //  showToastMessage(context, value['message'].toString(),true);
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        errorMessage = e.toString();
      });
      showToastMessage(context, e.toString(),false);
    });

  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });

    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

    name = _sharedPreferences.getString(UserConstants().userName)!;
    id = _sharedPreferences.getString(UserConstants().userId)!;
    print("Data getting called");
    print(name);
    print(id);
    _getTreeGrowth();
    setState(() {
      _isUserDataLoading = false;
    });
  }

  // List imageList = <String> [
  //   "assets/apple_tree/1.png",
  //   "assets/apple_tree/2.png",
  //   "assets/apple_tree/3.png",
  //   "assets/apple_tree/4.png",
  //   "assets/apple_tree/5.png",
  //   "assets/apple_tree/6.png",
  //   "assets/apple_tree/7.png",
  //   "assets/apple_tree/8.png",
  //   "assets/apple_tree/9.png",
  //   "assets/apple_tree/10.png",
  //   "assets/apple_tree/11.png",
  //   "assets/apple_tree/12.png",
  //   "assets/apple_tree/13.png",
  //   "assets/apple_tree/14.png",
  //   "assets/apple_tree/15.png",
  //   "assets/apple_tree/16.png",
  //   "assets/apple_tree/17.png",
  //   "assets/apple_tree/18.png",
  //   "assets/apple_tree/19.png",
  //   "assets/apple_tree/20.png",
  //   "assets/apple_tree/21.png",
  //   "assets/apple_tree/22.png",
  //   "assets/apple_tree/23.png",
  //   "assets/apple_tree/24.png",
  //   "assets/apple_tree/25.png",
  //   "assets/apple_tree/26.png",
  //   "assets/apple_tree/27.png",
  //   "assets/apple_tree/28.png",
  //   "assets/apple_tree/29.png",
  //   "assets/apple_tree/30.png",
  //   "assets/apple_tree/31.png",
  //   "assets/apple_tree/32.png",
  //   "assets/apple_tree/33.png",
  //   "assets/apple_tree/34.png",
  //   "assets/apple_tree/35.png",
  //   "assets/apple_tree/36.png",
  //   "assets/apple_tree/37.png",
  //
  // ];

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      appBar: _isUserDataLoading ? AppBarWidget().appBar(false,false,"","",false) : AppBarWidget().appBar(false,false,name,id,false),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
            },
            child: _isLoading ? Container(
              color: Colors.white,
              child:const Center(
                child: CircularProgressIndicator(),
              ),
            ) : errorMessage != "" ? Center(
              child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage,style:const TextStyle(fontSize: 25),),
                      const SizedBox(height: 5,),
                      GestureDetector(
                        onTap: () {
                          _getTreeGrowth();
                        },
                        child: OptionMcqAnswer(
                            TextButton(onPressed: () {
                              _getTreeGrowth();
                            }, child: const Text("Reload",style: TextStyle(fontSize:25,color: AppColors.redColor)),)
                        ),
                      )
                    ],
                  )
              ),
            ) : Container(
              color: Colors.white,
              alignment: Alignment.bottomCenter,
              child:AnimatedBuilder(
                animation: controllerForward,
                builder: (context, child) => FadeScaleTransition(
                  animation: controllerForward,
                  child: child,
                ),
                child:url == "" ? Container(
                  color: Colors.white,
                  child:const Center(
                    child: CircularProgressIndicator(),
                  ),
                ) : Center(
                  child: CachedNetworkImage(
                    imageUrl: url,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error,color: AppColors.redColor,),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
            },
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin:const EdgeInsets.only(top: 20),
                  child: Text(element.toString(),style:const TextStyle(fontSize: AppConstants.defaultFontSize),textAlign: TextAlign.center,)),
            ),
          )
        ],
      ),
    );
  }
}
