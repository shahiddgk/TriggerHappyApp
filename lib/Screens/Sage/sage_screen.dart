// ignore_for_file: avoid_print, duplicate_ignore, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Sage/shared_item_list_screen.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/sub_categoy_border.dart';
import '../../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../../model/reponse_model/Sage/user_search_list_response.dart';

import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/footer_widget.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';

class SageScreen extends StatefulWidget {
  const SageScreen({Key? key}) : super(key: key);

  @override
  State<SageScreen> createState() => _SageScreenState();
}

class _SageScreenState extends State<SageScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  String errorText = "";

  String email = "";
  String timeZone = "";
  String userType = "";

  String selectedRole = "Mentor";
  List<String> selectedModules = [];
  String selectedModulesString = "";
  late UsersSearchData selectedUsersData;
  final _formKey = GlobalKey<FormState>();

  late ConnectionUserListResponse1 connectionUserListResponse1;
  // late List <UsersSearchData> usersSearchData;


  final TextEditingController _emailController = TextEditingController();

  List<AcceptedConnectionItem> acceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> mentorAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> peerAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> menteeAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> searchAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];

  List<AcceptedConnectionItem> sentConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> mentorSentConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> peerSentConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> menteeSentConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> searchSentConnectionsListResponse = <AcceptedConnectionItem>[];

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;


  bool isAllConnections = true;
  bool isMentorConnections = false;
  bool isPeerConnections = false;
  bool isMenteeConnections = false;

  bool isSearchConnections = false;
  int badgeCount1 = 0;
  int badgeCountShared = 0;
  int selectedRadio = 1;

  bool otherUserLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState

    _getUserData();

    super.initState();
  }

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      _isUserDataLoading = true;
    });
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    // badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;
    otherUserLoggedIn = sharedPreferences.getBool(UserConstants().otherUserLoggedIn)!;

    if(otherUserLoggedIn) {

      id = sharedPreferences.getString(UserConstants().otherUserId)!;
      name = sharedPreferences.getString(UserConstants().otherUserName)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

    } else {
      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

    }

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

  setSelectedRadio(int val) {
    // print(val);
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    getScreenDetails();
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return  Scaffold(
      backgroundColor: AppColors.hoverColor,
      appBar:  AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
            if(otherUserLoggedIn) {
              Navigator.of(context).pop();
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
                      (Route<dynamic> route) => false
              );
            }
          }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared,otherUserLoggedIn,name),
      body: Column(
        children: [
          LogoScreen("Sage"),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                height:!isPhone ? MediaQuery.of(context).size.height/1.27  : MediaQuery.of(context).size.height/1.43,
                width: MediaQuery.of(context).size.width,
                child: GridView.count(
                  padding:  EdgeInsets.symmetric(vertical:10,horizontal: MediaQuery.of(context).size.width/5),
                  crossAxisCount:!isPhone ? 2 : 1,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 2.0,
                  childAspectRatio: itemHeight/itemWidth,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SharedItemList()));
                      },
                      child: OptionMcqAnswerSubCategory(
                          const Card(
                            elevation: 0,
                            color: AppColors.backgroundColor,
                            child: Center(
                              child: Text("Expertly Process One Issue",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                            ),
                          )
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showToastMessage(context, "Coming Soon...",false);
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));
                      },
                      child: OptionMcqAnswerSubCategory(
                          const  Card(
                            elevation: 0,
                            color: AppColors.greyColor,
                            child: Center(
                              child: Text("Book Coaching Consultation",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                            ),
                          )
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showToastMessage(context, "Coming Soon...",false);
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));
                      },
                      child: OptionMcqAnswerSubCategory(
                          const  Card(
                            elevation: 0,
                            color: AppColors.greyColor,
                            child: Center(
                              child: Text("Hire Expert Coach",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const FooterWidget(),
        ],
      )
    );
  }




}
