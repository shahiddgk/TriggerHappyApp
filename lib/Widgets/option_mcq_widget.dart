// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';

class OptionMcqAnswer extends StatefulWidget {
   OptionMcqAnswer(this.RadioListTile,{Key? key}) : super(key: key);
  Widget RadioListTile;

  @override
  _OptionMcqAnswerState createState() => _OptionMcqAnswerState();
}

class _OptionMcqAnswerState extends State<OptionMcqAnswer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 7,),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor,width: 2),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor:AppColors.primaryColor,
            disabledColor: AppColors.primaryColor,
          ),
          child: widget.RadioListTile,
        )
    );
  }
}

