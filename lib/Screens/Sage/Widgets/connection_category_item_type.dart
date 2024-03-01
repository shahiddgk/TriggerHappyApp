// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';

import '../../../Widgets/constants.dart';

class ConnectionCategoryItemType extends StatefulWidget {
   ConnectionCategoryItemType(this.onTap,this.categoryName,this.isCategorySelected,{Key? key}) : super(key: key);

  Function onTap;
  String categoryName;
  bool isCategorySelected;

  @override
  State<ConnectionCategoryItemType> createState() => _ConnectionCategoryItemTypeState();
}

class _ConnectionCategoryItemTypeState extends State<ConnectionCategoryItemType> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        padding:const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
        decoration: BoxDecoration(
            color: widget.isCategorySelected ? AppColors.primaryColor : AppColors.hoverColor,
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Text(widget.categoryName,style: TextStyle(color:widget.isCategorySelected ? AppColors.hoverColor : AppColors.textWhiteColor ,fontSize: AppConstants.headingFontSize),),
      ),
    );
  }
}
