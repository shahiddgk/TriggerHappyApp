// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';

class naqPrevNextButton extends StatefulWidget {
   naqPrevNextButton(this.onPrevTap,this.onNextTap,this.isPrevVisible,this.isNextVisible,{Key? key}) : super(key: key);

  Function onPrevTap;
  Function onNextTap;
  bool isPrevVisible;
   bool isNextVisible;

  @override
  State<naqPrevNextButton> createState() => _naqPrevNextButtonState();
}

class _naqPrevNextButtonState extends State<naqPrevNextButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 15,vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Visibility(
            visible: widget.isPrevVisible,
            child: ElevatedButton(
              onPressed: () {
               widget.onPrevTap();
              },
              child:const Text('Previous',style: TextStyle(color: AppColors.backgroundColor),),
            ),
          ),

          Visibility(
            visible: widget.isNextVisible,
            child: ElevatedButton(
              onPressed: () {
                widget.onNextTap();
              },
              child:const Text('Next',style: TextStyle(color: AppColors.backgroundColor),),
            ),
          ),

        ],
      ),
    );
  }
}
