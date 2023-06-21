import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

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
