import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';

import 'constants.dart';

// ignore: must_be_immutable
class AnswerFieldWidget extends StatefulWidget {
   AnswerFieldWidget(this._fieldController,this.fieldMaxLength,{Key? key}) : super(key: key);

  TextEditingController _fieldController;
  int fieldMaxLength;

  @override
  _AnswerFieldWidgetState createState() => _AnswerFieldWidgetState();
}

class _AnswerFieldWidgetState extends State<AnswerFieldWidget> {
  String errorMessage = "";
  bool isValidated = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Visibility(
            visible: isValidated,
            child: Align(alignment: Alignment.centerRight,
            child: Text(errorMessage,style: TextStyle(color: AppColors.redColor,fontSize: 13),),
            ),
          ),
          SizedBox(height: 1,),
          TextFormField(
            controller: widget._fieldController,
            textInputAction: TextInputAction.done,
            style: TextStyle(fontSize: AppConstants.defaultFontSize),
            validator: (value) {
              if(value!.trim().isEmpty) {
                setState(() {
                  errorMessage = "write something here ";
                  isValidated = true;
                });
                return "";
              } else if(value.trim().length>widget.fieldMaxLength) {
                setState(() {
                  errorMessage = "Maximum ${widget.fieldMaxLength} characters allowed";
                  isValidated = true;
                });
                return "Maximum ${widget.fieldMaxLength} characters allowed";
              } else {
                setState(() {
                  errorMessage = "";
                  isValidated = false;
                });
                return null;
              }
            },
            maxLines: 7,
            maxLength: widget.fieldMaxLength,
            decoration: InputDecoration(
                disabledBorder:const OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: AppColors.primaryColor)
                ),
                errorBorder:const OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: AppColors.redColor)
                ),
                focusedBorder:const OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: AppColors.primaryColor)
                ),
                focusedErrorBorder:const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.redColor)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    width: 2,
                    color:  AppColors.primaryColor,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                focusColor: AppColors.primaryColor,
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
          ),
        ],
      )
    );
  }
}
