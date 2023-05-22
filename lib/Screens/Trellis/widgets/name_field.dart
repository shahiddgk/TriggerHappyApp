import 'package:flutter/material.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';

class NameField extends StatefulWidget {
  NameField(this._NameFieldController,this.fieldName,this.maxLength,this.maxFieldLength,this.bottomSheet,{Key? key}) : super(key: key);
  TextEditingController _NameFieldController;
  int maxLength;
  String fieldName;
  bool bottomSheet;
  int maxFieldLength;
  @override
  _NameFieldState createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.bottomSheet ? AppColors.lightGreyColor: null,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
           color: widget.bottomSheet ? AppColors.lightGreyColor: null,
            borderRadius: BorderRadius.circular(5)
        ),
        child: TextFormField(
          style: const TextStyle(fontSize: AppConstants.defaultFontSize),
          controller: widget._NameFieldController,
          maxLines: widget.maxLength,
          maxLength:widget.maxLength != 1 ? widget.maxFieldLength : null,
          validator: (value) => value!.isEmpty ? "${widget.fieldName} is required" : null,
          decoration: InputDecoration(
            hoverColor: widget.bottomSheet ? AppColors.lightGreyColor: null,
              contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              focusColor:  widget.bottomSheet ? AppColors.lightGreyColor: null,
              disabledBorder:const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  )
              ),
              border: InputBorder.none,
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Type ${widget.fieldName}",
              fillColor: widget.bottomSheet ? AppColors.lightGreyColor: AppColors.hoverColor),
        ),
      ),
    );
  }
}