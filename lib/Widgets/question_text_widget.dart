import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';

import 'colors.dart';

// ignore: must_be_immutable
class QuestionTextWidget extends StatefulWidget {
   QuestionTextWidget(this.questionText,{Key? key}) : super(key: key);

  String? questionText;

  @override
  _QuestionTextWidgetState createState() => _QuestionTextWidgetState();
}

class _QuestionTextWidgetState extends State<QuestionTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
      child: Html(data: widget.questionText!,style: {
        "#" : Style(
          color: AppColors.textWhiteColor,
          fontSize: FontSize(18),
          textAlign: TextAlign.start
        ),
      },),
    );
  }
}
