
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';

import '../../Payment/payment_screen.dart';
import 'PopMenuButton.dart';

class AppBarWidget{
  AppBar appBar(BuildContext context,bool isSummaryVisible,bool isSettingVisible,String name,String userId, bool isLeading) {
    return AppBar(
      automaticallyImplyLeading: isLeading,
      centerTitle: true,
      title: Text(name),
      actions:  [
        if(isSettingVisible)
         IconButton(onPressed: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> StripePayment(false)));
         }, icon:const Icon(Icons.workspace_premium,color: AppColors.totalQuestionColor,)),
        PopMenuButton(isSummaryVisible,isSettingVisible,userId)
      ],
    );
  }


}

