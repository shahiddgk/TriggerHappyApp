import 'package:flutter/material.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';

class SageShareScreenListItem extends StatelessWidget {

  final String title;
  final String date;
  final String name;
  final bool isSharedByMe;
  final bool isPaid;

  const SageShareScreenListItem(
  {super.key, required this.title,
    required this.date,
    required this.name,
    required this.isSharedByMe,
    required this.isPaid,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
      decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(width: 7,color: AppColors.primaryColor),
            top: BorderSide(width: 0.0, color: AppColors.primaryColor),
            bottom: BorderSide(width: 0.0, color: AppColors.primaryColor),
            right: BorderSide(width: 0.0, color: AppColors.primaryColor),
          ),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5),)
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title,style: const TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSize),),
                    const SizedBox(width: 20,),
                    Visibility(
                      visible: isPaid,
                      child: SizedBox(
                          height: 15,
                          child: Image.asset("assets/Pro.png")),
                    ),
                    Visibility(
                        visible: isPaid,
                        child: const SizedBox(width: 5,)),
                    Visibility(
                        visible: isPaid,
                        child: const Icon(Icons.check_circle,size: 18,color: AppColors.primaryColor,)),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(children: [Text(isSharedByMe ? "Shared by:" : "Shared with:",style: const TextStyle(fontSize: AppConstants.defaultFontSize),),
                  const SizedBox(width: 3,),
                  Text(name,style: const TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),),],),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    const Icon(Icons.calendar_month,size: 19,),
                    const SizedBox(width: 5,),
                    Text(date,style: const TextStyle(fontSize: AppConstants.defaultFontSize),)
                  ],
                )
              ],
            ),
            const Icon(Icons.arrow_right,size:22,color: AppColors.containerBorder,)
          ],
        ),
      ),
    );
  }
}
