import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';

class PireNaqDetailsWidget extends StatelessWidget {
  const PireNaqDetailsWidget({required this.listIndex,required this.questionText,required this.answerText,required this.optionText,Key? key}) : super(key: key);

 final int listIndex;
 final String questionText;
 final String optionText;
 final String answerText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(" Question ${listIndex + 1} : "),
            Expanded(
              child: Html(data: questionText.replaceAll("Q${listIndex + 1}:", ""),style: {
                "#" : Style(
                  color: AppColors.textWhiteColor,
                  fontSize: FontSize(AppConstants.defaultFontSize),
                  textAlign: TextAlign.start,

                ),
              },),
            ),
          ],
        ),
        if(optionText!="")
          Row(
            children: [
              const Text(" Answer: ",style:  TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
              Expanded(
                child: Html(data: optionText.capitalize().replaceAll("Never", "1 - Never").replaceAll("Rarely", "2 - Rarely").replaceAll("Often", "3 - Often").replaceAll("Always", "4 - Always"),style: {
                  "#" : Style(
                    color: AppColors.textWhiteColor,
                    fontSize: FontSize(AppConstants.defaultFontSize),
                    textAlign: TextAlign.start,

                  ),
                },),
              ),
            ],),
        if(answerText!="")
          Row(
            children: [
              const Text(" Answer: ",style:  TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
              // Text(sharedItemDetailsResponse.data![index]..type == "naq" && newGardenHistoryResponseDetailsModel.data![index].options! == "yes" ? "  Why Yes:" : "   Answer: ",style:  const TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
              Expanded(
                child: Html(data: answerText,style: {
                  "#" : Style(
                    color: AppColors.textWhiteColor,
                    fontSize: FontSize(AppConstants.defaultFontSize),
                    textAlign: TextAlign.start,

                  ),
                },),
              ),
            ],),
        const Divider(color: AppColors.primaryColor,height: 2,)
      ],
    );
  }
}
