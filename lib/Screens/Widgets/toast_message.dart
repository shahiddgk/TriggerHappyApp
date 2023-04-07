
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

showToastMessage(BuildContext context,String message, bool isSuccess) {
  return showToast(
      message, shapeBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0)
  ),
      context: context,
      fullWidth: true,
      isHideKeyboard: true,
      alignment: Alignment.topCenter,
      duration:const Duration(seconds: 4),
      backgroundColor: isSuccess ? Colors.green  : Colors.red
  );
}