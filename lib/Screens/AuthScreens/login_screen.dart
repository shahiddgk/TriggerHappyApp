

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/AuthScreens/forgot_password.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_3.dart';
import 'package:flutter_quiz_app/Screens/TreeScreen/tree_screen.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Screens/dashboard_tiles.dart';
import 'package:flutter_quiz_app/Screens/utill/UserState.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/email_field.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/password_field_widget.dart';
import 'package:flutter_quiz_app/Widgets/username_field_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/login_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/login_request.dart';
import 'package:flutter_quiz_app/model/request_model/register_create_request.dart';
import 'package:flutter_quiz_app/model/request_model/social_login_request_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/constants.dart';
import '../../Widgets/searchable_dropdown_field.dart';
import '../PireScreens/widgets/AppBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

 // final Future<bool> _isAvailableFuture = TheAppleSignIn.isAvailable();

  late String errorMessage;
   String responseAppleEmail = "";
   String responseAppleName = "";
   String responseAppleIdentityToken = "";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;
  bool isLoading = false;
  bool isTimeZoneLoading = true;
  late String deviceToken;
  late String deviceTimeZone;
  late LoginResponseModel loginResponseModel;
  late SingleValueDropDownController _valueDropDownController;

  late String _timezone;
  List<String> _availableTimezones = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _valueDropDownController = SingleValueDropDownController();
    _initData();

   //  deviceTimeZone = DateTime.now().timeZoneName;
   // final deviceTimeZoneOffset = DateTime.now().timeZoneOffset.toString();

  //  final String abbreviation = DateFormat('z').format(DateTime.now().toUtc().add(Duration(hours: TimeZone().getLocation(deviceTimeZone).utcOffset.inHours))).replaceAll(RegExp(r'[a-zA-Z]'), '');

    // print('Current time zone: $deviceTimeZone');
    // print('Current time zone offset: $deviceTimeZoneOffset');
    //
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance; // Change here
    firebaseMessaging.getToken().then((token){
      print("token is $token");
      setState(() {
        deviceToken = token!;
      });
    });
   // checkLoggedInState();
   //  TheAppleSignIn.onCredentialRevoked?.listen((_) {
   //    print("Credentials revoked");
   //  });

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

  // void checkLoggedInState() async {
  //   final userId = await FlutterSecureStorage().read(key: "userId");
  //   if (userId == null) {
  //     print("No stored user ID");
  //     return;
  //   }
  //
  //   final credentialState = await TheAppleSignIn.getCredentialState(userId);
  //   switch (credentialState.status) {
  //     case CredentialStatus.authorized:
  //       print("getCredentialState returned authorized");
  //       break;
  //
  //     case CredentialStatus.error:
  //       print(
  //           "getCredentialState returned an error: ${credentialState.error?.localizedDescription}");
  //       break;
  //
  //     case CredentialStatus.revoked:
  //       print("getCredentialState returned revoked");
  //       break;
  //
  //     case CredentialStatus.notFound:
  //       print("getCredentialState returned not found");
  //       break;
  //
  //     case CredentialStatus.transferred:
  //       print("getCredentialState returned not transferred");
  //       break;
  //   }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _valueDropDownController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("LogIn"),centerTitle: true,),
      body: Container(
        color: AppColors.backgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 60),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: IgnorePointer(
              ignoring: false,
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
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                             Expanded(
                               child: OptionMcqAnswer(GestureDetector(
                                 onTap: (){
                                   setState(() {
                                     _isLogin = true;
                                   });
                                 },
                                 child: Container(
                                     decoration: BoxDecoration(
                                         color: _isLogin ? AppColors.primaryColor : AppColors.hoverColor,
                                         borderRadius: BorderRadius.circular(6)
                                     ),
                                   padding:const EdgeInsets.symmetric(vertical: 10),
                                   alignment: Alignment.center,
                                     child:const Text("Sign in",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.containerBorder,fontSize: AppConstants.defaultFontSize),)),
                               )),
                             ),
                             const SizedBox(
                                width: 5,
                              ),
                             Expanded(
                               child: OptionMcqAnswer(GestureDetector(
                                 onTap: (){
                                   setState(() {
                                     _isLogin = false;
                                   });
                                 },
                                 child: Container(
                                     decoration: BoxDecoration(
                                         color: _isLogin ? AppColors.hoverColor : AppColors.primaryColor,
                                         borderRadius: BorderRadius.circular(6)
                                     ),

                                     padding:const EdgeInsets.symmetric(vertical: 10),
                                   alignment: Alignment.center,
                                     child:const Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.containerBorder,fontSize: AppConstants.defaultFontSize),)),
                               )),
                             ),
                            ],
                          ),
                        ),
                        const Divider(color: AppColors.containerBorder,),

                        // SignInButton(
                        //   Buttons.google,
                        //   text: "Sign in with Google",
                        //   onPressed: () {
                        //     _loginUserWithGoogle(context);
                        //   },
                        // ),
                        // if (Platform.isIOS)
                        // SignInButton(
                        //   Buttons.apple,
                        //   text: "Sign in with App",
                        //   onPressed: () {
                        //     _loginUserWithApple(context);
                        //   },
                        // ),

                        Visibility(
                          visible: !_isLogin,
                          child: Container(
                              margin:const EdgeInsets.only(top: 10),
                              child: userName(_usernameController)),
                        ),

                        Container(
                            margin:const EdgeInsets.only(top: 10),
                            child: EmailField(_emailController)),
                        if(!isTimeZoneLoading)
                        Visibility(
                          visible: !_isLogin,
                          child: Container(
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
                                    // ignore: avoid_print
                                    print("Value Selected");
                                    setState(() {
                                      _timezone = _valueDropDownController.dropDownValue!.value.toString();
                                      // ignore: avoid_print
                                      print(_timezone);
                                    });
                                  },
                                ),
                              )

                          )

                          // SearchableDropdownField(_valueDropDownController,
                          //   _availableTimezones,
                          //       (val) {
                          //     print("Value Selected");
                          //     setState(() {
                          //       _timezone = _valueDropDownController.dropDownValue!.value.toString();
                          //       print(_valueDropDownController.dropDownValue!.value.toString());
                          //     });
                          //   },),
                        ),

                        Container(
                            margin:const EdgeInsets.only(top: 10,bottom: 10),
                            child: passwordField(_passwordController,"Enter your password")),

                          GestureDetector(
                            onTap: () {
                              if(_isLogin) {
                                _loginUser(_emailController.text, _passwordController.text,deviceToken);
                              } else {
                                _registerUser(_usernameController.text,_emailController.text,_passwordController.text);
                              }
                            },
                            child: OptionMcqAnswer(
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              margin:const EdgeInsets.only(top: 5,bottom: 5),
                              child:
                                 const Text("Submit",style: TextStyle(fontSize: AppConstants.defaultFontSize),)
                            ),
                        ),
                          ),

                        GestureDetector(
                          onTap: (){
                            forgotPassword();
                          },
                          child:const Center(
                            child: Text("Forgot Password?",style: TextStyle(color: Colors.blue,fontSize: AppConstants.defaultFontSize),),
                          ),
                        ),

                        // Text("Email: ${responseAppleEmail.toString()}"),
                        // Text("Name: ${responseAppleName.toString()}"),
                        // Text("Identity Token: ${responseAppleIdentityToken.toString()}"),

                      ],
                    ),
                  ),
                  Align(alignment: Alignment.center,
                    child: isLoading ? const CircularProgressIndicator(): Container(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _loginUserWithApple(BuildContext context) async {
  //   setState(() {
  //     isLoading = false;
  //   });
  //
  //
  //
  //   if(!await TheAppleSignIn.isAvailable()) {
  //     showToast(
  //         "Apple sign in not supported on this device", shapeBorder: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.0)
  //     ),
  //         context: context,
  //         fullWidth: true,
  //         isHideKeyboard: true,
  //         alignment: Alignment.topCenter,
  //         duration: Duration(seconds: 3),
  //         backgroundColor: Colors.red
  //     );
  //   }
  //
  //   final res = await TheAppleSignIn.performRequests([
  //     AppleIdRequest(requestedScopes: [
  //       Scope.email,Scope.fullName])
  //   ]);
  //
  //   switch (res.status) {
  //     case AuthorizationStatus.authorized:
  //       setState(() {
  //         responseAppleEmail = res.credential!.email.toString();
  //         responseAppleName = res.credential!.fullName!.givenName.toString();
  //         responseAppleIdentityToken = res.credential!.user.toString();
  //       });
  //       // HTTPManager().registerUserWithGoogle(SocialRegisterRequestModel(email: res.credential!.email,name: res.credential!.fullName!.familyName,authId: res.credential!.identityToken.toString())).then((value) async {
  //       //   print("APPLE ID RESPONSE");
  //       //   print(value);
  //       //   SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  //       //   // if(value['user_login'] == "TRUE") {
  //       //   setState(() {
  //       //     //  loginResponseModel = value;
  //       //     _emailController.text=="";
  //       //     _passwordController.text=="";
  //       //     _sharedPreferences.setBool("user_logged_in", value['user_session']['user_logged_in']);
  //       //     _sharedPreferences.setString("usertype", value['user_session']['usertype']);
  //       //     _sharedPreferences.setString("username", value['user_session']['username']);
  //       //     _sharedPreferences.setString("useremail", value['user_session']['useremail']);
  //       //     _sharedPreferences.setString("userid", value['user_session']['userid']);
  //       //     _sharedPreferences.setString("authId", value['user_session']['authID']);
  //       //
  //       //     isLoading = false;
  //       //
  //       //   });
  //       //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Screen3()));
  //       //   showToast(
  //       //       "Logged in successfully", shapeBorder: RoundedRectangleBorder(
  //       //       borderRadius: BorderRadius.circular(10.0)
  //       //   ),
  //       //       context: context,
  //       //       fullWidth: true,
  //       //       isHideKeyboard: true,
  //       //       alignment: Alignment.topCenter,
  //       //       duration: Duration(seconds: 3),
  //       //       backgroundColor: Colors.green
  //       //   );
  //       //
  //       // }).catchError((e){
  //       //   setState(() {
  //       //     isLoading = false;
  //       //   });
  //       //   //  print(e.toString());
  //       //   showToast(
  //       //       e.toString(), shapeBorder: RoundedRectangleBorder(
  //       //       borderRadius: BorderRadius.circular(10.0)
  //       //   ),
  //       //       context: context,
  //       //       fullWidth: true,
  //       //       isHideKeyboard: true,
  //       //       alignment: Alignment.topCenter,
  //       //       duration: Duration(seconds: 3),
  //       //       backgroundColor: Colors.red
  //       //   );
  //       // });
  //
  //       print(res.credential!.email);
  //       break;
  //
  //     case AuthorizationStatus.error:
  //       showToast(
  //           "Some thing went wrong", shapeBorder: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0)
  //       ),
  //           context: context,
  //           fullWidth: true,
  //           isHideKeyboard: true,
  //           alignment: Alignment.topCenter,
  //           duration: Duration(seconds: 3),
  //           backgroundColor: Colors.red
  //       );
  //       break;
  //     case AuthorizationStatus.cancelled:
  //       showToast(
  //           "User Canceled Apple login", shapeBorder: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0)
  //       ),
  //           context: context,
  //           fullWidth: true,
  //           isHideKeyboard: true,
  //           alignment: Alignment.topCenter,
  //           duration: Duration(seconds: 3),
  //           backgroundColor: Colors.red
  //       );
  //       break;
  //   }
  //
  //   // final AuthorizationResult result = await TheAppleSignIn.performRequests([
  //   //   AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //   // ]);
  //
  //   // switch (result.status) {
  //   //   case AuthorizationStatus.authorized:
  //   //     print("Apple Signin Result");
  //   //     print(result.credential!.email);
  //   //     print(result.credential!.user);
  //   //     print(result.credential!.fullName);
  //   //     print(result.credential!.identityToken);
  //   //     print(result.credential!.authorizationCode);
  //   //
  //   //     HTTPManager().registerUserWithGoogle(SocialRegisterRequestModel(email: result.credential!.email,name: result.credential!.fullName!.familyName,authId: result.credential!.identityToken.toString())).then((value) async {
  //   //       print("SocialLoginResponse");
  //   //       print(value);
  //   //       SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  //   //       // if(value['user_login'] == "TRUE") {
  //   //       setState(() {
  //   //         //  loginResponseModel = value;
  //   //         _emailController.text=="";
  //   //         _passwordController.text=="";
  //   //         _sharedPreferences.setBool("user_logged_in", value['user_session']['user_logged_in']);
  //   //         _sharedPreferences.setString("usertype", value['user_session']['usertype']);
  //   //         _sharedPreferences.setString("username", value['user_session']['username']);
  //   //         _sharedPreferences.setString("useremail", value['user_session']['useremail']);
  //   //         _sharedPreferences.setString("userid", value['user_session']['userid']);
  //   //         _sharedPreferences.setString("authId", value['user_session']['authID']);
  //   //
  //   //         isLoading = false;
  //   //
  //   //       });
  //   //       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Screen3()));
  //   //       showToast(
  //   //           "Logged in successfully", shapeBorder: RoundedRectangleBorder(
  //   //           borderRadius: BorderRadius.circular(10.0)
  //   //       ),
  //   //           context: context,
  //   //           fullWidth: true,
  //   //           isHideKeyboard: true,
  //   //           alignment: Alignment.topCenter,
  //   //           duration: Duration(seconds: 3),
  //   //           backgroundColor: Colors.green
  //   //       );
  //   //       // } else {
  //   //       //
  //   //       //   showToast(
  //   //       //       "Login failed", shapeBorder: RoundedRectangleBorder(
  //   //       //       borderRadius: BorderRadius.circular(10.0)
  //   //       //   ),
  //   //       //       context: context,
  //   //       //       fullWidth: true,
  //   //       //       isHideKeyboard: true,
  //   //       //       alignment: Alignment.topCenter,
  //   //       //       duration: Duration(seconds: 3),
  //   //       //       backgroundColor: Colors.red
  //   //       //   );
  //   //       //
  //   //       // }
  //   //
  //   //     }).catchError((e){
  //   //       setState(() {
  //   //         isLoading = false;
  //   //       });
  //   //       //  print(e.toString());
  //   //       showToast(
  //   //           e.toString(), shapeBorder: RoundedRectangleBorder(
  //   //           borderRadius: BorderRadius.circular(10.0)
  //   //       ),
  //   //           context: context,
  //   //           fullWidth: true,
  //   //           isHideKeyboard: true,
  //   //           alignment: Alignment.topCenter,
  //   //           duration: Duration(seconds: 3),
  //   //           backgroundColor: Colors.red
  //   //       );
  //   //     });
  //   //
  //   //     break;
  //   //   case AuthorizationStatus.error:
  //   //     print("Sign in failed: ${result.error?.localizedDescription}");
  //   //     setState(() {
  //   //       errorMessage = "Sign in failed";
  //   //     });
  //   //     break;
  //   //
  //   //   case AuthorizationStatus.cancelled:
  //   //     print('User cancelled');
  //   //     break;
  //   // }
  //
  //
  // }


  Future<void> _loginUserWithGoogle(BuildContext context) async {
    setState(() {
      isLoading = false;
    });
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    // ignore: avoid_print
    print("GoogleDetails");
    // ignore: avoid_print
    print(googleSignInAccount!.email);
    // ignore: avoid_print
    print(googleSignInAccount.displayName);
    // ignore: avoid_print
    print(googleSignInAccount.id);
    // ignore: avoid_print
    print(googleSignInAccount.photoUrl);
    // ignore: avoid_print
    print(googleSignInAccount.authentication);
    // ignore: avoid_print
    print(googleSignInAccount.authHeaders);


    HTTPManager().registerUserWithGoogle(SocialRegisterRequestModel(email: googleSignInAccount.email,name: googleSignInAccount.displayName,authId: googleSignInAccount.id,token: deviceToken,timeZone: _timezone)).then((value) async {
      // ignore: avoid_print
      print("SocialLoginResponse");
      // ignore: avoid_print
      print(value);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      // if(value['user_login'] == "TRUE") {
        setState(() {
          //  loginResponseModel = value;
          _emailController.text=="";
          _passwordController.text=="";
          googleSignIn.signOut();
          UserStatePrefrence().setAnswerText( value['user_session']['user_logged_in'],
              value['user_session']['usertype'].toString(),
              value['user_session']['username'].toString(),
              value['user_session']['useremail'].toString(),
              value['user_session']['userid'].toString(),
              value['user_session']['timezone'].toString(),
              value['user_session']['allowemail'].toString(),);
          sharedPreferences.setString("authId", value['user_session']['authID']);

          isLoading = false;

        });
      // ignore: use_build_context_synchronously
      showToastMessage(context, "Logged in successfully",true);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));


    }).catchError((e){
      setState(() {
        isLoading = false;
      });
      showToastMessage(context, e.toString(),false);
      //  print(e.toString());
    });


    // if result not null we simply call the MaterialpageRoute,
    // for go to the HomePage screen
  }

  void _loginUser( String email, String password, String deviceToken) {

    if(_formKey.currentState!.validate()) {

      setState(() {
        isLoading = true;
      });

      HTTPManager().loginUser(LoginRequestModel(email: email,password: password,token: deviceToken)).then((value) async {
        // ignore: avoid_print
        print("LoginResponse");
        // ignore: avoid_print
        print(value);
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

          setState(() {
          //  loginResponseModel = value;
            _emailController.text=="";
            _passwordController.text=="";

            UserStatePrefrence().setAnswerText(
                value['user_session']['user_logged_in'],
                value['user_session']['usertype'].toString(),
                value['user_session']['username'].toString(),
                value['user_session']['useremail'].toString(),
                value['user_session']['userid'].toString(),
                value['user_session']['timezone'].toString(),
                value['user_session']['allowemail'].toString(),
            );

            isLoading = false;
          });

        // ignore: use_build_context_synchronously
        showToastMessage(context, "Logged in successfully",true);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const TreeScreen()));

      }).catchError((e){
      //  print(e.toString());
        setState(() {
          isLoading = false;
        });
        showToastMessage(context, e.toString(),false);

      });
    }
  }

  void _registerUser(String userName, String email, String password) {

    if(_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      HTTPManager().registerUser(RegisterRequestModel(name: userName,email: email,password: password,timeZone: _timezone,token: deviceToken)).then((value) {
        // ignore: avoid_print
        print("SuccessRegister");
        // ignore: avoid_print
        print(value);
        setState(() {
          _usernameController.text == "";
          _emailController.text == "";
          _passwordController.text == "";
          _isLogin = true;
          isLoading = false;
        });

        showToastMessage(context, "user registered successfully",true);

      }).catchError((e){
        setState(() {
          isLoading = false;
        });
        showToastMessage(context, e.toString(),false);
      });

    }
  }

  void forgotPassword() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ForgotPasswordScreen()));
  }
}
