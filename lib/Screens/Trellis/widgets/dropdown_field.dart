// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';

class DropDownField extends StatefulWidget {
  DropDownField(this.initialValue,this.items,this.onValueChange,{Key? key}) : super(key: key);

  String initialValue;
  final Function(String value) onValueChange;
  final List<DropdownMenuItem<String>> items;

  @override
  // ignore: library_private_types_in_public_api
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.lightGreyColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<String>(
              //dropdownColor: widget.isColor?Colors.lightBlueAccent:Colors.white,
              // validator: (value) {
              //   if (value == null || value.length == 0) {
              //     return 'Please select one options';
              //   }
              // },
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                enabled: false,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: AppColors.backgroundColor,
                hoverColor: AppColors.backgroundColor
              ),
              value: widget.initialValue,
              iconSize: 30,
              icon: (null),
              style:const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
              onChanged: (String? newValue) =>
                  widget.onValueChange(newValue!),
              items: widget.items,
            ),
          ),
        ),
    );
  }
}
