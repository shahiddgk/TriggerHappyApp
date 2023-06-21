import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DatePickerField extends StatefulWidget {
   DatePickerField(this.controller,this.hint,this.isNewDateAvailable,{Key? key}) : super(key: key);
String hint;
TextEditingController controller;
bool isNewDateAvailable;

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.lightGreyColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          onTap: () => _selectDate(context,widget.isNewDateAvailable),
          readOnly: true,
          // onChanged: (v) {
          //   setState(() {
          //     isEmptyValidated = v.isNotEmpty;
          //   });
          // },
          // onFieldSubmitted: (v) {
          //   setState(() {
          //     isEmptyValidated = v.isNotEmpty;
          //   });
          // },
          controller: widget.controller,
          // validator: (v) {
          //   setState(() {
          //     isEmptyValidated = v.isNotEmpty;
          //   });
          //   return v.isNotEmpty ? null : "";
          // },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              errorText: "",
              contentPadding:const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              focusColor:  Colors.grey[800],
              disabledBorder:const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  )
              ),
              prefixIcon:const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
              ),
              hintText: widget.hint,
             // hintStyle: style_InputHintText,
              border: InputBorder.none),
        ),
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
