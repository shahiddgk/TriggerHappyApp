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
        margin: EdgeInsets.symmetric(vertical: 5,),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.PrimaryColor,width: 2),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor:AppColors.PrimaryColor,
            disabledColor: AppColors.PrimaryColor,
          ),
          child: widget.RadioListTile,
        )
    );
  }
}
