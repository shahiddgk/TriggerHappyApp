
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/screen_3.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/email_field.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/password_field_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/login_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/login_request.dart';
import 'package:flutter_quiz_app/model/request_model/register_create_request.dart';
import 'package:flutter_quiz_app/model/request_model/social_login_request_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../Widgets/username_field_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;
  bool isLoading = false;
  late LoginResponseModel loginResponseModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("LogIn"),centerTitle: true,),
      body: Container(
        color: AppColors.backgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 60),
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
                  LogoScreen(),

                  Container(
                    margin: EdgeInsets.only(top: 10),
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
                               child: GestureDetector(
                                 onTap: (){
                                   setState(() {
                                     _isLogin = true;
                                   });
                                 },
                                 child: Container(
                                   padding: EdgeInsets.symmetric(vertical: 5),
                                   alignment: Alignment.center,
                                     child: Text("Sign in",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.containerBorder),)),
                               ),
                             ),
                             Expanded(
                               child: GestureDetector(
                                 onTap: (){
                                   setState(() {
                                     _isLogin = false;
                                   });
                                 },
                                 child: Container(
                                     padding: EdgeInsets.symmetric(vertical: 5),
                                   alignment: Alignment.center,
                                     child: Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.containerBorder),)),
                               ),
                             ),
                            ],
                          ),
                        ),
                        Divider(color: AppColors.containerBorder,),

                        SignInButton(
                          Buttons.google,
                          text: "Sign in with Google",
                          onPressed: () {
                            _loginUserWithGoogle(context);
                          },
                        ),
                        if (Platform.isIOS)
                        SignInButton(
                          Buttons.apple,
                          text: "Sign in with App",
                          onPressed: () {
                            _loginUserWithApple(context);
                          },
                        ),

                        Visibility(
                          visible: !_isLogin,
                          child: Container(
                              margin:const EdgeInsets.only(top: 10),
                              child: userName(_usernameController)),
                        ),

                        Container(
                            margin:const EdgeInsets.only(top: 10),
                            child: EmailField(_emailController)),

                        Container(
                            margin:const EdgeInsets.only(top: 10,bottom: 10),
                            child: passwordField(_passwordController,"Enter your password")),

                          GestureDetector(
                            onTap: () {
                              if(_isLogin) {
                                _loginUser(_emailController.text, _passwordController.text);
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
                                 const Text("Submit",style: TextStyle(fontSize: 15),)
                            ),
                        ),
                          ),

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

  Future<void> _loginUserWithApple(BuildContext context) async {
    setState(() {
      isLoading = false;
    });
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print("Apple Sign in failed");
    print(credential);


  }

  Future<void> _loginUserWithGoogle(BuildContext context) async {
    setState(() {
      isLoading = false;
    });
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    print("GoogleDetails");
    print(googleSignInAccount!.email);
    print(googleSignInAccount.displayName);
    print(googleSignInAccount.id);
    print(googleSignInAccount.photoUrl);
    print(googleSignInAccount.authentication);
    print(googleSignInAccount.authHeaders);


    HTTPManager().registerUserWithGoogle(SocialRegisterRequestModel(email: googleSignInAccount.email,name: googleSignInAccount.displayName,authId: googleSignInAccount.id)).then((value) async {
      print("SocialLoginResponse");
      print(value);
      SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
      // if(value['user_login'] == "TRUE") {
        setState(() {
          //  loginResponseModel = value;
          _emailController.text=="";
          _passwordController.text=="";
          googleSignIn.signOut();
          _sharedPreferences.setBool("user_logged_in", value['user_session']['user_logged_in']);
          _sharedPreferences.setString("usertype", value['user_session']['usertype']);
          _sharedPreferences.setString("username", value['user_session']['username']);
          _sharedPreferences.setString("useremail", value['user_session']['useremail']);
          _sharedPreferences.setString("userid", value['user_session']['userid']);
          _sharedPreferences.setString("authId", value['user_session']['authID']);

          isLoading = false;

        });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Screen3()));
        showToast(
            "Logged in successfully", shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
            context: context,
            fullWidth: true,
            isHideKeyboard: true,
            alignment: Alignment.topCenter,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green
        );
      // } else {
      //
      //   showToast(
      //       "Login failed", shapeBorder: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10.0)
      //   ),
      //       context: context,
      //       fullWidth: true,
      //       isHideKeyboard: true,
      //       alignment: Alignment.topCenter,
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red
      //   );
      //
      // }

    }).catchError((e){
      setState(() {
        isLoading = false;
      });
      //  print(e.toString());
      showToast(
          e.toString(), shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
          context: context,
          fullWidth: true,
          isHideKeyboard: true,
          alignment: Alignment.topCenter,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red
      );
    });


    // if result not null we simply call the MaterialpageRoute,
    // for go to the HomePage screen
  }

  void _loginUser( String email, String password) {

    if(_formKey.currentState!.validate()) {

      setState(() {
        isLoading = true;
      });

      HTTPManager().loginUser(LoginRequestModel(email: email,password: password,rememberme: "on")).then((value) async {
        print("LoginResponse");
        print(value);
        SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
      //  if(value['user_login'] == "TRUE") {
          setState(() {
          //  loginResponseModel = value;
            _emailController.text=="";
            _passwordController.text=="";

            _sharedPreferences.setBool("user_logged_in", value['user_session']['user_logged_in']);
            _sharedPreferences.setString("usertype", value['user_session']['usertype'].toString());
            _sharedPreferences.setString("username", value['user_session']['username'].toString());
            _sharedPreferences.setString("useremail", value['user_session']['useremail'].toString());
            _sharedPreferences.setString("userid", value['user_session']['userid'].toString());
            isLoading = false;
          });
          showToast(
              "Logged in successfully", shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
              context: context,
              fullWidth: true,
              isHideKeyboard: true,
              alignment: Alignment.topCenter,
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green
          );
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Screen3()));
        // } else {
        //   setState(() {
        //     isLoading = false;
        //   });
        //
        //   showToast(
        //       "Login failed", shapeBorder: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10.0)
        //   ),
        //       context: context,
        //       fullWidth: true,
        //       isHideKeyboard: true,
        //       alignment: Alignment.topCenter,
        //       duration: Duration(seconds: 3),
        //       backgroundColor: Colors.red
        //   );
        //
        // }

      }).catchError((e){
      //  print(e.toString());
        setState(() {
          isLoading = false;
        });
        showToast(
            e.toString(), shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
            context: context,
            fullWidth: true,
            isHideKeyboard: true,
            alignment: Alignment.topCenter,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red
        );
      });
    }
  }

  void _registerUser(String userName, String email, String password) {

    if(_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      HTTPManager().registerUser(RegisterRequestModel(name: userName,email: email,password: password)).then((value) {
        print("SuccessRegister");
        print(value);
        setState(() {
          _usernameController.text == "";
          _emailController.text == "";
          _passwordController.text == "";
          _isLogin = true;
          isLoading = false;
        });
    //    if(value['user_signup'] == "TRUE") {
          showToast(
              "Registration successful", shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
              context: context,
              fullWidth: true,
              isHideKeyboard: true,
              alignment: Alignment.topCenter,
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green
          );
        // } else {
        //   setState(() {
        //     isLoading = false;
        //   });
        //   showToast(
        //       value.toString(), shapeBorder: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10.0)
        //   ),
        //       context: context,
        //       fullWidth: true,
        //       isHideKeyboard: true,
        //       alignment: Alignment.topCenter,
        //       duration: Duration(seconds: 3),
        //       backgroundColor: Colors.red
        //   );
        // }
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Screen3()));

      }).catchError((e){
        setState(() {
          isLoading = false;
        });
        showToast(
            e.toString(), shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
            context: context,
            fullWidth: true,
            isHideKeyboard: true,
            alignment: Alignment.topCenter,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red
        );
      });

    }
  }
}
