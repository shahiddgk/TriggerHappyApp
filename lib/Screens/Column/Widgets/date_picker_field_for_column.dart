import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:intl/intl.dart';

class DatePickerFieldForColumn extends StatefulWidget {
  DatePickerFieldForColumn(this.controller,this.hint,this.isNewDateAvailable,{Key? key}) : super(key: key);
  String hint;
  TextEditingController controller;
  bool isNewDateAvailable;

  @override
  _DatePickerFieldForColumnState createState() => _DatePickerFieldForColumnState();
}

class _DatePickerFieldForColumnState extends State<DatePickerFieldForColumn> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textAlignVertical: TextAlignVertical.center,
        onTap: () => _selectDate(context,widget.isNewDateAvailable),
        readOnly: true,
        controller: widget.controller,
        keyboardType: TextInputType.text,
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
    );
  }

  Future<Null> _selectDate(BuildContext context,bool newDates) async {
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
