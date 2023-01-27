
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';

class EmailField extends StatefulWidget {
  EmailField(this._textEditingController,{Key? key}) : super(key: key);

  TextEditingController _textEditingController;

  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {

  late String _errorMessage;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget._textEditingController,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            focusColor:  Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            prefixIcon: const Icon(Icons.email),
            hintStyle: TextStyle(color: Colors.grey[800]),
            hintText: "Type your email",
            fillColor: AppColors.hoverColor),
        validator: (email)=> EmailValidator.validate(email!.trim()) ? null :"Please enter a valid email"
    );
  }
}