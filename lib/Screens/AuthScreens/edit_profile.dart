
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_3.dart';
import 'package:flutter_quiz_app/Screens/AuthScreens/settings_screen.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/email_field.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/login_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/change_request_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../../Widgets/constants.dart';
import '../../Widgets/searchable_dropdown_field.dart';
import '../../Widgets/username_field_widget.dart';
import '../Widgets/toast_message.dart';
import '../utill/UserState.dart';
import '../utill/userConstants.dart';

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({Key? key}) : super(key: key);

  @override
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
  late String firebaseDeviceToken;
  String name = "";
  String id = "";
  String email = "";
  String userType = "";
  String authId = "";
  String allowEmail = "";
  late String _timezone;
  late String _timezoneValue;
  late SingleValueDropDownController _valueDropDownController;

  List<String> _availableTimezones = <String>[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _valueDropDownController = SingleValueDropDownController();
    _getUserData();
    _getAuthId();
    _initData();

    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance; // Change here
    firebaseMessaging.getToken().then((token){
      print("token is $token");
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


  _getAuthId() async {
    setState(() {
      _isUserDataLoading = true;
    });
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      authId = _sharedPreferences.getString("authId")!;
      _isUserDataLoading = false;
    });

  }
  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = _sharedPreferences.getString(UserConstants().userName)!;
      id = _sharedPreferences.getString(UserConstants().userId)!;
      email = _sharedPreferences.getString(UserConstants().userEmail)!;
      _timezoneValue = _sharedPreferences.getString(UserConstants().timeZone)!;
      userType = _sharedPreferences.getString(UserConstants().userType)!;
      allowEmail = _sharedPreferences.getString(UserConstants().allowEmail)!;
      userNameController.text = name;
      emailController.text = email;
      _valueDropDownController.dropDownValue = DropDownValueModel(name: _timezoneValue, value: _timezoneValue);
      _isUserDataLoading = false;
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
    if(userNameController.text != "" && userNameController.text!=name) {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            if(userNameController.text != "" && userNameController.text!=name) {
              showPopUponBackButton(context);
            } else {
              Navigator.of(context).pop();
            }
          }, icon:const Icon(Icons.arrow_back)),
          // automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(!_isUserDataLoading? name : ""),
        ),
        body: Container(
          color: AppColors.backgroundColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 60),
          child: Stack(
           children: [
             Form(
               key: _formKey,
               child: SingleChildScrollView(
                 scrollDirection: Axis.vertical,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     const LogoScreen(),

                     Container(
                       margin:const EdgeInsets.only(top: 10),
                       padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                       decoration: BoxDecoration(
                           color: AppColors.hoverColor,
                           borderRadius: BorderRadius.circular(5)
                       ),
                       child: _isUserDataLoading ? Container() : Column(
                         children: [

                           Container(
                               margin:const EdgeInsets.only(top: 10,bottom: 10),
                               child: userName(userNameController)),

                           Container(
                               margin:const EdgeInsets.only(top: 10,bottom: 10),
                               child: EmailField(emailController)),

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
                                       print("Value Selected");
                                       setState(() {
                                         _timezoneValue = _valueDropDownController.dropDownValue!.value.toString();
                                         print(_timezoneValue);
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
    print("ChangeProfile");
    print(name1);
    print(email);
    print(timeZone);

    if(_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      HTTPManager().changeProfile(
          ChangeProfileRequestModel(name:name1,email: email, userId: id,timeZone: timeZone,deviceToken: deviceToken)).then((
          value) async {
        print("ChangeProfileResponse");
        print(value);
        UserStatePrefrence().setAnswerText(
            true,
            userType,
            name1,
            email,
            id,
            timeZone,
            allowEmail);

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
            MaterialPageRoute(builder: (BuildContext context) => Screen3()),
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
    // if result not null we simply call the MaterialpageRoute,
    // for go to the HomePage screen
  }

}
