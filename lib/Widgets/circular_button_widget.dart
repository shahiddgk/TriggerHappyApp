// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';

class CircularButton extends StatefulWidget {
  CircularButton(this._title,this._onPressed,{Key? key}) : super(key: key);

  String _title;
  Function _onPressed;

  @override
  _CircularButtonState createState() => _CircularButtonState();
}

class _CircularButtonState extends State<CircularButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(

          onPressed: (){
            widget._onPressed();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(const Color(
                0xFFFFFFFF)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: const BorderSide(color: Color(
                        0xFF3e396f),width: 1)
                )
            )
        ),
          child: Text(widget._title,style: const TextStyle(color: AppColors.backgroundColor),),),
      ),
    );
  }
}