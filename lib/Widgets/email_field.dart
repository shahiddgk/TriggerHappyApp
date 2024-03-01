
// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, must_be_immutable

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';

import 'constants.dart';

class EmailField extends StatefulWidget {
  EmailField(this._textEditingController,this.hintText,{Key? key}) : super(key: key);

  TextEditingController _textEditingController;
  String hintText;

  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: AppConstants.defaultFontSize),
        controller: widget._textEditingController,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            focusColor:  AppColors.primaryColor,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.primaryColor
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColors.primaryColor
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            prefixIcon: const Icon(Icons.email,color: AppColors.primaryColor,),
            hintStyle: TextStyle(color: Colors.grey[800]),
            hintText: widget.hintText,
            fillColor: AppColors.hoverColor),
        validator: (email)=> EmailValidator.validate(email!.trim()) ? null :"Please enter a valid email"
    );
  }
}