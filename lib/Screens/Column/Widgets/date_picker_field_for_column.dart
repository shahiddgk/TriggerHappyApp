// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../Widgets/constants.dart';

class DatePickerFieldForColumn extends StatefulWidget {
  DatePickerFieldForColumn(this.controller,this.hint,this.isNewDateAvailable,{Key? key}) : super(key: key);
  String hint;
  TextEditingController controller;
  bool isNewDateAvailable;

  @override
  _DatePickerFieldForColumnState createState() => _DatePickerFieldForColumnState();
}

class _DatePickerFieldForColumnState extends State<DatePickerFieldForColumn> {
  String errorMessage = "" ;
  bool isValidated = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: isValidated,
          child: Align(alignment: Alignment.centerRight,
            child: Text(errorMessage,style: const TextStyle(color: AppColors.redColor,fontSize: 13),),
          ),
        ),
        const SizedBox(height: 1,),
        TextFormField(
          textAlignVertical: TextAlignVertical.center,
          onTap: () => _selectDate(context,widget.isNewDateAvailable),
          readOnly: true,
          style: const TextStyle(fontSize: AppConstants.defaultFontSize),
          controller: widget.controller,
          keyboardType: TextInputType.text,
          validator: (value) {
            if(value!.trim().isEmpty) {
              setState(() {
                errorMessage = "Select any date";
                isValidated = true;
              });
              return "";
            } else {
              setState(() {
                errorMessage = "";
                isValidated = false;
              });
              return null;
            }
          },
          decoration: InputDecoration(
              disabledBorder:const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,
                      color: AppColors.primaryColor)
              ),
              errorBorder:const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,
                      color: AppColors.redColor)
              ),
              focusedBorder:const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,
                      color: AppColors.primaryColor)
              ),
              focusedErrorBorder:const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.redColor)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  width: 2,
                  color:  AppColors.primaryColor,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              focusColor: AppColors.primaryColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              prefixIcon:const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
              ),
              filled: true,
              // prefixIcon: const Icon(Icons.person),
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Select any date",
              fillColor: AppColors.hoverColor),
        )
      ],
    );
  }

  Future<void> _selectDate(BuildContext context,bool newDates) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate:newDates ? DateTime.now() : DateTime(1950),
        lastDate:newDates? DateTime(2101) : DateTime.now());
    if (picked != null) {
      setState(() {
        widget.controller.text =  DateFormat('MM-dd-yy').format(picked);
      });
    }
  }

}
