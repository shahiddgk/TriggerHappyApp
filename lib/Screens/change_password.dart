
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/login_screen.dart';
import 'package:flutter_quiz_app/Screens/screen_3.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/email_field.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/password_field_widget.dart';
import 'package:flutter_quiz_app/model/reponse_model/login_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/change_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/login_request.dart';
import 'package:flutter_quiz_app/model/request_model/register_create_request.dart';
import 'package:flutter_quiz_app/model/request_model/social_login_request_model.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../Widgets/username_field_widget.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool _isLogin = true;
  late LoginResponseModel loginResponseModel;
  bool _isUserDataLoading = false;
  String name = "";
  String id = "";
  String authId = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
    _getAuthId();
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
      name = _sharedPreferences.getString("username")!;
      id = _sharedPreferences.getString("userid")!;
      _isUserDataLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(!_isUserDataLoading? name : ""),
        actions: [
          // IconButton(onPressed: (){
          //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChangePassword())
          //       }, icon: Icon(Icons.person,color: AppColors.textWhiteColor,)),
          IconButton(onPressed: () async {
            SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
            //googleSignIn.disconnect();
            googleSignIn.signOut();
            setState(() {
              _sharedPreferences.setBool("user_logged_in",false);
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false
            );
          }, icon: Icon(Icons.logout,color: AppColors.textWhiteColor,))
        ],
      ),
      body: Container(
        color: AppColors.backgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 60),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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

                      Visibility(
                        visible: authId == "" ? true : false,
                        child: Container(
                            margin:const EdgeInsets.only(top: 10,bottom: 10),
                            child: passwordField(_currentPasswordController,"Enter your old password")),
                      ),

                      Container(
                          margin:const EdgeInsets.only(top: 10,bottom: 10),
                          child: passwordField(_newPasswordController,"Enter your new password")),

                      GestureDetector(
                        onTap: () {
                          _changePassword(_currentPasswordController.text,_newPasswordController.text,);
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

                      GestureDetector(
                        onTap: () {
                          showAlertDialog(context);
                        },
                        child: OptionMcqAnswer(
                          Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              margin:const EdgeInsets.only(top: 5,bottom: 5),
                              child:
                              const Text("Delete Account",style: TextStyle(fontSize: 15),)
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
      ),
    );
  }

  Future<void> _changePassword(String currentPass,String newPass) async {

    print("ChangePassword");
    print(currentPass);
    print(newPass);
    print(authId);

    if(_formKey.currentState!.validate()) {
      HTTPManager().changePassword(
          ChangePasswordRequestModel(currentPassword:authId=="" || authId == null ? currentPass : "",newPassword: newPass, userId: id,authId: authId)).then((
          value) async {
        print("ChangePasswordResponse");
        print(value);
        SharedPreferences _sharedPreferences = await SharedPreferences
            .getInstance();
        // if(value['user_login'] == "TRUE") {
        setState(() {
          //  loginResponseModel = value;
          _currentPasswordController.text == "";
          _newPasswordController.text == "";
        });
        Navigator.of(context).pop();
        showToast(
            "Password Changed successfully",
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            context: context,
            fullWidth: true,
            isHideKeyboard: true,
            alignment: Alignment.topCenter,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green
        );
      }).catchError((e) {
        //  print(e.toString());
        showToast(
            "Some thing went wrong", shapeBorder: RoundedRectangleBorder(
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
    // if result not null we simply call the MaterialpageRoute,
    // for go to the HomePage screen
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
      showToast(
          "Account deleted successfully", shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
          context: context,
          fullWidth: true,
          isHideKeyboard: true,
          alignment: Alignment.topCenter,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red
      );

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      //googleSignIn.disconnect();
      googleSignIn.signOut();
      setState(() {
        sharedPreferences.setBool("user_logged_in",false);
      });
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
              (Route<dynamic> route) => false
      );

    }).catchError((e) {
      print(e.toString());
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
