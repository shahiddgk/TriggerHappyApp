import 'package:flutter/material.dart';

import 'PopMenuButton.dart';

class AppBarWidget{
  AppBar appBar(bool isSummaryVisible,bool isSettingVisible,String name,String userId, bool isLeading) {
    return AppBar(
      automaticallyImplyLeading: isLeading,
      centerTitle: true,
      title: Text(name),
      actions:  [
        PopMenuButton(isSummaryVisible,isSettingVisible,userId)
      ],
    );
  }


}

