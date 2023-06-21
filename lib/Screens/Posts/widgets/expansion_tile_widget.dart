import 'package:flutter/material.dart';

import '../../../Widgets/colors.dart';

// ignore: must_be_immutable
class ExpansionTileWidget extends StatelessWidget {
  ExpansionTileWidget(this.title,this.selectTime,this.selectedTime,this.switchValue,this.switchToggleFunction,{Key? key}) : super(key: key);

  String title;
  Function selectTime;
  String selectedTime;

  bool switchValue;
  Function switchToggleFunction;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryColor,
      child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style:  ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.backgroundColor)
                      ),
                      onPressed: () {
                        selectTime();
                      },
                      child: Text("Set time for $title",style: const TextStyle(color: AppColors.textWhiteColor),),),
                    Container(
                      margin:const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(2)
                      ),
                      padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 6),

                      child: Row(
                        children: [
                          Text(selectedTime,style:const TextStyle(fontSize: 20),),
                          // const Text(":",style: TextStyle(fontSize: 20),),
                          // Text(selectedTime.minute.toString(),style: TextStyle(fontSize: 20),),
                        ],
                      ),
                    ),
                  ],
                ),

              // LoadSwitch(
              //   value: switchValue,
              //   future:,
              //   onChange: (value) {
              //       switchToggleFunction();
              //     },
              //   onTap: (value) {
              //   switchToggleFunction();
              //   },
              // )
                Switch(
                    hoverColor: AppColors.textWhiteColor,
                    activeColor: AppColors.textWhiteColor,
                    value: switchValue,
                    onChanged: (value) {
                  switchToggleFunction();
                })
              ],
            ),
          )
      ),
    );
  }
}
