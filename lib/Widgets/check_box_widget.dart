import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';

class CheckBoxWidgetWithTitle extends StatefulWidget {
   CheckBoxWidgetWithTitle(this.onTap,this.answer,this.title,{Key? key}) : super(key: key);

  Function onTap;
  bool answer;
  String title;

  @override
  _CheckBoxWidgetWithTitleState createState() => _CheckBoxWidgetWithTitleState();
}

class _CheckBoxWidgetWithTitleState extends State<CheckBoxWidgetWithTitle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: OptionMcqAnswer((
          Row(
          children: [
            Expanded(
              flex: 1,
              child: Theme(
                data: ThemeData(
                    unselectedWidgetColor: AppColors.textWhiteColor
                ),
                child: Checkbox(
                  hoverColor: AppColors.primaryColor,
                  activeColor: AppColors.primaryColor,
                  checkColor: AppColors.backgroundColor,
                  value: widget.answer,
                  onChanged: (bool? value) {
                    widget.onTap();
                  },
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              flex: 2,
                child: Text(widget.title,style: TextStyle(color: AppColors.textWhiteColor))),
          ],
        )
      ),
     )
    );
  }
}
