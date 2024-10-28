// ignore_for_file: avoid_print, duplicate_ignore, unused_element, use_build_context_synchronously, unused_field


import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/add_widgets_button.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/bottom_sheet.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/expansion_tile_widget.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/name_field.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/save_button_widgets.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/model/reponse_model/post_reminder_list_response_model.dart';
import 'package:flutter_quiz_app/model/reponse_model/trellis_vision_data.dart';
import 'package:flutter_quiz_app/model/request_model/identity_add_favourite_request.dart';
import 'package:flutter_quiz_app/model/request_model/ladder_add_favourite_response.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:flutter_quiz_app/model/request_model/organizing_principles_add_favourite_request.dart';
import 'package:flutter_quiz_app/model/request_model/post_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/read_trellis_model.dart';
import 'package:flutter_quiz_app/model/request_model/rhythms_add_favourite_request.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_data_saving_request.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_delete_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_identity_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_vision_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/tribe_data_saving_request.dart';
import 'package:interval_time_picker/interval_time_picker.dart' as TimePicker;
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../../model/reponse_model/trellis_ladder_data_response.dart';
import '../../model/reponse_model/trellis_new_tribe_insertion.dart';
import '../../model/reponse_model/trellis_principle_data_response.dart';
import '../../model/reponse_model/tribe_new_read_data_response.dart';
import '../../model/request_model/trellis_ladder_request_model.dart';
import '../../model/request_model/trellis_principles_request_model.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/AppBar.dart';
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

  bool otherUserLoggedIn = false;

  String selectedValueFromBottomSheet = "Mentor";

  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";

  bool _isLoading = true;
  bool _isDataLoading = false;
  late bool isPhone;
  late List <dynamic> trellisData;



  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reminderTimeController = TextEditingController();
  bool isRepeat = true;
  String selectedRadio = "repeat";

  List _weekdays = [
    {"name" : "Sun", "Selected": true},
    {"name" : "Mon", "Selected": true},
    {"name" : "Tue", "Selected": true},
    {"name" : "Wed", "Selected": true},
    {"name" : "Thu", "Selected": true},
    {"name" : "Fri", "Selected": true},
    {"name" : "Sat", "Selected": true},];
  List _selectedWeekdays = [
    {"name" : "Sun", "Selected": true},
    {"name" : "Mon", "Selected": true},
    {"name" : "Tue", "Selected": true},
    {"name" : "Wed", "Selected": true},
    {"name" : "Thu", "Selected": true},
    {"name" : "Fri", "Selected": true},
    {"name" : "Sat", "Selected": true},];

  String daysSelected = "Everyone";

  final _formKey = GlobalKey<FormState>();

  DateTime selectedReminderTime= DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  List <String> dateList = <String>[];


  List <TrellisLadderDataModel> trellisLadderDataForGoalsAchievements = [];
  List <TrellisLadderDataModel> trellisLadderDataForGoals = [];
  List <TrellisLadderDataModel> trellisLadderDataForGoalsChallenges = [];
  List <TrellisLadderDataModel> trellisLadderDataForAchievements = [];
  List <TrellisLadderDataModel> trellisLadderDataForGoalsFavourites = [];
  List <TrellisLadderDataModel> trellisLadderDataForChallengesFavourites = [];
  List <TrellisLadderDataModel> trellisLadderDataForMemoriesAndAchievementsFavourites = [];
  List <TrellisLadderDataModel> trellisLadderDataForMemoriesFavourites = [];
  List <TrellisLadderDataModel> trellisLadderDataForAchievementsFavourites = [];

  List<TrellisLadderDataModel> trellisLadderDataFavorites = [];
  List <dynamic> trellisIdentityNeedsData = [];
  
  List <dynamic> trellisNeedsData = [];
  List <dynamic> trellisAntiNeedsData = [];
  List <dynamic> trellisIdentityData = [];
  List <dynamic> trellisVisionData = [];


  TrellisVisionDataModel? trellisVisionDataModel;
  List <Trellis_principle_data_model_class> trellisPrinciplesRhythmsData = [];
  List <Trellis_principle_data_model_class> trellisPrinciplesData = [];
  List <Trellis_principle_data_model_class> trellisRhythmsData = [];
  List <dynamic> trellisTribeData = [];

  List <TribeDataResponse> trellisAllTribeData = [];
  List <TribeDataResponse> trellisMenteeTribeData = [];
  List <TribeDataResponse> trellisMentorTribeData = [];
  List <TribeDataResponse> trellisPeerTribeData = [];
  
  // ignore: non_constant_identifier_names
  late Trellis_principle_data_model_class trellis_principle_data_model_class;
  late TrellisLadderDataModel trellisLadderDataModel;

  String initialValueForType = "Physical";
  List itemsForType = ["Physical","Emotional","Relational","Work","Financial","Spiritual"];

  String initialValueForLadderType = "Goals";
  List itemsForLadderType = <String>["Goals", "Challenges", "Memories", "Achievements"];

  String initialValueForMType = "Memories";
  List itemsForMType = ["Memories","Achievements"];

  String initialValueForGType = "Goals";
  List itemsForGType = <String>["Goals","Challenges"];

  bool isNameExpanded = false;
  bool isPurposeExpanded = false;
  bool isLadderExpanded = false;
  bool isOPExpanded = false;
  bool isVisionExpanded = false;
  bool isRhythmsExpanded = false;
  bool isNeedsExpanded = false;
  bool isIdentityExpanded = false;
  bool isTribeExpanded = false;

  int isLadderGoals = 2;
  int isLadderChallenges = 2;
  int isLadderMemoriesAndAchievement = 2;
  int isLadderMemories = 2;
  int isLadderAchievements = 2;
  int isOPLength = 2;
  int isRhythmsLength = 2;
  int isNeedsLength = 2;
  int isIdentityLength = 2;
  int isTribeLength = 1;

  bool isMentorVisible = true;
  bool isPeerVisible = false;
  bool isMenteeVisible = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController purposeController = TextEditingController();



  TextEditingController visionController = TextEditingController();
  TextEditingController relationalVisionController = TextEditingController();
  TextEditingController emotionalVisionController = TextEditingController();
  TextEditingController physicalVisionController = TextEditingController();
  TextEditingController workVisionController = TextEditingController();
  TextEditingController financialVisionController = TextEditingController();
  TextEditingController spiritualVisionController = TextEditingController();




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
  TextEditingController antiNeedsController = TextEditingController();
  TextEditingController identityController = TextEditingController();
  TextEditingController identityDescController = TextEditingController();

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
  String visionUrl = "https://www.youtube.com/watch?v=iqUEdMLACs8";
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

  int badgeCount1 = 0;
  int badgeCountShared = 0;
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

    badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

    otherUserLoggedIn = sharedPreferences.getBool(UserConstants().otherUserLoggedIn)!;

    if(otherUserLoggedIn) {
      name = sharedPreferences.getString(UserConstants().otherUserName)!;
      id = sharedPreferences.getString(UserConstants().otherUserId)!;
    } else {
      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

      userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
      userPremiumType =
      sharedPreferences.getString(UserConstants().userPremiumType)!;
      userCustomerId =
      sharedPreferences.getString(UserConstants().userCustomerId)!;
      userSubscriptionId =
      sharedPreferences.getString(UserConstants().userSubscriptionId)!;
    }
    setState(() {
      _isUserDataLoading = false;
    });
    _getTrellisNewDataRead();
    _getTrellisReadData();
    _getPrinciplesData();
    _getIdentityData();
    _getVisionData();
    _getNeedsData();
    _getTribeData();
  }

  _getTrellisNewDataRead() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisNewDataRead(LogoutRequestModel(userId: id)).then((value) {
      setState(() {
        trellisAllTribeData = value.values;
        _isLoading = false;
      });
      print("Trellis New Data Read");
      print(trellisAllTribeData);
      for(int i = 0; i<trellisAllTribeData.length; i++ ) {
        if(trellisAllTribeData[i].type == "peer") {
          trellisPeerTribeData.add(trellisAllTribeData[i]);
        } else if(trellisAllTribeData[i].type == "mentor") {
          trellisMentorTribeData.add(trellisAllTribeData[i]);
        } else {
          trellisMenteeTribeData.add(trellisAllTribeData[i]);
        }
      }

    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
    });
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
    // ignore: avoid_print
    print("Screen Status called");
