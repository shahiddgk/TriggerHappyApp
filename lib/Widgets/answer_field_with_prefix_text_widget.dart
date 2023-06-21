// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';

class AnswerFiedlWithPrefixText extends StatefulWidget {
  AnswerFiedlWithPrefixText(this._fieldController,this.prefixText,{Key? key}) : super(key: key);
  TextEditingController _fieldController;
  String prefixText;
  @override
  _AnswerFiedlWithPrefixTextState createState() => _AnswerFiedlWithPrefixTextState();
}

class _AnswerFiedlWithPrefixTextState extends State<AnswerFiedlWithPrefixText> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //         padding: EdgeInsets.only(top: 5,left: 5),
          //       child: Text(widget.prefixText,style: TextStyle(color: AppColors.textWhiteColor),)),
          Padding(
            padding: const EdgeInsets.only(top: 5,),
            child: TextFormField(
                controller: widget._fieldController,
                validator: (value) {
                  if(value!.isEmpty) {
                    return "Enter your answer";
                  } else if(value.length>280) {
                    return "Characters cannot be more than 280";
                  } else {
                    return null;
                  }
                },
                maxLines: 5,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,

                    contentPadding: const EdgeInsets.only(left: 10,right:5,top: 10),
                    focusColor: AppColors.hoverColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    labelStyle: TextStyle(color: Colors.grey[800]),
                    label:  Text(widget.prefixText),
                    // prefixIcon: const Icon(Icons.person),
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "280 characters or less",
                    fillColor: AppColors.hoverColor),
              ),
          ),
        ],
    );
  }
}
