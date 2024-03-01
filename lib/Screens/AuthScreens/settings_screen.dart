
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_3.dart';
import 'package:flutter_quiz_app/Screens/Posts/post_reminders.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Screens/utill/UserState.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/login_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/user_email_response_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../model/request_model/admin_access_request_model.dart';
import '../Garden/garden_screen.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../utill/userConstants.dart';
import 'change_password.dart';
import 'edit_profile.dart';
import 'login_screen.dart';

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  Settings(this.type,{Key? key}) : super(key: key);
  String type;
  @override
  // ignore: library_private_types_in_public_api
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final _formKey = GlobalKey<FormState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isStatusLoading = false;
  bool status = false;
  late LoginResponseModel loginResponseModel;
  String name = "";
  String id = "";
  String allowEmail = "";
  String authId = "";
  String email = "";
  String userType = "";
  String timeZone = "";
  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";
  int badgeCount1 = 0;
  int badgeCountShared = 0;
  String userAccess = "";
  bool userAccessStatus = false;

  bool isPhone = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
    _getAuthId();
  }


  _getAuthId() async {
    setState(() {
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      authId = sharedPreferences.getString("authId")!;
    });

  }
  _getUserData() async {
    setState(() {
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {

      badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
      badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;
      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      allowEmail = sharedPreferences.getString(UserConstants().allowEmail)!;
      userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
      userPremiumType = sharedPreferences.getString(UserConstants().userPremiumType)!;
      userCustomerId = sharedPreferences.getString(UserConstants().userCustomerId)!;
      userSubscriptionId = sharedPreferences.getString(UserConstants().userSubscriptionId)!;
      userAccess = sharedPreferences.getString(UserConstants().userAccess)!;

      setState(() {
        if(allowEmail == "yes") {
          status = true;
        } else {
          status = false;
        }

        if(userAccess == "yes") {
          userAccessStatus = true;
        } else {
          userAccessStatus = false;
        }
      });
    });

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

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      appBar: AppBarWidget().appBarGeneralButtons(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared),
      // bottomNavigationBar: GestureDetector(
      //   onTap: () {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Screen3()));
      //   },
      //   child: OptionMcqAnswer(
      //     Container(
      //       height: MediaQuery.of(context).size.height/10,
      //       width: MediaQuery.of(context).size.width,
      //       color: AppColors.backgroundColor,
      //       child:const Text("Next"),
      //     ),
      //   ),
      // ),
      body: Container(
        color: AppColors.backgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: !isPhone ?  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4,vertical: 10) : const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 60),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LogoScreen(""),

                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  decoration: BoxDecoration(
                      color: AppColors.hoverColor,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ChangeProfile()));
                            },
                            child: OptionMcqAnswer(
                              Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  margin:const EdgeInsets.only(top: 5,bottom: 5),
                                  child:
                                  const Text("Edit Profile",style: TextStyle(fontSize: AppConstants.defaultFontSize),)
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ChangePassword()));
                            },
                            child: OptionMcqAnswer(
                              Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  margin:const EdgeInsets.only(top: 5,bottom: 5),
                                  child:
                                  const Text("Change Password",style: TextStyle(fontSize: AppConstants.defaultFontSize),)
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              showAlertDialog(context);
                            },
                            child: OptionMcqAnswer(
                              Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  margin:const EdgeInsets.only(top: 5,bottom: 5),
                                  child:
                                  const Text("Delete Account",style: TextStyle(fontSize: AppConstants.defaultFontSize),)
                              ),
                            ),
                          ),

                          OptionMcqAnswer(
                            Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                   const Expanded(
                                       flex: 2,
                                       child: Text("Would you prefer to receive response via email?",style: TextStyle(fontSize: AppConstants.defaultFontSize),)),
                                    Expanded(
                                      flex: 1,
                                      child: MediaQuery(
                                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                        child: FlutterSwitch(
                                          activeColor: AppColors.primaryColor,
                                          value: status,
                                          borderRadius: 30.0,
                                          padding: 8.0,
                                          showOnOff: true,
                                          onToggle: (val) {
                                            setState(() {
                                              setEmailResponse(id,val);
                                              status = val;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          OptionMcqAnswer(
                            Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                        flex: 2,
                                        child: Text("Allow admin to make changes to your column?",style: TextStyle(fontSize: AppConstants.defaultFontSize),)),
                                    Expanded(
                                      flex: 1,
                                      child: MediaQuery(
                                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                        child: FlutterSwitch(
                                          activeColor: AppColors.primaryColor,
                                          value: userAccessStatus,
                                          borderRadius: 30.0,
                                          padding: 8.0,
                                          showOnOff: true,
                                          onToggle: (val) {
                                            String userAccessText = "";
                                            if(userAccessStatus) {
                                              userAccessText = "no";
                                            } else {
                                              userAccessText = "yes";
                                            }
                                            setState(() {
                                              setAdminAccess(userAccessText);
                                              userAccessStatus = val;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),

                          Visibility(
                            visible: widget.type != "",
                            child: GestureDetector(
                              onTap: () {
                                if(widget.type == "PIRE") {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const Screen3()));
                                } else if(widget.type == "Posts") {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>  const Posts()));
                                } else if(widget.type == "Garden") {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GardenScreen()));
                                }
                              },
                              child: OptionMcqAnswer(
                                Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    margin:const EdgeInsets.only(top: 5,bottom: 5),
                                    child:
                                    const Text("Next",style: TextStyle(fontSize: AppConstants.defaultFontSize),)
                                ),
                              ),
                            ),
                          ),

                          Align(alignment: Alignment.center,
                            child: isStatusLoading ? const CircularProgressIndicator(): Container(),
                          )
                        ],
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child:const Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child:const Text("Continue"),
      onPressed:  () {
        _deleteAccount(id);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Account"),
      content: const Text("Are you sure you want to delete your account permanently?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _deleteAccount(String id) {
    HTTPManager().deleteUser(id).then((value) async {

      showToastMessage(context, "Account deleted successfully",true);

      //googleSignIn.disconnect();
      googleSignIn.signOut();
      setState(() {
        UserStatePrefrence().clearAnswerText();
      });
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
              (Route<dynamic> route) => false
      );

    }).catchError((e) {
      // ignore: avoid_print
      print(e.toString());
      showToastMessage(context, e.toString(),false);
    });
  }

  setAdminAccess(String userAccessNew) async {
    setState(() {
      isStatusLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    HTTPManager().adminAccess(AdminAccessRequestModel(userId: id,adminAccess: userAccessNew)).then((value){
      setState(() {
        isStatusLoading = false;
      });
      sharedPreferences.setString(UserConstants().userAccess, value['data']['admin_access'].toString());
      showToastMessage(context, "Status updated successfully", true);
    }).catchError((e) {
      setState(() {
        isStatusLoading = false;
      });
    });
  }

  void setEmailResponse(String id, bool status) {
    String? selectedStatus;
    setState(() {
      isStatusLoading = true;
      if(status) {
        selectedStatus = "yes";
      } else {
        selectedStatus = "no";
      }
    });

    // print(id);
    // print(selectedStatus);
    HTTPManager().userEmailResponse(UserEmailResponseRequestModel(userId: id,status: selectedStatus)).then((value) {
      setState(() {
        isStatusLoading = false;
      });
      UserStatePrefrence().setAnswerText(
          true,
          userType,
          name,
          email,
          id,
          timeZone,
          selectedStatus!,
          userPremium,
      userPremiumType,
        userCustomerId,
        userSubscriptionId
      );
      showToastMessage(context, "Status updated successfully", true);
    }).catchError((e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        isStatusLoading = false;
      });
      showToastMessage(context, e.toString(), false);
    });
  }

}
