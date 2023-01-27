import 'package:flutter/material.dart';

import 'colors.dart';

class userName extends StatefulWidget {
  userName(this._usernameController,{Key? key}) : super(key: key);
  TextEditingController _usernameController;
  @override
  _userNameState createState() => _userNameState();
}

class _userNameState extends State<userName> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._usernameController,
      validator: (value) => value!.isEmpty ? "User name required" : null,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          focusColor:  Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),

          ),
          filled: true,
          prefixIcon: const Icon(Icons.person),
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: "Type your User name",
          fillColor: AppColors.hoverColor),
    );
  }
}
