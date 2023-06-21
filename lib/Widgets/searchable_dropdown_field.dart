// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class SearchableDropdownField extends StatefulWidget {
   SearchableDropdownField(this._valueDropDownController,this._availableTimezones,this._onValueChange,{Key? key}) : super(key: key);

  final SingleValueDropDownController _valueDropDownController;
  final List<String> _availableTimezones;
  final Function _onValueChange;

  @override
  _SearchableDropdownFieldState createState() => _SearchableDropdownFieldState();
}

class _SearchableDropdownFieldState extends State<SearchableDropdownField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        margin:const EdgeInsets.only(top: 10),
        child: DropdownButtonHideUnderline(
          child: DropDownTextField(
            textStyle:const TextStyle(fontSize: AppConstants.defaultFontSize),
            //listSpace: 20,
            textFieldDecoration:const InputDecoration(
              border: InputBorder.none,
              hintText: "Select your timezone",
              hintStyle: TextStyle(fontSize: AppConstants.defaultFontSize),
              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            // initialValue: _timezoneValue,
            listPadding: ListPadding(top: 20),
            enableSearch: true,
            controller: widget._valueDropDownController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Time zone Field is required";
              } else {
                return null;
              }
            },
            dropDownList: widget._availableTimezones.map<DropDownValueModel>((String value) {
              return DropDownValueModel(
                  value: value,
                  name: value
              );
            }).toList(),
            onChanged: (val) {

              widget._onValueChange();
            },
          ),
        )

    );
  }
}
