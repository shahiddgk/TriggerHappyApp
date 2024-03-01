import 'package:flutter/material.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/option_mcq_widget.dart';

class ErrorTextAndButtonWidget extends StatelessWidget {
  const ErrorTextAndButtonWidget({required this.errorText,required this.onTap,Key? key}) : super(key: key);
   final String errorText;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(errorText,style: const TextStyle(color: AppColors.redColor),),
        InkWell(
          onTap: () {
            onTap();
          },
          child:OptionMcqAnswer( const Text("Reload",style:  TextStyle(color: AppColors.redColor),)),
        )
      ],
    );
  }
}
