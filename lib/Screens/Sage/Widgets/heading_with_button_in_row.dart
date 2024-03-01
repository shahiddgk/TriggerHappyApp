// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';

class HeadingWithButtonRow extends StatefulWidget {
   HeadingWithButtonRow(this.headingText,this.onTap,this.isButtonShow,this.onSearchTap,this.isSearchShow,{Key? key}) : super(key: key);

  String headingText;
  Function onTap;
   Function onSearchTap;
  bool isButtonShow;
  bool isSearchShow;


  @override
  State<HeadingWithButtonRow> createState() => _HeadingWithButtonRowState();
}

class _HeadingWithButtonRowState extends State<HeadingWithButtonRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.headingText,style: const TextStyle(fontSize: AppConstants.headingFontSize,fontWeight: FontWeight.bold),),
              Visibility(
                  visible: widget.isButtonShow,
                  child: InkWell(onTap: () {widget.onTap();}, child: const Text("See all",style: TextStyle(color: AppColors.primaryColor),))),
              if(widget.isSearchShow)
              InkWell(onTap: () {widget.onSearchTap();}, child: const Icon(Icons.search,color: AppColors.primaryColor,))
            ],
          ),
          const Divider(color: AppColors.primaryColor,),
          const SizedBox(height: 5,),
        ],
      ),
    );
  }
}
