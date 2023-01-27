
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/screen_3.dart';
import 'package:flutter_quiz_app/Screens/login_screen.dart';
import 'package:flutter_quiz_app/Widgets/circular_button_widget.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/email_field.dart';
import 'package:flutter_quiz_app/Widgets/username_field_widget.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../Widgets/password_field_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title:const Text("Register"),centerTitle: true,),
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
                userName(_usernameController),

                Container(
                    margin:const EdgeInsets.only(top: 10),
                    child: EmailField(_emailController)),

                Container(
                    margin:const EdgeInsets.only(top: 10),
                    child: passwordField(_passwordController,"Enter your password")),

                Container(
                  margin:const EdgeInsets.only(top: 5),
                  child: CircularButton("Submit", (){
                    _registerUser(_usernameController.text,_emailController.text,_passwordController.text);
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser(String userName, String email, String password) {
    if(_formKey.currentState!.validate()) {
      _usernameController.text == "";
      _emailController.text == "";
      _passwordController.text == "";
      showToast(
          "Registration successful", shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
          context: context,
          fullWidth: true,
          alignment: Alignment.topCenter,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Screen3()));
    }
  }
}
