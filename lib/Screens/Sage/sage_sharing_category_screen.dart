import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../Bridge/naq_list_screen.dart';
import '../Column/column_screen.dart';
import '../Ladder/Ladder_Screen.dart';
import '../PireScreens/pire_listing_screen.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/footer_widget.dart';
import '../utill/userConstants.dart';

class SageSharingCategoryScreen extends StatefulWidget {
  const SageSharingCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SageSharingCategoryScreen> createState() => _SageSharingCategoryScreenState();
}

class _SageSharingCategoryScreenState extends State<SageSharingCategoryScreen> {

  late bool isPhone;

  String name = "";
  String id = "";
  String errorText = "";
  // bool _isUserDataLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";
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
      // _isUserDataLoading = true;
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
      // _isUserDataLoading = false;
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
      appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
              Navigator.of(context).pop();
          }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared,otherUserLoggedIn,name),
      body: Column(
        children: [
          LogoScreen("Expertly Process One Issue"),
          Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: GridView.count(
                  padding:  EdgeInsets.symmetric(vertical:10,horizontal:!isPhone? MediaQuery.of(context).size.width/5: 10),
                  crossAxisCount: !isPhone ? 2 : 2,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  childAspectRatio: itemHeight/itemWidth,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PireListScreen(isSageShare: true,)));
                      },
                      child: const Card(
                            elevation: 100,
                            color: AppColors.connectionTypeTextColor,
                            child: Align(
                              child: Text("P.I.R.E",textAlign: TextAlign.center,style: TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.headingFontSize),),
                            ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const NaqListScreen(isSageShare: true,)));
                      },
                      child: const Card(
                            elevation: 100,
                            color: AppColors.connectionTypeTextColor,
                            child: Align(
                              child: Text("NAQ",textAlign: TextAlign.center,style: TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.headingFontSize),),
                            ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ColumnScreen()));
                      },
                      child: const Card(
                            elevation: 100,
                            color: AppColors.connectionTypeTextColor,
                            child: Align(
                              child: Text("Column",textAlign: TextAlign.center,style: TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.headingFontSize),),
                            ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LadderTileSection()));
                      },
                      child: const Card(
                            elevation: 100,
                            color: AppColors.connectionTypeTextColor,
                            child: Align(
                              child: Text("Ladder",textAlign: TextAlign.center,style: TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.headingFontSize),),
                            ),
                      ),
                    ),
                  ],
                ),
              )
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}
