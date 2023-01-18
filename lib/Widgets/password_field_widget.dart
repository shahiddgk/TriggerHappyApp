import 'package:flutter/material.dart';

import 'colors.dart';

class passwordField extends StatefulWidget {
  passwordField(this._passwordController,this.textHint,{Key? key}) : super(key: key);

  TextEditingController _passwordController;
  String textHint;

  @override
  _passwordFieldState createState() => _passwordFieldState();
}

class _passwordFieldState extends State<passwordField> {

  bool _isShowPassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._passwordController,
      obscureText: _isShowPassword,
      validator: (value) {
        if(value!.isEmpty) {
          return "Password field can't be empty";
        }else if (value.contains(" ")) {
          return "Spaces not allowd";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          focusColor:  Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          suffixIcon: IconButton(onPressed: (){

            setState(() {

              _isShowPassword = !_isShowPassword;

            });

          }, icon: const Icon(Icons.remove_red_eye)),
          prefixIcon: const Icon(Icons.password),
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: widget.textHint,
          fillColor: AppColors.hoverColor),
    );
  }
}