// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';

import '../../../Widgets/constants.dart';

// ignore: must_be_immutable
class BulletPointsTextField extends StatefulWidget {
  BulletPointsTextField(this._NameFieldController,{Key? key}) : super(key: key);
  // ignore: prefer_final_fields
  TextEditingController _NameFieldController;
  @override
  // ignore: library_private_types_in_public_api
  _BulletPointsTextFieldState createState() => _BulletPointsTextFieldState();
}

class _BulletPointsTextFieldState extends State<BulletPointsTextField> {

  bool newLine = false;
  @override
  void initState() {
    //notesController.text = widget.healthEvent['text'];
    widget._NameFieldController.addListener(() {
      //print('___${ widget._NameFieldController.text}');
      String note =  widget._NameFieldController.text;
      if (note.isNotEmpty && note.substring(note.length - 1) == '\u2022') {
       // print('newline');
        setState(() {
          newLine = true;
        });
      } else {
        setState(() {
          newLine = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: AppConstants.defaultFontSize),
      controller: widget._NameFieldController,
      //inputFormatters: [BulletFormatter()],
       maxLines: 6,
      onChanged: (value) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (newLine) {
            return;
          }
          String note = widget._NameFieldController.text;
          if (note.isEmpty) {
            widget._NameFieldController.text = '${widget._NameFieldController.text}\u2022';
            widget._NameFieldController.selection = TextSelection.fromPosition(
                TextPosition(offset: widget._NameFieldController.text.length));
          }
          if (note.isNotEmpty && note.substring(note.length - 1) == '\n') {
            widget._NameFieldController.text = '${widget._NameFieldController.text}\u2022';
            widget._NameFieldController.selection = TextSelection.fromPosition(
                TextPosition(offset: widget._NameFieldController.text.length));
          }
        });
      },
      // maxLength:widget.maxLength != 1 ? widget.maxFieldLength : null,
     // validator: (value) => value!.isEmpty ? "${widget.fieldName} is required" : null,
      keyboardType: TextInputType.multiline,
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
          // prefixIcon:const Padding(
          //   padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
          //   child: Icon(
          //     Icons.calendar_today_outlined,
          //     color: Colors.grey,
          //   ),
          // ),
          filled: true,
          // prefixIcon: const Icon(Icons.person),
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: "Enter you take away points",
          fillColor: AppColors.hoverColor),);
  }
}

class BulletFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText.isNotEmpty) {
      newText = newText.replaceAll('\n', '\n• ');
      if (newText[0] != '•') {
        newText = '• $newText';
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newValue.selection.end),
    );
  }
}

