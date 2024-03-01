// ignore_for_file: unnecessary_import, avoid_print, depend_on_referenced_packages, unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Bridge/naq_screen_q1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/sub_categoy_border.dart';
import '../../model/reponse_model/pire_naq_list_response_model.dart';
import '../../model/reponse_model/skipped_list_response_model.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../model/request_model/pire_naq_request_model.dart';
import '../../network/http_manager.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/footer_widget.dart';
import '../Widgets/show_notification_pop_up.dart';
import '../Widgets/toast_message.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';
import 'package:intl/intl.dart';

import 'naq_list_screen.dart';

class BridgeCategoryScreen extends StatefulWidget {
  const BridgeCategoryScreen({Key? key}) : super(key: key);

  @override
  State<BridgeCategoryScreen> createState() => _BridgeCategoryScreenState();
}

class _BridgeCategoryScreenState extends State<BridgeCategoryScreen> {

  String name = "";
  String id = "";
  int badgeCount1 = 0;
  int badgeCountShared = 0;
  bool _isUserDataLoading = true;
  bool _isLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";

  bool otherUserLoggedIn = false;

  bool isTextField = true;
  bool isYesNo = false;
  bool isOptions = false;

  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";
  String allowEmail = "";

  String naqListLength = "";

  late bool isPhone;

  bool isError = false;
  String errorText = "";
  List<PireNaqListItem> pireNaqListItem = <PireNaqListItem>[];

  @override
  void initState() {
    // TODO: implement initState

    _getUserData();
    super.initState();
  }

  getScreenDetails() {
    // setState(() {
    //   _isLoading = true;
    // });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    print("Data getting called");
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
      allowEmail = sharedPreferences.getString(UserConstants().allowEmail)!;
      userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
      userPremiumType =
      sharedPreferences.getString(UserConstants().userPremiumType)!;
      userCustomerId =
      sharedPreferences.getString(UserConstants().userCustomerId)!;
      userSubscriptionId =
      sharedPreferences.getString(UserConstants().userSubscriptionId)!;

      _getSkippedReminderList();
    }
    _getNAQResonseList(id);

    _getNaqList();

    setState(() {
      _isUserDataLoading = false;
    });
  }

  _getNaqList() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().pireNaqListResponse(PireNaqListRequestModel(userId: id,type: "naq")).then((value) {
      setState(() {
        pireNaqListItem = value.responses!;
        _isLoading = false;
        isError = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        isError = true;
        errorText = e.toString();
      });
    });
  }

  String? formattedDate;
  String? formattedTime;
  late SkippedReminderNotification skippedReminderNotification;

  _getSkippedReminderList() {
    setState(() {
      // sharedPreferences.setString("Score", "");
      // _isLoading = false;
    });
    HTTPManager().getSkippedReminderListData(LogoutRequestModel(userId: id)).then((value) {
      setState(() {
        skippedReminderNotification = value;
        // sharedPreferences.setString("Score", "");
        // _isLoading = false;
      });
      print("SKIPPED REMINDER LIST");
      print(value);

      for(int i = 0; i<skippedReminderNotification.result!.length; i++) {
        String title = "Hi $name. Did you....";
        DateTime date = DateTime.parse(skippedReminderNotification.result![i].dateTime.toString());
        formattedDate = DateFormat('MM-dd-yy').format(DateTime.parse(skippedReminderNotification.result![i].createdAt.toString()));
        formattedTime = DateFormat("hh:mm a").format(date);
        showPopupDialogueForReminderGeneral(context,skippedReminderNotification.result![i].entityId.toString(),skippedReminderNotification.result![i].id.toString(),title,skippedReminderNotification.result![i].text.toString(),formattedDate!,formattedTime!);
      }

    }).catchError((e) {
      print(e);
      setState(() {
        // sharedPreferences.setString("Score", "");
        // _isLoading = false;
      });
    });
  }

  _getNAQResonseList(String id) {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().naqResponseExistingList(LogoutRequestModel(userId: id)).then((value) {
      print(value);
      setState(() {
        _isLoading = false;
       // naqListResponse = value.values;
        naqListLength = value['exist'].toString();
      });
      print("Naq list length");
      print(naqListLength);
    }).catchError((e){
      print(e);
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<bool> _onWillPop() async {
    // if(nameController.text.isNotEmpty || descriptionController.text.isNotEmpty || purposeController.text.isNotEmpty || mentorNameController.text.isNotEmpty || mentorDescriptionController.text.isNotEmpty || peerNameController.text.isNotEmpty || peerDescriptionController.text.isNotEmpty || menteeNameController.text.isNotEmpty || menteeDescriptionController.text.isNotEmpty) {
    //   _setTrellisData();
    // }
    if(otherUserLoggedIn) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Dashboard()));
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    getScreenDetails();
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LogoScreen("Bridge"),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  height:!isPhone ? MediaQuery.of(context).size.height/1.27  : MediaQuery.of(context).size.height/1.43,
                  width: MediaQuery.of(context).size.width,
                  child: _isLoading ? const Center(child: CircularProgressIndicator(),) : GridView.count(
                    padding:  EdgeInsets.symmetric(vertical:10,horizontal: MediaQuery.of(context).size.width/5),
                    crossAxisCount:!isPhone ? 2 : 1,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: 1.6,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print(otherUserLoggedIn);
                          print("Other User CHecking");

                          if(otherUserLoggedIn) {
                            if(pireNaqListItem.isEmpty) {
                              showToastMessage(context, "Naq Collection not created yet", false);
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(builder: (
                                  context) => const NaqListScreen(isSageShare: false,)));
                            }
                          } else {
                            if(userPremium == "no" && naqListLength == "yes") {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                            } else {
                              if(pireNaqListItem.isEmpty) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const NaqScreen1()));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(builder: (
                                    context) => const NaqListScreen(isSageShare: false,)));
                              }

                            }
                          }
                        },
                        child: OptionMcqAnswerSubCategory(
                            const Card(
                              elevation: 0,
                              color: AppColors.backgroundColor,
                              child: Center(
                                child: Text("NAQ",style: TextStyle(fontSize: AppConstants.headingFontSize),),
                              ),
                            )
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showToastMessage(context, "Coming Soon...",false);
                          //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));
                        },
                        child: OptionMcqAnswerSubCategory(
                            const  Card(
                              elevation: 0,
                              color: AppColors.greyColor,
                              child: Center(
                                child: Text("Team Assessment",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                              ),
                            )
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showToastMessage(context, "Coming Soon...",false);
                          //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));
                        },
                        child: OptionMcqAnswerSubCategory(
                            const  Card(
                              elevation: 0,
                              color: AppColors.greyColor,
                              child: Center(
                                child: Text("Exec Skill Assessment",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
                              ),
                            )
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showToastMessage(context, "Coming Soon...",false);
                          //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));
                        },
                        child: OptionMcqAnswerSubCategory(
                            const  Card(
                              elevation: 0,
                              color: AppColors.greyColor,
                              child: Center(
                                child: Text("Emotional Maturity",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.headingFontSize),),
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
        ),
      ),
    );
  }
}
