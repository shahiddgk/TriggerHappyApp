import 'package:flutter/material.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';
import 'package:intl/intl.dart';

class ColumnDetailsWidget extends StatelessWidget {
  const ColumnDetailsWidget({required this.typeText,required this.titleText,required this.dateText,required this.noteText,required this.takeAwayText,Key? key}) : super(key: key);

  final String typeText;
  final String titleText;
  final String dateText;
  final String noteText;
  final String takeAwayText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Type: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
            Expanded(
              child: Container(
                  padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                  alignment: Alignment.topLeft,
                  child: Text(typeText,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
            ),

          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Title: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
            Expanded(
              child: Container(
                  padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                  alignment: Alignment.topLeft,
                  child: Text(titleText,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
            ),


          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Date: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
            Expanded(
              child: Container(
                  padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                  alignment: Alignment.topLeft,
                  child: Text(" ${DateFormat('MM-dd-yy').format(DateTime.parse(dateText))}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),)),
            ),

          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Note: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
            Expanded(
              child: Container(
                padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                alignment: Alignment.topLeft,
                child: Text(" $noteText",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),),
            ),

          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Take Away: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
            Expanded(
              child: Container(
                padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                alignment: Alignment.topLeft,
                child: Text(" $takeAwayText",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),),
            ),
          ],
        ),
      ],
    );
  }
}
