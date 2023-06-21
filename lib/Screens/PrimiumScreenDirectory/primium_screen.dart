import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding:const EdgeInsets.symmetric(horizontal: 5),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            LogoScreen("Premium"),

            ImageSlideshow(
              initialPage: 1,
                indicatorColor: AppColors.primaryColor,
                indicatorRadius: 5,
                onPageChanged: (value) {
                  debugPrint('Page changed: $value');
                },
                isLoop: true,
                children: <Widget>[
                  Container(
                    // padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    // margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Column(
                        children: [
                          Text("Basic",style: TextStyle(fontSize: AppConstants.headingFontSize,color: AppColors.primaryColor ),),
                          SizedBox(height: 10,),
                          Text("For Burgeon",style: TextStyle(fontSize: AppConstants.headingFontSizeForCreation,color: AppColors.primaryColor ),),
                          SizedBox(height: 10,),
                          Text("Free",style: TextStyle(fontSize: AppConstants.headingFontSizeForCreation,fontWeight: FontWeight.bold,color: AppColors.primaryColor),),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Column(
                        children: [
                          Text("Premium",style: TextStyle(fontSize: AppConstants.headingFontSize,color: AppColors.primaryColor ),),
                          SizedBox(height: 10,),
                          Text("For Leaders",style: TextStyle(fontSize: AppConstants.headingFontSizeForCreation,color: AppColors.primaryColor ),),
                          SizedBox(height: 10,),
                          Text("\$200/year",style: TextStyle(fontSize: AppConstants.headingFontSizeForCreation,fontWeight: FontWeight.bold,color: AppColors.primaryColor),),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Column(
                        children: [
                          Text("Gold",style: TextStyle(fontSize: AppConstants.headingFontSize,color: AppColors.primaryColor ),),
                          SizedBox(height: 10,),
                          Text("For Learners",style: TextStyle(fontSize: AppConstants.headingFontSizeForCreation,color: AppColors.primaryColor ),),
                          SizedBox(height: 10,),
                          Text("\$20/year",style: TextStyle(fontSize: AppConstants.headingFontSizeForCreation,fontWeight: FontWeight.bold,color: AppColors.primaryColor),),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                ]),

          ],
        ),
      ),
    );
  }
}
