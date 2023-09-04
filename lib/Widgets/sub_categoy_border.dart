
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'colors.dart';

// ignore: must_be_immutable
class OptionMcqAnswerSubCategory extends StatefulWidget {
  OptionMcqAnswerSubCategory(this.RadioListTile,{Key? key}) : super(key: key);
  Widget RadioListTile;

  @override
  State<OptionMcqAnswerSubCategory> createState() => _OptionMcqAnswerSubCategoryState();
}

class _OptionMcqAnswerSubCategoryState extends State<OptionMcqAnswerSubCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 7,),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor,width: 5),
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
