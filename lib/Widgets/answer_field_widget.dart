import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';

// ignore: must_be_immutable
class AnswerFieldWidget extends StatefulWidget {
   AnswerFieldWidget(this._fieldController,this.fieldMaxLength,{Key? key}) : super(key: key);

  TextEditingController _fieldController;
  int fieldMaxLength;

  @override
  _AnswerFieldWidgetState createState() => _AnswerFieldWidgetState();
}

class _AnswerFieldWidgetState extends State<AnswerFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return OptionMcqAnswer(
        TextFormField(
        controller: widget._fieldController,
          textInputAction: TextInputAction.done,
        validator: (value) {
          if(value!.isEmpty) {
            return "write something here";
          } else if(value.length>widget.fieldMaxLength) {
            return "Maximum ${widget.fieldMaxLength} characters allowed";
          } else {
            return null;
          }
        },
          maxLines: 7,
        decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            focusColor: AppColors.hoverColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            // prefixIcon: const Icon(Icons.person),
            hintStyle: TextStyle(color: Colors.grey[800]),
            hintText: "${widget.fieldMaxLength} characters or less",
            fillColor: AppColors.hoverColor),
    ));
  }
}
