// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';

class TextFieldWidgetForColumnScreen extends StatefulWidget {
  // ignore: no_leading_underscores_for_local_identifiers
  TextFieldWidgetForColumnScreen(this._NameFieldController,this.maxLength,this.title,this.hint,{Key? key}) : super(key: key);
  // ignore: non_constant_identifier_names
  final TextEditingController _NameFieldController;
  int maxLength;
  bool title;
  String hint;

  @override
  // ignore: library_private_types_in_public_api
  _TextFieldWidgetForColumnScreenState createState() => _TextFieldWidgetForColumnScreenState();
}

class _TextFieldWidgetForColumnScreenState extends State<TextFieldWidgetForColumnScreen> {
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
          controller: widget._NameFieldController,
          textInputAction: TextInputAction.done,
          style: TextStyle(fontSize:widget.title ?AppConstants.headingFontSizeForEntriesAndSession  : AppConstants.defaultFontSize),
          validator: (value) {
            if(value!.trim().isEmpty) {
              setState(() {
                errorMessage = "write something here ";
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
          maxLines: widget.maxLength,
          // maxLength: widget.fieldMaxLength,
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
              filled: true,
              // prefixIcon: const Icon(Icons.person),
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: widget.hint,
              fillColor: AppColors.hoverColor),
        )
      ],
    );
  }
}
