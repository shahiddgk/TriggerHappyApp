

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/date_picker_field.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/save_button_widgets.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';
import 'dropdown_field.dart';
import 'name_field.dart';

void bottomSheet(BuildContext context,String heading,String details, String description) {
  showModalBottomSheet(
      enableDrag: false,
      isDismissible: true,
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0))
      ) ,
      context: context,
      builder: (builder){
        return SafeArea(
          child: Container(
              padding:const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children:const [
                          Icon(Icons.info_outline,size:30,color: AppColors.blueColor,),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Info",style: TextStyle(
                              fontSize: AppConstants.headingFontSize,
                              color: AppColors.blueColor
                          ),),
                        ],
                      ),

                      IconButton(onPressed: (){
                        Navigator.of(context).pop();
                      },
                          icon:const Icon(Icons.cancel)
                      )
                    ],
                  ),
                  Text(
                    heading,
                    style:const TextStyle(
                        fontSize: AppConstants.headingFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.lightBlueColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: (
                         Text(
                          details,
                          style:const TextStyle(
                              fontSize: AppConstants.defaultFontSize,
                              color: AppColors.blueColor,
                              fontWeight: FontWeight.normal
                          ),
                        )
                    ),
                  ),
                  //  Text(
                  //   description,
                  //   style:const TextStyle(
                  //       fontSize: AppConstants.defaultFontSize,
                  //       fontWeight: FontWeight.normal
                  //   ),
                  // )

                ],
              )
          ),
        );
      }
  );
}

void ladderBottomSheet(BuildContext context,bool isGoals,String heading, String type,
    String initialValueForType, List itemsForType,
    String initialValueForGoals, List itemsForGoals,
    Function onTap,Function(String value) goalsValue,
    Function(String value) typeValue,
    TextEditingController dateForGController,
    TextEditingController titleForGController,
    TextEditingController descriptionForGController) {

  showModalBottomSheet(
      enableDrag: false,
      isDismissible: true,
      isScrollControlled: true,
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0))
      ) ,
      context: context,
      builder: (builder){
        return StatefulBuilder(
            builder: (BuildContext context,StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Container(
                        color: AppColors.backgroundColor,
                        padding:const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  heading,
                                  style:const TextStyle(
                                    fontSize: AppConstants.headingFontSize,
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),
                                IconButton(onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                    icon:const Icon(Icons.cancel)
                                )
                              ],
                            ),
                            Text(
                              type,
                              style:const TextStyle(
                                  fontSize: AppConstants.defaultFontSize,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.primaryColor
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                DropDownField(initialValueForType, itemsForType.map((item) {
                                  return  DropdownMenuItem(
                                    value: item.toString(),
                                    child: Text(item.toString()),
                                  );
                                }).toList(), (value) {
                                  // setState(() {
                                  //   initialValueForType = value;
                                  // });
                                  typeValue(value);
                                }),

                                // DropDownField(initialValueForGoals, itemsForGoals.map((item) {
                                //   return  DropdownMenuItem(
                                //     value: item.toString(),
                                //     child: Text(item.toString()),
                                //   );
                                // }).toList(), (value) {
                                //   setState(() {
                                //     initialValueForGoals = value;
                                //   });
                                //   goalsValue(value);
                                // }
                                // ),

                                Visibility(
                                    visible: isGoals ? initialValueForGoals != "Challenges" : true,
                                    child: DatePickerField(dateForGController,"Select date",isGoals)),

                                Container(
                                    margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                    child: NameField(titleForGController,"title",1,70,true)),
                                Container(
                                    margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                    child: NameField(descriptionForGController,"description",4,70,true)),
                                SaveButtonWidgets( (){
                                  onTap();
                                }),
                              ],
                            ),
                          ],
                        )
                    ),
                  ),
                ),
              );
            }
        );

      }
  );
}

void needsBottomSheet(BuildContext context,String heading, List<Widget> fields ) {
  showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: true,
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0))
      ) ,
      context: context,
      builder: (builder){
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                  padding:const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            heading,
                            style:const TextStyle(
                              fontSize: AppConstants.headingFontSize,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                          IconButton(onPressed: (){
                            Navigator.of(context).pop();
                          },
                              icon:const Icon(Icons.cancel)
                          )
                        ],
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: fields,
                      ),
                    ],
                  )
              ),
            ),
          ),
        );
      }
  );
}

