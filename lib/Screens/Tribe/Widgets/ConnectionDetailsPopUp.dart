
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';

showConnectionDetailsPopUp(BuildContext context,String name,String role,String sharedModule,String accessibleModule) {
  bool isPhone;

  if(MediaQuery.of(context).size.width<= 500) {
    isPhone = true;
  } else {
    isPhone = false;
  }
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return  StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              backgroundColor: AppColors.backgroundColor,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: OptionMcqAnswer(
                    Container(
                    padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    child:const Text("Close"),
                    )
                ),
                  ),
                )
              ],
              content: SizedBox(
                height: !isPhone ? MediaQuery.of(context).size.height/3.5 : MediaQuery.of(context).size.height/3.5,
                width: !isPhone ? MediaQuery.of(context).size.width/2 : MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height/12,
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.topCenter,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                color: AppColors.alertDialogueHeaderColor),
                            // margin:const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                                margin:!isPhone ? const EdgeInsets.symmetric(vertical: 30) : const EdgeInsets.symmetric(vertical: 10),
                                height: 50,
                                width: 50,
                                child: Image.asset('assets/bimage.png',)),
                          ),
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: IconButton(onPressed: () {
                          //     Navigator.of(context).pop();
                          //   }, icon: const Icon(Icons.close)),
                          // )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.topLeft,
                        height: MediaQuery.of(context).size.height/5.5,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 5),
                                child:  const Text("Share Details",textAlign: TextAlign.start,style: TextStyle(fontSize:AppConstants.headingFontSizeForEntriesAndSession,color: AppColors.containerBorder,fontWeight: FontWeight.bold),),
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                padding:const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 1),
                                child:   Text(name,textAlign: TextAlign.start,style:const TextStyle(fontSize:AppConstants.headingFontSizeForEntriesAndSession,color: AppColors.containerBorder),),
                              ),
                              Container(
                                padding:const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 1),
                                child:  Text("Your $role",textAlign: TextAlign.start,style: const TextStyle(fontSize:AppConstants.columnDetailsScreenFontSize,color: AppColors.containerBorder),),
                              ),
                              Container(
                                padding:const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 1),
                                child:  Text("You've shared: ${sharedModule.isEmpty ? "None" : sharedModule.replaceAll(",", "/")}",textAlign: TextAlign.start,style: const TextStyle(fontSize:AppConstants.columnDetailsScreenFontSize,color: AppColors.containerBorder),),
                              ),
                              if(accessibleModule.isNotEmpty || accessibleModule!="")
                              Container(
                                padding:const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 1),
                                child:  Text("They shared: ${accessibleModule.isEmpty ? "None" : accessibleModule.replaceAll(",", "/")}",textAlign: TextAlign.start,style: const TextStyle(fontSize:AppConstants.columnDetailsScreenFontSize,color: AppColors.containerBorder),),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      });
}

showPermissionDetailsPopUp(BuildContext context,String name,String module) {
  bool isPhone;

  if(MediaQuery.of(context).size.width<= 500) {
    isPhone = true;
  } else {
    isPhone = false;
  }
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return  StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              backgroundColor: AppColors.backgroundColor,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: MediaQuery.of(context).size.height/3,
                width: !isPhone ? MediaQuery.of(context).size.width/3 : MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height/12,
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.topCenter,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                color: AppColors.alertDialogueHeaderColor),
                            // margin:const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                                margin:!isPhone ? const EdgeInsets.symmetric(vertical: 30) : const EdgeInsets.symmetric(vertical: 10),
                                height: 50,
                                width: 50,
                                child: Image.asset('assets/bimage.png',)),
                          ),
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: IconButton(onPressed: () {
                          //     Navigator.of(context).pop();
                          //   }, icon: const Icon(Icons.close)),
                          // )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      height: MediaQuery.of(context).size.height/5.5,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:const EdgeInsets.symmetric(horizontal: 5),
                              margin:const EdgeInsets.symmetric(vertical: 5),
                              child:  const Text("Share Details",textAlign: TextAlign.start,style: TextStyle(fontSize:AppConstants.headingFontSizeForEntriesAndSession,color: AppColors.containerBorder,fontWeight: FontWeight.bold),),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              padding:const EdgeInsets.symmetric(horizontal: 5),
                              margin:const EdgeInsets.symmetric(vertical: 1),
                              child:   Text(name,textAlign: TextAlign.start,style:const TextStyle(fontSize:AppConstants.headingFontSizeForEntriesAndSession,color: AppColors.containerBorder),),
                            ),
                            Container(
                              padding:const EdgeInsets.symmetric(horizontal: 5),
                              margin:const EdgeInsets.symmetric(vertical: 1),
                              child:  Text("Shared Modules: ${module.isEmpty ? "None" : module.replaceAll(",", "/")}",textAlign: TextAlign.start,style: const TextStyle(fontSize:AppConstants.columnDetailsScreenFontSize,color: AppColors.containerBorder),),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration:const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                  color: AppColors.primaryColor,
                                )
                            )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(onPressed: () async {
                            Navigator.of(context).pop();
                            }, child:const Text("OK",style: TextStyle(color: AppColors.textWhiteColor),)),
                          ],
                        )
                    )
                  ],
                ),
              ),
            );
          },
        );
      });
}