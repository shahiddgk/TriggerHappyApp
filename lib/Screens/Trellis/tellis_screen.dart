import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/PopMenuButton.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/add_widgets_button.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/bottom_sheet.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/expansion_tile_widget.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/name_field.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/save_button_widgets.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/model/request_model/read_trellis_model.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_data_saving_request.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_delete_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_identity_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/tribe_data_saving_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../../model/reponse_model/trellis_principle_data_response.dart';
import '../../model/request_model/trellis_ladder_request_model.dart';
import '../../model/request_model/trellis_principles_request_model.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';

class TrellisScreen extends StatefulWidget {
  const TrellisScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TrellisScreenState createState() => _TrellisScreenState();
}

class _TrellisScreenState extends State<TrellisScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  bool _isLoading = true;
  bool _isDataLoading = false;
  late bool isPhone;
  late List <dynamic> trellisData;
  List <dynamic> trellisLadderDataForGoalsAchievements = [];
  List <dynamic> trellisLadderDataForGoals = [];
  List <dynamic> trellisLadderDataForGoalsChallenges = [];
  List <dynamic> trellisLadderDataForAchievements = [];
  late List <dynamic> trellisIdentityNeedsData;
  List <dynamic> trellisNeedsData = [];
  List <dynamic> trellisIdentityData = [];
  List <Trellis_principle_data_model_class> trellisPrinciplesRhythmsData = [];
  List <Trellis_principle_data_model_class> trellisPrinciplesData = [];
  List <Trellis_principle_data_model_class> trellisRhythmsData = [];
  List <dynamic> trellisTribeData = [];
  late Trellis_principle_data_model_class trellis_principle_data_model_class;

  String initialValueForType = "physical";
  List itemsForType = ["physical","Emotional","Relational","Work","Financial","Spiritual"];

  String initialValueForMType = "Memories";
  List itemsForMType = ["Memories","Achievements"];

  String initialValueForGoals = "Goals";
  String initialValueForMGoals = "Goals";
  List itemsForGoals = <String>["Goals","Challenges"];

  bool isNameExpanded = false;
  bool isPurposeExpanded = false;
  bool isLadderExpanded = false;
  bool isOPExpanded = false;
  bool isRhythmsExpanded = false;
  bool isNeedsExpanded = false;
  bool isIdentityExpanded = false;
  bool isTribeExpanded = false;

  bool isMentorVisible = true;
  bool isPeerVisible = false;
  bool isMenteeVisible = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController purposeController = TextEditingController();

  TextEditingController dateForGController = TextEditingController();
  TextEditingController titleForGController = TextEditingController();
  TextEditingController descriptionForGController = TextEditingController();
  TextEditingController dateForMController = TextEditingController();
  TextEditingController titleForMController = TextEditingController();
  TextEditingController descriptionForMController = TextEditingController();

  TextEditingController empoweredTruthOPController = TextEditingController();
  TextEditingController powerlessOpController = TextEditingController();
  TextEditingController empoweredTruthRhController = TextEditingController();
  TextEditingController powerlessRhController = TextEditingController();

  TextEditingController needsController = TextEditingController();
  TextEditingController identityController = TextEditingController();

  TextEditingController mentorNameController = TextEditingController();
 // TextEditingController mentorDescriptionController = TextEditingController();
  TextEditingController peerNameController = TextEditingController();
 // TextEditingController peerDescriptionController = TextEditingController();
  TextEditingController menteeNameController = TextEditingController();
  //TextEditingController menteeDescriptionController = TextEditingController();


  String titleTrellis = "https://www.youtube.com/watch?v=GFqe2n4vnNU";
  String nameUrl = "https://www.youtube.com/watch?v=Z_9dsRt2cvQ";
  String purposeUrl = "https://www.youtube.com/watch?v=SMc9h2t-W4U";
  String ladderUrl = "https://www.youtube.com/watch?v=6g8EcajHQPY";
  String oPUrl = "https://www.youtube.com/watch?v=8yhH70QFBQ4";
  String identityUrl = "https://www.youtube.com/watch?v=iqUEdMLACs8";
  String rhythmsUrl = "https://www.youtube.com/watch?v=4_9pRALrO1k&t=3s";
  String tribeUrl = "https://www.youtube.com/watch?v=2PqaSGRZgI0";
  String needsUrl = "https://www.youtube.com/watch?v=v6wVjS_w_6Q";

  // String urlFirst = "https://www.youtube.com/watch?v=GFqe2n4vnNU";
  // String urlSecond = "https://www.youtube.com/watch?v=v6wVjS_w_6Q";
  // String urlThird = "https://www.youtube.com/watch?v=iqUEdMLACs8";
  // String urlFourth = "https://www.youtube.com/watch?v=4_9pRALrO1k";
  // String urlFifth = "https://www.youtube.com/watch?v=2PqaSGRZgI0";

  bool empoweredTruthOR = true;
  bool powerLessBelievedOR = true;

  bool empoweredTruthRhythms = true;
  bool powerLessBelievedRhythms = true;
