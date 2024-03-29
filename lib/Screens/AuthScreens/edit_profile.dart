
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/AuthScreens/settings_screen.dart';
import 'package:flutter_quiz_app/Screens/dashboard_tiles.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/email_field.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/login_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/change_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../../Widgets/constants.dart';
import '../../Widgets/username_field_widget.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/toast_message.dart';
import '../utill/UserState.dart';
import '../utill/userConstants.dart';

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChangeProfileState createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isLogin = true;
  bool isTimeZoneLoading = true;
  late LoginResponseModel loginResponseModel;
  bool _isUserDataLoading = false;
  bool isLoading = false;
  bool isLoading1 = true;
  late String firebaseDeviceToken;
  String name = "";
  String id = "";
  String email = "";
  String userType = "";
  String authId = "";
  String allowEmail = "";
  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";

  String profileImageUrl = "";

  int badgeCount1 = 0;
  int badgeCountShared = 0;

  bool isPhone = true;

  File? imageFile;
  bool isFilePicked = false;

  late String _timezoneValue;
  late SingleValueDropDownController _valueDropDownController;

  final List<String> _availableTimezones = <String>[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _valueDropDownController = SingleValueDropDownController();
    _getUserData();
    // _getAuthId();
    _initData();

    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance; // Change here
    firebaseMessaging.getToken().then((token){
      //print("token is $token");
      setState(() {
        firebaseDeviceToken = token!;
      });
    });
  }


  Future<void> _initData() async {
    setState(() {
      isTimeZoneLoading = true;
    });
    setState(() {
      _availableTimezones.add("European Central Time (GMT+1:00)");
      _availableTimezones.add("Eastern European Time (GMT+2:00)");
      _availableTimezones.add("Egypt Standard Time (GMT+2:00)");
      _availableTimezones.add("Eastern African Time (GMT+3:00)");
      _availableTimezones.add("Middle East Time (GMT+3:30)");

      _availableTimezones.add("Near East Time (GMT+4:00)");
      _availableTimezones.add("Pakistan Lahore Time (GMT+5:00)");
      _availableTimezones.add("India Standard Time (GMT+5:30)");
      _availableTimezones.add("Bangladesh Standard Time (GMT+6:00)");
      _availableTimezones.add("Vietnam Standard Time (GMT+7:00)");

      _availableTimezones.add("China Taiwan Time (GMT+8:00)");
      _availableTimezones.add("Japan Standard Time (GMT+9:00)");
      _availableTimezones.add("Australia Central Time (GMT+9:30)");
      _availableTimezones.add("Australia Eastern Time (GMT+10:00)");
      _availableTimezones.add("Solomon Standard Time (GMT+11:00)");

      _availableTimezones.add("New Zealand Standard Time (GMT+12:00)");
      _availableTimezones.add("Midway Islands Time (GMT-11:00)");
      _availableTimezones.add("Hawaii Standard Time (GMT-10:00)");
      _availableTimezones.add("Alaska Standard Time (GMT-9:00)");
      _availableTimezones.add("Yukon Standard Time (GMT-8:00)");
      _availableTimezones.add("Alaska-Hawaii Standard Time (GMT-9:00)");
      _availableTimezones.add("Pacific Standard Time (GMT-8:00)");

      _availableTimezones.add("Phoenix Standard Time (GMT-7:00)");
      _availableTimezones.add("Central Standard Time (GMT-6:00)");
      _availableTimezones.add("Mountain Standard Time (GMT-7:00)");
      _availableTimezones.add("Eastern Standard Time (GMT-5:00)");
      _availableTimezones.add("Indiana Eastern Standard Time (GMT-5:00)");

      _availableTimezones.add("Puerto Rico and US Virgin Islands Time (GMT-4:00)");
      _availableTimezones.add("Canada Newfoundland Time (GMT-3:30)");
      _availableTimezones.add("Argentina Standard Time (GMT-3:00)");
      _availableTimezones.add("Brazil Eastern Time (GMT-3:00)");
      _availableTimezones.add("Central African Time (GMT-1:00)");

      isTimeZoneLoading = false;
    });

    // setState(() {
    //   isTimeZoneLoading = true;
    // });
    // try {
    //   _timezone = await FlutterTimezone.getLocalTimezone();
    // } catch (e) {
    //   print('Could not get the local timezone');
    //   setState(() {
    //     isTimeZoneLoading = false;
    //   });
    // }
    // try {
    //   _availableTimezones = await FlutterTimezone.getAvailableTimezones();
    //   _availableTimezones.sort();
    //
    //   _timezone = _availableTimezones[0];
    //
    //   setState(() {
    //     isTimeZoneLoading = false;
    //   });
    //
    //   print('All available timezones');
    //   print(_availableTimezones);
    // } catch (e) {
    //   print('Could not get available timezones');
    //   setState(() {
    //     isTimeZoneLoading = false;
    //   });
    // }
    // if (mounted) {
    //   setState(() {
    //     isTimeZoneLoading = false;
    //   });
    // }
  }


  // _getAuthId() async {
  //   setState(() {
  //     _isUserDataLoading = true;
  //   });
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     authId = sharedPreferences.getString("authId")!;
  //     _isUserDataLoading = false;
  //   });
  //
  // }
  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {

      badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
      badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      _timezoneValue = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;
      allowEmail = sharedPreferences.getString(UserConstants().allowEmail)!;
      userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
      userPremiumType = sharedPreferences.getString(UserConstants().userPremiumType)!;
      userCustomerId = sharedPreferences.getString(UserConstants().userCustomerId)!;
      userSubscriptionId = sharedPreferences.getString(UserConstants().userSubscriptionId)!;

      getUserProfileDetails();

      _isUserDataLoading = false;
    });

  }

  getUserProfileDetails() {
    setState(() {
      isLoading1 = true;
    });
    HTTPManager().getUserProfileDetails(LogoutRequestModel(userId: id)).then((value) {

      setState(() {
        profileImageUrl = value['data']['image_url'];
        name = value['data']['name'];
        email = value['data']['email'];

        userNameController.text = name;
        emailController.text = email;
        _valueDropDownController.dropDownValue = DropDownValueModel(name: _timezoneValue, value: _timezoneValue);

        print("Profile Image");
        print(profileImageUrl);
        isLoading1 = false;
      });

    }).catchError((e) {
      setState(() {
        isLoading1 = false;
      });
      print(e.toString());
    });
  }

  showPopUponBackButton(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child:const Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
       // _changeProfile(userNameController.text,emailController.text,_timezone,firebaseDeviceToken);
      },
    );
    Widget continueButton = TextButton(
      child:const Text("Yes"),
      onPressed:  () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Settings("")));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Update profile"),
      content: const Text("Are you sure you want to continue without saving you data?"),
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

  Future<bool> _onWillPop() async {
    if(userNameController.text!=name || emailController.text != email) {
      showPopUponBackButton(context);
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _valueDropDownController.dispose();
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget().appBarGeneralButtons(
            context,
                () {
                  if(userNameController.text != "" && userNameController.text!=name) {
                    showPopUponBackButton(context);
                  } else {
                    Navigator.of(context).pop();
                  }
            }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared),

        // AppBar(
        //   leading: IconButton(onPressed: (){
        //
        //   }, icon:const Icon(Icons.arrow_back)),
        //   // automaticallyImplyLeading: false,
        //   centerTitle: true,
        //   title: Text(!_isUserDataLoading? name : ""),
        // ),
        body: Container(
          color: AppColors.backgroundColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: !isPhone ?  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4,vertical: 10) : const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: isLoading1 ? const Center(child: CircularProgressIndicator(),) : Stack(
           children: [
             Form(
               key: _formKey,
               child: SingleChildScrollView(
                 scrollDirection: Axis.vertical,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                      LogoScreen(""),

                     Container(
                       padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                       decoration: BoxDecoration(
                           color: AppColors.hoverColor,
                           borderRadius: BorderRadius.circular(5)
                       ),
                       child: _isUserDataLoading ? Container() : Column(
                         children: [

                           InkWell(
                             onTap: () async {
                               final ImagePicker picker=ImagePicker();
                               final XFile? image1 = await picker.pickImage(source: ImageSource.gallery);
                               if(image1!=null){
                                 print("image path: ${image1.path}");
                                 setState(() {
                                   imageFile = File(image1.path);
                                   isFilePicked = true;
                                 });
                               } else {
                                 setState(() {
                                   isFilePicked = false;
                                 });
                               }
                             },
                             child: Stack(
                               alignment: Alignment.center,
                               children: [
                                 Container(
                                   height: 150,
                                   width: 150,
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(150),
                                       border: Border.all(color: AppColors.primaryColor),
                                     ),
                                   margin: const EdgeInsets.symmetric(horizontal: 10),
                                   child: ClipOval(
                                     child: imageFile == null ? CachedNetworkImage(
                                       imageUrl: profileImageUrl,
                                       fit: BoxFit.cover,
                                       progressIndicatorBuilder: (context, url, downloadProgress) =>
                                           Container(
                                             margin: const EdgeInsets.only(
                                                 top: 100,
                                                 bottom: 100
                                             ),
                                             child: CircularProgressIndicator(
                                                 value: downloadProgress.progress,
                                                 color: AppColors.primaryColor
                                             ),
                                           ),
                                       errorWidget: (context, url, error) =>  const Center(child: Icon(Icons.error,color: AppColors.redColor,)),
                                     ) : Image.file(
                                       imageFile!,
                                       fit: BoxFit.cover,
                                     ),
                                   )
                                 ),
                                  Positioned(
                                   bottom: 10,
                                   right: 10,
                                   child: Container(
                                     padding: const EdgeInsets.all(5),
                                       decoration: BoxDecoration(
                                         color: AppColors.hoverColor,
                                         borderRadius: BorderRadius.circular(150)
                                       ),
                                       child: const Icon(Icons.image,color: AppColors.primaryColor,size: 30,)),
                                 )
                               ],
                             ),
                           ),

                           Container(
                               margin:const EdgeInsets.only(top: 10,bottom: 10),
                               child: userName(userNameController)),

                           Container(
                               margin:const EdgeInsets.only(top: 10,bottom: 10),
                               child: EmailField(emailController,"Type your email")),

                           if(!isTimeZoneLoading && !_isUserDataLoading)
                             Container(
                                 alignment: Alignment.centerLeft,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(8),
                                   border: Border.all(color: Colors.grey),
                                 ),
                                 margin:const EdgeInsets.only(top: 10),
                                 child: DropdownButtonHideUnderline(
                                   child: DropDownTextField(
                                     textStyle:const TextStyle(fontSize: AppConstants.defaultFontSize),
                                     //listSpace: 20,
                                     textFieldDecoration:const InputDecoration(
                                       border: InputBorder.none,
                                       hintText: "Select your timezone",
                                       hintStyle: TextStyle(fontSize: AppConstants.defaultFontSize),
                                       contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                     ),
                                     // initialValue: _timezoneValue,
                                     listPadding: ListPadding(top: 20),
                                     enableSearch: true,
                                     controller: _valueDropDownController,
                                     validator: (value) => value!.isEmpty ? "Time zone Field is required" : null,
                                     dropDownList: _availableTimezones.map<DropDownValueModel>((String value) {
                                       return DropDownValueModel(
                                           value: value,
                                           name: value
                                       );
                                     }).toList(),
                                     onChanged: (val) {
                                       //print("Value Selected");
                                       setState(() {
                                         _timezoneValue = _valueDropDownController.dropDownValue!.value.toString();
                                       //  print(_timezoneValue);
                                       });
                                     },
                                   ),
                                 )

                             ),
                             // Container(
                             //   alignment: Alignment.centerLeft,
                             //     decoration: BoxDecoration(
                             //       borderRadius: BorderRadius.circular(8),
                             //       border: Border.all(color: Colors.grey),
                             //     ),
                             //     margin:const EdgeInsets.only(top: 10),
                             //     child: DropdownButtonHideUnderline(
                             //       child: DropDownTextField(
                             //         //listSpace: 20,
                             //         textFieldDecoration:const InputDecoration(
                             //           border: InputBorder.none,
                             //           contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                             //         ),
                             //        // initialValue: _timezoneValue,
                             //         listPadding: ListPadding(top: 20),
                             //         enableSearch: true,
                             //         controller: _valueDropDownController,
                             //         validator: (value) {
                             //           if (value!.isEmpty) {
                             //             return "Time zone Field is required";
                             //           } else {
                             //             return null;
                             //           }
                             //         },
                             //           dropDownList: _availableTimezones.map<DropDownValueModel>((String value) {
                             //             return DropDownValueModel(
                             //               value: value,
                             //               name: value
                             //             );
                             //           }).toList(),
                             //           onChanged: (val) {
                             //           print("Value Selected");
                             //             setState(() {
                             //               _timezoneValue = _valueDropDownController.dropDownValue!.value.toString();
                             //               print(_valueDropDownController.dropDownValue!.value.toString());
                             //             });
                             //           },
                             //       ),
                             //     )
                             //
                             // ),
                            const SizedBox(
                              height: 10,
                            ),
                           GestureDetector(
                             onTap: () {
                               _changeProfile(userNameController.text,emailController.text,_timezoneValue,firebaseDeviceToken,allowEmail);
                             },
                             child: OptionMcqAnswer(
                               Container(
                                   margin:const EdgeInsets.only(top: 10,bottom: 10),
                                   width: MediaQuery.of(context).size.width,
                                   alignment: Alignment.center,
                                   child:
                                   const Text("Submit",style: TextStyle(fontSize: 15),)
                               ),
                             ),
                           ),

                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ),
             Align(alignment: Alignment.center,
               child: isLoading ? const CircularProgressIndicator(): Container(),
             )
           ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeProfile(String name1,String email,String timeZone,String deviceToken,String allowEmail) async {
    // print("ChangeProfile");
    // print(name1);
    // print(email);
    // print(timeZone);

    if(_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      if(isFilePicked) {
        HTTPManager().changeProfileWithImage(
            ChangeProfileRequestModel(name:name1,email: email, userId: id,timeZone: timeZone,deviceToken: deviceToken),imageFile!).then((
            value) async {
          // print("ChangeProfileResponse");
          // print(value);
          UserStatePrefrence().setAnswerText(
              true,
              userType,
              name1,
              email,
              id,
              timeZone,
              allowEmail,
              userPremium,
              userPremiumType,
              userCustomerId,
              userSubscriptionId);

          setState(() {
            name = name1;
            //  loginResponseModel = value;
            isLoading = false;
            userNameController.text == "";
            emailController.text == "";

          });
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const Dashboard()),
                  (Route<dynamic> route) => false
          );
          // ignore: use_build_context_synchronously
          showToastMessage(context, "Profile updated successfully",true);

        }).catchError((e) {
          setState(() {
            isLoading = false;
          });
          showToastMessage(context, e.toString(),false);

        });
      } else {
        HTTPManager().changeProfile(
            ChangeProfileRequestModel(name:name1,email: email, userId: id,timeZone: timeZone,deviceToken: deviceToken)).then((
            value) async {
          // print("ChangeProfileResponse");
          // print(value);
          UserStatePrefrence().setAnswerText(
              true,
              userType,
              name1,
              email,
              id,
              timeZone,
              allowEmail,
              userPremium,
              userPremiumType,
              userCustomerId,
              userSubscriptionId);

          setState(() {
            name = name1;
            //  loginResponseModel = value;
            isLoading = false;
            userNameController.text == "";
            emailController.text == "";

          });
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const Dashboard()),
                  (Route<dynamic> route) => false
          );
          // ignore: use_build_context_synchronously
          showToastMessage(context, "Profile updated successfully",true);

        }).catchError((e) {
          setState(() {
            isLoading = false;
          });
          showToastMessage(context, e.toString(),false);

        });
      }
    }
    // if result not null we simply call the MaterialpageRoute,
    // for go to the HomePage screen
  }

}
