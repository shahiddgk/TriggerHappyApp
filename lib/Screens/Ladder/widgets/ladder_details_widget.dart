import 'package:flutter/material.dart';

import '../../../Widgets/colors.dart';

class LadderDetailsWidgets extends StatelessWidget {
  const LadderDetailsWidgets({required this.typeText,required this.favourite,required this.category,required this.titleText,required this.descriptionText,Key? key}) : super(key: key);

  final String typeText;
  final String favourite;
  final String category;
  final String titleText;
  final String descriptionText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        Row(
          children: [
            const Text("Type : ",style: TextStyle(color: AppColors.primaryColor),),
            Text(typeText),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            const Text("Favourite : ",style: TextStyle(color: AppColors.primaryColor),),
            Text(favourite),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            const Text("Category : ",style: TextStyle(color: AppColors.primaryColor),),
            Text(category),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            const Text("Title : ",style: TextStyle(color: AppColors.primaryColor),),
            Expanded(child: Text(titleText)),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            const Text("Description : ",style: TextStyle(color: AppColors.primaryColor),),
            Expanded(child: Text(descriptionText)),
          ],
        ),
        const SizedBox(height: 10,),
      ],
    );
  }
}