void tribeBottomSheet(BuildContext context,String heading,bool isMentor,bool isPeer,bool isMentee,Widget isMentorField,Widget isPeerField,Widget isMenteeField,Function onTap) {
  // bool isMentorVisible = true;
  // bool isPeerVisible = false;
  // bool isMenteeVisible = false;

  showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: true,
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0))
      ) ,
      context: context,
      builder: (builder){
        return StatefulBuilder(
          builder: (BuildContext context,StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                      padding:const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                       // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                heading,
                                style:const TextStyle(
                                  fontSize: AppConstants.headingFontSize,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                              IconButton(onPressed: (){
                                Navigator.of(context).pop();
                              },
                                  icon:const Icon(Icons.cancel)
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap:() {
                                  setState((){
                                    isMentor = true;
                                    isPeer = false;
                                    isMentee = false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isMentor ? AppColors.primaryColor : AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text("Mentor",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                ),
                              ),
                              GestureDetector(
                                onTap:() {
                                  setState((){
                                    isMentor = false;
                                    isPeer = true;
                                    isMentee = false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isPeer ? AppColors.primaryColor : AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text("Peer",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                ),
                              ),
                              GestureDetector(
                                onTap:() {
                                  setState((){
                                    isMentor = false;
                                    isPeer = false;
                                    isMentee = true;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isMentee ? AppColors.primaryColor : AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text("Mentee",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                ),
                              )
                            ],
                          ),
                          Visibility(
                              visible: isMentor,
                              child: isMentorField),
                          Visibility(
                              visible: isPeer,
                              child: isPeerField),
                          Visibility(
                              visible: isMentee,
                              child: isMenteeField),

                          SaveButtonWidgets( (){
                            onTap();
                          }),
                        ],
                      )
                  ),
                ),
              ),
            );
          });
      }
  );
}

// class TribeBottomSheet extends StatefulWidget {
//   const TribeBottomSheet({Key? key}) : super(key: key);
//
//   @override
//   _TribeBottomSheetState createState() => _TribeBottomSheetState();
// }
//
// class _TribeBottomSheetState extends State<TribeBottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom),
//       child: SingleChildScrollView(
//         child: SafeArea(
//           child: Container(
//               padding:const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 40),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         heading,
//                         style:const TextStyle(
//                           fontSize: AppConstants.headingFontSize,
//                           fontWeight: FontWeight.bold,
//
//                         ),
//                       ),
//                       IconButton(onPressed: (){
//                         Navigator.of(context).pop();
//                       },
//                           icon:const Icon(Icons.cancel)
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       GestureDetector(
//                         onTap:() {
//                           setState((){
//                             isMentor = true;
//                             isPeer = false;
//                             isMentee = false;
//                           });
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
//                           decoration: BoxDecoration(
//                             color: isMentor ? AppColors.primaryColor : AppColors.lightGreyColor,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Text("Mentor",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap:() {
//                           setState((){
//                             isMentor = false;
//                             isPeer = true;
//                             isMentee = false;
//                           });
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
//                           decoration: BoxDecoration(
//                             color: isPeer ? AppColors.primaryColor : AppColors.lightGreyColor,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Text("Peer",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap:() {
//                           setState((){
//                             isMentor = false;
//                             isPeer = false;
//                             isMentee = true;
//                           });
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
//                           decoration: BoxDecoration(
//                             color: isMentee ? AppColors.primaryColor : AppColors.lightGreyColor,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Text("Mentee",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
//                         ),
//                       )
//                     ],
//                   ),
//                   Visibility(
//                       visible: isMentor,
//                       child: isMentorField),
//                   Visibility(
//                       visible: isPeer,
//                       child: isPeerField),
//                   Visibility(
//                       visible: isMentee,
//                       child: isMenteeField),
//                 ],
//               )
//           ),
//         ),
//       ),
//     );
//   }
// }
