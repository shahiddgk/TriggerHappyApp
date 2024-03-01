
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/email_field.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/model/request_model/forgot_password_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';

import '../../Widgets/constants.dart';
import '../Widgets/toast_message.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 100),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LogoScreen(""),
                    const  SizedBox(
                      height: 30,
                    ),
                    Container(
                        margin:const EdgeInsets.only(top: 10),
                        child: EmailField(_emailController,"Type your email")),
                  const  SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _forgotPassword(_emailController.text);
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
                  ],
                ),
              ),
            ),
          ),
          Align(alignment: Alignment.center,
            child: isLoading ? const CircularProgressIndicator(): Container(),
          )
        ],
      ),
    );
  }

  void _forgotPassword(String email) {
    if(_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      HTTPManager().forgotPassword(ForgotPasswordRequestModel(email: email)).then((value) {

        setState(() {
          isLoading = false;
        });
        showToastMessage(context, value['message'],true);

        Navigator.of(context).pop();

      }).catchError((e){
        setState(() {
          isLoading = false;
        });
        showToastMessage(context, e.toString(),false);

      });
    }
  }
}