// ignore: avoid_print
    print(key);
    // ignore: avoid_print
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
    }else if(key == "Vision"){
      sharedPreferences.setBool(TrellisScreenStatus().visionExpanded, value);
    }

  }

  @override
  void initState() {

    _getTrellisDetails();
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

  _getTrellisDetails() {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().getAppVersion().then((value)  async {
      setState(() {
         isLadderGoals = int.parse(value['goal'].toString());
         isLadderChallenges =  int.parse(value['challenges'].toString());
         isLadderMemories =  int.parse(value['memories'].toString());
         isLadderAchievements = int.parse(value['achievements'].toString());
         isOPLength = int.parse(value['principle'].toString());
         isRhythmsLength = int.parse(value['rhythms'].toString());
         isNeedsLength = int.parse(value['needs'].toString());
         isIdentityLength = int.parse(value['identity'].toString());
         isTribeLength = int.parse(value['tribe'].toString());

        _isLoading = false;
      });


    }).catchError((e) {
      // print(e);
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getNeedsData() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'ladder')).then((value) {

      TrellisLadderDataListModel trellisLadderDataListModel  = TrellisLadderDataListModel.fromJson(value['data']);
      trellisLadderDataForGoalsAchievements = trellisLadderDataListModel.values;
      print('Total Trellis Ladder Data =============> ${trellisLadderDataForGoalsAchievements.length}');
      for(int i=0; i<trellisLadderDataForGoalsAchievements.length;i++){
        print('Type ===============> $i : ${trellisLadderDataForGoalsAchievements[i].type}');
        print('Type ===============> $i : ${trellisLadderDataForGoalsAchievements[i].text}');
        print('Type ===============> $i : ${trellisLadderDataForGoalsAchievements[i].description}');
        print('Type ===============> $i : ${trellisLadderDataForGoalsAchievements[i].option1}');
        print('Type ===============> $i : ${trellisLadderDataForGoalsAchievements[i].option2}');
          if(trellisLadderDataForGoalsAchievements[i].favourite == "yes"){
            trellisLadderDataFavorites.add(trellisLadderDataForGoalsAchievements[i]);
          }
          if (trellisLadderDataForGoalsAchievements[i].type.toString() == "goal") {
            trellisLadderDataForGoalsFavourites.add(trellisLadderDataForGoalsAchievements[i]);
          }else if(trellisLadderDataForGoalsAchievements[i].type.toString() == "challenges"){
            trellisLadderDataForChallengesFavourites.add(trellisLadderDataForGoalsAchievements[i]);
          }else if(trellisLadderDataForGoalsAchievements[i].type.toString() == "memories" || trellisLadderDataForGoalsAchievements[i].type.toString() == "achievements") {
            trellisLadderDataForMemoriesAndAchievementsFavourites.add(trellisLadderDataForGoalsAchievements[i]);
          }else if(trellisLadderDataForGoalsAchievements[i].type.toString() == "memories"){
            trellisLadderDataForMemoriesFavourites.add(trellisLadderDataForGoalsAchievements[i]);
          }else if(trellisLadderDataForGoalsAchievements[i].type.toString() == "achievements"){
            trellisLadderDataForAchievementsFavourites.add(trellisLadderDataForGoalsAchievements[i]);
          }
      }

      print('Total Favorite Goals Data =============> ${trellisLadderDataForGoalsFavourites.length}');
      print('Total Favorite Challenges Data =============> ${trellisLadderDataForChallengesFavourites.length}');
      print('Total Favorite Memories And Achievements Data =============> ${trellisLadderDataForMemoriesAndAchievementsFavourites.length}');
      print('Total Favorite Memories Data =============> ${trellisLadderDataForMemoriesFavourites.length}');
      print('Total Favorite Achievements Data =============> ${trellisLadderDataForAchievementsFavourites.length}');



      // for(int i=0; i<trellisLadderDataForGoalsAchievements.length;i++) {
      //   if(trellisLadderDataForGoalsAchievements[i].favourite == "yes") {
      //     if (trellisLadderDataForGoalsAchievements[i].type.toString() == "goal") {
      //       if(trellisLadderDataForGoalsAchievements[i].favourite!="no" ) {
      //         trellisLadderDataForGoalsFavourites.add(trellisLadderDataForGoalsAchievements[i]);
      //       }
      //       if (trellisLadderDataForGoalsAchievements[i].option2 == "Challenges") {
      //         trellisLadderDataForGoalsChallenges.add(
      //             trellisLadderDataForGoalsAchievements[i]);
      //       } else {
      //         trellisLadderDataForGoals.add(
      //             trellisLadderDataForGoalsAchievements[i]);
      //       }
      //     } else {
      //       if(trellisLadderDataForGoalsAchievements[i].favourite!="no" ) {
      //         trellisLadderDataForAchievementsFavourites.add(
      //             trellisLadderDataForGoalsAchievements[i]);
      //       }
      //       trellisLadderDataForAchievements.add(
      //           trellisLadderDataForGoalsAchievements[i]);
      //     }
      //   }

      // }
      trellisLadderDataForGoalsFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForChallengesFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForMemoriesAndAchievementsFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForMemoriesFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForAchievementsFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForGoalsChallenges.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForGoals.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForAchievements.sort((a,b)=>b.date!.compareTo(a.date!));
      setState(() {
        _isLoading = false;
      });
      // ignore: avoid_print
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
            identityController.text  = trellisIdentityNeedsData[i]['text'];
            identityDescController.text = trellisIdentityNeedsData[i]['description'];
          } else if (trellisIdentityNeedsData[i]['type'].toString() == "needs") {
            trellisNeedsData.add(trellisIdentityNeedsData[i]);
          }else{
            trellisAntiNeedsData.add(trellisIdentityNeedsData[i]);
          }
        }
      }
      // ignore: avoid_print
      print("Identity Data");
      // ignore: avoid_print
      print(trellisIdentityData);
      // ignore: avoid_print
      print(trellisNeedsData);

      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      // ignore: avoid_print
      print(e.toString());
      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getVisionData(){
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'vision')).then((value) {


      trellisVisionData = value['data'];


      print("Vision Data ===================> ${value['data']}");
      for(int i=0; i<trellisVisionData.length;i++) {
        trellisVisionDataModel = TrellisVisionDataModel.fromJson(trellisVisionData[i]);
        // visionController.text = trellisVisionData[i]['vision'];
        // relationalVisionController.text = trellisVisionData[i]['relational_vision'];
        // emotionalVisionController.text = trellisVisionData[i]['emotional_vision'];
        // physicalVisionController.text = trellisVisionData[i]['physical_vision'];
        // workVisionController.text = trellisVisionData[i]['work_vision'];
        // financialVisionController.text = trellisVisionData[i]['financial_vision'];
        // spiritualVisionController.text = trellisVisionData[i]['spiritual_vision'];
      }

      print('Initialized Vision Data ===========> ${trellisVisionDataModel?.vision}');


      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      // ignore: avoid_print
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
      // ignore: avoid_print
      print(trellisTribeData);
      // ignore: avoid_print
      print(value);
      // ignore: avoid_print
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
      // ignore: avoid_print
      print(trellisData);
      // ignore: avoid_print
      print("Trellis Data");
    }).catchError((e) {

      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  showDeletePopupForTribe(String type,String tribeDataId,int indexItem) {

    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title:const Text('Confirm delete?'),
            content:const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text("Are you sure you want to delete!"),
            ),
            actions: [
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteNewTribe(type,tribeDataId,indexItem);
                  // Invoke the update now callback
                  // onUpdateNowPressed(deviceType);
                },
              ),
            ],
          );
        });
  }

  showDeletePopup(String type,String recordId,int index1,String goalsOrChallenges) {

    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title:const Text('Confirm delete?'),
            content:const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text("Are you sure you want to delete!"),
            ),
            actions: [
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteRecord(type, recordId, index1,goalsOrChallenges);
                  // Invoke the update now callback
                  // onUpdateNowPressed(deviceType);
                },
              ),
            ],
          );
        });
  }

  Future<bool> _onWillPop() async {
    // if(nameController.text.isNotEmpty || descriptionController.text.isNotEmpty || purposeController.text.isNotEmpty || mentorNameController.text.isNotEmpty || mentorDescriptionController.text.isNotEmpty || peerNameController.text.isNotEmpty || peerDescriptionController.text.isNotEmpty || menteeNameController.text.isNotEmpty || menteeDescriptionController.text.isNotEmpty) {
    //   _setTrellisData();
    // }

    Navigator.of(context).pop();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
            context,
                () {
                  Navigator.of(context).pop();

              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
              //         (Route<dynamic> route) => false
              // );
            }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared,otherUserLoggedIn,name),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _isLoading ? const Center(child: CircularProgressIndicator(),)  : Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
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
                          // if(!otherUserLoggedIn)
                          // IconButton(onPressed: () {
                          //   showDialog(
                          //   barrierDismissible: false,
                          //   context: context,
                          //   builder: (context) {
                          //     return const ShareCustomAlertDialogue(responseId: "", isModule: true, responseType: "trellis");
                          //   }
                          //   );
                          //   // showThumbsUpDialogueForTrellis(context, _animationController, id,'trellis',selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
                          // }, icon: const Icon(Icons.share,color: AppColors.primaryColor,)),
                          const SizedBox(width: 5,),
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
                      YoutubePlayerController playerController1 = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to name",playerController1);
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
                                        child: NameField(nameController,"Name",1,70,false,otherUserLoggedIn))),
                                Container(
                                    margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                    child: Focus(
                                      // onFocusChange: (hasFocus) {
                                      //   print('Description Field:  $hasFocus');
                                      //   if(!hasFocus && descriptionController.text.isNotEmpty) {
                                      //     _setTrellisData ();
                                      //   }
                                      // },
                                        child: NameField(descriptionController,"Description",1,70,false,otherUserLoggedIn))),
                                if(!otherUserLoggedIn)
                                SaveButtonWidgets( (){
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _setTrellisData();
                                }),
                              ],
                            ),
                          )
                        ]
                    ),






                    ExpansionTileWidgetScreen(isIdentityExpanded,"Identity",isIdentityExpanded,identityController.text,"",true,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Identity",value);
                      setState(() {
                        isIdentityExpanded = value;
                      });

                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(identityUrl);
                      YoutubePlayerController playerController7 = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Identity",playerController7);
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
                                Container(
                                    margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                    child: Focus(
                                      // onFocusChange: (hasFocus) {
                                      //   print('Name Field:  $hasFocus');
                                      //   if(!hasFocus && nameController.text.isNotEmpty) {
                                      //     _setTrellisData ();
                                      //   }
                                      //   },
                                        child: NameField(identityController,"Core Identity",1,140,false,otherUserLoggedIn))),
                                Container(
                                    margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                    child: Focus(
                                      // onFocusChange: (hasFocus) {
                                      //   print('Description Field:  $hasFocus');
                                      //   if(!hasFocus && descriptionController.text.isNotEmpty) {
                                      //     _setTrellisData ();
                                      //   }
                                      // },
                                        child: NameField(identityDescController,"Unique Identity",1,300,false,otherUserLoggedIn))),
                                if(!otherUserLoggedIn)
                                  SaveButtonWidgets( (){
                                    _setTrellisIdentityData();
                                  }),
                              ],
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
                          //       if(!otherUserLoggedIn)
                          //         AddButton(userPremium == "no" ? trellisIdentityData.length>= isIdentityLength : false,(){
                          //           needsBottomSheet(context, "Identity", <Widget>[
                          //             NameField(identityController,"identity",5,0,true,otherUserLoggedIn),
                          //             SaveButtonWidgets( (){
                          //               FocusManager.instance.primaryFocus?.unfocus();
                          //               _setTrellisIdentityData ();
                          //             }),
                          //           ]);
                          //         }),
                          //       Container(
                          //         margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          //         child:trellisIdentityData.isEmpty ? const Align(
                          //             alignment: Alignment.topLeft,
                          //             child: Text("")) : ListView.builder(
                          //             shrinkWrap: true,
                          //             itemCount: trellisIdentityData.length,
                          //             physics: const NeverScrollableScrollPhysics(),
                          //             itemBuilder:(context,index) {
                          //               return GestureDetector(
                          //                 child: Container(
                          //                     margin:const EdgeInsets.symmetric(vertical: 5),
                          //                     decoration: BoxDecoration(
                          //                         color: AppColors.backgroundColor,
                          //                         borderRadius: BorderRadius.circular(10)
                          //                     ),
                          //                     padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                          //                     child: Column(
                          //                       children: [
                          //                         if(!otherUserLoggedIn)
                          //                           Align(
                          //                             alignment: Alignment.topRight,
                          //                             child: Row(
                          //                               mainAxisAlignment: MainAxisAlignment.end,
                          //                               crossAxisAlignment: CrossAxisAlignment.end,
                          //                               children: [
                          //                                 Align(alignment: Alignment.topRight,
                          //                                   child: IconButton(
                          //                                     onPressed: () {
                          //                                       setState(() {
                          //                                         identityController.text = trellisIdentityData[index]['text'].toString();
                          //                                       });
                          //                                       needsBottomSheet(context, "Identity", <Widget>[
                          //                                         NameField(identityController,"identity",5,200,true,otherUserLoggedIn),
                          //                                         SaveButtonWidgets( (){
                          //                                           FocusManager.instance.primaryFocus?.unfocus();
                          //                                           _updateTrellisIdentityData(index, trellisIdentityData[index]['id'].toString());
                          //                                         }),
                          //                                       ]);
                          //
                          //                                     },
                          //                                     icon:const Icon(Icons.edit,color: AppColors.primaryColor,),
                          //                                   ),),
                          //                                 Align(alignment: Alignment.topRight,
                          //                                   child: IconButton(
                          //                                     onPressed: () {
                          //                                       // _deleteRecord("identity", trellisIdentityData[index]['id'],index,"");
                          //                                       showDeletePopup("identity",trellisIdentityData[index]['id'],index,"");
                          //                                     },
                          //                                     icon:const Icon(Icons.delete,color: AppColors.redColor,),
                          //                                   ),),
                          //                               ],
                          //                             ),
                          //                           ),
                          //                         Align(
                          //                             alignment: Alignment.topLeft,
                          //                             child: Text(trellisIdentityData[index]['text'].toString()))
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


                    // ExpansionTileWidgetScreen(isIdentityExpanded,"Identity",true,"","",true,(bool value) {
                    //   // ignore: avoid_print
                    //   print(value);
                    //   setScreenStatus("Identity",value);
                    //
                    // },() {
                    //   String? videoId = YoutubePlayer.convertUrlToId(identityUrl);
                    //   YoutubePlayerController playerController7 = YoutubePlayerController(
                    //       initialVideoId: videoId!,
                    //       flags: const YoutubePlayerFlags(
                    //         autoPlay: false,
                    //         controlsVisibleAtStart: false,
                    //       )
                    //
                    //   );
                    //   videoPopupDialog(context,"Introduction to Identity",playerController7);
                    //   // bottomSheet(context,"Identity","My identity is the primary way I identify myself to me and the world around me. Example - “I am a beloved child of God.” Also you can use personality assessments like Enneagram, Strengths, or Meyers-Briggs results and others.","");
                    // },
                    //     <Widget>[
                    //       Container(
                    //         decoration:const BoxDecoration(
                    //             color: AppColors.lightGreyColor,
                    //             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                    //         ),
                    //         padding:const EdgeInsets.symmetric(vertical: 10),
                    //         child: Column(
                    //           children: [
                    //             if(!otherUserLoggedIn)
                    //               AddButton(userPremium == "no" ? trellisIdentityData.length>= isIdentityLength : false,(){
                    //                 needsBottomSheet(context, "Identity", <Widget>[
                    //                   NameField(identityController,"identity",5,0,true,otherUserLoggedIn),
                    //                   SaveButtonWidgets( (){
                    //                     FocusManager.instance.primaryFocus?.unfocus();
                    //                     _setTrellisIdentityData ();
                    //                   }),
                    //                 ]);
                    //               }),
                    //             Container(
                    //               margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    //               child:trellisIdentityData.isEmpty ? const Align(
                    //                   alignment: Alignment.topLeft,
                    //                   child: Text("")) : ListView.builder(
                    //                   shrinkWrap: true,
                    //                   itemCount: trellisIdentityData.length,
                    //                   physics: const NeverScrollableScrollPhysics(),
                    //                   itemBuilder:(context,index) {
                    //                     return GestureDetector(
                    //                       child: Container(
                    //                           margin:const EdgeInsets.symmetric(vertical: 5),
                    //                           decoration: BoxDecoration(
                    //                               color: AppColors.backgroundColor,
                    //                               borderRadius: BorderRadius.circular(10)
                    //                           ),
                    //                           padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                    //                           child: Column(
                    //                             children: [
                    //                               if(!otherUserLoggedIn)
                    //                                 Align(
                    //                                   alignment: Alignment.topRight,
                    //                                   child: Row(
                    //                                     mainAxisAlignment: MainAxisAlignment.end,
                    //                                     crossAxisAlignment: CrossAxisAlignment.end,
                    //                                     children: [
                    //                                       Align(alignment: Alignment.topRight,
                    //                                         child: IconButton(
                    //                                           onPressed: () {
                    //                                             setState(() {
                    //                                               identityController.text = trellisIdentityData[index]['text'].toString();
                    //                                             });
                    //                                             needsBottomSheet(context, "Identity", <Widget>[
                    //                                               NameField(identityController,"identity",5,200,true,otherUserLoggedIn),
                    //                                               SaveButtonWidgets( (){
                    //                                                 FocusManager.instance.primaryFocus?.unfocus();
                    //                                                 _updateTrellisIdentityData(index, trellisIdentityData[index]['id'].toString());
                    //                                               }),
                    //                                             ]);
                    //
                    //                                           },
                    //                                           icon:const Icon(Icons.edit,color: AppColors.primaryColor,),
                    //                                         ),),
                    //                                       Align(alignment: Alignment.topRight,
                    //                                         child: IconButton(
                    //                                           onPressed: () {
                    //                                             // _deleteRecord("identity", trellisIdentityData[index]['id'],index,"");
                    //                                             showDeletePopup("identity",trellisIdentityData[index]['id'],index,"");
                    //                                           },
                    //                                           icon:const Icon(Icons.delete,color: AppColors.redColor,),
                    //                                         ),),
                    //                                     ],
                    //                                   ),
                    //                                 ),
                    //                               Align(
                    //                                   alignment: Alignment.topLeft,
                    //                                   child: Text(trellisIdentityData[index]['text'].toString()))
                    //                             ],
                    //                           )),
                    //                     );
                    //                   }
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     ]
                    // ),

                    ExpansionTileWidgetScreen(isPurposeExpanded,"Purpose",isPurposeExpanded,purposeController.text,"",true,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Purpose",value);
                      setState(() {
                        isPurposeExpanded = value;
                      });
                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(purposeUrl);
                      YoutubePlayerController playerController2 = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to purpose",playerController2);
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
                                        child: NameField(purposeController,"Purpose",4,140,false,otherUserLoggedIn))),
                                if(!otherUserLoggedIn)
                                SaveButtonWidgets( (){
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _setTrellisData();
                                }),
                              ],
                            ),
                          )


                        ]
                    ),

                    ExpansionTileWidgetScreen(isVisionExpanded,"Vision",isVisionExpanded,trellisVisionDataModel?.vision ?? '',"",true,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Identity",value);
                      setState(() {
                        isVisionExpanded = value;
                      });

                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(visionUrl);
                      YoutubePlayerController playerController7 = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Vision",playerController7);
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(!otherUserLoggedIn)
                                  Align(alignment: Alignment.topRight,
                                    child: trellisVisionDataModel?.vision != null &&   trellisVisionDataModel?.vision  != '' ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(onPressed: (){
                                          visionController.text = trellisVisionDataModel?.vision ?? '';
                                          relationalVisionController.text = trellisVisionDataModel?.relationalVision ?? '';
                                          emotionalVisionController.text = trellisVisionDataModel?.emotionalVision ?? '';
                                          physicalVisionController.text = trellisVisionDataModel?.physicalVision ?? '';
                                          workVisionController.text = trellisVisionDataModel?.workVision ?? '';
                                          financialVisionController.text = trellisVisionDataModel?.financialVision ?? '';
                                          spiritualVisionController.text = trellisVisionDataModel?.spiritualVision ?? '';
                                          visionBottomSheet(
                                              context,
                                              "Vision",
                                              visionController,
                                              relationalVisionController,
                                              emotionalVisionController,
                                              physicalVisionController,
                                              workVisionController,
                                              financialVisionController,
                                              spiritualVisionController,
                                                  (){
                                                if(visionController.text.trim().isNotEmpty){
                                                  _setTrellisVisionData();
                                                }else{
                                                  // for(int i=0; i<trellisVisionData.length;i++) {
                                                  //   visionController.text = trellisVisionData[i]['vision'];
                                                  //   relationalVisionController.text = trellisVisionData[i]['relational_vision'];
                                                  //   emotionalVisionController.text = trellisVisionData[i]['emotional_vision'];
                                                  //   physicalVisionController.text = trellisVisionData[i]['physical_vision'];
                                                  //   workVisionController.text = trellisVisionData[i]['work_vision'];
                                                  //   financialVisionController.text = trellisVisionData[i]['financial_vision'];
                                                  //   spiritualVisionController.text = trellisVisionData[i]['spiritual_vision'];
                                                  // }
                                                  showToastMessage(context, "please enter data in fields!", false);
                                                }


                                              }
                                          );
                                        }, icon: const Icon(Icons.edit,color: AppColors.primaryColor,),),
                                        IconButton(
                                          onPressed: () {
                                            showDeletePopup( "vision",trellisVisionData[0]['id'].toString(),0,"vision");
                                          }, icon: const Icon(Icons.delete,color: AppColors.redColor,),
                                        ),
                                      ],
                                    )  : AddButton(false, (){
                                          visionController.text = trellisVisionDataModel?.vision ?? '';
                                          relationalVisionController.text = trellisVisionDataModel?.relationalVision ?? '';
                                          emotionalVisionController.text = trellisVisionDataModel?.emotionalVision ?? '';
                                          physicalVisionController.text = trellisVisionDataModel?.physicalVision ?? '';
                                          workVisionController.text = trellisVisionDataModel?.workVision ?? '';
                                          financialVisionController.text = trellisVisionDataModel?.financialVision ?? '';
                                          spiritualVisionController.text = trellisVisionDataModel?.spiritualVision ?? '';
                                          visionBottomSheet(
                                              context,
                                              "Vision",
                                              visionController,
                                              relationalVisionController,
                                              emotionalVisionController,
                                              physicalVisionController,
                                              workVisionController,
                                              financialVisionController,
                                              spiritualVisionController,
                                                  (){
                                                if(visionController.text.trim().isNotEmpty){
                                                  _setTrellisVisionData();
                                                }else{
                                                // for(int i=0; i<trellisVisionData.length;i++) {
                                                //   visionController.text = trellisVisionData[i]['vision'];
                                                //   relationalVisionController.text = trellisVisionData[i]['relational_vision'];
                                                //   emotionalVisionController.text = trellisVisionData[i]['emotional_vision'];
                                                //   physicalVisionController.text = trellisVisionData[i]['physical_vision'];
                                                //   workVisionController.text = trellisVisionData[i]['work_vision'];
                                                //   financialVisionController.text = trellisVisionData[i]['financial_vision'];
                                                //   spiritualVisionController.text = trellisVisionData[i]['spiritual_vision'];
                                                // }
                                                showToastMessage(context, "please enter data in fields!", false);
                                              }


                                            }
                                        );
                                      }
                                    ),
                                  ),


                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                          // visible : trellisVisionDataModel?.vision != null &&  trellisVisionDataModel?.vision != '',
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Vision",style: TextStyle(
                                                  fontSize: AppConstants.defaultFontSize,
                                                  color: AppColors.primaryColor),
                                              ),
                                              Visibility(
                                                visible: trellisVisionDataModel?.vision != null && trellisVisionDataModel?.vision != '',
                                                child: Container(
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  child: Text(trellisVisionDataModel?.vision ?? '',style: const TextStyle(fontSize: AppConstants.defaultFontSize, color: AppColors.textColor),),
                                                ),
                                              )
                                            ],
                                          )
                                      ),
                                      Visibility(
                                          // visible: (trellisVisionDataModel?.physicalVision != null  && trellisVisionDataModel?.physicalVision != '')  || (trellisVisionDataModel?.relationalVision != null && trellisVisionDataModel?.relationalVision != '') || (trellisVisionDataModel?.emotionalVision != null && trellisVisionDataModel?.emotionalVision != '') || (trellisVisionDataModel?.workVision != null && trellisVisionDataModel?.workVision != '') || (trellisVisionDataModel?.financialVision != null && trellisVisionDataModel?.financialVision != '') || (trellisVisionDataModel?.spiritualVision != null && trellisVisionDataModel?.spiritualVision != ''),
                                          child: Padding(
                                            padding : const EdgeInsets.symmetric(vertical: 5),
                                            child : const Text(
                                              "Obituary (1-2 sentences per section)", style: TextStyle(
                                                fontSize: AppConstants.defaultFontSize,
                                                color: AppColors.primaryColor),
                                            ),
                                          )
                                      ),
                                      Visibility(
                                          // visible : trellisVisionDataModel?.physicalVision != null && trellisVisionDataModel?.physicalVision != '',
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Physical Vision",style: TextStyle(
                                                  fontSize: AppConstants.defaultFontSize,
                                                  color: AppColors.primaryColor),
                                              ),
                                              Visibility(
                                                visible : trellisVisionDataModel?.physicalVision != null && trellisVisionDataModel?.physicalVision != '',
                                                child: Container(
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  child: Text(trellisVisionDataModel?.physicalVision ?? '',style: const TextStyle(fontSize: AppConstants.defaultFontSize, color: AppColors.textColor),),
                                                ),
                                              ),


                                            ],
                                          )
                                      ),
                                      const SizedBox(height: 5),
                                      Visibility(
                                          // visible : trellisVisionDataModel?.relationalVision != null &&  trellisVisionDataModel?.relationalVision != '',
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [


                                              const Text(
                                                "Relational Vision",style: TextStyle(
                                                  fontSize: AppConstants.defaultFontSize,
                                                  color: AppColors.primaryColor),
                                              ),
                                              Visibility(
                                                visible : trellisVisionDataModel?.relationalVision != null &&  trellisVisionDataModel?.relationalVision != '',
                                                child: Container(
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  child: Text(trellisVisionDataModel?.relationalVision ?? '',style: const TextStyle(fontSize: AppConstants.defaultFontSize, color: AppColors.textColor),),
                                                ),
                                              )



                                            ],
                                          )
                                      ),
                                      const SizedBox(height: 5),
                                      Visibility(
                                          // visible : trellisVisionDataModel?.emotionalVision != null &&  trellisVisionDataModel?.emotionalVision != '',
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Emotional Vision",style: TextStyle(
                                                  fontSize: AppConstants.defaultFontSize,
                                                  color: AppColors.primaryColor),
                                              ),
                                              Visibility(
                                                visible : trellisVisionDataModel?.emotionalVision != null &&  trellisVisionDataModel?.emotionalVision != '',
                                                child: Container(
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  child: Text(trellisVisionDataModel?.emotionalVision ?? '',style: const TextStyle(fontSize: AppConstants.defaultFontSize, color: AppColors.textColor),),
                                                ),
                                              ),


                                            ],
                                          )
                                      ),
                                      const SizedBox(height: 5),
                                      Visibility(
                                          // visible : trellisVisionDataModel?.workVision != null && trellisVisionDataModel?.workVision != '',
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Work Vision",style: TextStyle(
                                                  fontSize: AppConstants.defaultFontSize,
                                                  color: AppColors.primaryColor),
                                              ),
                                              Visibility(
                                                visible : trellisVisionDataModel?.workVision != null && trellisVisionDataModel?.workVision != '',
                                                child: Container(
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  child: Text(trellisVisionDataModel?.workVision ?? '',style: const TextStyle(fontSize: AppConstants.defaultFontSize, color: AppColors.textColor),),
                                                ),
                                              )


                                            ],
                                          )
                                      ),
                                      const SizedBox(height: 5),
                                      Visibility(
                                          // visible : trellisVisionDataModel?.financialVision != null && trellisVisionDataModel?.financialVision != '',
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Financial Vision",style: TextStyle(
                                                  fontSize: AppConstants.defaultFontSize,
                                                  color: AppColors.primaryColor),
                                              ),
                                              Visibility(
                                                visible : trellisVisionDataModel?.financialVision != null && trellisVisionDataModel?.financialVision != '',
                                                child: Container(
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  child: Text(trellisVisionDataModel?.financialVision ?? '',style: const TextStyle(fontSize: AppConstants.defaultFontSize, color: AppColors.textColor),),
                                                ),
                                              )


                                            ],
                                          )
                                      ),
                                      const SizedBox(height: 5),
                                      Visibility(
                                          // visible : trellisVisionDataModel?.spiritualVision != null && trellisVisionDataModel?.spiritualVision != '',
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Spiritual Vision",style: TextStyle(
                                                  fontSize: AppConstants.defaultFontSize,
                                                  color: AppColors.primaryColor),
                                              ),
                                              Visibility(
                                                visible : trellisVisionDataModel?.spiritualVision != null && trellisVisionDataModel?.spiritualVision != '',
                                                child: Container(
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  child: Text(trellisVisionDataModel?.spiritualVision ?? '',style: const TextStyle(fontSize: AppConstants.defaultFontSize, color: AppColors.textColor),),
                                                ),
                                              )


                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          )
                        ]
                    ),

                      ExpansionTileWidgetScreen(isLadderExpanded,"Ladder",isLadderExpanded,trellisLadderDataFavorites.map((e) => '• ${e.text}').join('\n'),"",true,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Ladder",value);

                      setState(() {
                        isLadderExpanded = value;
                      });
                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(ladderUrl);
                      YoutubePlayerController playerController3 = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Ladder",playerController3);
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
                                if(!otherUserLoggedIn)
                                Align(alignment: Alignment.topRight,
                                  child: AddButton(userPremium == "no" ? trellisLadderDataForAchievements.length>=isLadderAchievements : false,
                                          () async {
                                            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                            sharedPreferences.setBool("IsGoals", true);
                                            print(userPremium);
                                
                                            setState(() {
                                              initialValueForLadderType = "Goals";
                                              initialValueForType = "Physical";
                                              initialValueForMType = "Memories";
                                              initialValueForGType = "Goals";
                                              titleForGController.clear();
                                              descriptionForGController.clear();
                                              dateForGController.clear();
                                              dateForGController.text = "";
                                              descriptionForGController.text = "";
                                              titleForGController.text = "";
                                            });
                                            ladderBottomSheet(false,context,true,true,"Ladder",
                                                initialValueForType,itemsForType,
                                                initialValueForLadderType, itemsForLadderType,
                                                initialValueForMType, itemsForMType,
                                                initialValueForGType, itemsForGType,
                                                    () async {
                                                  print('Ladder Type ===========> $initialValueForLadderType' );
                                                  print('Type ===========> $initialValueForType' );
                                                 if(userPremium == "no" && trellisLadderDataForGoalsFavourites.length >= isLadderGoals && trellisLadderDataForChallengesFavourites.length >= isLadderChallenges && trellisLadderDataForMemoriesAndAchievementsFavourites.length >= isLadderMemoriesAndAchievement &&  trellisLadderDataForMemoriesFavourites.length >= isLadderMemories  && trellisLadderDataForAchievementsFavourites.length >= isLadderAchievements){
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                  }else{
                                                    if(initialValueForLadderType != "Challenges"){
                                                      if(dateForGController.text.isEmpty) {
                                                        showToastMessage(context, "Please select a date", false);
                                                        return;
                                                      }
                                                    }

                                                    if(initialValueForLadderType == "Goals" || initialValueForLadderType == "Challenges"){
                                                      print('Initial Value For Ladder Type is Goals or Challenges ========> ');
                                                      print(initialValueForLadderType);
                                                      print(initialValueForType);
                                                      _setLadderGoalsData();

                                                    }else if(initialValueForLadderType == "Memories" || initialValueForLadderType == "Achievements"){
                                                      print('Initial Value For Ladder Type is Memories or Achievements ========> ');
                                                      initialValueForType = "";
                                                      print(initialValueForLadderType);
                                                      print(initialValueForType);
                                                      _setLadderMemoriesData();
                                                    }



                                                  }

                                                },
                                                    (value) {
                                                  print(value);
                                                  setState(() {
                                                    initialValueForLadderType = value;
                                                  });
                                                },
                                                    (value) {
                                                  print(value);
                                                  setState(() {
                                                    initialValueForType = value;
                                                  });
                                                },
                                                dateForGController,
                                                titleForGController,
                                                descriptionForGController
                                            );
                                      }
                                  ),
                                ),
                                Container(
                                  margin:const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(
                                        children: [
                                          const Text("Future",style: TextStyle(
                                              fontSize: AppConstants.defaultFontSize,
                                              color: AppColors.primaryColor
                                          ),),
                                        ],
                                      ),



                                    ],
                                  ),
                                ),

                                trellisLadderDataForGoalsFavourites.isEmpty ? const Text("") : Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: trellisLadderDataForGoalsFavourites.length,
                                      itemBuilder:(context,index) {
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => _buildPopupDialog(context,"Goals",trellisLadderDataForGoalsFavourites[index],false),
                                            );
                                          },
                                          child: Container(
                                              margin:const EdgeInsets.symmetric(vertical: 5),
                                             decoration: BoxDecoration(
                                               color: AppColors.backgroundColor,
                                               borderRadius: BorderRadius.circular(10)
                                             ),
                                              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 15, top: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("${trellisLadderDataForGoalsFavourites[index].option1} | ${trellisLadderDataForGoalsFavourites[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),

                                                      if(!otherUserLoggedIn)
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap:(){
                                                              if(trellisLadderDataForGoalsFavourites[index].favourite != 'no'){
                                                                _setLadderFavouriteItem(index,trellisLadderDataForGoalsFavourites[index].id.toString(),trellisLadderDataForGoalsFavourites[index].favourite.toString());
                                                              }else{
                                                                final items = trellisLadderDataFavorites.where((e) => e.type == 'goal');
                                                                if(items.length < 2){
                                                                  _setLadderFavouriteItem(index,trellisLadderDataForGoalsFavourites[index].id.toString(),trellisLadderDataForGoalsFavourites[index].favourite.toString());
                                                                }else{
                                                                  showToastMessage(context, "You cannot add more than two goals as favorites", false);
                                                                }
                                                              }
                                                            },
                                                            child: trellisLadderDataForGoalsFavourites[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          InkWell(onTap: () async {
                                                            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                                            sharedPreferences.setBool("IsGoals", true);
                                                            setState(() {
                                                              titleForGController.clear();
                                                              descriptionForGController.clear();
                                                              descriptionForGController.text = "";
                                                              titleForGController.text = "";
                                                            });
                                                            setState(() {
                                                              initialValueForType = trellisLadderDataForGoalsFavourites[index].option1!;
                                                              initialValueForLadderType = trellisLadderDataForGoalsFavourites[index].option2!;
                                                              dateForGController.text = trellisLadderDataForGoalsFavourites[index].date!;
                                                              titleForGController.text = trellisLadderDataForGoalsFavourites[index].text!;
                                                              descriptionForGController.text = trellisLadderDataForGoalsFavourites[index].description!;
                                                            });

                                                            ladderBottomSheet(false,context,true,true,"Ladder",
                                                                initialValueForType,itemsForType,
                                                                initialValueForLadderType, itemsForLadderType,
                                                                initialValueForMType, itemsForMType,
                                                                initialValueForGType, itemsForGType,
                                                                    () async {
                                                                  print('Ladder Type ===========> $initialValueForLadderType' );
                                                                  print('Type ===========> $initialValueForType' );
                                                                  if(userPremium == "no" && trellisLadderDataForGoalsFavourites.length >= isLadderGoals){
                                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                                  }else{
                                                                    if(initialValueForLadderType != "Challenges"){
                                                                      if(dateForGController.text.isEmpty) {
                                                                        showToastMessage(context, "Please select a date", false);
                                                                        return;
                                                                      }
                                                                    }

                                                                    if(initialValueForLadderType == "Goals" || initialValueForLadderType == "Challenges"){
                                                                      print('Initial Value For Ladder Type is Goals or Challenges ========> ');
                                                                      print(initialValueForLadderType);
                                                                      print(initialValueForType);
                                                                      _updateLadderGoalsData('goal',trellisLadderDataForGoalsFavourites[index].id!, index);



                                                                    }else if(initialValueForLadderType == "Memories" || initialValueForLadderType == "Achievements"){
                                                                      print('Initial Value For Ladder Type is Memories or Achievements ========> ');
                                                                      initialValueForType = "";
                                                                      print(initialValueForLadderType);
                                                                      print(initialValueForType);
                                                                      _updateLadderMemoriesData('goal',trellisLadderDataForGoalsFavourites[index].id!,index);

                                                                    }
                                                                  }

                                                                },
                                                                    (value) {
                                                                  print(value);
                                                                  setState(() {
                                                                    initialValueForLadderType = value;
                                                                  });
                                                                },
                                                                    (value) {
                                                                  print(value);
                                                                  setState(() {
                                                                    initialValueForType = value;
                                                                  });
                                                                },
                                                                dateForGController,
                                                                titleForGController,
                                                                descriptionForGController
                                                            );

                                                            // showDeletePopup( "goal",trellisLadderDataForGoals[index].id.toString(),index,trellisLadderDataForGoals[index].option2!);
                                                          }, child: const Icon(Icons.edit,color: AppColors.primaryColor,),),
                                                          const SizedBox(width: 10),

                                                          InkWell(onTap: () {
                                                            showDeletePopup( "goal",trellisLadderDataForGoalsFavourites[index].id.toString(),index,trellisLadderDataForGoalsFavourites[index].option2.toString());
                                                          }, child: const Icon(Icons.delete,color: AppColors.redColor,),),
                                                            ],
                                                          )

                                                    ],
                                                  ),
                                                  // Align(alignment: Alignment.topRight,
                                                  //   child: IconButton(
                                                  //     onPressed: () {},
                                                  //     icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                  //   ),),
                                                  const SizedBox(height: 10),
                                                  Align(
                                                      alignment: Alignment.topLeft,
                                                      child:  Text("${DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForGoalsFavourites[index].date.toString()))} | ${trellisLadderDataForGoalsFavourites[index].text} | ${trellisLadderDataForGoalsFavourites[index].description}"))
                                                ],
                                              )),
                                        );
                                      }
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10,),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Present",style: TextStyle(
                                              fontSize: AppConstants.defaultFontSize,
                                              color: AppColors.primaryColor
                                          ),),
                                          // const SizedBox(
                                          //   width: 10,
                                          // ),
                                          // IconButton(
                                          //     onPressed: (){
                                          //       bottomSheet(context,"Challenges","Challenges are obstacles or difficulties that arise while striving to achieve goals. They test one's resilience, problem-solving abilities, and determination. ","");
                                          //     },
                                          //     icon:const Icon(Icons.info_outline,size:20,color: AppColors.infoIconColor,)),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                                trellisLadderDataForChallengesFavourites.isEmpty ?const Text("") : Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: trellisLadderDataForChallengesFavourites.length,
                                      itemBuilder:(context,index) {
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => _buildPopupDialog(context,"Challenges",trellisLadderDataForChallengesFavourites[index],true),
                                            );
                                          },
                                          child: Container(
                                              margin:const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: AppColors.backgroundColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 15, top: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("${trellisLadderDataForChallengesFavourites[index].option1} | ${trellisLadderDataForChallengesFavourites[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),

                                                      if(!otherUserLoggedIn)
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap:(){
                                                                if(trellisLadderDataForChallengesFavourites[index].favourite != 'no'){
                                                                  _setLadderFavouriteItem(index,trellisLadderDataForChallengesFavourites[index].id.toString(),trellisLadderDataForChallengesFavourites[index].favourite.toString());
                                                                }else{
                                                                  final items = trellisLadderDataFavorites.where((e) => e.type == 'challenges');
                                                                  if(items.length < 2){
                                                                    _setLadderFavouriteItem(index,trellisLadderDataForChallengesFavourites[index].id.toString(),trellisLadderDataForChallengesFavourites[index].favourite.toString());
                                                                  }else{
                                                                    showToastMessage(context, "You cannot add more than two challenges as favorites", false);
                                                                  }
                                                                }
                                                              },
                                                              child: trellisLadderDataForChallengesFavourites[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                                            ),
                                                            const SizedBox(width: 10),
                                                            InkWell(onTap: () async {
                                                              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                                              sharedPreferences.setBool("IsGoals", true);
                                                              setState(() {
                                                                titleForGController.clear();
                                                                descriptionForGController.clear();
                                                                descriptionForGController.text = "";
                                                                titleForGController.text = "";
                                                              });
                                                              setState(() {
                                                                initialValueForType = trellisLadderDataForChallengesFavourites[index].option1!.capitalize();
                                                                initialValueForLadderType = trellisLadderDataForChallengesFavourites[index].option2!;
                                                                // dateForGController.text = trellisLadderDataForGoalsChallenges[index].date!;
                                                                titleForGController.text = trellisLadderDataForChallengesFavourites[index].text!;
                                                                descriptionForGController.text = trellisLadderDataForChallengesFavourites[index].description!;
                                                              });

                                                              ladderBottomSheet(false,context,true,false,"Ladder",
                                                                  initialValueForType,itemsForType,
                                                                  initialValueForLadderType, itemsForLadderType,
                                                                  initialValueForMType, itemsForMType,
                                                                  initialValueForGType, itemsForGType,
                                                                      () async {
                                                                    print('Ladder Type ===========> $initialValueForLadderType' );
                                                                    print('Type ===========> $initialValueForType' );
                                                                    if(userPremium == "no" && trellisLadderDataForChallengesFavourites.length >= isLadderChallenges ){
                                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                                    }else{
                                                                      if(initialValueForLadderType != "Challenges"){
                                                                        if(dateForGController.text.isEmpty) {
                                                                          showToastMessage(context, "Please select a date", false);
                                                                          return;
                                                                        }
                                                                      }

                                                                      if(initialValueForLadderType == "Goals" || initialValueForLadderType == "Challenges"){
                                                                        print('Initial Value For Ladder Type is Goals or Challenges ========> ');
                                                                        print(initialValueForLadderType);
                                                                        print(initialValueForType);
                                                                        _updateLadderGoalsData('challenges',trellisLadderDataForChallengesFavourites[index].id!, index);



                                                                      }else if(initialValueForLadderType == "Memories" || initialValueForLadderType == "Achievements"){
                                                                        print('Initial Value For Ladder Type is Memories or Achievements ========> ');
                                                                        initialValueForType = "";
                                                                        print(initialValueForLadderType);
                                                                        print(initialValueForType);
                                                                        _updateLadderMemoriesData('challenges',trellisLadderDataForChallengesFavourites[index].id!,index);

                                                                      }
                                                                    }

                                                                  },
                                                                      (value) {
                                                                    print(value);
                                                                    setState(() {
                                                                      initialValueForLadderType = value;
                                                                    });
                                                                  },
                                                                      (value) {
                                                                    print(value);
                                                                    setState(() {
                                                                      initialValueForType = value;
                                                                    });
                                                                  },
                                                                  dateForGController,
                                                                  titleForGController,
                                                                  descriptionForGController
                                                              );

                                                              // showDeletePopup( "goal",trellisLadderDataForGoals[index].id.toString(),index,trellisLadderDataForGoals[index].option2!);
                                                            }, child: const Icon(Icons.edit,color: AppColors.primaryColor,),),
                                                            const SizedBox(width: 10),

                                                            InkWell(onTap: () {
                                                              showDeletePopup( "challenges",trellisLadderDataForChallengesFavourites[index].id.toString(),index,"");
                                                            }, child: const Icon(Icons.delete,color: AppColors.redColor,),),
                                                          ],
                                                        )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("${trellisLadderDataForChallengesFavourites[index].text}"))
                                                ],
                                              )),
                                        );
                                      }
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10,),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Past",style: TextStyle(
                                              fontSize: AppConstants.defaultFontSize,
                                              color: AppColors.primaryColor
                                          ),),
                                          // const SizedBox(
                                          //   width: 10,
                                          // ),
                                          // IconButton(
                                          //     onPressed: (){
                                          //       bottomSheet(context,"Memories","Memories are recollections of past experiences, whether joyful, sorrowful, or mundane. They shape our identity and influence our future actions and decisions.","");
                                          //     },
                                          //     icon:const Icon(Icons.info_outline,size:20,color: AppColors.infoIconColor,)),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                                  trellisLadderDataForMemoriesAndAchievementsFavourites.isEmpty ? const SizedBox() : Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: trellisLadderDataForMemoriesAndAchievementsFavourites.length,
                                        itemBuilder:(context,index) {
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) => _buildPopupDialog(context,"Memories & Achievement",trellisLadderDataForMemoriesAndAchievementsFavourites[index],true),
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
                                                        Text("${trellisLadderDataForMemoriesAndAchievementsFavourites[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),

                                                        if(!otherUserLoggedIn)
                                                          Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap:(){
                                                                  if(trellisLadderDataForMemoriesAndAchievementsFavourites[index].favourite != 'no'){
                                                                    _setLadderFavouriteItem(index,trellisLadderDataForMemoriesAndAchievementsFavourites[index].id.toString(),trellisLadderDataForMemoriesAndAchievementsFavourites[index].favourite.toString());
                                                                  }else{
                                                                    final items = trellisLadderDataFavorites.where((e) => e.type == 'achievements' || e.type == 'memories' );
                                                                    if(items.length < 2){
                                                                      _setLadderFavouriteItem(index,trellisLadderDataForMemoriesAndAchievementsFavourites[index].id.toString(),trellisLadderDataForMemoriesAndAchievementsFavourites[index].favourite.toString());
                                                                    }else{
                                                                      showToastMessage(context, "You cannot add more than two memories or achievements as favorites", false);
                                                                    }
                                                                  }


                                                                },
                                                                child: trellisLadderDataForMemoriesAndAchievementsFavourites[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                                              ),
                                                              IconButton(
                                                                onPressed: () async {
                                                                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                                                  sharedPreferences.setBool("IsGoals", false);
                                                                  setState(() {
                                                                    titleForGController.clear();
                                                                    descriptionForGController.clear();
                                                                    dateForGController.clear();
                                                                    dateForGController.text = "";
                                                                    descriptionForGController.text = "";
                                                                    titleForGController.text = "";
                                                                  });
                                                                  setState(() {
                                                                    initialValueForLadderType = trellisLadderDataForMemoriesAndAchievementsFavourites[index].option2!.capitalize();
                                                                    initialValueForType = 'Physical';
                                                                    dateForGController.text = trellisLadderDataForMemoriesAndAchievementsFavourites[index].date!;
                                                                    titleForGController.text = trellisLadderDataForMemoriesAndAchievementsFavourites[index].text!;
                                                                    descriptionForGController.text = trellisLadderDataForMemoriesAndAchievementsFavourites[index].description!;
                                                                  });


                                                                  ladderBottomSheet(false,context,false,true,"Ladder",
                                                                      initialValueForType,itemsForType,
                                                                      initialValueForLadderType, itemsForLadderType,
                                                                      initialValueForMType, itemsForMType,
                                                                      initialValueForGType, itemsForGType,
                                                                          () async {
                                                                        print('Ladder Type ===========> $initialValueForLadderType' );
                                                                        print('Type ===========> $initialValueForType' );
                                                                        if(userPremium == "no" && trellisLadderDataForMemoriesAndAchievementsFavourites.length >= isLadderMemoriesAndAchievement){
                                                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                                        }else{
                                                                          if(initialValueForLadderType != "Challenges"){
                                                                            if(dateForGController.text.isEmpty) {
                                                                              showToastMessage(context, "Please select a date", false);
                                                                              return;
                                                                            }
                                                                          }

                                                                          if(initialValueForLadderType == "Goals" || initialValueForLadderType == "Challenges"){
                                                                            print('Initial Value For Ladder Type is Goals or Challenges ========> ');
                                                                            print(initialValueForLadderType);
                                                                            print(initialValueForType);
                                                                            if(trellisLadderDataForMemoriesAndAchievementsFavourites[index].type == 'memories'){
                                                                              _updateLadderGoalsData('memories',trellisLadderDataForMemoriesAndAchievementsFavourites[index].id!, index);
                                                                            }else if(trellisLadderDataForMemoriesAndAchievementsFavourites[index].type == 'achievements'){
                                                                              _updateLadderGoalsData('achievements',trellisLadderDataForMemoriesAndAchievementsFavourites[index].id!, index);
                                                                            }




                                                                          }else if(initialValueForLadderType == "Memories" || initialValueForLadderType == "Achievements"){
                                                                            print('Initial Value For Ladder Type is Memories or Achievements ========> ');
                                                                            initialValueForType = "";
                                                                            print(initialValueForLadderType);
                                                                            print(initialValueForType);
                                                                            if(trellisLadderDataForMemoriesAndAchievementsFavourites[index].type == 'memories'){
                                                                              _updateLadderMemoriesData('memories',trellisLadderDataForMemoriesAndAchievementsFavourites[index].id!,index);
                                                                            }else if(trellisLadderDataForMemoriesAndAchievementsFavourites[index].type == 'achievements'){
                                                                              _updateLadderMemoriesData('achievements',trellisLadderDataForMemoriesAndAchievementsFavourites[index].id!,index);
                                                                            }


                                                                          }
                                                                        }

                                                                      },
                                                                          (value) {
                                                                        print(value);
                                                                        setState(() {
                                                                          initialValueForLadderType = value;
                                                                        });
                                                                      },
                                                                          (value) {
                                                                        print(value);
                                                                        setState(() {
                                                                          initialValueForType = value;
                                                                        });
                                                                      },
                                                                      dateForGController,
                                                                      titleForGController,
                                                                      descriptionForGController
                                                                  );

                                                                  // showDeletePopup( "goal",trellisLadderDataForGoals[index].id.toString(),index,trellisLadderDataForGoals[index].option2!);
                                                                },
                                                                icon: const Icon(Icons.edit,color: AppColors.primaryColor,),),
                                                              IconButton(onPressed: () {
                                                                if(trellisLadderDataForMemoriesAndAchievementsFavourites[index].type == 'memories'){
                                                                  showDeletePopup( "memories",trellisLadderDataForMemoriesAndAchievementsFavourites[index].id.toString(),index,"");
                                                                }else if(trellisLadderDataForMemoriesAndAchievementsFavourites[index].type == 'achievements'){
                                                                  showDeletePopup( "achievements",trellisLadderDataForMemoriesAndAchievementsFavourites[index].id.toString(),index,"");
                                                                }

                                                              }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                                            ],
                                                          )
                                                      ],
                                                    ),
                                                    Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text("${DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForMemoriesAndAchievementsFavourites[index].date.toString()))} | ${trellisLadderDataForMemoriesAndAchievementsFavourites[index].text}"))
                                                  ],
                                                )
                                          ),
                                          );
                                        }
                                    ),
                                  ),

                                // trellisLadderDataForMemoriesFavourites.isEmpty ? const SizedBox() : Container(
                                //   margin: const EdgeInsets.symmetric(horizontal: 10),
                                //   child: ListView.builder(
                                //       shrinkWrap: true,
                                //       physics: const NeverScrollableScrollPhysics(),
                                //       itemCount: trellisLadderDataForMemoriesFavourites.length,
                                //       itemBuilder:(context,index) {
                                //         return GestureDetector(
                                //           onTap: () {
                                //             showDialog(
                                //               context: context,
                                //               builder: (BuildContext context) => _buildPopupDialog(context,"Memories",trellisLadderDataForMemoriesFavourites[index],true),
                                //             );
                                //           },
                                //           child: Container(
                                //               margin:const EdgeInsets.symmetric(vertical: 5),
                                //               decoration: BoxDecoration(
                                //                   color: AppColors.backgroundColor,
                                //                   borderRadius: BorderRadius.circular(10)
                                //               ),
                                //               padding:const EdgeInsets.only(left: 10,right: 10,bottom: 15, top: 10),
                                //               child: Column(
                                //                 children: [
                                //                   Row(
                                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                     children: [
                                //                       Text("${trellisLadderDataForMemoriesFavourites[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),

                                //                       if(!otherUserLoggedIn)
                                //                         Row(
                                //                           children: [
                                //                             GestureDetector(
                                //                               onTap:(){
                                //                                 if(trellisLadderDataForMemoriesFavourites[index].favourite != 'no'){
                                //                                   _setLadderFavouriteItem(index,trellisLadderDataForMemoriesFavourites[index].id.toString(),trellisLadderDataForMemoriesFavourites[index].favourite.toString());
                                //                                 }else{
                                //                                   final items = trellisLadderDataFavorites.where((e) => e.type == 'achievements' || e.type == 'memories' );
                                //                                   if(items.length < 2){
                                //                                     _setLadderFavouriteItem(index,trellisLadderDataForMemoriesFavourites[index].id.toString(),trellisLadderDataForMemoriesFavourites[index].favourite.toString());
                                //                                   }else{
                                //                                     showToastMessage(context, "You cannot add more than two memories or achievements as favorites", false);
                                //                                   }
                                //                                 }
                                //                               },
                                //                               child: trellisLadderDataForMemoriesFavourites[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                //                             ),
                                //                             const SizedBox(width: 10),
                                //                             InkWell(
                                //                               onTap: () async {
                                //                                 SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                //                                 sharedPreferences.setBool("IsGoals", false);
                                //                                 setState(() {
                                //                                   titleForGController.clear();
                                //                                   descriptionForGController.clear();
                                //                                   dateForGController.clear();
                                //                                   dateForGController.text = "";
                                //                                   descriptionForGController.text = "";
                                //                                   titleForGController.text = "";
                                //                                 });
                                //                                 setState(() {
                                //                                   initialValueForLadderType = trellisLadderDataForMemoriesFavourites[index].option2!.capitalize();
                                //                                   initialValueForType = 'Physical';
                                //                                   dateForGController.text = trellisLadderDataForMemoriesFavourites[index].date!;
                                //                                   titleForGController.text = trellisLadderDataForMemoriesFavourites[index].text!;
                                //                                   descriptionForGController.text = trellisLadderDataForMemoriesFavourites[index].description!;
                                //                                 });


                                //                                 ladderBottomSheet(false,context,false,true,"Ladder",
                                //                                     initialValueForType,itemsForType,
                                //                                     initialValueForLadderType, itemsForLadderType,
                                //                                     initialValueForMType, itemsForMType,
                                //                                     initialValueForGType, itemsForGType,
                                //                                         () async {
                                //                                       print('Ladder Type ===========> $initialValueForLadderType' );
                                //                                       print('Type ===========> $initialValueForType' );
                                //                                       if(userPremium == "no" && trellisLadderDataForMemoriesFavourites.length >= isLadderMemories){
                                //                                         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                //                                       }else{
                                //                                         if(initialValueForLadderType != "Challenges"){
                                //                                           if(dateForGController.text.isEmpty) {
                                //                                             showToastMessage(context, "Please select a date", false);
                                //                                             return;
                                //                                           }
                                //                                         }

                                //                                         if(initialValueForLadderType == "Goals" || initialValueForLadderType == "Challenges"){
                                //                                           print('Initial Value For Ladder Type is Goals or Challenges ========> ');
                                //                                           print(initialValueForLadderType);
                                //                                           print(initialValueForType);
                                //                                           _updateLadderGoalsData('memories',trellisLadderDataForMemoriesFavourites[index].id!, index);



                                //                                         }else if(initialValueForLadderType == "Memories" || initialValueForLadderType == "Achievements"){
                                //                                           print('Initial Value For Ladder Type is Memories or Achievements ========> ');
                                //                                           initialValueForType = "";
                                //                                           print(initialValueForLadderType);
                                //                                           print(initialValueForType);
                                //                                           _updateLadderMemoriesData('memories',trellisLadderDataForMemoriesFavourites[index].id!,index);

                                //                                         }
                                //                                       }

                                //                                     },
                                //                                         (value) {
                                //                                       print(value);
                                //                                       setState(() {
                                //                                         initialValueForLadderType = value;
                                //                                       });
                                //                                     },
                                //                                         (value) {
                                //                                       print(value);
                                //                                       setState(() {
                                //                                         initialValueForType = value;
                                //                                       });
                                //                                     },
                                //                                     dateForGController,
                                //                                     titleForGController,
                                //                                     descriptionForGController
                                //                                 );

                                //                                 // showDeletePopup( "goal",trellisLadderDataForGoals[index].id.toString(),index,trellisLadderDataForGoals[index].option2!);
                                //                               },
                                //                               child: const Icon(Icons.edit,color: AppColors.primaryColor,),),

                                //                             const SizedBox(width: 10),
                                //                             InkWell(
                                //                               onTap: () {
                                //                               showDeletePopup( "memories",trellisLadderDataForMemoriesFavourites[index].id.toString(),index,"");
                                //                             }, child: const Icon(Icons.delete,color: AppColors.redColor,),),
                                //                           ],
                                //                         )
                                //                     ],
                                //                   ),
                                //                   const SizedBox(height: 10),
                                //                   Align(
                                //                       alignment: Alignment.topLeft,
                                //                       child: Text("${DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForMemoriesFavourites[index].date.toString()))} | ${trellisLadderDataForMemoriesFavourites[index].text}"))
                                //                 ],
                                //               )),
                                //         );
                                //       }
                                //   ),
                                // ),

                                // trellisLadderDataForAchievementsFavourites.isEmpty ? const SizedBox() : Container(
                                //   margin: const EdgeInsets.symmetric(horizontal: 10),
                                //   child: ListView.builder(
                                //       shrinkWrap: true,
                                //       physics: const NeverScrollableScrollPhysics(),
                                //       itemCount: trellisLadderDataForAchievementsFavourites.length,
                                //       itemBuilder:(context,index) {
                                //         return GestureDetector(
                                //           onTap: () {
                                //             showDialog(
                                //               context: context,
                                //               builder: (BuildContext context) => _buildPopupDialog(context,"Achievements",trellisLadderDataForAchievementsFavourites[index],true),
                                //             );
                                //           },
                                //           child: Container(
                                //               margin:const EdgeInsets.symmetric(vertical: 5),
                                //               decoration: BoxDecoration(
                                //                   color: AppColors.backgroundColor,
                                //                   borderRadius: BorderRadius.circular(10)
                                //               ),
                                //               padding:const EdgeInsets.only(left: 10,right: 15,bottom: 15, top: 10),
                                //               child: Column(
                                //                 children: [
                                //                   Row(
                                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                     children: [
                                //                       Text("${trellisLadderDataForAchievementsFavourites[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),

                                //                       if(!otherUserLoggedIn)
                                //                       Row(
                                //                         children: [
                                //                           GestureDetector(
                                //                             onTap:(){
                                //                               if(trellisLadderDataForAchievementsFavourites[index].favourite != 'no'){
                                //                                 _setLadderFavouriteItem(index,trellisLadderDataForAchievementsFavourites[index].id.toString(),trellisLadderDataForAchievementsFavourites[index].favourite.toString());
                                //                               }else{
                                //                                 final items = trellisLadderDataFavorites.where((e) => e.type == 'achievements' || e.type == 'memories' );
                                //                                 if(items.length < 2){
                                //                                   _setLadderFavouriteItem(index,trellisLadderDataForAchievementsFavourites[index].id.toString(),trellisLadderDataForAchievementsFavourites[index].favourite.toString());
                                //                                 }else{
                                //                                   showToastMessage(context, "You cannot add more than two memories or achievements as favorites", false);
                                //                                 }
                                //                               }
                                //                             },
                                //                             child: trellisLadderDataForAchievementsFavourites[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                //                           ),
                                //                           const SizedBox(width: 10),
                                //                           InkWell(
                                //                             onTap: () async {
                                //                               SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                //                               sharedPreferences.setBool("IsGoals", false);
                                //                               setState(() {
                                //                                 titleForGController.clear();
                                //                                 descriptionForGController.clear();
                                //                                 dateForGController.clear();
                                //                                 dateForGController.text = "";
                                //                                 descriptionForGController.text = "";
                                //                                 titleForGController.text = "";
                                //                               });
                                //                               setState(() {
                                //                                 initialValueForLadderType = trellisLadderDataForAchievementsFavourites[index].option2!.capitalize();
                                //                                 initialValueForType = 'Physical';
                                //                                 dateForGController.text = trellisLadderDataForAchievementsFavourites[index].date!;
                                //                                 titleForGController.text = trellisLadderDataForAchievementsFavourites[index].text!;
                                //                                 descriptionForGController.text = trellisLadderDataForAchievementsFavourites[index].description!;
                                //                               });


                                //                               ladderBottomSheet(false,context,false,true,"Ladder",
                                //                                   initialValueForType,itemsForType,
                                //                                   initialValueForLadderType, itemsForLadderType,
                                //                                   initialValueForMType, itemsForMType,
                                //                                   initialValueForGType, itemsForGType,
                                //                                       () async {
                                //                                     print('Ladder Type ===========> $initialValueForLadderType' );
                                //                                     print('Type ===========> $initialValueForType' );
                                //                                     if(userPremium == "no" && trellisLadderDataForAchievementsFavourites.length >= isLadderAchievements){
                                //                                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                //                                     }else{
                                //                                       if(initialValueForLadderType != "Challenges"){
                                //                                         if(dateForGController.text.isEmpty) {
                                //                                           showToastMessage(context, "Please select a date", false);
                                //                                           return;
                                //                                         }
                                //                                       }

                                //                                       if(initialValueForLadderType == "Goals" || initialValueForLadderType == "Challenges"){
                                //                                         print('Initial Value For Ladder Type is Goals or Challenges ========> ');
                                //                                         print(initialValueForLadderType);
                                //                                         print(initialValueForType);
                                //                                         _updateLadderGoalsData('achievements',trellisLadderDataForAchievementsFavourites[index].id!, index);



                                //                                       }else if(initialValueForLadderType == "Memories" || initialValueForLadderType == "Achievements"){
                                //                                         print('Initial Value For Ladder Type is Memories or Achievements ========> ');
                                //                                         initialValueForType = "";
                                //                                         print(initialValueForLadderType);
                                //                                         print(initialValueForType);
                                //                                         _updateLadderMemoriesData('achievements',trellisLadderDataForAchievementsFavourites[index].id!,index);

                                //                                       }
                                //                                     }

                                //                                   },
                                //                                       (value) {
                                //                                     print(value);
                                //                                     setState(() {
                                //                                       initialValueForLadderType = value;
                                //                                     });
                                //                                   },
                                //                                       (value) {
                                //                                     print(value);
                                //                                     setState(() {
                                //                                       initialValueForType = value;
                                //                                     });
                                //                                   },
                                //                                   dateForGController,
                                //                                   titleForGController,
                                //                                   descriptionForGController
                                //                               );

                                //                               // showDeletePopup( "goal",trellisLadderDataForGoals[index].id.toString(),index,trellisLadderDataForGoals[index].option2!);
                                //                             },
                                //                             child: const Icon(Icons.edit,color: AppColors.primaryColor,),),
                                //                           const SizedBox(width: 10),

                                //                           InkWell(onTap: () {
                                //                               showDeletePopup( "achievements",trellisLadderDataForAchievementsFavourites[index].id.toString(),index,"");
                                //                             }, child: const Icon(Icons.delete,color: AppColors.redColor,),),
                                //                         ],
                                //                       )
                                //                     ],
                                //                   ),
                                //                   const SizedBox(height: 10),
                                //                   Align(
                                //                       alignment: Alignment.topLeft,
                                //                       child: Text("${DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForAchievementsFavourites[index].date.toString()))} | ${trellisLadderDataForAchievementsFavourites[index].text}"))
                                //                 ],
                                //               )),
                                //         );
                                //       }
                                //   ),
                                // ),
                              


                                // Container(
                                //   margin: const EdgeInsets.symmetric(horizontal: 10,),
                                //   child: Row(
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Row(
                                //         children: [
                                //          const Text("Achievements",style: TextStyle(
                                //               fontSize: AppConstants.defaultFontSize,
                                //               color: AppColors.primaryColor
                                //           ),),
                                //          const SizedBox(
                                //             width: 10,
                                //           ),
                                //           IconButton(
                                //             onPressed: (){
                                //               bottomSheet(context,"Achievements","Achievements are milestones or successes reached as a result of effort, skill, and perseverance. They represent the fulfillment of goals and are often celebrated as significant accomplishments.","");
                                //             },
                                //             icon:const Icon(Icons.info_outline,size:20,color: AppColors.infoIconColor,)),
                                //         ],
                                //       ),

                                //     ],
                                //   ),
                                // ),

                                // trellisLadderDataForAchievementsFavourites.isEmpty ?const Text("") : Container(
                                //   margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                //   child: ListView.builder(
                                //       shrinkWrap: true,
                                //       physics: const NeverScrollableScrollPhysics(),
                                //       itemCount: trellisLadderDataForAchievementsFavourites.length >= 3 ? 3 : trellisLadderDataForAchievementsFavourites.length,
                                //       itemBuilder:(context,index) {
                                //         return GestureDetector(
                                //           onTap: () {
                                //             showDialog(
                                //               context: context,
                                //               builder: (BuildContext context) => _buildPopupDialog(context,"Achievements",trellisLadderDataForAchievementsFavourites[index],true),
                                //             );
                                //           },
                                //           child: Container(
                                //               margin:const EdgeInsets.symmetric(vertical: 5),
                                //               decoration: BoxDecoration(
                                //                   color: AppColors.backgroundColor,
                                //                   borderRadius: BorderRadius.circular(10)
                                //               ),
                                //               padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                //               child: Column(
                                //                 children: [
                                //                   Row(
                                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                     children: [
                                //                       Text("${trellisLadderDataForAchievementsFavourites[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),

                                //                       if(!otherUserLoggedIn)
                                //                       Row(
                                //                         children: [
                                //                           trellisLadderDataForAchievementsFavourites[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                //                       IconButton(onPressed: () {
                                //                         showDeletePopup( "achievements",trellisLadderDataForAchievementsFavourites[index].id.toString(),index,"");
                                //                       }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                //                         ],
                                //                       )
                                //                     ],
                                //                   ),
                                //                   Align(
                                //                       alignment: Alignment.topLeft,
                                //                       child: Text("${DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForAchievementsFavourites[index].date.toString()))} | ${trellisLadderDataForAchievementsFavourites[index].text}"))
                                //                 ],
                                //               )),
                                //         );
                                //       }
                                //   ),
                                // ),
                              ],
                            ),
                          )

                        ]
                    ),

                   ExpansionTileWidgetScreen(isOPExpanded,"Organizing Principles",isOPExpanded,trellisPrinciplesData.where((element) => element.favourite == 'yes').map((e) => '• ${e.empTruths}').join('\n'),"",true,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("OP",value);

                      setState(() {
                        isOPExpanded = value;
                      });
                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(oPUrl);
                      YoutubePlayerController playerController4 = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Organizing Principle",playerController4);
                     // bottomSheet(context,"Organizing Principles","Two organizing principles shape us: Powerless Beliefs and Empowered Truths. Powerless Beliefs are negative, unconsciously formed around fear or shame in our formative years, such as I don't have what it takes. Empowered Truths are core, empowering principles to organize our lives around, such as There is goodness in me, for me, and through me. Shade out powerless beliefs.","");
                    },
                        <Widget>[
                          if(!otherUserLoggedIn)
                          AddButton(userPremium == "no" ? trellisPrinciplesData.length>=isOPLength : false,() {
                              empoweredTruthOPController.text = '';
                              powerlessOpController.text = '';
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
                                              child: NameField(empoweredTruthOPController,"empowered truth",1,70,true,otherUserLoggedIn)))),
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
                                              child: NameField(powerlessOpController,"powerless Belief",1,70,true,otherUserLoggedIn)))),
                                  if(!otherUserLoggedIn)
                                  SaveButtonWidgets( (){
                                    FocusManager.instance.primaryFocus?.unfocus();
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
                                physics: const NeverScrollableScrollPhysics(),
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
                                        padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5, top: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Container(
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
                                                        )
                                                    ),
                                                ),


                                                if(!otherUserLoggedIn)
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                     GestureDetector(
                                                        onTap:(){
                                                          if(trellisPrinciplesData[index].favourite != 'no'){
                                                            _setOrganizingPrinciplesFavouriteItem(index, trellisPrinciplesData[index].id.toString(), trellisPrinciplesData[index].favourite.toString());
                                                          }else{
                                                            final items = trellisPrinciplesData.where((e) => e.favourite != 'no');
                                                            if(items.isEmpty){
                                                              _setOrganizingPrinciplesFavouriteItem(index, trellisPrinciplesData[index].id.toString(), trellisPrinciplesData[index].favourite.toString());
                                                            }else{
                                                              showToastMessage(context, "You cannot add more than one organizing principles as favorites", false);
                                                            }
                                                          }


                                                        },
                                                        child: trellisPrinciplesData[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                                      ),
                                                      const SizedBox(width: 10),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          powerlessOpController.text = trellisPrinciplesData[index].powerlessBelieves! ;
                                                          empoweredTruthOPController.text = trellisPrinciplesData[index].empTruths!;
                                                        });
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
                                                                    ),
                                                                  ),

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
                                                                          child: NameField(empoweredTruthOPController,"empowered truth",1,70,true,otherUserLoggedIn)))),
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
                                                                          child: NameField(powerlessOpController,"powerless Belief",1,70,true,otherUserLoggedIn)))),
                                                              SaveButtonWidgets( (){
                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                _updateTrellisOPData(index,trellisPrinciplesData[index].id!);
                                                              }),
                                                            ],
                                                          ),
                                                        ]);
                                                      },
                                                      child: const Icon(Icons.edit,color: AppColors.primaryColor,),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    InkWell(
                                                      onTap: () {
                                                        // _deleteRecord("principles", trellisPrinciplesData[index].id.toString(),index,"");
                                                        showDeletePopup("principles", trellisPrinciplesData[index].id.toString(),index,"");
                                                      },
                                                      child: const Icon(Icons.delete,color: AppColors.redColor),
                                                    )


                                                  ],
                                                )
                                              ],
                                            ),
                                            // Align(alignment: Alignment.topRight,
                                            //   child: ,),
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 10),
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

                    ExpansionTileWidgetScreen(isNeedsExpanded,"Needs & Anti-Needs",isNeedsExpanded,'${trellisNeedsData.where((element) => element['favourite'] == 'yes').map((e) => '• ${e['text']}').join('\n')} \n${trellisAntiNeedsData.where((element) => element['favourite'] == 'yes').map((e) => '• ${e['text']}').join('\n')}',"",true,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Needs",value);
                      setState(() {
                        isNeedsExpanded = value;
                      });

                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(needsUrl);
                      YoutubePlayerController playerController6 = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Needs & Anti-Needs",playerController6);
                      //bottomSheet(context,"Needs","The essential and engaging aspects of my life that increase my functioning (joy, peace, and confidence) when present, and lead to greater breakdown and dysfunction when absent. Example - “Regular emotional and relational intimacy with people I enjoy.”","");
                    },
                        <Widget>[
                          Container(
                            decoration:const BoxDecoration(
                                color: AppColors.lightGreyColor,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                            ),
                            padding:const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding : const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('Needs', style : TextStyle(fontSize: AppConstants.defaultFontSize, color: AppColors.primaryColor)),
                                ),
                                if(!otherUserLoggedIn)
                                  AddButton(userPremium == "no" ? trellisNeedsData.length>= isNeedsLength : false,() {
                                    needsController.text = '';
                                    needsBottomSheet(context, "Needs", <Widget>[
                                      NameField(needsController,"needs",5,0,true,otherUserLoggedIn),
                                      if(!otherUserLoggedIn)
                                        SaveButtonWidgets( (){
                                          FocusManager.instance.primaryFocus?.unfocus();
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
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder:(context,index) {
                                        return GestureDetector(
                                          child: Container(
                                              margin:const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: AppColors.backgroundColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 10, top: 10),
                                              child: Column(
                                                children: [
                                                  if(!otherUserLoggedIn)
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          GestureDetector(
                                                            onTap:(){
                                                              if(trellisNeedsData[index]['favourite'] != 'no'){
                                                                _setIdentityFavouriteItem(index, trellisNeedsData[index]['id'].toString(), trellisNeedsData[index]['favourite'].toString());
                                                              }else{
                                                                final items = trellisNeedsData.where((e) => e['favourite'] != 'no');
                                                                if(items.isEmpty){
                                                                  _setIdentityFavouriteItem(index, trellisNeedsData[index]['id'].toString(), trellisNeedsData[index]['favourite'].toString());
                                                                }else{
                                                                  showToastMessage(context, "You cannot add more than one needs as favorites", false);
                                                                }
                                                              }


                                                            },
                                                            child: trellisNeedsData[index]['favourite'] != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Align(alignment: Alignment.topRight,
                                                            child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  needsController.text = trellisNeedsData[index]['text'].toString();
                                                                });

                                                                needsBottomSheet(context, "Needs", <Widget>[
                                                                  NameField(needsController,"needs",5,140,true,otherUserLoggedIn),
                                                                  if(!otherUserLoggedIn)
                                                                    SaveButtonWidgets( (){
                                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                                      _updateTrellisNeedsData(index, trellisNeedsData[index]['id'].toString());
                                                                    }),
                                                                ]);
                                                              },
                                                              child:const Icon(Icons.edit,color: AppColors.primaryColor,),
                                                            ),),
                                                          const SizedBox(width: 10),
                                                          Align(alignment: Alignment.topRight,
                                                            child: InkWell(
                                                              onTap: () {

                                                                showDeletePopup("needs", trellisNeedsData[index]['id'].toString(),index,"");
                                                              },
                                                              child:const Icon(Icons.delete,color: AppColors.redColor),
                                                            ),),
                                                        ],
                                                      ),
                                                    ),
                                                  const SizedBox(height: 5),
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
                          ),
                          Container(
                            decoration:const BoxDecoration(
                                color: AppColors.lightGreyColor,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                            ),
                            padding:const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding : const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('Anti Needs', style : TextStyle(fontSize: AppConstants.defaultFontSize, color: AppColors.primaryColor)),
                                ),
                                if(!otherUserLoggedIn)
                                  AddButton(userPremium == "no" ? trellisAntiNeedsData.length>= isNeedsLength : false,() {
                                    antiNeedsController.text = '';
                                    needsBottomSheet(context, "Anti Needs", <Widget>[
                                      NameField(antiNeedsController,"anti needs",5,140,true,otherUserLoggedIn),
                                      if(!otherUserLoggedIn)
                                        SaveButtonWidgets( (){
                                          _setTrellisAntiNeedsData();
                                        }),
                                    ]);
                                  }),

                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: trellisAntiNeedsData.isEmpty ? const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("")) : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: trellisAntiNeedsData.length,
                                      itemBuilder:(context,index) {
                                        return GestureDetector(
                                          child: Container(
                                              margin:const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: AppColors.backgroundColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 10, top: 10),
                                              child: Column(
                                                children: [
                                                  if(!otherUserLoggedIn)
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          GestureDetector(
                                                            onTap:(){
                                                              if(trellisAntiNeedsData[index]['favourite'] != 'no'){
                                                                _setIdentityFavouriteItem(index, trellisAntiNeedsData[index]['id'].toString(), trellisAntiNeedsData[index]['favourite'].toString());
                                                              }else{
                                                                final items = trellisAntiNeedsData.where((e) => e['favourite'] != 'no');
                                                                if(items.isEmpty){
                                                                  _setIdentityFavouriteItem(index, trellisAntiNeedsData[index]['id'].toString(), trellisAntiNeedsData[index]['favourite'].toString());
                                                                }else{
                                                                  showToastMessage(context, "You cannot add more than one anti needs as favorites", false);
                                                                }
                                                              }


                                                            },
                                                            child: trellisAntiNeedsData[index]['favourite'] != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Align(alignment: Alignment.topRight,
                                                            child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  antiNeedsController.text = trellisAntiNeedsData[index]['text'].toString();
                                                                });

                                                                needsBottomSheet(context, "Anti Needs", <Widget>[
                                                                  NameField(antiNeedsController,"anti needs",5,140,true,otherUserLoggedIn),
                                                                  if(!otherUserLoggedIn)
                                                                    SaveButtonWidgets( (){
                                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                                      _updateTrellisAntiNeedsData(index, trellisAntiNeedsData[index]['id'].toString());
                                                                    }),
                                                                ]);
                                                              },
                                                              child:const Icon(Icons.edit,color: AppColors.primaryColor,),
                                                            ),),
                                                          const SizedBox(width: 10),
                                                          Align(alignment: Alignment.topRight,
                                                            child: InkWell(
                                                              onTap: () {

                                                                showDeletePopup("anti_need", trellisAntiNeedsData[index]['id'],index,"");
                                                              },
                                                              child:const Icon(Icons.delete,color: AppColors.redColor),
                                                            ),),
                                                        ],
                                                      ),
                                                    ),
                                                  const SizedBox(height: 5),
                                                  Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(trellisAntiNeedsData[index]['text'].toString()))
                                                ],
                                              )),
                                        );
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ]
                    ),

                 ExpansionTileWidgetScreen(isRhythmsExpanded,"Rhythms",isRhythmsExpanded,trellisRhythmsData.where((element) => element.favourite == 'yes').map((e) => '• ${e.empTruths}').join('\n'),"",true,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Rh",value);

                      setState(() {
                        isRhythmsExpanded = value;
                      });
                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(rhythmsUrl);
                      YoutubePlayerController playerController5 = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Rhythms",playerController5);
                    //  bottomSheet(context,"Rhythms","Rhythms are either principles or habitual behaviors that either increase or decrease our well-being. Empowered Rhythms bring life-giving results while Powerless Rhythms decrease overall flourishing. Example: Empowering Rhythm is waking up early to avoid rushing, while a Powerless Rhythm is talking over people.","");
                    },
                        <Widget>[
                          if(!otherUserLoggedIn)
                          AddButton(userPremium == "no" ? trellisRhythmsData.length>= isRhythmsLength: false ,() {
                              empoweredTruthRhController.text = '';
                              powerlessRhController.text = '';
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
                                              child: NameField(empoweredTruthRhController,"empowered rhythms",1,70,true,otherUserLoggedIn)))),
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
                                              child: NameField(powerlessRhController,"powerless habits",1,70,true,otherUserLoggedIn)))),
                                  if(!otherUserLoggedIn)
                                  SaveButtonWidgets( (){
                                    FocusManager.instance.primaryFocus?.unfocus();
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
                                physics: const NeverScrollableScrollPhysics(),
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
                                        padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5, top: 10),
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
                                                if(!otherUserLoggedIn)
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                        onTap:(){
                                                          if(trellisRhythmsData[index].favourite != 'no'){
                                                            _setRhythmsFavouriteItem(index, trellisRhythmsData[index].id.toString(), trellisRhythmsData[index].favourite.toString());
                                                          }else{
                                                            final items = trellisRhythmsData.where((e) => e.favourite != 'no');
                                                            if(items.isEmpty){
                                                              _setRhythmsFavouriteItem(index, trellisRhythmsData[index].id.toString(), trellisRhythmsData[index].favourite.toString());
                                                            }else{
                                                              showToastMessage(context, "You cannot add more than one rhythms as favorites", false);
                                                            }
                                                          }


                                                        },
                                                        child: trellisRhythmsData[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                                      ),
                                                    const SizedBox(width: 2),
                                                    InkWell(onTap: () {
                                                      setState(() {
                                                        powerlessRhController.text = trellisRhythmsData[index].powerlessBelieves! ;
                                                        empoweredTruthRhController.text = trellisRhythmsData[index].empTruths!;
                                                      });

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
                                                                        child: NameField(empoweredTruthRhController,"empowered rhythms",1,70,true,otherUserLoggedIn)))),
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
                                                                        child: NameField(powerlessRhController,"powerless habits",1,70,true,otherUserLoggedIn)))),
                                                            if(!otherUserLoggedIn)
                                                            SaveButtonWidgets( (){
                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                              _updateTrellisRhythmsData(index,trellisRhythmsData[index].id!);
                                                            }),

                                                          ],
                                                        ),
                                                      ]);

                                                    }, child: const Icon(Icons.edit,color: AppColors.primaryColor,)),
                                                    const SizedBox(width: 2),
                                                    InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                          _dateController.text = "";
                                                          _titleController.text = trellisRhythmsData[index].empTruths ?? '';
                                                          _endDateController.text = "";
                                                          isRepeat = true;
                                                          selectedRadio = "repeat";
                                                          _weekdays = [
                                                            {"name" : "Sun", "Selected": true},
                                                            {"name" : "Mon", "Selected": true},
                                                            {"name" : "Tue", "Selected": true},
                                                            {"name" : "Wed", "Selected": true},
                                                            {"name" : "Thu", "Selected": true},
                                                            {"name" : "Fri", "Selected": true},
                                                            {"name" : "Sat", "Selected": true},];
                                                        });
                                                        reminderCreateBottomSheet(true,SingleAnswer(id: "0",userId: "0",dayList: "",date: "",time: "",status: "",timeType: ""),-1);
                                                      } ,
                                                      child: const Icon(Icons.calendar_month,color: AppColors.primaryColor),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    InkWell(
                                                      onTap: () {
                                                        // _deleteRecord("rhythms", trellisRhythmsData[index].id.toString(),index,"");
                                                        showDeletePopup("rhythms", trellisRhythmsData[index].id.toString(),index,"");
                                                      },
                                                      child:const Icon(Icons.delete,color: AppColors.redColor,),
                                                    ),
                                                  ],
                                                )
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
                                              margin: const EdgeInsets.only(bottom: 10),
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





                    ExpansionTileWidgetScreen(isTribeExpanded,"Tribe",isTribeExpanded,"Mentor, Peer, Mentee","",false,(bool value) {
                      // ignore: avoid_print
                      print(value);
                      setScreenStatus("Tribe",value);
                      setState(() {
                        isTribeExpanded = value;
                      });
                    },() {
                      String? videoId = YoutubePlayer.convertUrlToId(tribeUrl);
                      YoutubePlayerController playerController0 = YoutubePlayerController(
                          initialVideoId: videoId!,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            controlsVisibleAtStart: false,
                          )

                      );
                      videoPopupDialog(context,"Introduction to Tribe",playerController0);
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
                                if(!otherUserLoggedIn)
                                AddButton(false,() {
                                  setState(() {
                                    selectedValueFromBottomSheet = "Mentor";
                                    mentorNameController.text = '';
                                    peerNameController.text = '';
                                    menteeNameController.text = '';
                                  });
                                  tribeBottomSheet(context,"Mentor",false,"Tribe",isMentorVisible,isPeerVisible,isMenteeVisible,Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                              margin:const EdgeInsets.only(left: 10,right: 10),
                                              child:  const Row(
                                                children: [
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
                                              child: NameField(mentorNameController," name of mentor-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                    ],
                                  ),Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                              margin:const EdgeInsets.only(left: 10,right: 10),
                                              child:const Row(
                                                children: [
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
                                              child: NameField(peerNameController," name of peer-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                    ],
                                  ),Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                              margin:const EdgeInsets.only(left: 10,right: 10),
                                              child:const Row(
                                                children: [
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

                                              child: NameField(menteeNameController," name of mentee-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                    ],
                                  ),(selectedValue) {
                                    print('Selected value From Bottom Sheet: $selectedValue');
                                    mentorNameController.clear();
                                    peerNameController.clear();
                                    menteeNameController.clear();
                                    setState(() {
                                      selectedValueFromBottomSheet = selectedValue;
                                    });
                                    // Do something with the selected value
                                  },(){
                                    if(userPremium == "no") {

                                      if(selectedValueFromBottomSheet == "Peer" && trellisPeerTribeData.isEmpty  ) {
                                        _addNewTribeData(id, peerNameController.text, "Peer");
                                      } else if(selectedValueFromBottomSheet == "Mentee" && trellisMenteeTribeData.isEmpty) {
                                        _addNewTribeData(id, menteeNameController.text, "Mentee");
                                      } else if(selectedValueFromBottomSheet == "Mentor" && trellisMentorTribeData.isEmpty) {
                                        _addNewTribeData(id, mentorNameController.text, "Mentor");
                                      }else {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                      }

                                    } else {
                                          if (selectedValueFromBottomSheet == "Peer") {
                                            _addNewTribeData(id, peerNameController.text, "Peer");
                                          } else if (selectedValueFromBottomSheet == "Mentee") {
                                            _addNewTribeData(id, menteeNameController.text, "Mentee");
                                          } else {
                                            _addNewTribeData(id, mentorNameController.text, "Mentor");
                                          }
                                        }
                                      },);
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
                                    margin:const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        color: AppColors.backgroundColor,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding:const EdgeInsets.only(top:5,left: 10,right: 10,bottom: 5),
                                    child: Column(
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.person,color: AppColors.primaryColor,),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                          ],
                                        ),
                                       trellisMentorTribeData.isEmpty ?const Text("No mentor available") : ListView.builder(
                                            shrinkWrap: true,
                                            physics:const NeverScrollableScrollPhysics(),
                                            itemCount: trellisMentorTribeData.length,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: Text("• ${trellisMentorTribeData[index].text} ")),
                                                  if(!otherUserLoggedIn)
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedValueFromBottomSheet = "Mentor";
                                                        isMenteeVisible = false;
                                                        isMentorVisible = true;
                                                        isPeerVisible = false;
                                                        mentorNameController.text = trellisMentorTribeData[index].text!;
                                                        peerNameController.text = '';
                                                        menteeNameController.text = '';
                                                      });

                                                      tribeBottomSheet(context,"Mentor",true,"Tribe",isMentorVisible,isPeerVisible,isMenteeVisible,Column(
                                                        children: [
                                                          Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Container(
                                                                  margin:const EdgeInsets.only(left: 10,right: 10),
                                                                  child:  const Row(
                                                                    children: [
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
                                                                  child: NameField(mentorNameController," name of mentor-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                        ],
                                                      ),Column(
                                                        children: [
                                                          Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Container(
                                                                  margin:const EdgeInsets.only(left: 10,right: 10),
                                                                  child:const Row(
                                                                    children: [
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
                                                                  child: NameField(peerNameController," name of peer-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                        ],
                                                      ),Column(
                                                        children: [
                                                          Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Container(
                                                                  margin:const EdgeInsets.only(left: 10,right: 10),
                                                                  child:const Row(
                                                                    children: [
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

                                                                  child: NameField(menteeNameController," name of mentee-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                        ],
                                                      ),(selectedValue) {
                                                        print('Selected value From Bottom Sheet: $selectedValue');
                                                        mentorNameController.clear();
                                                        peerNameController.clear();
                                                        menteeNameController.clear();
                                                        setState(() {
                                                          selectedValueFromBottomSheet = selectedValue;
                                                        });
                                                        // Do something with the selected value
                                                      },(){
                                                          _updateTribeData(
                                                              index,
                                                              trellisMentorTribeData[index]
                                                                  .id!,
                                                              mentorNameController
                                                                  .text,
                                                              selectedValueFromBottomSheet);
                                                      },);
                                                    },
                                                    icon:const Icon(Icons.edit,color: AppColors.primaryColor,),
                                                  ),
                                                  if(!otherUserLoggedIn)
                                                  IconButton(
                                                    onPressed: () {
                                                      showDeletePopupForTribe("Mentor",trellisMentorTribeData[index].id.toString(),index);
                                                      // _deleteNewTribe("Mentor",trellisMentorTribeData[index].id.toString(),index);
                                                    },
                                                    icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                  )
                                                ],
                                              );
                                            }),
                                      ],
                                    )),
                                Container(
                                    margin:const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        color: AppColors.backgroundColor,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding:const EdgeInsets.only(top:5,left: 10,right: 10,bottom: 5),
                                    child: Column(
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.person,color: AppColors.primaryColor,),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                          ],
                                        ),
                                        trellisPeerTribeData.isEmpty ?const Text("No peer available") : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: trellisPeerTribeData.length,
                                            physics:const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(child: Text("• ${trellisPeerTribeData[index].text}")),
                                              if(!otherUserLoggedIn)
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    selectedValueFromBottomSheet = "Peer";
                                                    isMenteeVisible = false;
                                                    isMentorVisible = false;
                                                    isPeerVisible = true;
                                                    mentorNameController.text = '';
                                                    peerNameController.text = trellisPeerTribeData[index].text!;
                                                    menteeNameController.text = '';
                                                  });

                                                  tribeBottomSheet(context,"Peer",true,"Tribe",isMentorVisible,isPeerVisible,isMenteeVisible,Column(
                                                    children: [
                                                      Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Container(
                                                              margin:const EdgeInsets.only(left: 10,right: 10),
                                                              child:  const Row(
                                                                children: [
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
                                                              child: NameField(mentorNameController," name of mentor-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                    ],
                                                  ),Column(
                                                    children: [
                                                      Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Container(
                                                              margin:const EdgeInsets.only(left: 10,right: 10),
                                                              child:const Row(
                                                                children: [
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
                                                              child: NameField(peerNameController," name of peer-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                    ],
                                                  ),Column(
                                                    children: [
                                                      Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Container(
                                                              margin:const EdgeInsets.only(left: 10,right: 10),
                                                              child:const Row(
                                                                children: [
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

                                                              child: NameField(menteeNameController," name of mentee-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                    ],
                                                  ),(selectedValue) {
                                                    print('Selected value From Bottom Sheet: $selectedValue');
                                                    mentorNameController.clear();
                                                    peerNameController.clear();
                                                    menteeNameController.clear();
                                                    setState(() {
                                                      selectedValueFromBottomSheet = selectedValue;
                                                    });
                                                    // Do something with the selected value
                                                  },(){
                                                      _updateTribeData(index,
                                                          trellisPeerTribeData[index]
                                                              .id!,
                                                          peerNameController
                                                              .text,
                                                          selectedValueFromBottomSheet);

                                                    },);

                                                },
                                                icon:const Icon(Icons.edit,color: AppColors.primaryColor,),
                                              ),
                                              if(!otherUserLoggedIn)
                                              IconButton(
                                                onPressed: () {
                                                  showDeletePopupForTribe("Peer",trellisPeerTribeData[index].id.toString(),index);
                                                  // _deleteNewTribe("Peer",trellisPeerTribeData[index].id.toString(),index);
                                                },
                                                icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                              )
                                            ],
                                          );
                                        }),

                                      ],
                                    )),
                                Container(
                                    margin:const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        color: AppColors.backgroundColor,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding:const EdgeInsets.only(top:5,left: 10,right: 10,bottom: 5),
                                    child: Column(
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.person,color: AppColors.primaryColor,),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                          ],
                                        ),
                                        trellisMenteeTribeData.isEmpty ?const Text("No mentee available") :  ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: trellisMenteeTribeData.length,
                                            physics:const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(child: Text("• ${trellisMenteeTribeData[index].text}")),
                                                  if(!otherUserLoggedIn)
                                                  IconButton(
                                                    onPressed: () {

                                                      setState(() {
                                                        menteeNameController.text = trellisMenteeTribeData[index].text!;
                                                        selectedValueFromBottomSheet = "Mentee";
                                                        isMenteeVisible = true;
                                                        isMentorVisible = false;
                                                        isPeerVisible = false;
                                                        mentorNameController.text = '';
                                                        peerNameController.text = '';
                                                      });

                                                      print('EDIT MENTEE');
                                                      print(trellisMenteeTribeData[index].text!);
                                                      print(menteeNameController.text);


                                                      tribeBottomSheet(context,"Mentee",true,"Tribe",isMentorVisible,isPeerVisible,isMenteeVisible,Column(
                                                        children: [
                                                          Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Container(
                                                                  margin:const EdgeInsets.only(left: 10,right: 10),
                                                                  child:  const Row(
                                                                    children: [
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
                                                                  child: NameField(mentorNameController," name of mentor-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                        ],
                                                      ),Column(
                                                        children: [
                                                          Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Container(
                                                                  margin:const EdgeInsets.only(left: 10,right: 10),
                                                                  child:const Row(
                                                                    children: [
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
                                                                  child: NameField(peerNameController," name of peer-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                        ],
                                                      ),Column(
                                                        children: [
                                                          Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Container(
                                                                  margin:const EdgeInsets.only(left: 10,right: 10),
                                                                  child:const Row(
                                                                    children: [
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

                                                                  child: NameField(menteeNameController," name of mentee-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                        ],
                                                      ),(selectedValue) {
                                                        print('Selected value From Bottom Sheet: $selectedValue');
                                                        mentorNameController.clear();
                                                        peerNameController.clear();
                                                        menteeNameController.clear();
                                                        setState(() {
                                                          selectedValueFromBottomSheet = selectedValue;
                                                        });
                                                        // Do something with the selected value
                                                      },(){
                                                          _updateTribeData(
                                                              index,
                                                              trellisMenteeTribeData[index]
                                                                  .id!,
                                                              menteeNameController
                                                                  .text,
                                                              selectedValueFromBottomSheet);

                                                        },);
                                                    },
                                                    icon:const Icon(Icons.edit,color: AppColors.primaryColor,),
                                                  ),
                                                  if(!otherUserLoggedIn)
                                                  IconButton(
                                                    onPressed: () {
                                                      showDeletePopupForTribe("Mentee",trellisMenteeTribeData[index].id.toString(),index);
                                                    },
                                                    icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                  )
                                                ],
                                              );
                                            }),
                                      ],
                                    )),
                                // Container(
                                //   margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                //   child: trellisTribeData.isEmpty ? const Align(
                                //       alignment: Alignment.topLeft,
                                //       child: Text("")) : ListView.builder(
                                //       shrinkWrap: true,
                                //       itemCount: trellisTribeData.length,
                                //       itemBuilder:(context,index) {
                                //         return GestureDetector(
                                //           // onTap: () {
                                //           //   showDialog(
                                //           //     context: context,
                                //           //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                                //           //   );
                                //           // },
                                //           child: Container(
                                //               margin:const EdgeInsets.symmetric(vertical: 5),
                                //               decoration: BoxDecoration(
                                //                   color: AppColors.backgroundColor,
                                //                   borderRadius: BorderRadius.circular(10)
                                //               ),
                                //               padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                //               child: Column(
                                //                 children: [
                                //                   Row(
                                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                     children: [
                                //                       const Row(
                                //                         children: [
                                //                           Icon(Icons.person,color: AppColors.primaryColor,),
                                //                           SizedBox(
                                //                             width: 5,
                                //                           ),
                                //                           Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                //                         ],
                                //                       ),
                                //                       IconButton(
                                //                         onPressed: () {
                                //                           _deleteRecord("tribe", trellisTribeData[index]['id'],index,"");
                                //                         },
                                //                         icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                //                       )
                                //                     ],
                                //                   ),
                                //                   Container(
                                //                     alignment: Alignment.centerLeft,
                                //                     padding:const EdgeInsets.only(left: 5,right: 5,bottom: 10),
                                //                     child: Column(
                                //                       crossAxisAlignment: CrossAxisAlignment.start,
                                //                       mainAxisAlignment: MainAxisAlignment.start,
                                //                       children: [
                                //                         Text(trellisTribeData[index]['mentor'].toString()),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                   const Row(
                                //                     children: [
                                //                       Icon(Icons.person,color: AppColors.primaryColor,),
                                //                       SizedBox(
                                //                         width: 5,
                                //                       ),
                                //                       Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                //                     ],
                                //                   ),
                                //                   Container(
                                //                     alignment: Alignment.centerLeft,
                                //                     padding:const EdgeInsets.only(left: 5,right: 5,bottom: 10),
                                //                     child: Column(
                                //                       crossAxisAlignment: CrossAxisAlignment.start,
                                //                       mainAxisAlignment: MainAxisAlignment.start,
                                //                       children: [
                                //                         Text(trellisTribeData[index]['peer'].toString()),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                   const  Row(
                                //                     children: [
                                //                       Icon(Icons.person,color: AppColors.primaryColor,),
                                //                       SizedBox(
                                //                         width: 5,
                                //                       ),
                                //                       Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                //                     ],
                                //                   ),
                                //                   Container(
                                //                     alignment: Alignment.centerLeft,
                                //                     padding:const EdgeInsets.only(left: 5,right: 5,bottom: 10),
                                //                     child: Column(
                                //                       crossAxisAlignment: CrossAxisAlignment.start,
                                //                       mainAxisAlignment: MainAxisAlignment.start,
                                //                       children: [
                                //                         Text(trellisTribeData[index]['mentee'].toString()),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 ],
                                //               )),
                                //         );
                                //       }
                                //   ),
                                // ),
                              ],
                            ),
                          )
                        ]
                    ),
                    if(!otherUserLoggedIn)
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: (){
                          _saveTrellisTriggerResponse();
                        },
                        style:ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: const Text("I Read My Trellis Today",style: TextStyle(color: AppColors.backgroundColor),),
                      ),
                    )
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

  Widget _buildPopupDialog(BuildContext context,String heading,TrellisLadderDataModel trellisLadderDataModel1, bool oneCategory) {
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
                      child: Text(trellisLadderDataModel1.type!)),
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
                      child: Text(trellisLadderDataModel1.option1!)),
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
                      child: Text(trellisLadderDataModel1.option2! == "Challenges" ? "" :DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataModel1.date.toString())))),
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
                      child: Text(trellisLadderDataModel1.text!)),
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
                      child: Text(trellisLadderDataModel1.description!)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addNewTribeData(String userIdd,String fieldValue,String type) {

    if(fieldValue.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisNewTribeDataAdd(TrellisNewDataAddRequestModel(
          userId: userIdd, text: fieldValue, type: type)).then((value) {

        TribeDataResponse tribeDataResponse = TribeDataResponse(
          id: value['post_data']['id'].toString(),
        userId: value['post_data']['user_id'].toString(),
        type: value['post_data']['type'].toString(),
        text: value['post_data']['text'].toString(),
        createdAt: "",);

        if(type == "Peer") {
          trellisPeerTribeData.add(tribeDataResponse);
        } else if(type == "Mentee") {
          trellisMenteeTribeData.add(tribeDataResponse);
        } else {
          trellisMentorTribeData.add(tribeDataResponse);
        }
        setState(() {
          mentorNameController.text = '';
          peerNameController.text = '';
          menteeNameController.text = '';

          _isDataLoading = false;
        });

        Navigator.of(context).pop();
        showToastMessage(context, "Added Successfully", true);
      }).catchError((e) {
        print(e.toString());
        setState(() {
          _isDataLoading = false;
        });
        showToastMessage(context, e.toString(), false);
      });
    } else {
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, "Please Enter data in the field", false);
    }

  }


  _updateTribeData(int index,String responseId,String fieldValue,String type) {

    print("Update This type date");
    print(type);

    if(fieldValue.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisUpdateTribeDataAdd(TrellisUpdateDataAddRequestModel(
          id: responseId, text: fieldValue, type: type)).then((value) {

        TribeDataResponse tribeDataResponse = TribeDataResponse(
          id: responseId,
          userId: id,
          type: value['updated_data']['type'].toString(),
          text: value['updated_data']['text'].toString(),
          createdAt: "",);

        if(type == "Peer") {
          trellisPeerTribeData[index] = tribeDataResponse;
        } else if(type == "Mentee") {
          trellisMenteeTribeData[index] = tribeDataResponse;
        } else {
          trellisMentorTribeData[index] = tribeDataResponse;
        }
        setState(() {
          mentorNameController.text = '';
          peerNameController.text = '';
          menteeNameController.text = '';

          _isDataLoading = false;
        });

        Navigator.of(context).pop();
        showToastMessage(context, "updated Successfully", true);
      }).catchError((e) {
        print(e.toString());
        setState(() {
          _isDataLoading = false;
        });
        showToastMessage(context, e.toString(), false);
      });
    } else {
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, "Please Enter data in the field", false);
    }

  }

  _saveTrellisTriggerResponse() {
    setState(() {
      _isDataLoading = true;
    });
    HTTPManager().trellisTriggerData(TrellisTriggerRequestModel(userId: id)).then((value) {
      // ignore: avoid_print
      print(value);
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, "Great job growing your Garden!", true);
    }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      print(e);
    });
  }

  _deleteNewTribe(String type,String tribeDataId,int indexItem) {
    setState(() {
      _isDataLoading = true;
    });

    HTTPManager().trellisNewTribeDelete(TribeNewDataTrellisDeleteRequestModel(recordId: tribeDataId)).then((value) {

      print(value);
      if(type == "Peer") {
        trellisPeerTribeData.removeAt(indexItem);
      } else if(type == "Mentee") {
        trellisMenteeTribeData.removeAt(indexItem);
      } else {
        trellisMentorTribeData.removeAt(indexItem);
      }
      setState(() {
        _isDataLoading = false;
      });

      showToastMessage(context, "Deleted successfully", true);

    }).catchError((e) {
      print(e.toString());
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, e.toString(), false);
    });

  }

  _deleteRecord(String type,String recordId,int index,String goalsOrChallenges) {
    // print(type);
    // print(index);
    setState(() {
      _isDataLoading = true;
    });
    HTTPManager().trellisDelete(TrellisDeleteRequestModel(userId: id,recordId: recordId,type:type,)).then((value) {

      if(type == "goal") {
          setState(() {
            trellisLadderDataFavorites.removeWhere((element) => element.id == recordId);
            trellisLadderDataForGoalsFavourites.removeAt(index);
          });
      } else if(type == "challenges") {
        setState(() {
          trellisLadderDataFavorites.removeWhere((element) => element.id == recordId);
          trellisLadderDataForChallengesFavourites.removeAt(index);
        });
      } else if(type == "memories" || type == "achievements") {
        setState(() {
          trellisLadderDataFavorites.removeWhere((element) => element.id == recordId);
          trellisLadderDataForMemoriesAndAchievementsFavourites.removeAt(index);
        });
      } 
      // else if(type == "memories") {
      //   setState(() {
      //     trellisLadderDataFavorites.removeWhere((element) => element.id == recordId);
      //     trellisLadderDataForMemoriesFavourites.removeAt(index);
      //   });
      // } else if(type == "achievements") {
      //   setState(() {
      //     trellisLadderDataFavorites.removeWhere((element) => element.id == recordId);
      //     trellisLadderDataForAchievementsFavourites.removeAt(index);
      //   });
      // } 
      else if(type == "needs") {
        setState(() {
          trellisNeedsData.removeAt(index);
        });
      } else if(type == "anti_need") {
        setState(() {
          trellisAntiNeedsData.removeAt(index);
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
      } else if(type == "vision") {
        setState(() {
          trellisVisionData = [];
          trellisVisionDataModel = null;
          visionController.text = "";
          relationalVisionController.text = "";
          emotionalVisionController.text = "";
          physicalVisionController.text = "";
          workVisionController.text = "";
          financialVisionController.text = "";
          spiritualVisionController.text = "";
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
    // ignore: avoid_print
    // print("Selected Date:${dateForGController.text}");
    print('Setting Ladder Goals Data  =================> Ladder Type = $initialValueForLadderType');

    if(initialValueForLadderType != "" && titleForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });


      HTTPManager().trellisLadderForGoals(TrellisLadderGoalsRequestModel(userId: id,type: initialValueForLadderType == "Goals" ? "goal" : initialValueForLadderType.toLowerCase(),option1: initialValueForType,option2: initialValueForLadderType,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text,insertFrom: "trellis")).then((value) {

        Navigator.of(context).pop();
        setState(() {
          initialValueForLadderType = "Goals";
          initialValueForType = "Physical";
          initialValueForMType = "Memories";
          initialValueForGType = "Goals";
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['post_data']['id'].toString(),
          userId: value['post_data']['user_id'].toString(),
          type: value['post_data']['type'].toString(),
          favourite: value['post_data']['favourite'].toString(),
          option1: value['post_data']['option1'].toString(),
          option2: value['post_data']['option2'].toString(),
          date: value['post_data']['date'].toString(),
          text: value['post_data']['text'].toString(),
          description: value['post_data']['description'].toString(),
        );


        if(trellisLadderDataModel.type == 'goal'){
          // if(trellisLadderDataForGoalsFavourites.length < 2 ) {
            showToastMessage(context, "Added successfully", true);
            trellisLadderDataForGoalsFavourites.add(trellisLadderDataModel);
          // }else{
          //   showToastMessage(context, "Please remove some item from your favourites list in Goals in ladder section", true);
          // }
        }else if(trellisLadderDataModel.type == 'challenges'){
          // if(trellisLadderDataForChallengesFavourites.length < 2){
            showToastMessage(context, "Added successfully", true);
            trellisLadderDataForChallengesFavourites.add(trellisLadderDataModel);
          // }else{
          //   showToastMessage(context, "Please remove some item from your favourites list in Challenges in ladder section", true);
          // }
        }


        trellisLadderDataForGoals.sort((a,b)=>b.date!.compareTo(a.date!));
        trellisLadderDataForGoalsFavourites.sort((a,b) => b.date!.compareTo(a.date!));
        trellisLadderDataForChallengesFavourites.sort((a,b) => b.date!.compareTo(a.date!));
        trellisLadderDataForGoalsChallenges.sort((a,b)=>b.date!.compareTo(a.date!));

        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Goals");
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });

    } else {
      showToastMessage(context, "Add some text to title field please", false);
    }
  }

  _setLadderFavouriteItem(int indexItem,String responseId,String status) {
    String? favouriteStatus;
    if(status == "yes") {
      setState(() {
        favouriteStatus = "no";
      });
    } else {
      setState(() {
        favouriteStatus = "yes";
      });
    }
    print(favouriteStatus);
    setState(() {
      _isDataLoading = true;
    });

    HTTPManager().ladderAddFavourite(LadderAddFavouriteItem(responseId:responseId,favStatus: favouriteStatus)).then((value) {

      showToastMessage(context,value['data']['favourite'] == "no" ? "Removed from favorites" : "Added to favorites", true);

      TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
        id: value['data']['id'],
        userId: value['data']['user_id'],
        type: value['data']['type'],
        favourite: value['data']['favourite'],
        option1: value['data']['option1'],
        option2: value['data']['option2'],
        date: value['data']['date'],
        text: value['data']['text'],
        description: value['data']['description'],
      );
      if(trellisLadderDataModel.type == "goal"){
        trellisLadderDataForGoalsFavourites[indexItem] = trellisLadderDataModel;
      }else if(trellisLadderDataModel.type == "challenges"){
        trellisLadderDataForChallengesFavourites[indexItem] = trellisLadderDataModel;
      }else if(trellisLadderDataModel.type == "memories" || trellisLadderDataModel.type == "achievements"){
        trellisLadderDataForMemoriesAndAchievementsFavourites[indexItem] = trellisLadderDataModel;
      }

      if(status == 'yes'){
        trellisLadderDataFavorites.removeWhere((element) => element.id == trellisLadderDataModel.id);
      }else{
        trellisLadderDataFavorites.add(trellisLadderDataModel);
      }

      setState(() {
        _isDataLoading = false;
      });
    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
      print(e.toString());
      setState(() {
        _isDataLoading = false;
      });
    });
  }


  _setIdentityFavouriteItem(int indexItem, String responseId, String status){
    String? favouriteStatus;
    if(status == "yes") {
      setState(() {
        favouriteStatus = "no";
      });
    } else {
      setState(() {
        favouriteStatus = "yes";
      });
    }
    print(favouriteStatus);
    setState(() {
      _isDataLoading = true;
    });

    HTTPManager().identityAddFavourite(IdentityAddFavouriteItem(responseId:responseId,favStatus: favouriteStatus)).then((value) {

      showToastMessage(context,value['data']['favourite'] == "no" ? "Removed from favorites" : "Added to favorites", true);

      print('Identity Add Favourite Item ===============> $value');


      if(value['data']['type'] == 'needs'){
        trellisNeedsData[indexItem] = value['data'];
      }else if(value['data']['type'] == 'anti_need'){
        trellisAntiNeedsData[indexItem] = value['data'];
      }

      setState(() {
        _isDataLoading = false;
      });
    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
      print(e.toString());
      setState(() {
        _isDataLoading = false;
      });
    });
  }

    _setOrganizingPrinciplesFavouriteItem(int indexItem, String responseId, String status){
    String? favouriteStatus;
    if(status == "yes") {
      setState(() {
        favouriteStatus = "no";
      });
    } else {
      setState(() {
        favouriteStatus = "yes";
      });
    }
    print(favouriteStatus);
    setState(() {
      _isDataLoading = true;
    });

    HTTPManager().organizingPrinciplesAddFavourite(OrganizingPrincipleAddFavouriteItem(responseId:responseId,favStatus: favouriteStatus)).then((value) {

      showToastMessage(context,value['data']['favourite'] == "no" ? "Removed from favorites" : "Added to favorites", true);

      print('Organizing Principles Add Favourite Item ===============> $value');


      trellisPrinciplesData[indexItem] = Trellis_principle_data_model_class.fromJson(value['data']);


      setState(() {
        _isDataLoading = false;
      });
    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
      print(e.toString());
      setState(() {
        _isDataLoading = false;
      });
    });
  }

  _setRhythmsFavouriteItem(int indexItem, String responseId, String status){
    String? favouriteStatus;
    if(status == "yes") {
      setState(() {
        favouriteStatus = "no";
      });
    } else {
      setState(() {
        favouriteStatus = "yes";
      });
    }
    print(favouriteStatus);
    setState(() {
      _isDataLoading = true;
    });

    HTTPManager().rhythmsAddFavourite(RhythmsAddFavouriteItem(responseId:responseId,favStatus: favouriteStatus)).then((value) {

      showToastMessage(context,value['data']['favourite'] == "no" ? "Removed from favorites" : "Added to favorites", true);

      print('Rhythms Add Favourite Item ===============> $value');


      trellisRhythmsData[indexItem] = Trellis_principle_data_model_class.fromJson(value['data']);


      setState(() {
        _isDataLoading = false;
      });
    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
      print(e.toString());
      setState(() {
        _isDataLoading = false;
      });
    });
  }

  // _setLadderGoalsData() {
  //   // ignore: avoid_print
  //   print("Seleted Date:${dateForGController.text}");
  //
  //   if(initialValueForGoals != "" || dateForGController.text.isNotEmpty || initialValueForType == "" || titleForGController.text.isNotEmpty ) {
  //     setState(() {
  //       _isDataLoading = true;
  //     });
  //     HTTPManager().trellisLadderForGoals(TrellisLadderGoalsRequestModel(userId: id,type: "goal",option1: initialValueForType,option2: initialValueForGoals,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text,insertFrom: "trellis")).then((value) {
  //
  //       Navigator.of(context).pop();
  //       setState(() {
  //         dateForGController.text = "";
  //         titleForGController.text = "";
  //         descriptionForGController.text = "";
  //       });
  //       if(value['post_data']['option2'] == "Challenges") {
  //         trellisLadderDataForGoalsChallenges.insert(0, value['post_data']);
  //       } else {
  //         trellisLadderDataForGoals.insert(0, value['post_data']);
  //       }
  //       setState(() {
  //         _isDataLoading = false;
  //       });
  //       // print(value);
  //       // print("Ladder Data For Goals");
  //       showToastMessage(context, "Record added successfully", true);
  //     }).catchError((e) {
  //       showToastMessage(context, e.toString(), false);
  //       setState(() {
  //         _isDataLoading = false;
  //       });
  //     });
  //
  //   } else {
  //     showToastMessage(context, "Add some data please", false);
  //   }
  // }

  // _setLadderMemoriesData() {
  //   if( dateForMController.text.isNotEmpty  || titleForMController.text.isNotEmpty ) {
  //     setState(() {
  //       _isDataLoading = true;
  //     });
  //     HTTPManager().trellisLadderForAchievements(TrellisLadderAchievementRequestModel(userId: id,type: "achievements",option1:initialValueForMType ,date: dateForMController.text,title: titleForMController.text,description: descriptionForMController.text,insertFrom: "trellis")).then((value) {
  //
  //       Navigator.of(context).pop();
  //       setState(() {
  //         dateForMController.text = "";
  //         titleForMController.text = "";
  //         descriptionForMController.text = "";
  //       });
  //       trellisLadderDataForAchievements.insert(0,value['post_data']);
  //       setState(() {
  //         _isDataLoading = false;
  //       });
  //       // print(value);
  //       // print("Ladder Data For Achievements");
  //       showToastMessage(context, "Record added successfully", true);
  //     }).catchError((e) {
  //       showToastMessage(context, e.toString(), false);
  //       setState(() {
  //         _isDataLoading = false;
  //       });
  //     });
  //
  //   } else {
  //     showToastMessage(context, "Add some data please", false);
  //   }
  // }

  _updateLadderGoalsData(String updateType,String ladderGoalsId, int index1) {
    // ignore: avoid_print
    // print("Selected Date:${dateForGController.text}");
    print("Update Ladder goals data ================>");
    // return;
    if(initialValueForLadderType != "" && titleForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForGoalsUpdate(TrellisLadderGoalsUpdateRequestModel(ladderId: ladderGoalsId,type: initialValueForLadderType == "Goals" ? 'goal' :  initialValueForLadderType.toLowerCase(),option1: initialValueForType,option2: initialValueForLadderType,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text)).then((value) {



        Navigator.of(context).pop();

        if(updateType == "challenges") {
          setState(() {
            trellisLadderDataForChallengesFavourites.removeAt(index1);
          });
        } else if(updateType == "goal") {
          setState(() {
            trellisLadderDataForGoalsFavourites.removeAt(index1);
          });
        }else if(updateType == "memories" || updateType == "achievements" ){
          setState(() {
            trellisLadderDataForMemoriesAndAchievementsFavourites.removeAt(index1);
          });
        }

        setState(() {
          initialValueForLadderType = "Goals";
          initialValueForType = "Physical";
          initialValueForMType = "Memories";
          initialValueForGType = "Goals";
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });

        final now = DateTime.now();
        final expirationDate = DateTime.parse(value['updated_data']['date'].toString());
        final bool isExpired = expirationDate.isBefore(now);

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
            id: value['updated_data']['id'].toString(),
            userId: value['updated_data']['user_id'].toString(),
            type: value['updated_data']['type'].toString(),
            favourite: value['updated_data']['favourite'].toString(),
            option1: value['updated_data']['option1'].toString(),
            option2: value['updated_data']['option2'].toString(),
            date: value['updated_data']['date'].toString(),
            text: value['updated_data']['text'].toString(),
            description: value['updated_data']['description'].toString(),
            isExpired: isExpired
        );
        if(trellisLadderDataModel.type == "challenges") {
          trellisLadderDataForChallengesFavourites.add(trellisLadderDataModel);
          trellisLadderDataForChallengesFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
        }else{
          trellisLadderDataForGoalsFavourites.add(trellisLadderDataModel);
          trellisLadderDataForGoalsFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
        }




        // _getTrellisReadData(false);
        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Goals");
        showToastMessage(context, "Updated successfully", true);
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });

    } else {
      showToastMessage(context, "Add some text to title field please", false);
    }
  }

  _updateLadderMemoriesData(String updateType,String ladderMemoriesId, int index) {
    print("Ladder Memories ID");
    print(ladderMemoriesId);
    print(initialValueForType);
    print(dateForGController.text);
    print(titleForGController.text);
    print(descriptionForGController.text);

    if(initialValueForLadderType != "" && titleForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForAchievementsUpdate(TrellisLadderAchievementUpdateRequestModel(ladderId: ladderMemoriesId,type: initialValueForLadderType.toLowerCase(),option1:initialValueForType ,option2: initialValueForLadderType,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text)).then((value) {

        Navigator.of(context).pop();

        if(updateType == "challenges") {
          setState(() {
            trellisLadderDataForChallengesFavourites.removeAt(index);
          });
        } else if(updateType == "goal") {
          setState(() {
            trellisLadderDataForGoalsFavourites.removeAt(index);
          });
        }else if(updateType == "memories" || updateType == "achievements" ){
          setState(() {
            trellisLadderDataForMemoriesAndAchievementsFavourites.removeAt(index);
          });
        }




        setState(() {
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['updated_data']['id'].toString(),
          userId: value['updated_data']['user_id'].toString(),
          type: value['updated_data']['type'].toString(),
          favourite: value['updated_data']['favourite'].toString(),
          option1: value['updated_data']['option1'].toString(),
          option2: value['updated_data']['option2'].toString(),
          date: value['updated_data']['date'].toString(),
          text: value['updated_data']['text'].toString(),
          description: value['updated_data']['description'].toString(),
        );

         trellisLadderDataForMemoriesAndAchievementsFavourites.add(trellisLadderDataModel);
          trellisLadderDataForMemoriesAndAchievementsFavourites.sort((a,b)=>b.date!.compareTo(a.date!));

        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Achievements");
        showToastMessage(context, "Updated successfully", true);
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
    print('Set Ladder Memories Data =========>');
    print(initialValueForLadderType != "");
    print(titleForGController.text.isNotEmpty);

    if(initialValueForLadderType != "" && titleForGController.text.isNotEmpty && dateForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForAchievements(TrellisLadderAchievementRequestModel(userId: id,type: initialValueForLadderType.toLowerCase(),option1:initialValueForType,option2: initialValueForLadderType,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text,insertFrom: "trellis")).then((value) {

        print('Achievement Added Successfully 1 =================> ${value['post_data']['type']}');
        Navigator.of(context).pop();
        setState(() {
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['post_data']['id'].toString(),
          userId: value['post_data']['user_id'].toString(),
          type: value['post_data']['type'].toString(),
          favourite: value['post_data']['favourite'].toString(),
          option1: value['post_data']['option1'].toString(),
          option2: value['post_data']['option2'].toString(),
          date: value['post_data']['date'].toString(),
          text: value['post_data']['text'].toString(),
          description: value['post_data']['description'].toString(),
        );


        showToastMessage(context, "Added successfully", true);

        trellisLadderDataForMemoriesAndAchievementsFavourites.add(trellisLadderDataModel);
        trellisLadderDataForMemoriesAndAchievementsFavourites.sort((a,b)=>b.date!.compareTo(a.date!));

        


        trellisLadderDataForAchievements.sort((a,b)=>b.date!.compareTo(a.date!));
        trellisLadderDataForAchievementsFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
        trellisLadderDataForMemoriesFavourites.sort((a,b)=>b.date!.compareTo(a.date!));

        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Achievements");

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
            favourite: value['post_data']['favourite'].toString()
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
        // ignore: avoid_print
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

  _updateTrellisOPData (int index,String responseId) {

    if(empoweredTruthOPController.text.isNotEmpty || powerlessOpController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisUpdatePrinciples(TrellisPrinciplesUpdateRequestModel(
          id: responseId, type: "principles", empTruths: empoweredTruthOPController.text,powerlessBelieve: powerlessOpController.text))
          .then((value) {
        // print("Organizing Principle Success");
        // print(value);
        setState(() {
          trellisPrinciplesData[index] = Trellis_principle_data_model_class(
            id : responseId,
            userId : id,
            type : value['updated_data']['type'].toString(),
            empTruths : value['updated_data']['emp_truths'].toString(),
            powerlessBelieves : value['updated_data']['powerless_believes'].toString(),
            visibility : false,
            favourite: value['updated_data']['favourite'].toString()
          );
        });
        Navigator.of(context).pop();
        showToastMessage(context, "Record updated successfully", true);
        setState(() {
          empoweredTruthOPController.text = "";
          powerlessOpController.text = "";
          _isDataLoading = false;
        });
        // Navigator.of(context).pop();
      }).catchError((e) {
        // ignore: avoid_print
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
          favourite: value['post_data']['favourite'].toString()
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

  _updateTrellisRhythmsData (int index,String responseId) {

    if(empoweredTruthRhController.text.isNotEmpty || powerlessRhController.text.isNotEmpty ) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisUpdatePrinciples(TrellisPrinciplesUpdateRequestModel(
          id: responseId, type: "rhythms", empTruths: empoweredTruthRhController.text,powerlessBelieve: powerlessRhController.text))
          .then((value) {
        setState(() {
          _isDataLoading = false;
        });
        trellisRhythmsData[index] = Trellis_principle_data_model_class(
          id : responseId,
          userId : id,
          type : value['updated_data']['type'].toString(),
          empTruths : value['updated_data']['emp_truths'].toString(),
          powerlessBelieves : value['updated_data']['powerless_believes'].toString(),
          visibility : false,
          favourite: value['updated_data']['favourite'].toString()
          );
        Navigator.of(context).pop();
        showToastMessage(context, "Record updated successfully", true);
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
      HTTPManager().trellisIdentity(TrellisIdentityRequestModel(userId: id, type: "needs", text: needsController.text,description: "Unknown")).then((value) {
        print("Needs Success");
        print(value);
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

  _setTrellisAntiNeedsData () {

    if(antiNeedsController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisIdentity(TrellisIdentityRequestModel(userId: id, type: "anti_need", text: antiNeedsController.text,description: "")).then((value) {
        // print("Needs Success");
        // print(value);
        trellisAntiNeedsData.insert(0, value['post_data']);
        showToastMessage(context, "Anti Needs added successfully", true);
        setState(() {
          antiNeedsController.text = "";
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
      showToastMessage(context, "Add your anti needs in the field", false);
    }
  }

  _updateTrellisNeedsData (int index,String responseID) {

    if(needsController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisUpdateIdentity(TrellisUpdateIdentityRequestModel(id: responseID, type: "needs", text: needsController.text, description: "")).then((value) {
        // print("Needs Success");
        // print(value);
        trellisNeedsData[index] = value['updated_data'];
        showToastMessage(context, "Record updated successfully", true);
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

  _updateTrellisAntiNeedsData (int index,String responseID) {

    if(antiNeedsController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisUpdateIdentity(TrellisUpdateIdentityRequestModel(id: responseID, type: "anti_need", text: antiNeedsController.text, description: "")).then((value) {
        // print("Needs Success");
        // print(value);
        trellisAntiNeedsData[index] = value['updated_data'];
        showToastMessage(context, "Need updated successfully", true);
        setState(() {
          antiNeedsController.text = "";
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
      HTTPManager().trellisIdentity(TrellisIdentityRequestModel(userId: id, type: "identity", text: identityController.text, description: identityDescController.text)).then((value) {
        // print("Identity Success");
        // print(value);
        trellisIdentityData.insert(0, value['post_data']);
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
      showToastMessage(context, "Add your identity in the field", false);
    }
  }

  _updateTrellisIdentityData (int index,String responseID) {

    if(identityController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisUpdateIdentity(TrellisUpdateIdentityRequestModel(
          id: responseID, type: "identity", text: identityController.text))
          .then((value) {
        // print("Identity Success");
        // print(value);
        trellisIdentityData[index] = value['updated_data'];
        showToastMessage(context, "Record updated successfully", true);
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

    _setTrellisVisionData(){

      if(visionController.text.trim().isNotEmpty){
      setState(() {
        _isDataLoading = true;
      });

      HTTPManager().trellisVision(TrellisVisionRequestModel(
        userId: id,
        vision: visionController.text.trim(),
        relationalVision: relationalVisionController.text.trim(),
        emotionalVision: emotionalVisionController.text.trim(),
        physicalVision: physicalVisionController.text.trim(),
        workVision: workVisionController.text.trim(),
        financialVision: financialVisionController.text.trim(),
        spiritualVision: spiritualVisionController.text.trim(),
      )).then((value) {

        trellisVisionData = [];
        if(trellisVisionDataModel != null){
          trellisVisionData.add(value['updated_data']);
          trellisVisionDataModel = TrellisVisionDataModel.fromJson(value['updated_data']);
        }else{
          trellisVisionData.add(value['post_data']);
          trellisVisionDataModel = TrellisVisionDataModel.fromJson(value['post_data']);
        }
        showToastMessage(context, "Vision added successfully", true);
        setState(() {
          _isDataLoading = false;
        });
        Navigator.of(context).pop();
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });


    }else{
        showToastMessage(context, "please enter data in vision field!", false);
    }


  }

  _setTribeData() {
    print(mentorNameController.text);
    print(peerNameController.text);
    print(menteeNameController.text);
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
        // ignore: avoid_print
        print(e);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Please fill your fields", false);
    }
  }

  Future<void> _selectDate(BuildContext context,TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1950),
        lastDate:DateTime(2101));
    if (picked != null) {
      setState(() {
        controller.text =  DateFormat('MM-dd-yy').format(picked);
      });
    }
  }

  removeWeekFromList (int index2) {

    setState(() {
      daysSelected = "";
    });

    for (int i = 0; i < _selectedWeekdays.length; i++) {
      if(_weekdays[index2]['name'] ==_selectedWeekdays[i]['name'] ) {
        _selectedWeekdays.removeAt(i);
      }
    }
    for (int i = 0; i < _weekdays.length; i++) {
      if(_weekdays[i]['Selected'] == true) {
        setState(() {
          daysSelected = "${daysSelected + _weekdays[i]['name']},".toLowerCase();
          // daysSelected.re(",", "");
        });
      }
    }
    if(_selectedWeekdays.isEmpty) {
      setState(() {
        selectedRadio = "once";
      });
    } else {
      setState(() {
        selectedRadio = "repeat";
      });
    }
    print("Remove value to list");
    print(daysSelected);
    print(_selectedWeekdays);
  }

  addWeekValueToList(int index1) {
    setState(() {
      daysSelected = "";
      selectedRadio = "repeat";
    });
    _selectedWeekdays.add(_weekdays[index1]);
    if(_selectedWeekdays.length == _weekdays.length) {
      setState(() {
        isRepeat = true;
        daysSelected = "Everyone";
      });
    } else {
      for (int i = 0; i < _weekdays.length; i++) {
        if(_weekdays[i]['Selected'] == true) {
          setState(() {
            daysSelected = "${daysSelected + _weekdays[i]['name']},".toLowerCase();
            // daysSelected.re(",", "");
          });

        }
      }
    }
    print("Add value to list");
    print(daysSelected);

    print(_selectedWeekdays);
  }

  void reminderCreateBottomSheet(bool isEditReminder,SingleAnswer singleAnswer,int index1) {

    bool isSunAvailable = false;
    bool isMonAvailable = false;
    bool isTueAvailable = false;
    bool isWedAvailable = false;
    bool isThuAvailable = false;
    bool isFriAvailable = false;
    bool isSatAvailable = false;

    if(!isEditReminder) {
      DateTime endDate;
      String formattedEndDate = "";

      _selectedWeekdays.clear();
      DateTime date = DateFormat("yyyy-MM-dd").parse(singleAnswer.date!);
      if(singleAnswer.endDate != "") {

        setState(() {
          endDate = DateFormat("yyyy-MM-dd").parse(
              singleAnswer.endDate!);
          formattedEndDate = DateFormat('MM-dd-yy').format(endDate);
        });
      } else {
        setState(() {
          formattedEndDate = "";
        });
      }
      DateTime time = DateFormat("hh:mm").parse(singleAnswer.time!);
      String formattedDate = DateFormat('MM-dd-yy').format(date);
      // Format the date as desired
      // String formattedTime = DateFormat.jm().format(dateTime); // Format the time as desired

      // print("dateTimeMin: ${time.minute}");
      // print("dateTimePm: ${singleAnswer.timeType}");

      // for(int i=0; i< _itemsHour.length; i++) {
      //   print("dateTimeHour: ${time.hour}");
      //   print("dateTimeHourFromList: ${_itemsHour[i]}");
      //   if(time.hour.toString() == _itemsHour[i].toString()) {
      //
      //     setState(() {
      //       _selectedItemIndexForHour = i;
      //       _scrollControllerHour =  FixedExtentScrollController(initialItem: i);
      //     });
      //   } else if (time.hour.toString() == '0' || time.hour.toString() == '12' && _itemsHour[i].toString() == '12') {
      //     setState(() {
      //       _selectedItemIndexForHour = i;
      //       _scrollControllerHour =  FixedExtentScrollController(initialItem: i);
      //     });
      //   }
      // }
      //
      // if(time.minute == 00) {
      //   setState(() {
      //     _selectedItemIndexForMin = 0;
      //     _scrollControllerMin =  FixedExtentScrollController(initialItem: 0);
      //   });
      //
      // } else if(time.minute == 15) {
      //   setState(() {
      //     _selectedItemIndexForMin = 1;
      //     _scrollControllerMin =  FixedExtentScrollController(initialItem: 1);
      //   });
      //
      // } else if(time.minute == 30) {
      //   setState(() {
      //     _selectedItemIndexForMin = 2;
      //     _scrollControllerMin =  FixedExtentScrollController(initialItem: 2);
      //   });
      //
      // } else if(time.minute == 45) {
      //   setState(() {
      //     _selectedItemIndexForMin = 3;
      //     _scrollControllerMin =  FixedExtentScrollController(initialItem: 3);
      //   });
      //
      // }
      //
      // if(singleAnswer.timeType == "AM") {
      //   setState(() {
      //     _selectedItemIndexForAmPm = 0;
      //     _scrollControllerAmPM =  FixedExtentScrollController(initialItem: 0);
      //   });
      //
      // } else {
      //   setState(() {
      //     _selectedItemIndexForAmPm = 1;
      //     _scrollControllerAmPM =  FixedExtentScrollController(initialItem: 1);
      //   });
      //
      // }

      String sortedDaysList = singleAnswer.dayList!.substring(1,singleAnswer.dayList!.length-1);

      sortedDaysList = sortedDaysList.replaceAll(" ", "");
      List<String> dayList = sortedDaysList.split(",");
      for(int i=0; i<dayList.length; i++) {
        // print(dayList[i]);
        if(dayList[i] == "Sun") {
          setState(() {
            isSunAvailable = true;
            _selectedWeekdays.add({
              "name": "Sun",
              "Selected": true,});
          });
        } else if(dayList[i] == "Mon") {
          setState(() {
            isMonAvailable = true;
            _selectedWeekdays.add({
              "name": "Mon",
              "Selected": true,});
          });
        } else if(dayList[i] == "Tue") {
          setState(() {
            isTueAvailable = true;
            _selectedWeekdays.add({
              "name": "Tue",
              "Selected": true,});
          });
        } else if(dayList[i] == "Wed") {
          setState(() {
            isWedAvailable = true;
            _selectedWeekdays.add({
              "name": "Wed",
              "Selected": true,});
          });
        } else if(dayList[i] == "Thu") {
          setState(() {
            isThuAvailable = true;
            _selectedWeekdays.add({
              "name": "Thu",
              "Selected": true,});
          });
        } else if(dayList[i] == "Fri") {
          setState(() {
            isFriAvailable = true;
            _selectedWeekdays.add({
              "name": "Fri",
              "Selected": true,});
          });
        } else if(dayList[i] == "Sat") {
          setState(() {
            isSatAvailable = true;
            _selectedWeekdays.add({
              "name": "Sat",
              "Selected": true,});
          });
        }

      }

      if(dayList.length == 7) {
        setState(() {
          isRepeat = true;
        });
      } else {
        setState(() {
          isRepeat = false;
        });
      }

      setState(() {
        _weekdays = [
          {"name" : "Sun", "Selected": isSunAvailable},
          {"name" : "Mon", "Selected": isMonAvailable},
          {"name" : "Tue", "Selected": isTueAvailable},
          {"name" : "Wed", "Selected": isWedAvailable},
          {"name" : "Thu", "Selected": isThuAvailable},
          {"name" : "Fri", "Selected": isFriAvailable},
          {"name" : "Sat", "Selected": isSatAvailable},];
        _titleController.text = singleAnswer.text!;
        _dateController.text = formattedDate;
        _endDateController.text = formattedEndDate;
        daysSelected = sortedDaysList;
        selectedRadio = singleAnswer.reminderType!;
      });
    }




    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0))
        ) ,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context,StateSetter setState) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SafeArea(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(onPressed: () {
                                Navigator.of(context).pop();
                              }, icon:const Icon(Icons.close)),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              // height: MediaQuery.of(context).size.height/5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color:AppColors.primaryColor ),
                                //color: AppColors.primaryColor,
                              ),
                              child: TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Reminder Description",
                                    // isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10)
                                ),
                                validator: (value) => value!.isEmpty ? "Enter something" : null,
                                style: const TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: AppConstants.defaultFontSize,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(color:AppColors.primaryColor ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _dateController,
                                onTap: () => _selectDate(context,_dateController),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Select Start Date",
                                    // isDense: true,
                                    prefixIcon: Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10)
                                ),
                                validator: (value) => value!.isEmpty ? "Start Date field required" : null,
                                readOnly: true,
                                style: const TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: AppConstants.defaultFontSize,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Visibility(
                              visible: selectedRadio == 'repeat',
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color:AppColors.primaryColor ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  controller: _endDateController,
                                  onTap: () => _selectDate(context,_endDateController),
                                  decoration:  InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Select End Date (Optional)",
                                      // isDense: true,
                                      suffixIcon: IconButton(onPressed: () {
                                        setState(() {
                                          _endDateController.clear();
                                        });
                                      }, icon:const Icon(Icons.clear)),
                                      prefixIcon:const Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                                      contentPadding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10)
                                  ),
                                  readOnly: true,
                                  style: const TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: AppConstants.defaultFontSize,
                                  ),
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(color:AppColors.primaryColor ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _reminderTimeController,
                                onTap: () async {
                                  // final pickedTime = await showTimePicker(
                                  //   helpText: 'Select Reminder Time',
                                  //   context: context,
                                  //   initialEntryMode: TimePickerEntryMode.inputOnly,
                                  //   initialTime: TimeOfDay(hour: selectedReminderTime.hour, minute: selectedReminderTime.minute),
                                  // );

                                  final pickedTime = await TimePicker.showIntervalTimePicker(
                                      context: context,
                                      helpText: 'Select Remainder Time',
                                      interval: 15,
                                      visibleStep: TimePicker.VisibleStep.fifteenths,
                                      errorInvalidText: 'Enter a valid time(15 minutes interval)',
                                      initialEntryMode: TimePicker.TimePickerEntryMode.dial,
                                      initialTime: TimeOfDay(hour: selectedReminderTime.hour, minute: selectedReminderTime.minute)
                                  );

                                  if(pickedTime != null){
                                    print('Picked Time ===============> ${pickedTime.hour}:${pickedTime.minute}');
                                    setState((){
                                      selectedReminderTime = DateTime(selectedReminderTime.year,selectedReminderTime.month, selectedReminderTime.day,pickedTime?.hour ?? selectedReminderTime.hour,pickedTime?.minute ?? selectedReminderTime.hour);
                                      _reminderTimeController.text = DateFormat('hh:mm a').format(selectedReminderTime);
                                    });

                                  }


                                },
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Select Reminder Time",
                                    // isDense: true,
                                    prefixIcon: Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10)
                                ),
                                validator: (value) => value!.isEmpty ? "Reminder Time Required" : null,
                                readOnly: true,
                                style: const TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: AppConstants.defaultFontSize,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            // InkWell(
                            //   onTap: () async {
                            //
                            //    final pickedTime = await showTimePicker(
                            //         context: context,
                            //         initialEntryMode: TimePickerEntryMode.inputOnly,
                            //         initialTime: TimeOfDay(hour: selectedReminderTime.hour, minute: selectedReminderTime.minute),
                            //     );
                            //
                            //    setState((){
                            //      selectedReminderTime = DateTime(selectedReminderTime.year,selectedReminderTime.month, selectedReminderTime.day,pickedTime?.hour ?? selectedReminderTime.hour,pickedTime?.minute ?? selectedReminderTime.hour);
                            //    });
                            //   },
                            //   child: ,
                            // child: Container(
                            //   padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            //   height: MediaQuery.of(context).size.height/3,
                            //   child: CupertinoDatePicker(
                            //     initialDateTime: selectedReminderTime,
                            //     minuteInterval: 15,
                            //     mode: CupertinoDatePickerMode.time,
                            //     onDateTimeChanged: (value) {
                            //       print('DateTime =========> $value');
                            //
                            //       print('Hour ===========> ${DateFormat('hh:mm').format(value)}');
                            //       print('Minutes ================>${DateFormat('a').format(value)}');
                            //       setState((){
                            //         selectedReminderTime = value;
                            //       });
                            //     },
                            //   ),
                            //   // child: Stack(
                            //   //   alignment: Alignment.center,
                            //   //   children: [
                            //   //     Container(
                            //   //       height: MediaQuery.of(context).size.height/25,
                            //   //       decoration: BoxDecoration(
                            //   //         borderRadius: BorderRadius.circular(20),
                            //   //         color: AppColors.primaryColor,
                            //   //       ),
                            //   //     ),
                            //   //     Row(
                            //   //       mainAxisAlignment: MainAxisAlignment.center,
                            //   //       crossAxisAlignment: CrossAxisAlignment.center,
                            //   //       children: [
                            //   //         Expanded(
                            //   //             child: ListWheelScrollView(
                            //   //               controller: _scrollControllerHour,
                            //   //               itemExtent: 25,
                            //   //               onSelectedItemChanged: (int index) {
                            //   //                 // update the UI on selected item changes
                            //   //                 setState(() {
                            //   //                   _selectedItemIndexForHour = index;
                            //   //                 });
                            //   //               },
                            //   //               diameterRatio: 1.4,
                            //   //               physics: const FixedExtentScrollPhysics(),
                            //   //               children: _itemsHour
                            //   //                   .map((e) => Center(
                            //   //                 child: Text(
                            //   //                   _itemsHour.indexOf(e) == _selectedItemIndexForHour ?e + " hr" : e,
                            //   //                   style:  TextStyle(
                            //   //                       fontSize:_itemsHour.indexOf(e) == _selectedItemIndexForHour ? AppConstants.fontSizeForReminderSectionTimePicker : AppConstants.defaultFontSize),
                            //   //                 ),
                            //   //               ))
                            //   //                   .toList(),
                            //   //               // Other properties...
                            //   //             )
                            //   //         ),
                            //   //         Expanded(
                            //   //             child: ListWheelScrollView(
                            //   //               controller: _scrollControllerMin,
                            //   //               itemExtent: 25,
                            //   //               onSelectedItemChanged: (int index) {
                            //   //                 // update the UI on selected item changes
                            //   //                 setState(() {
                            //   //                   _selectedItemIndexForMin = index;
                            //   //                 });
                            //   //               },
                            //   //               diameterRatio: 1.4,
                            //   //               physics: const FixedExtentScrollPhysics(),
                            //   //               children: _itemsMin
                            //   //                   .map((e) => Center(
                            //   //                 child: Text(
                            //   //                   _itemsMin.indexOf(e) == _selectedItemIndexForMin ?e + " min" : e,
                            //   //                   style:  TextStyle(
                            //   //                       fontSize:_itemsMin.indexOf(e) == _selectedItemIndexForMin ? AppConstants.fontSizeForReminderSectionTimePicker : AppConstants.defaultFontSize),
                            //   //                 ),
                            //   //               ))
                            //   //                   .toList(),
                            //   //               // Other properties...
                            //   //             )
                            //   //         ),
                            //   //         Expanded(
                            //   //             child: ListWheelScrollView(
                            //   //               controller: _scrollControllerAmPM,
                            //   //               itemExtent: 25,
                            //   //               onSelectedItemChanged: (int index) {
                            //   //                 // update the UI on selected item changes
                            //   //                 setState(() {
                            //   //                   _selectedItemIndexForAmPm = index;
                            //   //                 });
                            //   //               },
                            //   //               diameterRatio: 1.4,
                            //   //               physics: const FixedExtentScrollPhysics(),
                            //   //               children: _itemsAmPm
                            //   //                   .map((e) => Center(
                            //   //                 child: Text(
                            //   //                   e,
                            //   //                   style:  TextStyle(
                            //   //                       fontSize:_itemsAmPm.indexOf(e) == _selectedItemIndexForAmPm ? AppConstants.fontSizeForReminderSectionTimePicker : AppConstants.defaultFontSize),
                            //   //                 ),
                            //   //               ))
                            //   //                   .toList(),
                            //   //               // Other properties...
                            //   //             )
                            //   //         ),
                            //   //       ],
                            //   //     ),
                            //   //   ],
                            //   // ),
                            // ),
                            // ),
                            Container(
                              padding:const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        listTileTheme:const ListTileThemeData(
                                          horizontalTitleGap: 1,//here adjust based on your need
                                        ),
                                      ),
                                      child: RadioListTile<String>(
                                        value: 'repeat',
                                        groupValue: selectedRadio,
                                        title:const Text('Repeat',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                        onChanged: (String? val) {
                                          print(val);
                                          setState(() {
                                            selectedRadio = val!;
                                            isRepeat = true;
                                            _weekdays = [
                                              {"name" : "Sun", "Selected": true},
                                              {"name" : "Mon", "Selected": true},
                                              {"name" : "Tue", "Selected": true},
                                              {"name" : "Wed", "Selected": true},
                                              {"name" : "Thu", "Selected": true},
                                              {"name" : "Fri", "Selected": true},
                                              {"name" : "Sat", "Selected": true},];
                                          });
                                          _selectedWeekdays = _weekdays;
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        listTileTheme:const ListTileThemeData(
                                          horizontalTitleGap: 1,//here adjust based on your need
                                        ),
                                      ),
                                      child: RadioListTile<String>(
                                        value: 'once',
                                        groupValue: selectedRadio,
                                        title:const Text('Once',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                        onChanged: (String? val) {
                                          print(val);
                                          setState(() {
                                            selectedRadio = val!;
                                            isRepeat = false;
                                            _endDateController.clear();
                                            _weekdays = [
                                              {"name" : "Sun", "Selected": false},
                                              {"name" : "Mon", "Selected": false},
                                              {"name" : "Tue", "Selected": false},
                                              {"name" : "Wed", "Selected": false},
                                              {"name" : "Thu", "Selected": false},
                                              {"name" : "Fri", "Selected": false},
                                              {"name" : "Sat", "Selected": false},];
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  // Add more RadioListTile widgets for additional options
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Repeat",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                      Text(isRepeat ? "Everyday" : !isEditReminder ? daysSelected : daysSelected == "" || daysSelected == " " || selectedRadio == "once" ? "No day selected" :daysSelected.substring(0,daysSelected.length-1),style:const TextStyle(fontSize: AppConstants.defaultFontSize,color: AppColors.primaryColor),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Select All",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                      Checkbox(
                                        value: isRepeat,
                                        checkColor: AppColors.textWhiteColor,
                                        onChanged: (bool? value) {
                                          if(!isRepeat) {
                                            setState(() {
                                              isRepeat = value!;
                                              _weekdays = [
                                                {"name" : "Sun", "Selected": true},
                                                {"name" : "Mon", "Selected": true},
                                                {"name" : "Tue", "Selected": true},
                                                {"name" : "Wed", "Selected": true},
                                                {"name" : "Thu", "Selected": true},
                                                {"name" : "Fri", "Selected": true},
                                                {"name" : "Sat", "Selected": true},];
                                            });
                                          } else {
                                            setState(() {
                                              isRepeat = value!;
                                              _weekdays = [
                                                {"name" : "Sun", "Selected": false},
                                                {"name" : "Mon", "Selected": false},
                                                {"name" : "Tue", "Selected": false},
                                                {"name" : "Wed", "Selected": false},
                                                {"name" : "Thu", "Selected": false},
                                                {"name" : "Fri", "Selected": false},
                                                {"name" : "Sat", "Selected": false},];
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  )

                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height/14,
                              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _weekdays.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        // if(selectedRadio == "Repeat") {
                                        // print(index);
                                        if (_weekdays[index]['Selected']) {
                                          setState(() {
                                            isRepeat = false;
                                            _weekdays[index] = {
                                              "name": _weekdays[index]['name'],
                                              "Selected": false,
                                            };
                                          });
                                          removeWeekFromList(index);
                                        } else {
                                          setState(() {
                                            _weekdays[index] = {
                                              "name": _weekdays[index]['name'],
                                              "Selected": true,
                                            };
                                          });
                                          addWeekValueToList(index);
                                        }
                                        // } else {
                                        //
                                        //   // showToastMessage(context, "Please Select repeat from option", false);
                                        // }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 90,
                                        width: 50,
                                        padding:const EdgeInsets.symmetric(vertical: 10),
                                        margin:const EdgeInsets.symmetric(horizontal: 2),
                                        decoration: BoxDecoration(
                                          color:_weekdays[index]['Selected'] ? AppColors.primaryColor : AppColors.backgroundColor,
                                          border: Border.all(color: AppColors.primaryColor),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(_weekdays[index]['name'],style: TextStyle(fontSize: AppConstants.defaultFontSizeForWeekDays,color: _weekdays[index]['Selected'] ? AppColors.backgroundColor : AppColors.textWhiteColor),),
                                      ),
                                    );
                                  }),
                            ),
                            Container(
                              margin:const EdgeInsets.symmetric(vertical: 5),
                              child: ElevatedButton(
                                  onPressed: (){
                                    print('Hour ===========> ${DateFormat('hh:mm').format(selectedReminderTime)}');
                                    print('Minutes ================>${DateFormat('a').format(selectedReminderTime)}');
                                    dateList.clear();
                                    String reminderTitle = _titleController.text;
                                    String date1 = _dateController.text;
                                    String endDate1 = _endDateController.text;
                                    String time1 = DateFormat('hh:mm').format(selectedReminderTime);
                                    String reminderTypeTime = DateFormat('a').format(selectedReminderTime);
                                    selectedReminderTime = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
                                    for(int i = 0; i<_selectedWeekdays.length; i++) {
                                      dateList.add(_selectedWeekdays[i]["name"]);
                                    }
                                    print("DATE LIST CHECKING");
                                    print(dateList);
                                    _submitReminderData(
                                        date1,endDate1 ,time1, reminderTitle,selectedRadio == "repeat" ? dateList : [],
                                        reminderTypeTime, "active",selectedRadio);

                                    // } else {
                                    //   showToastMessage(context, "Select any day please", false);
                                    // }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    minimumSize: Size(MediaQuery.of(context).size.width/2, 35), // Set the minimum width and height
                                    padding: EdgeInsets.zero, // Remove any default padding
                                  ),
                                  child:const Text("Submit",style: TextStyle(color: AppColors.backgroundColor),)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          );
        });
  }

  _submitReminderData(String reminderDate,String reminderEndDate,String reminderTime,String title,List<String> selectedDaysList,String reminderTimeType,String status,String radioOptionSelection) {

    // print("EDIT REMINDER DETAILS");
    //
    // print(reminderDate);
    // print(reminderEndDate);
    // print(reminderTime);
    // print(title);
    // print(selectedDaysList);
    // print(reminderTimeType);
    // print(radioOptionSelection);

    if(_formKey.currentState!.validate()) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .postReminderInsertData(InsertPostReminderRequestModel(userId:id, text: title, date: reminderDate,endDate: reminderEndDate,time: reminderTime,status: status, daysList: selectedDaysList.toString(),timeType: reminderTimeType,reminderType: radioOptionSelection))
          .then((value) {
        setState(() {
          _isDataLoading = false;
          _dateController.text = "";
          _endDateController.text = "";
          _titleController.text = "";
          isRepeat = true;
          _weekdays = [
            {"name" : "Sun", "Selected": true},
            {"name" : "Mon", "Selected": true},
            {"name" : "Tue", "Selected": true},
            {"name" : "Wed", "Selected": true},
            {"name" : "Thu", "Selected": true},
            {"name" : "Fri", "Selected": true},
            {"name" : "Sat", "Selected": true},];
        });
        print("Reminder Data Insertion Saved");
        print(value);
        SingleAnswer singleAnswer = SingleAnswer(
          id: value['post_data']['id'].toString(),
          userId: value['post_data']['user_id'].toString(),
          text: value['post_data']['text'].toString(),
          dayList : value['post_data']['day_list'].toString(),
          date : value['post_data']['date'].toString(),
          endDate: value['post_data']['end_date'] ?? "",
          time : value['post_data']['time'].toString(),
          timeType : value['post_data']['time_type'].toString(),
          status : value['post_data']['status'].toString(),
          reminderType: value['post_data']['reminder_type'].toString(),
        );
        showToastMessage(context, "Reminder created successfully ", true);
        Navigator.of(context).pop();
      }).catchError((e) {
        print(e);
        setState(() {
          _isDataLoading = false;
        });
        showToastMessage(context, e.toString(), false);
      });
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
