
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_3.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/circular_button_widget.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/email_field.dart';
import 'package:flutter_quiz_app/Widgets/username_field_widget.dart';

import '../../Widgets/password_field_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title:const Text("Register"),centerTitle: true,),
      body: Container(
        color: AppColors.backgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 60),
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
                    child: EmailField(_emailController,"Type your email")),

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
      showToastMessage(context, "User registered successfully",true);

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Screen3()));
    }
  }
}