//  late final YoutubePlayerController _playerController;

  // bool isNameExpanded = false;
  // bool isPurposeExpanded = false;
  // bool isLadderExpanded = false;
  // bool isOPExpanded = false;
  // bool isRhythmsExpanded = false;
  // bool isNeedsExpanded = false;
  // bool isIdentityExpanded = false;
  // bool isTribeExpanded = false;



  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // ignore: avoid_print
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

    _getTrellisReadData();
    _getPrinciplesData();
    _getIdentityData();
    _getNeedsData();
    _getTribeData();
  }

  _getScreenStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isNameExpanded = sharedPreferences.getBool(TrellisScreenStatus().nameExpended)!;
     }

  _getScreenStatus2() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isPurposeExpanded = sharedPreferences.getBool(TrellisScreenStatus().purposeExpended)!;
    }

  _getScreenStatus3() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isLadderExpanded = sharedPreferences.getBool(TrellisScreenStatus().ladderExpended)!;
     }

  _getScreenStatus4() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isOPExpanded = sharedPreferences.getBool(TrellisScreenStatus().oPExpended)!;
    }

  _getScreenStatus5() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isRhythmsExpanded = sharedPreferences.getBool(TrellisScreenStatus().rhythmsExpended)!;
     }

  _getScreenStatus6() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     isNeedsExpanded = sharedPreferences.getBool(TrellisScreenStatus().needsExpended)!;
     }

  _getScreenStatus7() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     isIdentityExpanded = sharedPreferences.getBool(TrellisScreenStatus().identityExpended)!;
     }

  _getScreenStatus8() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isTribeExpanded = sharedPreferences.getBool(TrellisScreenStatus().tribeExpended)!;
  }

  setScreenStatus(String key,bool value) async {
    print("Screen Status called");
    print(key);
    print(value);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(key == "Name") {
      sharedPreferences.setBool(TrellisScreenStatus().nameExpended, value);
    } else if(key == "Purpose") {
      sharedPreferences.setBool(TrellisScreenStatus().purposeExpended, value);
    } else if(key == "Ladder") {
      sharedPreferences.setBool(TrellisScreenStatus().ladderExpended, value);
    } else if(key == "OP") {
      sharedPreferences.setBool(TrellisScreenStatus().oPExpended, value);
    } else if(key == "Rh") {
      sharedPreferences.setBool(TrellisScreenStatus().rhythmsExpended, value);
    } else if(key == "Needs") {
      sharedPreferences.setBool(TrellisScreenStatus().needsExpended, value);
    } else if(key == "Identity") {
      sharedPreferences.setBool(TrellisScreenStatus().identityExpended, value);
    } else if(key == "Tribe") {
      sharedPreferences.setBool(TrellisScreenStatus().tribeExpended, value);
    }

  }

  @override
  void initState() {
    _getUserData();
    _getScreenStatus();
    _getScreenStatus2();
    _getScreenStatus3();
    _getScreenStatus4();
    _getScreenStatus5();
    _getScreenStatus6();
    _getScreenStatus7();
    _getScreenStatus8();
    // TODO: implement initState
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _getNeedsData() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'ladder')).then((value) {

      trellisLadderDataForGoalsAchievements = value['data'];
      for(int i=0; i<trellisLadderDataForGoalsAchievements.length;i++) {
        if (trellisLadderDataForGoalsAchievements[i]['type'].toString() == "goal") {
          if(trellisLadderDataForGoalsAchievements[i]['option2'] == "Challenges") {
            trellisLadderDataForGoalsChallenges.add(trellisLadderDataForGoalsAchievements[i]);
          }else {
            trellisLadderDataForGoals.add(
                trellisLadderDataForGoalsAchievements[i]);
          }

          } else {
          trellisLadderDataForAchievements.add(trellisLadderDataForGoalsAchievements[i]);
        }

      }
      setState(() {
        _isLoading = false;
      });
      print("Ladder Data Load");
      // setState(() {
      //   _isLoading = false;
      // });
    }).catchError((e) {

      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getIdentityData() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'identity')).then((value) {

      trellisIdentityNeedsData = value['data'];
      for(int i=0; i<trellisIdentityNeedsData.length;i++) {
        if (trellisIdentityNeedsData[i]['text'] != "") {
          if (trellisIdentityNeedsData[i]['type'].toString() == "identity") {
            trellisIdentityData.add(trellisIdentityNeedsData[i]);
          } else {
            trellisNeedsData.add(trellisIdentityNeedsData[i]);
          }
        }
      }
      print("Identity Data");
      print(trellisIdentityData);
      print(trellisNeedsData);

      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      print(e.toString());
      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getPrinciplesData() {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'principles')).then((value) {

      TrellisResponseListModel trellisResponseListModel  = TrellisResponseListModel.fromJson(value['data']);
      trellisPrinciplesRhythmsData = trellisResponseListModel.values;
      for(int i=0; i<trellisPrinciplesRhythmsData.length;i++) {
          if (trellisPrinciplesRhythmsData[i].type.toString() == "principles") {
            trellisPrinciplesData.add(trellisPrinciplesRhythmsData[i]);
          } else {
            trellisRhythmsData.add(trellisPrinciplesRhythmsData[i]);
          }
      }

      setState(() {
        _isLoading = false;
      });

      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {

      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getTribeData() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'tribe')).then((value) {
      trellisTribeData = value['data'];

      setState(() {
        _isLoading = false;
      });
      print(trellisTribeData);
      print(value);
      print("Trellis Tribe Data");
    }).catchError((e) {

      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getTrellisReadData() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'trellis')).then((value) {
      trellisData = value['data'];
      if(trellisData.isNotEmpty) {
        setState(() {
          nameController.text = trellisData[0]['name'];
          descriptionController.text = trellisData[0]['name_desc'];

          purposeController.text = trellisData[0]['purpose'];

          // mentorNameController.text = trellisData[0]['mentor'];
          // mentorDescriptionController.text = trellisData[0]['mentor_desc'];
          // peerNameController.text = trellisData[0]['peer'];
          // peerDescriptionController.text = trellisData[0]['peer_desc'];
          // menteeNameController.text = trellisData[0]['mentee'];
         // menteeDescriptionController.text = trellisData[0]['mentee_desc'];
          _isLoading = false;
        });
      }
      setState(() {
        _isLoading = false;
      });
      print(trellisData);
      print("Trellis Data");
    }).catchError((e) {

      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<bool> _onWillPop() async {
    // if(nameController.text.isNotEmpty || descriptionController.text.isNotEmpty || purposeController.text.isNotEmpty || mentorNameController.text.isNotEmpty || mentorDescriptionController.text.isNotEmpty || peerNameController.text.isNotEmpty || peerDescriptionController.text.isNotEmpty || menteeNameController.text.isNotEmpty || menteeDescriptionController.text.isNotEmpty) {
    //   _setTrellisData();
    // }

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
            onPressed: () {
              // if(nameController.text.isNotEmpty || descriptionController.text.isNotEmpty || purposeController.text.isNotEmpty || mentorNameController.text.isNotEmpty  || peerNameController.text.isNotEmpty || menteeNameController.text.isNotEmpty ) {
              //   _setTrellisData();
              // }
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
            },
          ),
          title: Text(_isUserDataLoading ? "" : name),
          actions:  [
            PopMenuButton(false,false,id)
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _isLoading ? const Center(child: CircularProgressIndicator(),)  : Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LogoScreen("Trellis"),
                            const SizedBox(width: 20,),
                          IconButton(onPressed: (){
                            String? videoId = YoutubePlayer.convertUrlToId(titleTrellis);
                            YoutubePlayerController playerController = YoutubePlayerController(
                                initialVideoId: videoId!,
                                flags: const YoutubePlayerFlags(
                                  autoPlay: false,
                                  controlsVisibleAtStart: false,
                                )

                            );
                            videoPopupDialog(context,"Introduction to Trellis",playerController);
                            //bottomSheet(context,"Trellis","Welcome to Trellis, the part of the Brugeon app designed to help you flourish and live life intentionally. Trellis is a light structure that provides structure and focus, and helps propel you towards your desired outcomes. Invest at least five minutes a day in reviewing and meditating on your Trellis. If you don't have any answers yet, spend your time meditating, praying, or journaling on the questions/sections. If you have partial answers, keep taking your time daily to consider the questions and your answers. By consistently returning to your Trellis, you will become more clear and focused on creating the outcomes you desire. Enjoy your Trellis!","");
                          }, icon: const Icon(Icons.ondemand_video,size:30,color: AppColors.infoIconColor,))
                        ],
                    ),

                    const SizedBox(height: 5,),

                    ExpansionTileWidgetScreen(isNameExpanded,"Name",isNameExpanded,descriptionController.text,nameController.text,true,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Name",value);
                      setState(() {
                        isNameExpanded = value;
                      });
                        },() {
                      String? videoId = YoutubePlayer.convertUrlToId(nameUrl);
                      YoutubePlayerController _playerController = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to name",_playerController);
                     // bottomSheet(context,"Name","Names have meaning and power. Try searching the meanings of the names of the five closest people to you. You'll likely find that they live up to their meaning. Fill in your first and middle name in the name section, and write the meaning in the description. Your name can give clues about who you are and who you're meant to be.","");
                    },
                        <Widget>[
                          Container(
                            decoration:const BoxDecoration(
                              color: AppColors.lightGreyColor,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                            ),
                            padding:const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Container(
                                    margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                    child: Focus(
                                      // onFocusChange: (hasFocus) {
                                      //   print('Name Field:  $hasFocus');
                                      //   if(!hasFocus && nameController.text.isNotEmpty) {
                                      //     _setTrellisData ();
                                      //   }
                                      //   },
                                        child: NameField(nameController,"Name",1,70,false))),
                                Container(
                                    margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                    child: Focus(
                                      // onFocusChange: (hasFocus) {
                                      //   print('Description Field:  $hasFocus');
                                      //   if(!hasFocus && descriptionController.text.isNotEmpty) {
                                      //     _setTrellisData ();
                                      //   }
                                      // },
                                        child: NameField(descriptionController,"Description",1,70,false))),
                                SaveButtonWidgets( (){
                                  _setTrellisData();
                                }),
                              ],
                            ),
                          )
                        ]
                    ),

                    ExpansionTileWidgetScreen(isPurposeExpanded,"Purpose",isPurposeExpanded,purposeController.text,"",true,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Purpose",value);
                      setState(() {
                        isPurposeExpanded = value;
                      });
                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(purposeUrl);
                      YoutubePlayerController _playerController = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to purpose",_playerController);
                     // bottomSheet(context,"Purpose","Define your purpose and keep it in focus daily for success. In the Purpose section, write a sentence about your life purpose. Review and tweak it daily until it feels right. Use exercises to help uncover your purpose. If unsure, write the first thing that comes to mind. Imagine your headstone for inspiration. Enjoy living out your purpose!","");
                    },
                        <Widget>[
                          Container(
                            decoration:const BoxDecoration(
                              color: AppColors.lightGreyColor,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                            ),
                            padding:const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Container(
                                    margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                    child: Focus(
                                      // onFocusChange: (hasFocus) {
                                      //   print('Purpose Field:  $hasFocus');
                                      //   if(!hasFocus && purposeController.text.isNotEmpty) {
                                      //     _setTrellisData ();
                                      //   }
                                      // },
                                        child: NameField(purposeController,"Purpose",4,100,false))),
                                SaveButtonWidgets( (){
                                  _setTrellisData();
                                }),
                              ],
                            ),
                          )

                        ]
                    ),

                    ExpansionTileWidgetScreen(isLadderExpanded,"Ladder",isLadderExpanded,"Goals/challenges,Memories/Achievements","",false,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Ladder",value);

                      setState(() {
                        isLadderExpanded = value;
                      });
                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(ladderUrl);
                      YoutubePlayerController _playerController = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Ladder",_playerController);
                     // bottomSheet(context,"Ladder","Use the Ladder exercise to take a historical view of your life. Divide events into past (Memories & Achievements) and future (Goals & Challenges). See patterns and direction in one linear path.","");
                    },
                        <Widget>[

                          Container(
                            decoration:const BoxDecoration(
                              color: AppColors.lightGreyColor,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                            ),
                            padding:const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Container(
                                  margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Goals/Challenges",style: TextStyle(
                                              fontSize: AppConstants.defaultFontSize,
                                              color: AppColors.primaryColor
                                          ),),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            onPressed: (){
                                              bottomSheet(context,"Goals/Challenges","Healthy goals lead to greater flourishing. Use S.M.A.R.T goals (Specific, Measurable, Attainable, Relevant, Timely) to ensure clarity and confirm accomplishment. Benchmarks are smaller goals. Challenges are unsatisfactory areas not yet committed to changing. Remember the six major life areas when setting goals.","");
                                            },
                                            icon:const Icon(Icons.info_outline,size:20,color: AppColors.infoIconColor,)),
                                        ],
                                      ),

                                      AddButton( trellisLadderDataForGoals.length>=2,(){

                                        ladderBottomSheet(context,true,"Ladder","Goals/Challenges",
                                            initialValueForType,itemsForType,
                                            initialValueForGoals,itemsForGoals,
                                                (){_setLadderGoalsData();},
                                                (value) {
                                                    setState(() {
                                                      initialValueForGoals = value;
                                                    });
                                                },
                                                (value) {
                                                  setState(() {
                                                    initialValueForType = value;
                                                  });
                                                },
                                            dateForGController,
                                            titleForGController,
                                            descriptionForGController
                                        //     <Widget>[
                                        //   DropDownField(initialValueForType, itemsForType.map((item) {
                                        //     return  DropdownMenuItem(
                                        //       value: item.toString(),
                                        //       child: Text(item.toString()),
                                        //     );
                                        //   }).toList(), (value) {
                                        //     setState(() {
                                        //       initialValueForType = value;
                                        //     });
                                        //   }),
                                        //
                                        //   DropDownField(initialValueForGoals, itemsForGoals.map((item) {
                                        //     return  DropdownMenuItem(
                                        //       value: item.toString(),
                                        //       child: Text(item.toString()),
                                        //     );
                                        //   }).toList(), (value) {
                                        //     setState(() {
                                        //       initialValueForGoals = value;
                                        //     });
                                        //   }),
                                        //
                                        //   Visibility(
                                        //       visible: initialValueForGoals != "Challenges",
                                        //       child: DatePickerField(dateForGController,"Select date",true)),
                                        //
                                        //   Container(
                                        //       margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                        //       child: NameField(titleForGController,"title",1,70,true)),
                                        //   Container(
                                        //       margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                        //       child: NameField(descriptionForGController,"description",4,70,true)),
                                        //   SaveButtonWidgets( (){
                                        //     _setLadderGoalsData();
                                        //   }),
                                        // ]
                                        );

                                      } ),

                                    ],
                                  ),
                                ),

                                trellisLadderDataForGoals.isEmpty ? const Text("") : Container(
                                  margin: const EdgeInsets.symmetric(vertical:5,horizontal: 10),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: trellisLadderDataForGoals.length,
                                      itemBuilder:(context,index) {
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => _buildPopupDialog(context,"Goals/Challenges",trellisLadderDataForGoals[index],false),
                                            );
                                          },
                                          child: Container(
                                              margin:const EdgeInsets.symmetric(vertical: 5),
                                             decoration: BoxDecoration(
                                               color: AppColors.backgroundColor,
                                               borderRadius: BorderRadius.circular(10)
                                             ),
                                              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("${trellisLadderDataForGoals[index]['option1']} | ${trellisLadderDataForGoals[index]['option2']}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                                      IconButton(onPressed: () {
                                                        _deleteRecord("goal", trellisLadderDataForGoals[index]['id'].toString(),index,trellisLadderDataForGoals[index]['option2']);
                                                      }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                                    ],
                                                  ),
                                                  // Align(alignment: Alignment.topRight,
                                                  //   child: IconButton(
                                                  //     onPressed: () {},
                                                  //     icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                  //   ),),
                                                  Align(
                                                      alignment: Alignment.topLeft,
                                                      child:  Text("${DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForGoals[index]['date'].toString()))} | ${trellisLadderDataForGoals[index]['text']} | ${trellisLadderDataForGoals[index]['description']}"))
                                                ],
                                              )),
                                        );
                                      }
                                  ),
                                ),
                              //  const Divider(),
                                trellisLadderDataForGoalsChallenges.isEmpty ? const Text("") : Container(
                                  margin: const EdgeInsets.symmetric(vertical:5,horizontal: 10),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: trellisLadderDataForGoalsChallenges.length,
                                      itemBuilder:(context,index) {
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => _buildPopupDialog(context,"Goals/Challenges",trellisLadderDataForGoalsChallenges[index],false),
                                            );
                                          },
                                          child: Container(
                                              margin:const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: AppColors.backgroundColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("${trellisLadderDataForGoalsChallenges[index]['option1']} | ${trellisLadderDataForGoalsChallenges[index]['option2']}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                                      IconButton(onPressed: () {
                                                        _deleteRecord("goal", trellisLadderDataForGoalsChallenges[index]['id'].toString(),index,trellisLadderDataForGoalsChallenges[index]['option2']);
                                                      }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                                    ],
                                                  ),
                                                  // Align(alignment: Alignment.topRight,
                                                  //   child: IconButton(
                                                  //     onPressed: () {},
                                                  //     icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                  //   ),),
                                                  Align(
                                                      alignment: Alignment.topLeft,
                                                      child:  Text(" ${trellisLadderDataForGoalsChallenges[index]['text']} "))
                                                ],
                                              )),
                                        );
                                      }
                                  ),
                                ),

                                const Divider(),

                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                         const Text("Memories/Achievements",style: TextStyle(
                                              fontSize: AppConstants.defaultFontSize,
                                              color: AppColors.primaryColor
                                          ),),
                                         const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            onPressed: (){
                                              bottomSheet(context,"Memories/Achievements","Memories & Achievements are significant events that shape us. Memories are things that happened to us, while achievements are things we worked to accomplish. Convert goals to achievements once completed.","");
                                            },
                                            icon:Icon(Icons.info_outline,size:20,color: AppColors.infoIconColor,)),
                                        ],
                                      ),

                                      AddButton(trellisLadderDataForAchievements.length>=2,
                                          () {
                                            ladderBottomSheet(context,false,"Ladder","Memories/Achievements",
                                                initialValueForMType,itemsForMType,
                                                initialValueForMGoals,itemsForGoals,
                                                    (){_setLadderMemoriesData();},
                                                    (value) {
                                                  setState(() {
                                                    initialValueForMGoals = value;
                                                  });
                                                },
                                                    (value) {
                                                  setState(() {
                                                    initialValueForMType = value;
                                                  });
                                                },
                                                dateForMController,
                                                titleForMController,
                                                descriptionForMController
                                            //     <Widget>[
                                            //
                                            //   DropDownField(initialValueForMType, itemsForMType.map((item) {
                                            //     return  DropdownMenuItem(
                                            //       value: item.toString(),
                                            //       child: Text(item.toString()),
                                            //     );
                                            //   }).toList(), (value) {
                                            //     setState(() {
                                            //       initialValueForMType = value;
                                            //     });
                                            //   }),
                                            //
                                            //   DropDownField(initialValueForMGoals, itemsForGoals.map((item) {
                                            //     return  DropdownMenuItem(
                                            //       value: item.toString(),
                                            //       child: Text(item.toString()),
                                            //     );
                                            //   }).toList(), (value) {
                                            //     setState(() {
                                            //       initialValueForMGoals = value;
                                            //     });
                                            //   }),
                                            //
                                            //   Visibility(
                                            //       visible: initialValueForMGoals != "Challenges",
                                            //       child: DatePickerField(dateForMController,"Select date",false)),
                                            //
                                            //   Container(
                                            //       margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                            //       child: NameField(titleForMController,"title",1,70,true)),
                                            //   Container(
                                            //       margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                            //       child: NameField(descriptionForMController,"description",4,70,true)),
                                            //   SaveButtonWidgets( (){
                                            //     _setLadderMemoriesData();
                                            //   }),
                                            //
                                            // ]
                                            );
                                          }
                                      ),

                                    ],
                                  ),
                                ),

                                trellisLadderDataForAchievements.isEmpty ?const Text("") : Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: trellisLadderDataForAchievements.length,
                                      itemBuilder:(context,index) {
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements",trellisLadderDataForAchievements[index],true),
                                            );
                                          },
                                          child: Container(
                                              margin:const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: AppColors.backgroundColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("${trellisLadderDataForAchievements[index]['option1']} | ${trellisLadderDataForAchievements[index]['option2']}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                                      IconButton(onPressed: () {
                                                        _deleteRecord("achievements", trellisLadderDataForAchievements[index]['id'],index,"");
                                                      }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                                    ],
                                                  ),
                                                  Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("${DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForAchievements[index]['date'].toString()))} | ${trellisLadderDataForAchievements[index]['text']}"))
                                                ],
                                              )),
                                        );
                                      }
                                  ),
                                ),
                              ],
                            ),
                          )

                        ]
                    ),

                    ExpansionTileWidgetScreen(isOPExpanded,"Organizing Principles",isOPExpanded,"Empowered truths,Powerless beliefs","",false,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("OP",value);

                      setState(() {
                        isOPExpanded = value;
                      });
                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(oPUrl);
                      YoutubePlayerController _playerController = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Organizing Principle",_playerController);
                     // bottomSheet(context,"Organizing Principles","Two organizing principles shape us: Powerless Beliefs and Empowered Truths. Powerless Beliefs are negative, unconsciously formed around fear or shame in our formative years, such as I don't have what it takes. Empowered Truths are core, empowering principles to organize our lives around, such as There is goodness in me, for me, and through me. Shade out powerless beliefs.","");
                    },
                        <Widget>[
                          AddButton(trellisPrinciplesData.length>=2,() {
                            needsBottomSheet(context, "Organizing Principles", <Widget>[
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          margin:const EdgeInsets.only(left: 10,right: 10),
                                          child: Row(
                                            children: [
                                              Image.asset("assets/arm.png"),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const  Text("Empowered truths",style: TextStyle(color: AppColors.primaryColor),)
                                            ],
                                          )),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     setState(() {
                                      //       empoweredTruthOR = !empoweredTruthOR;
                                      //     });
                                      //   },
                                      //   child: Container(
                                      //       margin:const EdgeInsets.only(left: 10,right: 10),
                                      //       child: Row(
                                      //         children: [
                                      //           Image.asset(empoweredTruthOR ? "assets/close_eye.png" : "assets/open_eye.png"),
                                      //           const SizedBox(
                                      //             width: 5,
                                      //           ),
                                      //         //  Text(empoweredTruthOR ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                                      //         ],
                                      //       )
                                      //   ),
                                      // )

                                    ],
                                  ),

                                  Container(
                                      margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                      child: Visibility(
                                          visible: empoweredTruthOR,
                                          child: Focus(
                                            // onFocusChange: (hasFocus) {
                                            //   print('empowered truths OP:  $hasFocus');
                                            //   if(!hasFocus && empoweredTruthOPController.text.isNotEmpty) {
                                            //     _setTrellisData ();
                                            //    }
                                            //   },
                                              child: NameField(empoweredTruthOPController,"empowered truth",1,70,true)))),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Container(
                                          margin:const EdgeInsets.only(left: 10,right: 10),
                                          child: Row(

                                            children: [
                                              Image.asset("assets/emoji.png"),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const  Text("Powerless Belief",style: TextStyle(color: AppColors.primaryColor),)
                                            ],
                                          )),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     setState(() {
                                      //       powerLessBelievedOR = !powerLessBelievedOR;
                                      //     });
                                      //   },
                                      //   child: Container(
                                      //       margin:const EdgeInsets.only(left: 10,right: 10),
                                      //       child: Row(
                                      //         children: [
                                      //           Image.asset(powerLessBelievedOR ? "assets/close_eye.png" : "assets/open_eye.png"),
                                      //           const SizedBox(
                                      //             width: 5,
                                      //           ),
                                      //           Text(powerLessBelievedOR ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                                      //         ],
                                      //       )
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Container(
                                      margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                      child: Visibility(
                                          visible: powerLessBelievedOR,
                                          child: Focus(
                                            // onFocusChange: (hasFocus) {
                                            //   print('PowerLess believes OP Field:  $hasFocus');
                                            //   if(!hasFocus && powerlessOpController.text.isNotEmpty) {
                                            //     _setTrellisData ();
                                            //   }
                                            // },
                                              child: NameField(powerlessOpController,"powerless Belief",1,70,true)))),
                                  SaveButtonWidgets( (){
                                    _setTrellisOPData();
                                  }),
                                ],
                              ),
                            ]);
                          }),

                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: trellisPrinciplesData.isEmpty ? const Align(
                                alignment: Alignment.topLeft,
                                child: Text("")) : ListView.builder(
                                shrinkWrap: true,
                                itemCount: trellisPrinciplesData.length,
                                itemBuilder:(context,index) {
                                  return GestureDetector(
                                    // onTap: () {
                                    //   showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                                    //   );
                                    // },
                                    child: Container(
                                        margin:const EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                            color: AppColors.backgroundColor,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        margin:const EdgeInsets.only(left: 10,right: 10),
                                                        alignment: Alignment.centerLeft,
                                                        child: Row(
                                                          children: [
                                                            Image.asset("assets/arm.png"),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            const  Text("Empowered truths",style: TextStyle(color: AppColors.primaryColor),)
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    _deleteRecord("principles", trellisPrinciplesData[index].id.toString(),index,"");
                                                  },
                                                  icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                )
                                              ],
                                            ),
                                            // Align(alignment: Alignment.topRight,
                                            //   child: ,),
                                            Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Padding(
                                                    padding:const EdgeInsets.only(left:10,right:10,bottom: 10),
                                                      child: Text(trellisPrinciplesData[index].empTruths.toString()),
                                                  ),
                                                  const SizedBox(height: 5,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                          margin:const EdgeInsets.only(left: 10,right: 10),
                                                          child: Row(

                                                            children: [
                                                              Image.asset("assets/emoji.png"),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              const  Text("Powerless Belief",style: TextStyle(color: AppColors.primaryColor),)
                                                            ],
                                                          )),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            trellisPrinciplesData[index].visibility = !trellisPrinciplesData[index].visibility!;
                                                          });
                                                        },
                                                        child: Container(
                                                            margin:const EdgeInsets.only(left: 10,right: 10),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(trellisPrinciplesData[index].visibility! ? "assets/close_eye.png" : "assets/open_eye.png"),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(trellisPrinciplesData[index].visibility! ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                                                              ],
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  )   ,
                                                  Visibility(
                                                      visible: trellisPrinciplesData[index].visibility!,
                                                      child: Padding(
                                                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          child: Text(trellisPrinciplesData[index].powerlessBelieves.toString()))),
                                                ],
                                              ),
                                            )
                                              ],
                                        )),
                                  );
                                }
                            ),
                          ),

                          // Container(
                          //   decoration:const BoxDecoration(
                          //       color: AppColors.lightGreyColor,
                          //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                          //   ),
                          //   padding:const EdgeInsets.symmetric(vertical: 10),
                          //   child: Column(
                          //     children: [
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Container(
                          //               margin:const EdgeInsets.only(left: 10,right: 10),
                          //               child: Row(
                          //                 children: [
                          //                   Image.asset("assets/arm.png"),
                          //                   const SizedBox(
                          //                     width: 5,
                          //                   ),
                          //                   const  Text("Empowered truths",style: TextStyle(color: AppColors.primaryColor),)
                          //                 ],
                          //               )),
                          //           GestureDetector(
                          //             onTap: () {
                          //               setState(() {
                          //                 empoweredTruthOR = !empoweredTruthOR;
                          //               });
                          //             },
                          //             child: Container(
                          //                 margin:const EdgeInsets.only(left: 10,right: 10),
                          //                 child: Row(
                          //                   children: [
                          //                     Image.asset(empoweredTruthOR ? "assets/close_eye.png" : "assets/open_eye.png"),
                          //                     const SizedBox(
                          //                       width: 5,
                          //                     ),
                          //                     Text(empoweredTruthOR ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                          //                   ],
                          //                 )
                          //             ),
                          //           )
                          //
                          //         ],
                          //       ),
                          //
                          //       Container(
                          //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                          //           child: Visibility(
                          //               visible: empoweredTruthOR,
                          //               child: Focus(
                          //                 // onFocusChange: (hasFocus) {
                          //                 //   print('empowered truths OP:  $hasFocus');
                          //                 //   if(!hasFocus && empoweredTruthOPController.text.isNotEmpty) {
                          //                 //     _setTrellisData ();
                          //                 //    }
                          //                 //   },
                          //                   child: NameField(empoweredTruthOPController,"empowered truth",1,70,false)))),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //
                          //           Container(
                          //               margin:const EdgeInsets.only(left: 10,right: 10),
                          //               child: Row(
                          //
                          //                 children: [
                          //                   Image.asset("assets/emoji.png"),
                          //                   const SizedBox(
                          //                     width: 5,
                          //                   ),
                          //                   const  Text("Powerless believes",style: TextStyle(color: AppColors.primaryColor),)
                          //                 ],
                          //               )),
                          //           GestureDetector(
                          //             onTap: () {
                          //               setState(() {
                          //                 powerLessBelievedOR = !powerLessBelievedOR;
                          //               });
                          //             },
                          //             child: Container(
                          //                 margin:const EdgeInsets.only(left: 10,right: 10),
                          //                 child: Row(
                          //                   children: [
                          //                     Image.asset(powerLessBelievedOR ? "assets/close_eye.png" : "assets/open_eye.png"),
                          //                     const SizedBox(
                          //                       width: 5,
                          //                     ),
                          //                     Text(powerLessBelievedOR ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                          //                   ],
                          //                 )
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       Container(
                          //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                          //           child: Visibility(
                          //               visible: powerLessBelievedOR,
                          //               child: Focus(
                          //                 // onFocusChange: (hasFocus) {
                          //                 //   print('PowerLess believes OP Field:  $hasFocus');
                          //                 //   if(!hasFocus && powerlessOpController.text.isNotEmpty) {
                          //                 //     _setTrellisData ();
                          //                 //   }
                          //                 // },
                          //                   child: NameField(powerlessOpController,"powerless believes",1,70,false)))),
                          //       SaveButtonWidgets( (){
                          //         _setTrellisOPData();
                          //       }),
                          //
                          //       Container(
                          //         margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          //         child: trellisPrinciplesData.isEmpty ? const Align(
                          //             alignment: Alignment.topLeft,
                          //             child: Text("")) : ListView.builder(
                          //             shrinkWrap: true,
                          //             itemCount: trellisPrinciplesData.length,
                          //             itemBuilder:(context,index) {
                          //               return GestureDetector(
                          //                 // onTap: () {
                          //                 //   showDialog(
                          //                 //     context: context,
                          //                 //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                          //                 //   );
                          //                 // },
                          //                 child: Container(
                          //                     margin:const EdgeInsets.symmetric(vertical: 5),
                          //                     decoration: BoxDecoration(
                          //                         color: AppColors.backgroundColor,
                          //                         borderRadius: BorderRadius.circular(10)
                          //                     ),
                          //                     padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                          //                     child: Column(
                          //                       children: [
                          //                         Align(alignment: Alignment.topRight,
                          //                           child: IconButton(
                          //                             onPressed: () {
                          //                               _deleteRecord("principles", trellisPrinciplesData[index]['id'],index);
                          //                             },
                          //                             icon:const Icon(Icons.delete,color: AppColors.redColor,),
                          //                           ),),
                          //                         Align(
                          //                             alignment: Alignment.topLeft,
                          //                             child: Text("${trellisPrinciplesData[index]['emp_truths'].toString()} | ${trellisPrinciplesData[index]['powerless_believes'].toString()} "))
                          //                       ],
                          //                     )),
                          //               );
                          //             }
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ]
                    ),

                    ExpansionTileWidgetScreen(isRhythmsExpanded,"Rhythms",isRhythmsExpanded,"Empowered rhythms,Powerless habits","",false,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Rh",value);

                      setState(() {
                        isRhythmsExpanded = value;
                      });
                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(rhythmsUrl);
                      YoutubePlayerController _playerController = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Rhythms",_playerController);
                    //  bottomSheet(context,"Rhythms","Rhythms are either principles or habitual behaviors that either increase or decrease our well-being. Empowered Rhythms bring life-giving results while Powerless Rhythms decrease overall flourishing. Example: Empowering Rhythm is waking up early to avoid rushing, while a Powerless Rhythm is talking over people.","");
                    },
                        <Widget>[

                          AddButton(trellisRhythmsData.length>=2,() {
                            needsBottomSheet(context, "Rhythms", <Widget>[
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          margin:const EdgeInsets.only(left: 10,right: 10),
                                          child: Row(
                                            children: [
                                              Image.asset("assets/arm.png"),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const  Text("Empowered Rhythms",style: TextStyle(color: AppColors.primaryColor),)
                                            ],
                                          )),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     setState(() {
                                      //       empoweredTruthRhythms = !empoweredTruthRhythms;
                                      //     });
                                      //   },
                                      //   child: Container(
                                      //       margin:const EdgeInsets.only(left: 10,right: 10),
                                      //       child: Row(
                                      //         children: [
                                      //           Image.asset(empoweredTruthRhythms ? "assets/close_eye.png" : "assets/open_eye.png"),
                                      //           const SizedBox(
                                      //             width: 5,
                                      //           ),
                                      //           Text(empoweredTruthRhythms ? "Hide" : "Show",style:const TextStyle(color: AppColors.primaryColor),)
                                      //         ],
                                      //       )
                                      //   ),
                                      // )

                                    ],
                                  ),

                                  Container(
                                      margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                      child: Visibility(
                                          visible: empoweredTruthRhythms,
                                          child: Focus(
                                            // onFocusChange: (hasFocus) {
                                            //   print('Empowered Truth Rh Field:  $hasFocus');
                                            //   if(!hasFocus && empoweredTruthRhController.text.isNotEmpty) {
                                            //     _setTrellisData ();
                                            //   }
                                            // },
                                              child: NameField(empoweredTruthRhController,"empowered rhythms",1,70,true)))),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Container(
                                          margin:const EdgeInsets.only(left: 10,right: 10),
                                          child: Row(

                                            children: [
                                              Image.asset("assets/emoji.png"),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const  Text("Powerless habits",style: TextStyle(color: AppColors.primaryColor),)
                                            ],
                                          )),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     setState(() {
                                      //       powerLessBelievedRhythms = !powerLessBelievedRhythms;
                                      //     });
                                      //   },
                                      //   child: Container(
                                      //       margin:const EdgeInsets.only(left: 10,right: 10),
                                      //       child: Row(
                                      //         children: [
                                      //           Image.asset(powerLessBelievedRhythms ? "assets/close_eye.png" : "assets/open_eye.png"),
                                      //           const SizedBox(
                                      //             width: 5,
                                      //           ),
                                      //           Text(powerLessBelievedRhythms ? "Hide" : "Show",style:const TextStyle(color: AppColors.primaryColor),)
                                      //         ],
                                      //       )
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Container(
                                      margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                      child: Visibility(
                                          visible: powerLessBelievedRhythms,
                                          child: Focus(
                                            // onFocusChange: (hasFocus) {
                                            //   print('PowerLess believe Rh Field:  $hasFocus');
                                            //   if(!hasFocus && powerlessRhController.text.isNotEmpty) {
                                            //     _setTrellisData ();
                                            //   }
                                            // },
                                              child: NameField(powerlessRhController,"powerless habits",1,70,true)))),

                                  SaveButtonWidgets( (){
                                    _setTrellisRhythmsData();
                                  }),

                                ],
                              ),
                            ]);
                          }),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: trellisRhythmsData.isEmpty ? const Align(
                                alignment: Alignment.topLeft,
                                child: Text("")) : ListView.builder(
                                shrinkWrap: true,
                                itemCount: trellisRhythmsData.length,
                                itemBuilder:(context,index) {
                                  return GestureDetector(
                                    // onTap: () {
                                    //   showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                                    //   );
                                    // },
                                    child: Container(
                                        margin:const EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                            color: AppColors.backgroundColor,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        margin:const EdgeInsets.only(left: 10,right: 10),
                                                        alignment: Alignment.centerLeft,
                                                        child: Row(
                                                          children: [
                                                            Image.asset("assets/arm.png"),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            const  Text("Empowered rhythms",style: TextStyle(color: AppColors.primaryColor),)
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    _deleteRecord("rhythms", trellisRhythmsData[index].id.toString(),index,"");
                                                  },
                                                  icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                ),
                                              ],
                                            ),
                                            // Align(alignment: Alignment.topRight,
                                            //   child: IconButton(
                                            //     onPressed: () {
                                            //       _deleteRecord("rhythms", trellisRhythmsData[index].id.toString(),index);
                                            //     },
                                            //     icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                            //   ),),
                                            Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Padding(
                                                    padding:const EdgeInsets.only(left:10,right:10,bottom: 10),
                                                    child: Text(trellisRhythmsData[index].empTruths.toString()),
                                                  ),
                                                  const SizedBox(height: 5,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                          margin:const EdgeInsets.only(left: 10,right: 10),
                                                          child: Row(

                                                            children: [
                                                              Image.asset("assets/emoji.png"),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              const  Text("Powerless habits",style: TextStyle(color: AppColors.primaryColor),)
                                                            ],
                                                          )),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            trellisRhythmsData[index].visibility = !trellisRhythmsData[index].visibility!;
                                                          });
                                                        },
                                                        child: Container(
                                                            margin:const EdgeInsets.only(left: 10,right: 10),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(trellisRhythmsData[index].visibility! ? "assets/close_eye.png" : "assets/open_eye.png"),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(trellisRhythmsData[index].visibility! ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                                                              ],
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  )   ,
                                                  Visibility(
                                                      visible: trellisRhythmsData[index].visibility!,
                                                      child: Padding(
                                                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                          child: Text(trellisRhythmsData[index].powerlessBelieves.toString()))),
                                                ],
                                              ),
                                            ),
                                            // Align(
                                            //     alignment: Alignment.topLeft,
                                            //     child: Text("${trellisRhythmsData[index].empTruths.toString()} | ${trellisRhythmsData[index].powerlessBelieves.toString()} "))
                                          ],
                                        )),
                                  );
                                }
                            ),
                          ),
                          // Container(
                          //   decoration:const BoxDecoration(
                          //     color: AppColors.lightGreyColor,
                          //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                          //   ),
                          //   padding:const EdgeInsets.symmetric(vertical: 10),
                          //   child: Column(
                          //     children: [
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Container(
                          //               margin:const EdgeInsets.only(left: 10,right: 10),
                          //               child: Row(
                          //                 children: [
                          //                   Image.asset("assets/arm.png"),
                          //                   const SizedBox(
                          //                     width: 5,
                          //                   ),
                          //                   const  Text("Empowered truths",style: TextStyle(color: AppColors.primaryColor),)
                          //                 ],
                          //               )),
                          //           GestureDetector(
                          //             onTap: () {
                          //               setState(() {
                          //                 empoweredTruthRhythms = !empoweredTruthRhythms;
                          //               });
                          //             },
                          //             child: Container(
                          //                 margin:const EdgeInsets.only(left: 10,right: 10),
                          //                 child: Row(
                          //                   children: [
                          //                     Image.asset(empoweredTruthRhythms ? "assets/close_eye.png" : "assets/open_eye.png"),
                          //                     const SizedBox(
                          //                       width: 5,
                          //                     ),
                          //                     Text(empoweredTruthRhythms ? "Hide" : "Show",style:const TextStyle(color: AppColors.primaryColor),)
                          //                   ],
                          //                 )
                          //             ),
                          //           )
                          //
                          //         ],
                          //       ),
                          //
                          //       Container(
                          //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                          //           child: Visibility(
                          //               visible: empoweredTruthRhythms,
                          //               child: Focus(
                          //                 // onFocusChange: (hasFocus) {
                          //                 //   print('Empowered Truth Rh Field:  $hasFocus');
                          //                 //   if(!hasFocus && empoweredTruthRhController.text.isNotEmpty) {
                          //                 //     _setTrellisData ();
                          //                 //   }
                          //                 // },
                          //                   child: NameField(empoweredTruthRhController,"empowered truth",1,70,false)))),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //
                          //           Container(
                          //               margin:const EdgeInsets.only(left: 10,right: 10),
                          //               child: Row(
                          //
                          //                 children: [
                          //                   Image.asset("assets/emoji.png"),
                          //                   const SizedBox(
                          //                     width: 5,
                          //                   ),
                          //                   const  Text("Powerless believes",style: TextStyle(color: AppColors.primaryColor),)
                          //                 ],
                          //               )),
                          //           GestureDetector(
                          //             onTap: () {
                          //               setState(() {
                          //                 powerLessBelievedRhythms = !powerLessBelievedRhythms;
                          //               });
                          //             },
                          //             child: Container(
                          //                 margin:const EdgeInsets.only(left: 10,right: 10),
                          //                 child: Row(
                          //                   children: [
                          //                     Image.asset(powerLessBelievedRhythms ? "assets/close_eye.png" : "assets/open_eye.png"),
                          //                     const SizedBox(
                          //                       width: 5,
                          //                     ),
                          //                     Text(powerLessBelievedRhythms ? "Hide" : "Show",style:const TextStyle(color: AppColors.primaryColor),)
                          //                   ],
                          //                 )
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       Container(
                          //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                          //           child: Visibility(
                          //               visible: powerLessBelievedRhythms,
                          //               child: Focus(
                          //                 // onFocusChange: (hasFocus) {
                          //                 //   print('PowerLess believe Rh Field:  $hasFocus');
                          //                 //   if(!hasFocus && powerlessRhController.text.isNotEmpty) {
                          //                 //     _setTrellisData ();
                          //                 //   }
                          //                 // },
                          //                   child: NameField(powerlessRhController,"powerless believe",1,70,false)))),
                          //
                          //       SaveButtonWidgets( (){
                          //         _setTrellisRhythmsData();
                          //       }),
                          //       Container(
                          //         margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          //         child: trellisRhythmsData.isEmpty ? const Align(
                          //             alignment: Alignment.topLeft,
                          //             child: Text("")) : ListView.builder(
                          //             shrinkWrap: true,
                          //             itemCount: trellisRhythmsData.length,
                          //             itemBuilder:(context,index) {
                          //               return GestureDetector(
                          //                 // onTap: () {
                          //                 //   showDialog(
                          //                 //     context: context,
                          //                 //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                          //                 //   );
                          //                 // },
                          //                 child: Container(
                          //                     margin:const EdgeInsets.symmetric(vertical: 5),
                          //                     decoration: BoxDecoration(
                          //                         color: AppColors.backgroundColor,
                          //                         borderRadius: BorderRadius.circular(10)
                          //                     ),
                          //                     padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                          //                     child: Column(
                          //                       children: [
                          //                         Align(alignment: Alignment.topRight,
                          //                           child: IconButton(
                          //                             onPressed: () {
                          //                               _deleteRecord("rhythms", trellisRhythmsData[index]['id'],index);
                          //                             },
                          //                             icon:const Icon(Icons.delete,color: AppColors.redColor,),
                          //                           ),),
                          //                         Align(
                          //                             alignment: Alignment.topLeft,
                          //                             child: Text("${trellisRhythmsData[index]['emp_truths'].toString()} | ${trellisRhythmsData[index]['powerless_believes'].toString()} "))
                          //                       ],
                          //                     )),
                          //               );
                          //             }
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // )

                        ]
                    ),

                    ExpansionTileWidgetScreen(isNeedsExpanded,"Needs",true,"","",true,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Needs",value);

                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(needsUrl);
                      YoutubePlayerController _playerController = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Needs",_playerController);
                     //bottomSheet(context,"Needs","The essential and engaging aspects of my life that increase my functioning (joy, peace, and confidence) when present, and lead to greater breakdown and dysfunction when absent. Example - “Regular emotional and relational intimacy with people I enjoy.”","");
                    },
                        <Widget>[
                          Container(
                            decoration:const BoxDecoration(
                              color: AppColors.lightGreyColor,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                            ),
                            padding:const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [

                                AddButton(trellisNeedsData.length>= 2,() {
                                  needsBottomSheet(context, "Needs", <Widget>[
                                    NameField(needsController,"needs",5,70,true),
                                    SaveButtonWidgets( (){
                                      _setTrellisNeedsData();
                                    }),
                                  ]);
                                }),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: trellisNeedsData.isEmpty ? const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("")) : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: trellisNeedsData.length,
                                      itemBuilder:(context,index) {
                                        return GestureDetector(
                                          // onTap: () {
                                          //   showDialog(
                                          //     context: context,
                                          //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                                          //   );
                                          // },
                                          child: Container(
                                              margin:const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: AppColors.backgroundColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                              child: Column(
                                                children: [
                                                  Align(alignment: Alignment.topRight,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        _deleteRecord("needs", trellisNeedsData[index]['id'],index,"");
                                                      },
                                                      icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                    ),),
                                                  Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(trellisNeedsData[index]['text'].toString()))
                                                ],
                                              )),
                                        );
                                      }
                                  ),
                                ),
                              ],
                            ),
                          )

                        ]
                    ),

                    ExpansionTileWidgetScreen(isIdentityExpanded,"Identity",true,"","",true,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Identity",value);

                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(identityUrl);
                      YoutubePlayerController _playerController = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Identity",_playerController);
                     // bottomSheet(context,"Identity","My identity is the primary way I identify myself to me and the world around me. Example - “I am a beloved child of God.” Also you can use personality assessments like Enneagram, Strengths, or Meyers-Briggs results and others.","");
                    },
                        <Widget>[
                          Container(
                            decoration:const BoxDecoration(
                              color: AppColors.lightGreyColor,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                            ),
                            padding:const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                AddButton(trellisIdentityData.length>=2,(){
                                  needsBottomSheet(context, "Identity", <Widget>[
                                    NameField(identityController,"identity",5,200,true),
                                    SaveButtonWidgets( (){
                                      _setTrellisIdentityData ();
                                    }),
                                  ]);
                                }),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child:trellisIdentityData.isEmpty ? const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("")) : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: trellisIdentityData.length,
                                      itemBuilder:(context,index) {
                                        return GestureDetector(
                                          // onTap: () {
                                          //   showDialog(
                                          //     context: context,
                                          //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                                          //   );
                                          // },
                                          child: Container(
                                            margin:const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: AppColors.backgroundColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                              child: Column(
                                                children: [
                                                  Align(alignment: Alignment.topRight,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        _deleteRecord("identity", trellisIdentityData[index]['id'],index,"");
                                                      },
                                                      icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                    ),),
                                                  Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(trellisIdentityData[index]['text'].toString()))
                                                ],
                                              )),
                                        );
                                      }
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]
                    ),

                    ExpansionTileWidgetScreen(isTribeExpanded,"Tribe",isTribeExpanded,"Mentor, Peer, Mentee","",false,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Tribe",value);
                      setState(() {
                        isTribeExpanded = value;
                      });
                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(tribeUrl);
                      YoutubePlayerController _playerController = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Tribe",_playerController);
                     // bottomSheet(context,"Tribe","Your Tribe represents your inner circle and concentric circles of people who help you to live the life you desire and be the person you want to be. ","");
                    },
                        <Widget>[
                          Container(
                            decoration:const BoxDecoration(
                              color: AppColors.lightGreyColor,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                            ),
                            padding:const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                AddButton(trellisTribeData.isNotEmpty,() {
                                  tribeBottomSheet(context,"Tribe",isMentorVisible,isPeerVisible,isMenteeVisible,Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                              margin:const EdgeInsets.only(left: 10,right: 10),
                                              child: Row(
                                                children:const [
                                                  Icon(Icons.person,color: AppColors.primaryColor,),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                                ],
                                              ))),
                                      Container(
                                          margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                          child: Focus(
                                            // onFocusChange: (hasFocus) {
                                            //   print('Mentor Name Field:  $hasFocus');
                                            //   if(!hasFocus && mentorNameController.text.isNotEmpty) {
                                            //     _setTrellisData ();
                                            //   }
                                            // },
                                              child: NameField(mentorNameController," name of mentor-Type what thy provide you",1,70,false))),
                                      // Container(
                                      //     margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                      //     child: Focus(
                                      //       // onFocusChange: (hasFocus) {
                                      //       //   print('Mentor Desc Field:  $hasFocus');
                                      //       //   if(!hasFocus && mentorDescriptionController.text.isNotEmpty) {
                                      //       //     _setTrellisData ();
                                      //       //   }
                                      //       // },
                                      //         child: NameField(mentorDescriptionController,"Description",1,70,false))),
                                    ],
                                  ),Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                              margin:const EdgeInsets.only(left: 10,right: 10),
                                              child: Row(
                                                children:const [
                                                  Icon(Icons.person,color: AppColors.primaryColor,),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                                ],
                                              ))),
                                      Container(
                                          margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                          child: Focus(
                                            // onFocusChange: (hasFocus) {
                                            //   print('Peer Name Field:  $hasFocus');
                                            //   if(!hasFocus && peerNameController.text.isNotEmpty) {
                                            //     _setTrellisData ();
                                            //   }
                                            // },
                                              child: NameField(peerNameController," name of peer-Type what thy provide you",1,70,false))),
                                      // Container(
                                      //     margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                      //     child: Focus(
                                      //       // onFocusChange: (hasFocus) {
                                      //       //   print('Peer Desc Field:  $hasFocus');
                                      //       //   if(!hasFocus && peerDescriptionController.text.isNotEmpty) {
                                      //       //     _setTrellisData ();
                                      //       //   }
                                      //       // },
                                      //         child: NameField(peerDescriptionController,"Description",1,70,false))),
                                    ],
                                  ),Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                              margin:const EdgeInsets.only(left: 10,right: 10),
                                              child: Row(
                                                children:const [
                                                  Icon(Icons.person,color: AppColors.primaryColor,),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                                ],
                                              ))),
                                      Container(
                                          margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                          child: Focus(
                                            // onFocusChange: (hasFocus) {
                                            //   print('Mentee Name Field:  $hasFocus');
                                            //   if(!hasFocus && menteeNameController.text.isNotEmpty) {
                                            //     _setTrellisData ();
                                            //   }
                                            // },
                                              child: NameField(menteeNameController," name of mentee-Type what thy provide you",1,70,false))),
                                      // Container(
                                      //     margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                      //     child: Focus(
                                      //       // onFocusChange: (hasFocus) {
                                      //       //   print('Mentee Desc Field:  $hasFocus');
                                      //       //   if(!hasFocus && menteeDescriptionController.text.isNotEmpty ) {
                                      //       //     _setTrellisData ();
                                      //       //   }
                                      //       // },
                                      //         child: NameField(menteeDescriptionController,"Description",1,70,false))),
                                    ],
                                  ),(){_setTribeData();},);
                                  // needsBottomSheet(context, "Tribe", <Widget>[
                                  //   Row(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  //     children: [
                                  //       GestureDetector(
                                  //         onTap:() {
                                  //          setState(() {
                                  //            isMentorVisible = true;
                                  //            isPeerVisible = false;
                                  //            isMenteeVisible = false;
                                  //          });
                                  //         },
                                  //         child: Container(
                                  //           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  //           decoration: BoxDecoration(
                                  //             color: isMentorVisible ? AppColors.primaryColor : AppColors.lightGreyColor,
                                  //             borderRadius: BorderRadius.circular(10),
                                  //           ),
                                  //           child: const Text("Mentor",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                  //         ),
                                  //       ),
                                  //       GestureDetector(
                                  //         onTap:() {
                                  //           setState(() {
                                  //             isMentorVisible = false;
                                  //             isPeerVisible = true;
                                  //             isMenteeVisible = false;
                                  //           });
                                  //         },
                                  //         child: Container(
                                  //           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  //           decoration: BoxDecoration(
                                  //             color: isPeerVisible ? AppColors.primaryColor : AppColors.lightGreyColor,
                                  //             borderRadius: BorderRadius.circular(10),
                                  //           ),
                                  //           child: const Text("Peer",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                  //         ),
                                  //       ),
                                  //       GestureDetector(
                                  //         onTap:() {
                                  //           print(isMenteeVisible);
                                  //           setState(() {
                                  //             isMentorVisible = false;
                                  //             isPeerVisible = false;
                                  //             isMenteeVisible = true;
                                  //           });
                                  //         },
                                  //         child: Container(
                                  //           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  //           decoration: BoxDecoration(
                                  //             color: isMenteeVisible ? AppColors.primaryColor : AppColors.lightGreyColor,
                                  //             borderRadius: BorderRadius.circular(10),
                                  //           ),
                                  //           child: const Text("Mentee",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  //   Visibility(
                                  //       visible: isMentorVisible,
                                  //       child: Column(
                                  //     children: [
                                  //       Align(
                                  //           alignment: Alignment.topLeft,
                                  //           child: Container(
                                  //               margin:const EdgeInsets.only(left: 10,right: 10),
                                  //               child: Row(
                                  //                 children:const [
                                  //                   Icon(Icons.person,color: AppColors.primaryColor,),
                                  //                   SizedBox(
                                  //                     width: 5,
                                  //                   ),
                                  //                   Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                  //                 ],
                                  //               ))),
                                  //       Container(
                                  //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                  //           child: Focus(
                                  //             // onFocusChange: (hasFocus) {
                                  //             //   print('Mentor Name Field:  $hasFocus');
                                  //             //   if(!hasFocus && mentorNameController.text.isNotEmpty) {
                                  //             //     _setTrellisData ();
                                  //             //   }
                                  //             // },
                                  //               child: NameField(mentorNameController,"Name",1,70,false))),
                                  //       Container(
                                  //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                  //           child: Focus(
                                  //             // onFocusChange: (hasFocus) {
                                  //             //   print('Mentor Desc Field:  $hasFocus');
                                  //             //   if(!hasFocus && mentorDescriptionController.text.isNotEmpty) {
                                  //             //     _setTrellisData ();
                                  //             //   }
                                  //             // },
                                  //               child: NameField(mentorDescriptionController,"Description",1,70,false))),
                                  //     ],
                                  //   )),
                                  //
                                  //   Visibility(
                                  //       visible: isPeerVisible,
                                  //       child: Column(
                                  //     children: [
                                  //       Align(
                                  //           alignment: Alignment.topLeft,
                                  //           child: Container(
                                  //               margin:const EdgeInsets.only(left: 10,right: 10),
                                  //               child: Row(
                                  //                 children:const [
                                  //                   Icon(Icons.person,color: AppColors.primaryColor,),
                                  //                   SizedBox(
                                  //                     width: 5,
                                  //                   ),
                                  //                   Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                  //                 ],
                                  //               ))),
                                  //       Container(
                                  //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                  //           child: Focus(
                                  //             // onFocusChange: (hasFocus) {
                                  //             //   print('Peer Name Field:  $hasFocus');
                                  //             //   if(!hasFocus && peerNameController.text.isNotEmpty) {
                                  //             //     _setTrellisData ();
                                  //             //   }
                                  //             // },
                                  //               child: NameField(peerNameController,"Name",1,70,false))),
                                  //       Container(
                                  //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                  //           child: Focus(
                                  //             // onFocusChange: (hasFocus) {
                                  //             //   print('Peer Desc Field:  $hasFocus');
                                  //             //   if(!hasFocus && peerDescriptionController.text.isNotEmpty) {
                                  //             //     _setTrellisData ();
                                  //             //   }
                                  //             // },
                                  //               child: NameField(peerDescriptionController,"Description",1,70,false))),
                                  //     ],
                                  //   )),
                                  //
                                  //   Visibility(
                                  //     visible: isMenteeVisible,
                                  //       child: Column(
                                  //         children: [
                                  //           Align(
                                  //               alignment: Alignment.topLeft,
                                  //               child: Container(
                                  //                   margin:const EdgeInsets.only(left: 10,right: 10),
                                  //                   child: Row(
                                  //                     children:const [
                                  //                       Icon(Icons.person,color: AppColors.primaryColor,),
                                  //                       SizedBox(
                                  //                         width: 5,
                                  //                       ),
                                  //                       Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                  //                     ],
                                  //                   ))),
                                  //           Container(
                                  //               margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                  //               child: Focus(
                                  //                 // onFocusChange: (hasFocus) {
                                  //                 //   print('Mentee Name Field:  $hasFocus');
                                  //                 //   if(!hasFocus && menteeNameController.text.isNotEmpty) {
                                  //                 //     _setTrellisData ();
                                  //                 //   }
                                  //                 // },
                                  //                   child: NameField(menteeNameController,"Name",1,70,false))),
                                  //           Container(
                                  //               margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                  //               child: Focus(
                                  //                 // onFocusChange: (hasFocus) {
                                  //                 //   print('Mentee Desc Field:  $hasFocus');
                                  //                 //   if(!hasFocus && menteeDescriptionController.text.isNotEmpty ) {
                                  //                 //     _setTrellisData ();
                                  //                 //   }
                                  //                 // },
                                  //                   child: NameField(menteeDescriptionController,"Description",1,70,false))),
                                  //         ],
                                  //       )),
                                  //   SaveButtonWidgets( (){
                                  //     _setTribeData();
                                  //   }),
                                  // ]);
                                }),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: trellisTribeData.isEmpty ? const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("")) : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: trellisTribeData.length,
                                      itemBuilder:(context,index) {
                                        return GestureDetector(
                                          // onTap: () {
                                          //   showDialog(
                                          //     context: context,
                                          //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                                          //   );
                                          // },
                                          child: Container(
                                              margin:const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: AppColors.backgroundColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children:const [
                                                          Icon(Icons.person,color: AppColors.primaryColor,),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                                        ],
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          _deleteRecord("tribe", trellisTribeData[index]['id'],index,"");
                                                        },
                                                        icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(left: 5,right: 5,bottom: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(trellisTribeData[index]['mentor'].toString()),
                                                        // SizedBox(height: 5,),
                                                        // Text(trellisTribeData[index]['mentor_desc'].toString())
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children:const [
                                                      Icon(Icons.person,color: AppColors.primaryColor,),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(left: 5,right: 5,bottom: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(trellisTribeData[index]['peer'].toString()),
                                                        // SizedBox(height: 5,),
                                                        // Text(trellisTribeData[index]['peer_desc'].toString())
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children:const [
                                                      Icon(Icons.person,color: AppColors.primaryColor,),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(left: 5,right: 5,bottom: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(trellisTribeData[index]['mentee'].toString()),
                                                        // SizedBox(height: 5,),
                                                        // Text(trellisTribeData[index]['mentee_desc'].toString())
                                                      ],
                                                    ),
                                                  ),
                                                  // Align(alignment: Alignment.topRight,
                                                  //   child: IconButton(
                                                  //     onPressed: () {
                                                  //       _deleteRecord("tribe", trellisTribeData[index]['id'],index);
                                                  //     },
                                                  //     icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                  //   ),),
                                                  // Align(
                                                  //     alignment: Alignment.topLeft,
                                                  //     child: Text("${trellisTribeData[index]['mentor'].toString()} | ${trellisTribeData[index]['mentor_desc'].toString()} , ${trellisTribeData[index]['peer'].toString()} | ${trellisTribeData[index]['peer_desc'].toString()} , ${trellisTribeData[index]['mentee'].toString()} | ${trellisTribeData[index]['mentee_desc'].toString()}"))
                                                ],
                                              )),
                                        );
                                      }
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]
                    ),
                  ],
                ),
              ),
              _isDataLoading ?
              const Center(child: CircularProgressIndicator())
                  : Container() ,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context,String heading,dynamic object, bool oneCategory) {
    return  AlertDialog(
      backgroundColor: AppColors.lightGreyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ladder",style: TextStyle(fontSize: AppConstants.headingFontSize),),
              Text(heading,style: const TextStyle(fontSize: AppConstants.defaultFontSize,color: AppColors.primaryColor),),
            ],
          ),
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon:const Icon(Icons.cancel))
        ],),
      content:  Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Container(
                  margin:const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const  Expanded(
                          flex:1,
                          child: Text("Type: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                      Expanded(
                          flex: 2,
                          child: Text(object['type'])),
                    ],
            ),
                ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      flex:1,
                      child: Text("Category: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                  Expanded(
                      flex: 2,
                      child: Text(object['option1'])),
                ],
              ),
            ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      flex:1,
                      child: Text("Date: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                  Expanded(
                      flex: 2,
                      child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(object['date'].toString())))),
                ],
              ),
            ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const Expanded(
                      flex:1,
                      child: Text("Title: ",style: TextStyle(fontWeight: FontWeight.bold),)),

                  Expanded(
                      flex: 2,
                      child: Text(object['text'])),
                ],
              ),
            ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex:1,
                      child:  Text("Description: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                  Expanded(
                      flex: 2,
                      child: Text(object['description'])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  _deleteRecord(String type,String recordId,int index,String goalsOrChallenges) {
    // print(type);
    // print(index);
    setState(() {
      _isDataLoading = true;
    });
    HTTPManager().trellisDelete(TrellisDeleteRequestModel(userId: id,recordId: recordId,type:type,)).then((value) {

      if(type == "goal") {
        if(goalsOrChallenges == "Challenges") {
          setState(() {
            trellisLadderDataForGoalsChallenges.removeAt(index);
          });
        } else {
          trellisLadderDataForGoals.removeAt(index);
        }

      } else if(type == "achievements") {
        setState(() {
          trellisLadderDataForAchievements.removeAt(index);
        });
      } else if(type == "needs") {
        setState(() {
          trellisNeedsData.removeAt(index);
        });
      } else if(type == "identity") {
        setState(() {
          trellisIdentityData.removeAt(index);
        });
      } else if(type == "principles") {
        setState(() {
          trellisPrinciplesData.removeAt(index);
        });
      } else if(type == "rhythms") {
        setState(() {
          trellisRhythmsData.removeAt(index);
        });
      } else if(type == "tribe") {
        setState(() {
          trellisTribeData.removeAt(index);
        });
      }
      setState(() {
        _isDataLoading = false;
      });
     // print(value);
     // _getTrellisReadData(false);
      showToastMessage(context, "Record deleted successfully", true);

    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
      setState(() {
        _isDataLoading = false;
      });
    });
  }

  _setLadderGoalsData() {
    print("Seleted Date:${dateForGController.text}");

    if(initialValueForGoals != "" || dateForGController.text.isNotEmpty || initialValueForType == "" || titleForGController.text.isNotEmpty ) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForGoals(TrellisLadderGoalsRequestModel(userId: id,type: "goal",option1: initialValueForType,option2: initialValueForGoals,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text)).then((value) {

        Navigator.of(context).pop();
        setState(() {
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });
        if(value['post_data']['option2'] == "Challenges") {
          trellisLadderDataForGoalsChallenges.insert(0, value['post_data']);
        } else {
          trellisLadderDataForGoals.insert(0, value['post_data']);
        }
        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Goals");
        showToastMessage(context, "Record added successfully", true);
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });

    } else {
      showToastMessage(context, "Add some data please", false);
    }
  }

  _setLadderMemoriesData() {
    if( dateForMController.text.isNotEmpty  || titleForMController.text.isNotEmpty ) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForAchievements(TrellisLadderAchievementRequestModel(userId: id,type: "achievements",option1:initialValueForMType ,date: dateForMController.text,title: titleForMController.text,description: descriptionForMController.text)).then((value) {

        Navigator.of(context).pop();
        setState(() {
          dateForMController.text = "";
          titleForMController.text = "";
          descriptionForMController.text = "";
        });
        trellisLadderDataForAchievements.insert(0,value['post_data']);
        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Achievements");
        showToastMessage(context, "Record added successfully", true);
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });

    } else {
      showToastMessage(context, "Add some data please", false);
    }
  }

  _setTrellisOPData () {

    if(empoweredTruthOPController.text.isNotEmpty || powerlessOpController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisPrinciples(TrellisPrinciplesRequestModel(
          userId: id, type: "principles", empTruths: empoweredTruthOPController.text,powerlessBelieve: powerlessOpController.text))
          .then((value) {
        // print("Organizing Principle Success");
        // print(value);
        trellisPrinciplesData.add(Trellis_principle_data_model_class(
            id : value['post_data']['id'].toString(),
            userId : value['post_data']['user_id'].toString(),
            type : value['post_data']['type'].toString(),
            empTruths : value['post_data']['emp_truths'].toString(),
            powerlessBelieves : value['post_data']['powerless_believes'].toString(),
            visibility : false,
            ));
        Navigator.of(context).pop();
        showToastMessage(context, "Record added successfully", true);
        setState(() {
          empoweredTruthOPController.text = "";
          powerlessOpController.text = "";
          _isDataLoading = false;
        });
       // Navigator.of(context).pop();
      }).catchError((e) {
        print(e);
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add some data please", false);
    }
  }

  _setTrellisRhythmsData () {

    if(empoweredTruthRhController.text.isNotEmpty || powerlessRhController.text.isNotEmpty ) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisPrinciples(TrellisPrinciplesRequestModel(
          userId: id, type: "rhythms", empTruths: empoweredTruthRhController.text,powerlessBelieve: powerlessRhController.text))
          .then((value) {
        setState(() {
          _isDataLoading = false;
        });
        trellisRhythmsData.add(Trellis_principle_data_model_class(
          id : value['post_data']['id'].toString(),
          userId : value['post_data']['user_id'].toString(),
          type : value['post_data']['type'].toString(),
          empTruths : value['post_data']['emp_truths'].toString(),
          powerlessBelieves : value['post_data']['powerless_believes'].toString(),
          visibility : false,
        ));
        Navigator.of(context).pop();
        showToastMessage(context, "Record added successfully", true);
        setState(() {
          empoweredTruthRhController.text = "";
          powerlessRhController.text = "";
        });
      //  Navigator.of(context).pop();
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add your data please", false);
    }
  }

  _setTrellisNeedsData () {

    if(needsController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisIdentity(TrellisIdentityRequestModel(
              userId: id, type: "needs", text: needsController.text))
          .then((value) {
        // print("Needs Success");
        // print(value);
        trellisNeedsData.insert(0, value['post_data']);
        showToastMessage(context, "Record added successfully", true);
        setState(() {
          needsController.text = "";
          _isDataLoading = false;
        });
        Navigator.of(context).pop();
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add your needs in the field", false);
    }
  }

  _setTrellisIdentityData () {

    if(identityController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisIdentity(TrellisIdentityRequestModel(
              userId: id, type: "identity", text: identityController.text))
          .then((value) {
        // print("Identity Success");
        // print(value);
        trellisIdentityData.insert(0, value['post_data']);
        showToastMessage(context, "Record added successfully", true);
        setState(() {
          _isDataLoading = false;
          identityController.text = "";
        });
        Navigator.of(context).pop();
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add your identity in the field", false);
    }
  }

  _setTribeData() {
    if(mentorNameController.text.isNotEmpty
        || peerNameController.text.isNotEmpty
        || menteeNameController.text.isNotEmpty)
    {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisTribeScreen(TribeDataRequestModel(
          userId: id,
        mentor: mentorNameController.text,
        peer: peerNameController.text,
        mentee: menteeNameController.text,
      ))
          .then((value) {
            // print(value);
            Navigator.of(context).pop();
            setState(() {
              trellisTribeData.add(value['post_data']);
              mentorNameController.text = "";
            //  mentorDescriptionController.text = "";
              peerNameController.text = "";
             // peerDescriptionController.text = "";
              menteeNameController.text = "";
            //  menteeDescriptionController.text = "";
              _isDataLoading = false;
            });
        showToastMessage(context, "Record added successfully", true);

      })
          .catchError((e) {
        showToastMessage(context, e.toString(), false);
        print(e);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Please fill your fields", false);
    }
  }

  _setTrellisData () {
    // setState(() {
    //   _isDataLoading = true;
    // });

    if(nameController.text.isNotEmpty
    || descriptionController.text.isNotEmpty
    || purposeController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisScreen(TrellisDataRequestModel(
          userId: id,
          name: nameController.text,
          nameDescription: descriptionController.text,
          purpose: purposeController.text,
          mentor: mentorNameController.text,
        //  mentorDescription: mentorDescriptionController.text,
          peer: peerNameController.text,
         // peerDescription: peerDescriptionController.text,
          mentee: menteeNameController.text,
         // menteeDescription: menteeDescriptionController.text
      )).then((value) {
        // print(value);
        showToastMessage(context, "Record added successfully", true);
        setState(() {
          _isDataLoading = false;
        });

      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Please fill your fields", false);
    }
  }
}
