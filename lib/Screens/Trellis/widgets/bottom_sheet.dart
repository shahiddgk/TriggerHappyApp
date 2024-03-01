

// ignore_for_file: must_be_immutable, avoid_print


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/date_picker_field.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/save_button_widgets.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';
import '../../../model/reponse_model/Sage/user_search_list_response.dart';
import '../../../model/reponse_model/Tribe/tribe_single_item_shared_list.dart';
import 'dropdown_field.dart';
import 'name_field.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

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
                      const Row(
                        children:[
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

class LadderBottomSheet extends StatefulWidget {
   LadderBottomSheet(
       this.isGoals,
       this.heading,
       this.type,
       this.initialValueForType,
       this.itemsForType,
       this.initialValueForGoals,
       this.itemsForGoals,
       this.onTap,
       this.goalsValue,
       this.typeValue,
       this.dateForGController,
       this.titleForGController,
       this.descriptionForGController,
       {Key? key}) : super(key: key);

  bool isGoals;
  String heading;
  String type;
  String initialValueForType;
  List itemsForType;
  String initialValueForGoals;
  List itemsForGoals;
  Function onTap;
  Function(String value) goalsValue;
  Function(String value) typeValue;
  TextEditingController dateForGController;
  TextEditingController titleForGController;
  TextEditingController descriptionForGController;

  @override
  State<LadderBottomSheet> createState() => _LadderBottomSheetState();
}

// class MyBottomSheet extends StatefulWidget {
//
//   MyBottomSheet(
//       this.isGoals,
//       this.heading,
//       this.type,
//       this.initialValueForType,
//       this.itemsForType,
//       this.initialValueForGoals,
//       this.itemsForGoals,
//       this.onTap,
//       this.goalsValue,
//       this.typeValue,
//       this.dateForGController,
//       this.titleForGController,
//       this.descriptionForGController,
//       {Key? key}) : super(key: key);
//
//   bool isGoals;
//   String heading;
//   String type;
//   String initialValueForType;
//   List itemsForType;
//   String initialValueForGoals;
//   List itemsForGoals;
//   Function onTap;
//   Function(String value) goalsValue;
//   Function(String value) typeValue;
//   TextEditingController dateForGController;
//   TextEditingController titleForGController;
//   TextEditingController descriptionForGController;
//
//   @override
//   _MyBottomSheetState createState() => _MyBottomSheetState();
// }
//
// class _MyBottomSheetState extends State<MyBottomSheet> {
//   bool isGoals = false;
//
//   toggleVisibility(bool value) {
//     setState(() {
//       isGoals = value;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Container(
//         child: Column(
//           children: [
//             // ElevatedButton(
//             //   onPressed: (){toggleVisibility(false);},
//             //   child: Text('Toggle Visibility'),
//             // ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   widget.heading,
//                   style:const TextStyle(
//                     fontSize: AppConstants.headingFontSize,
//                     fontWeight: FontWeight.bold,
//
//                   ),
//                 ),
//                 IconButton(onPressed: (){
//                   Navigator.of(context).pop();
//                 },
//                     icon:const Icon(Icons.cancel)
//                 )
//               ],
//             ),
//             Container(
//               margin:const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         toggleVisibility(true);
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         //width: MediaQuery.of(context).size.width/2,
//                         padding:const EdgeInsets.symmetric(vertical: 10),
//                         decoration: BoxDecoration(
//                             color: isGoals ? AppColors.primaryColor : AppColors.backgroundColor,
//                             border: Border.all(color: AppColors.primaryColor),
//                             borderRadius:const BorderRadius.only(bottomLeft: Radius.circular(30),topLeft:Radius.circular(30), )),
//                         child: Text("Goals/Challenges",style: TextStyle(color: isGoals ? AppColors.backgroundColor : AppColors.primaryColor),),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: (){toggleVisibility(false);},
//                       child: Container(
//                         alignment: Alignment.center,
//                         // width: MediaQuery.of(context).size.width/2,
//                         padding:const EdgeInsets.symmetric(vertical: 10),
//                         decoration: BoxDecoration(
//                             color: !isGoals ? AppColors.primaryColor : AppColors.backgroundColor,
//                             border: Border.all(color: AppColors.primaryColor),
//                             borderRadius:const BorderRadius.only(bottomRight: Radius.circular(30),topRight:Radius.circular(30), )),
//                         child: Text("Memories/achievements",style: TextStyle(color: !isGoals ? AppColors.backgroundColor : AppColors.primaryColor),),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             DropDownField(widget.initialValueForType, widget.itemsForType.map((item) {
//               return  DropdownMenuItem(
//                 value: item.toString(),
//                 child: Text(item.toString()),
//               );
//             }).toList(), (value) {
//               // setState(() {
//               //   initialValueForType = value;
//               // });
//               widget.typeValue(value);
//             }),
//             Visibility(
//                 visible: isGoals,
//                 child: DatePickerField(widget.dateForGController,"Select date",isGoals)),
//
//             Container(
//                 margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
//                 child: NameField(widget.titleForGController,"title",1,70,true)),
//             Container(
//                 margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
//                 child: NameField(widget.descriptionForGController,"description",4,70,true)),
//             SaveButtonWidgets( (){
//               widget.onTap();
//             }),
//             // ListView(
//             //   shrinkWrap: true,
//             //   physics: const NeverScrollableScrollPhysics(),
//             //   children: [
//             //
//             //
//             //     // DropDownField(initialValueForGoals, itemsForGoals.map((item) {
//             //     //   return  DropdownMenuItem(
//             //     //     value: item.toString(),
//             //     //     child: Text(item.toString()),
//             //     //   );
//             //     // }).toList(), (value) {
//             //     //   setState(() {
//             //     //     initialValueForGoals = value;
//             //     //   });
//             //     //   goalsValue(value);
//             //     // }
//             //     // ),
//             //
//             //
//             //   ],
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _LadderBottomSheetState extends State<LadderBottomSheet> {

  bool isGoals = true;

  toggleVisibility(bool value) {
    print(value);
    setState(() {
      isGoals = value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        widget.heading,
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
                  Container(
                    margin:const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              toggleVisibility(true);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              //width: MediaQuery.of(context).size.width/2,
                              padding:const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: isGoals ? AppColors.primaryColor : AppColors.backgroundColor,
                                  border: Border.all(color: AppColors.primaryColor),
                                  borderRadius:const BorderRadius.only(bottomLeft: Radius.circular(30),topLeft:Radius.circular(30), )),
                              child: Text("Goals/Challenges",style: TextStyle(color: isGoals ? AppColors.backgroundColor : AppColors.primaryColor),),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){toggleVisibility(false);},
                            child: Container(
                              alignment: Alignment.center,
                              // width: MediaQuery.of(context).size.width/2,
                              padding:const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: !isGoals ? AppColors.primaryColor : AppColors.backgroundColor,
                                  border: Border.all(color: AppColors.primaryColor),
                                  borderRadius:const BorderRadius.only(bottomRight: Radius.circular(30),topRight:Radius.circular(30), )),
                              child: Text("Memories/achievements",style: TextStyle(color: !isGoals ? AppColors.backgroundColor : AppColors.primaryColor),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.type,
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
                      DropDownField(widget.initialValueForType, widget.itemsForType.map((item) {
                        return  DropdownMenuItem(
                          value: item.toString(),
                          child: Text(item.toString()),
                        );
                      }).toList(), (value) {
                        // setState(() {
                        //   initialValueForType = value;
                        // });
                        widget.typeValue(value);
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
                          visible: isGoals,
                          child: DatePickerField(widget.dateForGController,"Select date",isGoals)),

                      Container(
                          margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                          child: NameField(widget.titleForGController,"title",1,70,true,false)),
                      Container(
                          margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                          child: NameField(widget.descriptionForGController,"description",4,70,true,false)),
                      SaveButtonWidgets( (){
                        widget.onTap();
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
}


void ladderBottomSheet(
    bool isEdit,
    BuildContext context,
    bool isGoals,
    String heading, String type,
    String initialValueForType1,
    List itemsForType,
    String initialValueForGoals1,
    List itemsForGoals,
    Function onTap,
    Function(String value) goalsValue,
    Function(String value) typeValue,
    TextEditingController dateForGController,
    TextEditingController titleForGController,
    TextEditingController descriptionForGController) {

  // bool isGoalsTabActive = true;

  bool isChallenges = true;

  String initialValueForMType = "Memories";
  List itemsForMType = ["Memories","Achievements"];

  String initialValueForMGoals = "Goals";
  List itemsForGoals = <String>["Goals","Challenges"];

  String initialValueForType = "Physical";
  List itemsForType = ["Physical","Emotional","Relational","Work","Financial","Spiritual"];

  if(isEdit) {
    if(isGoals) {
      initialValueForMGoals = initialValueForGoals1;
      initialValueForType = initialValueForType1;

      if(initialValueForMGoals == "Challenges") {
        isChallenges = false;
      } else {
        isChallenges = true;
      }
    } else {
      initialValueForMType = initialValueForType1;
    }

  }

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
                            Container(
                              margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: isEdit ? Row(
                                children: [
                                  if(isGoals)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


                                        print(isGoals);
                                        setState(() {
                                          // isGoalsTabActive = true;
                                          isGoals = true;
                                          sharedPreferences.setBool("IsGoals", true);
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        //width: MediaQuery.of(context).size.width/2,
                                        padding:const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            color: isGoals ? AppColors.primaryColor : AppColors.backgroundColor,
                                            border: Border.all(color: AppColors.primaryColor),
                                            borderRadius:const BorderRadius.all(Radius.circular(30))),
                                        child: Text("Goals/Challenges",maxLines: 1,style: TextStyle(fontSize:AppConstants.defaultFontSize,color: isGoals ? AppColors.backgroundColor : AppColors.primaryColor),),
                                      ),
                                    ),
                                  ),
                                  if(!isGoals)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                        print(isGoals);
                                        setState(() {
                                          // isGoalsTabActive = false;
                                          isGoals = false;
                                          sharedPreferences.setBool("IsGoals", false);
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        // width: MediaQuery.of(context).size.width/2,
                                        padding:const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            color: !isGoals ? AppColors.primaryColor : AppColors.backgroundColor,
                                            border: Border.all(color: AppColors.primaryColor),
                                            borderRadius:const BorderRadius.all(Radius.circular(30))),
                                        child: Text("Memories/achievements",maxLines: 1,style: TextStyle(fontSize:AppConstants.defaultFontSize,color: !isGoals ? AppColors.backgroundColor : AppColors.primaryColor),),
                                      ),
                                    ),
                                  ),
                                ],
                              ) : Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


                                        print(isGoals);
                                        setState(() {
                                          // isGoalsTabActive = true;
                                          isGoals = true;
                                          sharedPreferences.setBool("IsGoals", true);
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        //width: MediaQuery.of(context).size.width/2,
                                        padding:const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            color: isGoals ? AppColors.primaryColor : AppColors.backgroundColor,
                                            border: Border.all(color: AppColors.primaryColor),
                                            borderRadius:const BorderRadius.only(bottomLeft: Radius.circular(30),topLeft:Radius.circular(30), )),
                                        child: Text("Goals/Challenges",maxLines: 1,style: TextStyle(fontSize:AppConstants.defaultFontSize,color: isGoals ? AppColors.backgroundColor : AppColors.primaryColor),),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                        print(isGoals);
                                        setState(() {
                                          // isGoalsTabActive = false;
                                          isGoals = false;
                                          sharedPreferences.setBool("IsGoals", false);
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        // width: MediaQuery.of(context).size.width/2,
                                        padding:const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            color: !isGoals ? AppColors.primaryColor : AppColors.backgroundColor,
                                            border: Border.all(color: AppColors.primaryColor),
                                            borderRadius:const BorderRadius.only(bottomRight: Radius.circular(30),topRight:Radius.circular(30), )),
                                        child: Text("Memories/achievements",maxLines: 1,style: TextStyle(fontSize:AppConstants.defaultFontSize,color: !isGoals ? AppColors.backgroundColor : AppColors.primaryColor),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Text(
                            //   type,
                            //   style:const TextStyle(
                            //       fontSize: AppConstants.defaultFontSize,
                            //       fontWeight: FontWeight.normal,
                            //       color: AppColors.primaryColor
                            //   ),
                            // ),
                            ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                DropDownField(isGoals ? initialValueForType : initialValueForMType, isGoals? itemsForType.map((item) {
                              return  DropdownMenuItem(
                                value: item.toString(),
                                child: Text(item.toString()),
                              );
                            }).toList() : itemsForMType.map((item) {
                                  return  DropdownMenuItem(
                                    value: item.toString(),
                                    child: Text(item.toString()),
                                  );
                                }).toList(), (value) {
                                  // setState(() {
                                  //   initialValueForType = value;
                                  // });
                                  print(value);
                                  typeValue(value);
                                }),

                                Visibility(
                                  visible: isGoals,
                                  child: DropDownField(initialValueForMGoals, itemsForGoals.map((item) {
                                    return  DropdownMenuItem(
                                      value: item.toString(),
                                      child: Text(item.toString()),
                                    );
                                  }).toList(), (value) {
                                    if(value == "Challenges") {
                                      setState(() {
                                        isChallenges = false;
                                      });
                                    } else {
                                      setState(() {
                                        isChallenges = true;
                                      });
                                    }
                                    setState(() {
                                      initialValueForGoals1 = value;
                                    });
                                    goalsValue(value);
                                  }
                                  ),
                                ),

                                Visibility(
                                    visible: isChallenges,
                                    child: DatePickerField(dateForGController,"Select date",isGoals)),

                                Container(
                                    margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                    child: NameField(titleForGController,"title",1,70,true,false)),
                                Container(
                                    margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                    child: NameField(descriptionForGController,"description",4,0,true,false)),
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
          );}
        );
      }
  );
}

void tribeBottomSheet(BuildContext context,String selected,bool isEdit,String heading,bool isMentor,bool isPeer,bool isMentee,Widget isMentorField,Widget isPeerField,Widget isMenteeField,Function(String) onOptionSelected,Function onTap) {
  String initialValue = selected;
  List itemsForType = <String>["Mentor","Peer","Mentee"];
  // bool isDataLoading = false;
  print(isMentor);
  print(isPeer);
  print(isMentee);

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
                      child: Stack(
                        children: [
                          Column(
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
                              IgnorePointer(
                                ignoring: isEdit,
                                child: DropDownField(

                                    initialValue, itemsForType.map((item) {
                                  return  DropdownMenuItem(
                                    value: item.toString(),
                                    child: Text(item.toString()),
                                  );
                                }).toList(), (value) {
                                  // setState(() {
                                  //   initialValueForType = value;
                                  // });
                                  onOptionSelected(value);
                                  if(value == "Peer") {
                                    setState((){
                                      isMentor = false;
                                      isPeer = true;
                                      isMentee = false;
                                    });
                                  } else if(value == "Mentee") {
                                    setState((){
                                      isMentor = false;
                                      isPeer = false;
                                      isMentee = true;
                                    });
                                  } else {
                                    setState((){
                                      isMentor = true;
                                      isPeer = false;
                                      isMentee = false;
                                    });
                                  }
                                  print(value);
                                }),
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     GestureDetector(
                              //       onTap:() {
                              //         onOptionSelected("Mentor");
                              //         setState((){
                              //           isMentor = true;
                              //           isPeer = false;
                              //           isMentee = false;
                              //         });
                              //       },
                              //       child: Container(
                              //         padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                              //         decoration: BoxDecoration(
                              //           color: isMentor ? AppColors.primaryColor : AppColors.lightGreyColor,
                              //           borderRadius: BorderRadius.circular(10),
                              //         ),
                              //         child: const Text("Mentor",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                              //       ),
                              //     ),
                              //     GestureDetector(
                              //       onTap:() {
                              //         setState((){
                              //           onOptionSelected("Peer");
                              //           isMentor = false;
                              //           isPeer = true;
                              //           isMentee = false;
                              //         });
                              //       },
                              //       child: Container(
                              //         padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                              //         decoration: BoxDecoration(
                              //           color: isPeer ? AppColors.primaryColor : AppColors.lightGreyColor,
                              //           borderRadius: BorderRadius.circular(10),
                              //         ),
                              //         child: const Text("Peer",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                              //       ),
                              //     ),
                              //     GestureDetector(
                              //       onTap:() {
                              //         setState((){
                              //           onOptionSelected("Mentee");
                              //           isMentor = false;
                              //           isPeer = false;
                              //           isMentee = true;
                              //         });
                              //       },
                              //       child: Container(
                              //         padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                              //         decoration: BoxDecoration(
                              //           color: isMentee ? AppColors.primaryColor : AppColors.lightGreyColor,
                              //           borderRadius: BorderRadius.circular(10),
                              //         ),
                              //         child: const Text("Mentee",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                              //       ),
                              //     )
                              //   ],
                              // ),
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
                                // setState((){
                                //   isDataLoading = true;
                                // });
                                onTap();
                              }),
                            ],
                          ),
                          // isDataLoading ?const Center(child: CircularProgressIndicator()) :
                          //     Container()
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

showModuleListPopUp(BuildContext context, Function(List<String> value) selectedList,List<String> selected1) {
  bool isPhone;

  bool checkbox1 = false;
  bool checkbox2 = false;
  bool checkbox3 = false;
  bool checkbox4 = false;
  bool checkbox5 = false;
  bool checkbox6 = false;

  final List<String> moduleItems = [
    'All',
    'P.I.R.E',
    'NAQ',
    'Column',
    'Trellis',
    'Ladder',
  ];

  List<String> selected = selected1;

  if(selected.contains("All")) {
    checkbox1 = true;
    checkbox2 = true;
    checkbox3 = true;
    checkbox4 = true;
    checkbox5 = true;
    checkbox6 = true;
  } else {
    if(selected.contains("P.I.R.E")) {
      checkbox2 = true;
    }
    if(selected.contains("NAQ")) {
      checkbox3 = true;
    }
    if(selected.contains("Column")) {
      checkbox4 = true;
    }
    if(selected.contains("Ladder")) {
      checkbox5 = true;
    }
    if(selected.contains("Trellis")) {
      checkbox6 = true;
    }
  }

  if(MediaQuery.of(context).size.width<= 500) {
    isPhone = true;
  } else {
    isPhone = false;
  }
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return  StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              backgroundColor: AppColors.hoverColor,
              contentPadding: EdgeInsets.zero,
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: OptionMcqAnswer(
                          Container(
                              margin: !isPhone ? const EdgeInsets.symmetric(horizontal: 30,vertical: 10) : const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              child: const Text("Cancel",style: TextStyle(color: AppColors.textWhiteColor),)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: InkWell(
                        onTap: ()  {
                          setState(() {
                            print(checkbox1);
                            print(checkbox2);
                            print(checkbox3);
                            print(checkbox4);
                            print(checkbox5);
                            print(checkbox6);

                            selected = [];
                            if(checkbox2 && checkbox3 && checkbox4 && checkbox5 && checkbox6) {
                              selected = moduleItems;
                            } else {
                              selected = [];
                              if (checkbox2) {
                                selected.add("P.I.R.E");
                              }
                              if (checkbox3) {
                                selected.add("NAQ");
                              }
                              if (checkbox4) {
                                selected.add("Column");
                              }
                              if (checkbox5) {
                                selected.add("Ladder");
                              }
                              if (checkbox6) {
                                selected.add("Trellis");
                              }
                            }
                            selectedList(selected);
                            Navigator.of(context).pop();
                            // isLadingAdminAccess = true;

                          });
                        },
                        child: OptionMcqAnswer(
                          Container(
                              margin: !isPhone ? const EdgeInsets.symmetric(horizontal: 30,vertical: 10) : const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              child: const Text("Submit",style: TextStyle(color: AppColors.textWhiteColor),)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
              // title: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Select Modules",textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.userActivityCardRadius : AppConstants.headingFontSizeForCreation,color: AppColors.alertDialogueColor)),
              //     // Align(alignment: Alignment.topRight,
              //     // child: IconButton(onPressed: () {
              //     //   Navigator.of(context).pop();
              //     // }, icon: const Icon(Icons.cancel,)),
              //     // )
              //   ],
              // ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: !isPhone ? MediaQuery.of(context).size.height/2.5 : MediaQuery.of(context).size.height/2.5,
                width: !isPhone ? MediaQuery.of(context).size.width/3 : MediaQuery.of(context).size.width/2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Container(
                            //     margin: const EdgeInsets.only(left: 10),
                            //     child: Text("Select Modules",textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontSize:!isPhone ? AppConstants.userActivityCardRadius : AppConstants.headingFontSize,color: AppColors.alertDialogueColor))),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  checkbox1 = !checkbox1;
                                });
                                if(checkbox1) {
                                  setState(() {
                                    checkbox1 = true;
                                    checkbox2 = true;
                                    checkbox3 = true;
                                    checkbox4 = true;
                                    checkbox5 = true;
                                    checkbox6 = true;
                                  });
                                } else {
                                  setState(() {
                                    checkbox1 = false;
                                    checkbox2 = false;
                                    checkbox3 = false;
                                    checkbox4 = false;
                                    checkbox5 = false;
                                    checkbox6 = false;
                                  });
                                }

                              },
                              child: Container(
                                  padding:const EdgeInsets.symmetric(horizontal: 5),
                                  margin:const EdgeInsets.symmetric(vertical:5),
                                  child: Row(
                                    children: [
                                      Expanded(child: Icon(checkbox2 && checkbox3 && checkbox4 && checkbox5 && checkbox6? Icons.check_box_outlined :  Icons.check_box_outline_blank,color: AppColors.alertDialogueHeaderColor,)),

                                      Expanded(flex: 4,child: Text("All",textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.columnDetailsScreenFontSize),),)
                                    ],
                                  )
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  checkbox2 = !checkbox2;
                                });
                              },
                              child: Container(
                                  padding:const EdgeInsets.symmetric(horizontal: 5),
                                  margin:const EdgeInsets.symmetric(vertical:7),
                                  child: Row(
                                    children: [
                                      Expanded(child: Icon(checkbox2 ? Icons.check_box_outlined :  Icons.check_box_outline_blank,color: AppColors.alertDialogueHeaderColor,)),
                                      Expanded(flex: 4,child: Text("P.I.R.E",textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.columnDetailsScreenFontSize),),)
                                    ],
                                  )
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  checkbox3 = !checkbox3;
                                });
                              },
                              child: Container(
                                  padding:const EdgeInsets.symmetric(horizontal: 5),
                                  margin:const EdgeInsets.symmetric(vertical:7),
                                  child: Row(
                                    children: [
                                      Expanded(child: Icon(checkbox3 ? Icons.check_box_outlined :  Icons.check_box_outline_blank,color: AppColors.alertDialogueHeaderColor,)),
                                      Expanded(flex: 4,child: Text("NAQ",textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.columnDetailsScreenFontSize),),)
                                    ],
                                  )
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  checkbox4 = !checkbox4;
                                });
                              },
                              child: Container(
                                  padding:const EdgeInsets.symmetric(horizontal: 5),
                                  margin:const EdgeInsets.symmetric(vertical:7),
                                  child: Row(
                                    children: [
                                      Expanded(child: Icon(checkbox4 ? Icons.check_box_outlined :  Icons.check_box_outline_blank,color: AppColors.alertDialogueHeaderColor,)),
                                      Expanded(flex: 4,child: Text("Column",textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.columnDetailsScreenFontSize),),)
                                    ],
                                  )
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  checkbox5 = !checkbox5;
                                });
                              },
                              child: Container(
                                  padding:const EdgeInsets.symmetric(horizontal: 5),
                                  margin:const EdgeInsets.symmetric(vertical:7),
                                  child: Row(
                                    children: [
                                      Expanded(child: Icon(checkbox5 ? Icons.check_box_outlined :  Icons.check_box_outline_blank,color: AppColors.alertDialogueHeaderColor,)),
                                      Expanded(flex: 4,child: Text("Ladder",textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.columnDetailsScreenFontSize),),)
                                    ],
                                  )
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  checkbox6 = !checkbox6;
                                });
                              },
                              child: Container(
                                  padding:const EdgeInsets.symmetric(horizontal: 5),
                                  margin:const EdgeInsets.symmetric(vertical:7),
                                  child: Row(
                                    children: [
                                      Expanded(child: Icon(checkbox6 ? Icons.check_box_outlined :  Icons.check_box_outline_blank,color: AppColors.alertDialogueHeaderColor,)),
                                      Expanded(flex: 4,child: Text("Trellis",textAlign: TextAlign.start,style: TextStyle(fontSize:!isPhone ? AppConstants.headingFontSizeForEntriesAndSession : AppConstants.columnDetailsScreenFontSize),),)
                                    ],
                                  )
                              ),
                            ),

                          ],
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

void sendConnectionBottomSheet(BuildContext context,Function(UsersSearchData value) selectedUserValue, Function(String value) connectionTypeValue,Function onTap,List<UsersSearchData> userConnectionList,Function(int value) selectedRadioOption,int selectedRadio,Widget emailTextField, Function(List<String> value) selectedModuleValue ) {
  List<String> connectionTypeList = [ "Mentor","Peer","Mentee"];
  String initialValueForConnectionType = "Mentor";


  List<String> selectedModule = [];

  List<UsersSearchData> connectionUserList = userConnectionList;
  UsersSearchData initialValueForConnectionUser = userConnectionList[0];

  TextEditingController textEditingController = TextEditingController();

  bool isSendCalled = false;

  bool isPhone;

  if(MediaQuery.of(context).size.width<= 500) {
    isPhone = true;
  } else {
    isPhone = false;
  }

  showModalBottomSheet(
      enableDrag: false,
      isDismissible: true,
      backgroundColor: AppColors.hoverColor,
      isScrollControlled: true,
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0))
      ) ,
      context: context, builder: (builder) {
    return StatefulBuilder(builder: (BuildContext context,StateSetter setState) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding:!isPhone ? const EdgeInsets.symmetric(vertical: 20) : const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 5),
                height: 60,
                decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                ),
                child: Image.asset('assets/bimage.png',)),
              Container(
                margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(selectedRadio == 1 ? "Send Connection Request" : "Invite User",style: const TextStyle(fontSize: AppConstants.headingFontSize,color: AppColors.connectionTypeTextColor,fontWeight: FontWeight.bold),),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: 1,
                            groupValue: selectedRadio,
                            title:const Text('Connection Request',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                            onChanged: (int? val) {
                              setState(() {
                                selectedRadio = 1;
                                selectedRadioOption(val!);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: 2,
                            groupValue: selectedRadio,
                            title:const Text('Invite User',style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                            onChanged: (int? val) {
                              setState(() {
                                selectedRadio = 2;
                                selectedRadioOption(val!);
                              });

                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Request For:',style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.columnDetailsScreenFontSize,fontWeight: FontWeight.bold),),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: OptionMcqAnswer(
                              DropdownButtonHideUnderline(
                                child: DropdownButton2 <String>(
                                  isExpanded: true,
                                  value: initialValueForConnectionType,
                                  onChanged: (String? value) {
                                    setState(() {
                                      initialValueForConnectionType = value!;
                                      connectionTypeValue(value);
                                    });
                                  },
                                  items: connectionTypeList.map((e) => DropdownMenuItem<String>(
                                    value: e.toString(),
                                    child: Text(
                                      e.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  )).toList(),),
                              )
                          ),
                        ),
                        Visibility(
                          visible: selectedRadio == 1,
                          child: const Text('Select User:',style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.columnDetailsScreenFontSize,fontWeight: FontWeight.bold),),),
                        Visibility(
                          visible: selectedRadio == 1,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: OptionMcqAnswer(
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2 <UsersSearchData>(
                                    isExpanded: true,
                                    dropdownSearchData: DropdownSearchData(
                                      searchController: textEditingController,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller: textEditingController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            hintText: 'Search for an item...',
                                            hintStyle: const TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return item.value!.name!.toLowerCase().toString().contains(searchValue.toLowerCase());
                                      },
                                    ),
                                    value: initialValueForConnectionUser,
                                    onChanged: (UsersSearchData? value) {
                                      setState(() {
                                        initialValueForConnectionUser = value!;
                                        textEditingController.clear();
                                        selectedUserValue(value);
                                      });
                                    },
                                    items: connectionUserList.map((e) => DropdownMenuItem<UsersSearchData>(
                                      value: e,
                                      child: Text(
                                        "${e.name.toString()} (${e.email.toString()})",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    )).toList(),),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: selectedRadio == 2,
                      child: emailTextField,
                    ),
                    Visibility(
                      visible: selectedRadio == 1,
                      child: const Text('Share Modules:',style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.columnDetailsScreenFontSize,fontWeight: FontWeight.bold),),),
                    InkWell(
                      onTap: () {
                        showModuleListPopUp(context,(value) {
                          setState(() {
                            selectedModule = value;
                          });
                        },selectedModule);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: OptionMcqAnswer(
                            DropdownButtonHideUnderline(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  child: Text(selectedModule.isNotEmpty ? selectedModule.contains("All") ? "All" : selectedModule.join(", ") : "Select Module",style: TextStyle(color: selectedModule.isNotEmpty ? AppColors.textWhiteColor : AppColors.userActivityGreyColor ),)),
                            )
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/6),
                      child: InkWell(
                        onTap: () {
                          List<String> selectedModule1 ;
                          setState(() {
                            if(selectedModule.contains("All")) {
                              selectedModule1 = ['app'];
                            } else {
                              selectedModule1 = selectedModule;
                            }
                            selectedModuleValue(selectedModule1);
                          });
                          if(!isSendCalled){
                            onTap();
                          }
                          setState(() {
                            isSendCalled = true;
                          });

                        },
                        child: IgnorePointer(
                          ignoring: isSendCalled,
                          child: OptionMcqAnswer(
                            isSendCalled ? Center(child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                height: 30,
                                width: 30,
                                child: const CircularProgressIndicator())) : Container(
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Send",style: TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.headingFontSize),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      );
    });
  });
}

void editSendConnectionBottomSheet(BuildContext context,bool isConnectionAccept,List<String> selectedModuleList,String connectionType, Function(List<String> value) selectedModuleValue,Function onTap, Function(String value) connectionTypeValue,Function onDeleteTap,List<ShareSingleItemDetails> pireList,List<ShareSingleItemDetails> naqList,List<ShareSingleItemDetails> columnList,List<ShareSingleItemDetails> ladderList ,Function(ShareSingleItemDetails value) shareSingleItemDetailsForDelete ) {
  List<String> connectionTypeList = [ "Mentor","Peer","Mentee"];
  String initialValueForConnectionType = connectionType.capitalize();

  print("selectedModules");
  print(selectedModuleList);

  List<String> selectedModule = selectedModuleList;
  List<String> singleItemCategory = [];
  String initialItemForSingleItem = "";


  bool isSendCalled = false;
  bool isPhone;

  if(pireList.isNotEmpty) {
    singleItemCategory.add("P.I.R.E");
    initialItemForSingleItem = "P.I.R.E";
  }

  if(naqList.isNotEmpty) {
    singleItemCategory.add("NAQ");
    if(initialItemForSingleItem == "") {
      initialItemForSingleItem = "NAQ";
    }
  }
  if(columnList.isNotEmpty) {
    singleItemCategory.add("Column");
    if(initialItemForSingleItem== "") {
      initialItemForSingleItem = "Column";
    }
  }
  if(ladderList.isNotEmpty ) {
    singleItemCategory.add("Ladder");
    if(initialItemForSingleItem == "") {
      initialItemForSingleItem = "Ladder";
    }
  }


  if(MediaQuery.of(context).size.width<= 500) {
    isPhone = true;
  } else {
    isPhone = false;
  }

  showModalBottomSheet(
      enableDrag: false,
      isDismissible: true,
      backgroundColor: AppColors.hoverColor,
      isScrollControlled: true,
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0))
      ) ,
      context: context, builder: (builder) {
        return StatefulBuilder(builder: (BuildContext context,StateSetter setState) {
          return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding:!isPhone ? const EdgeInsets.symmetric(vertical: 20) : const EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 60,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                    ),
                    child: Image.asset('assets/bimage.png',)),
                Container(
                  margin:  const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(!isConnectionAccept)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Request For:',style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.columnDetailsScreenFontSize,fontWeight: FontWeight.bold),),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: OptionMcqAnswer(
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2 <String>(
                                      isExpanded: true,
                                      value: initialValueForConnectionType,
                                      onChanged: (String? value) {
                                        setState(() {
                                          initialValueForConnectionType = value!;
                                          connectionTypeValue(value);
                                        });
                                      },
                                      items: connectionTypeList.map((e) => DropdownMenuItem<String>(
                                        value: e.toString(),
                                        child: Text(
                                          e.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )).toList(),),
                                  )
                              ),
                            ),
                          ],
                        ),
                      const Text('Modules Shared:',style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.columnDetailsScreenFontSize,fontWeight: FontWeight.bold),),
                      const Divider(color: AppColors.primaryColor,),
                      InkWell(
                        onTap: () {
                          showModuleListPopUp(context,(value) {
                            setState(() {
                              selectedModule = value;
                            });
                          },selectedModule);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: OptionMcqAnswer(
                              DropdownButtonHideUnderline(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                    child: Text(selectedModule.isNotEmpty ? selectedModule.contains("All") ? "All" : selectedModule.join(", ") : "Select Module",style: TextStyle(color: selectedModule.isNotEmpty ? AppColors.textWhiteColor : AppColors.userActivityGreyColor ),)),
                              )
                          ),
                        ),
                      ),
                      if(isConnectionAccept)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Single Items Shared:',style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.columnDetailsScreenFontSize,fontWeight: FontWeight.bold),),
                            const Divider(color: AppColors.primaryColor,),
                            pireList.isNotEmpty || naqList.isNotEmpty || columnList.isNotEmpty || ladderList.isNotEmpty ? Column(
                              children: [
                                OptionMcqAnswer(
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2 <String>(
                                      isExpanded: true,
                                      value: initialItemForSingleItem,
                                      onChanged: (String? value) {
                                        setState(() {
                                          initialItemForSingleItem = value!;
                                        });
                                      },
                                      items: singleItemCategory.map((e) =>
                                          DropdownMenuItem<String>(
                                            value: e.toString(),
                                            child: Text(
                                              e.toString(),
                                              style: const TextStyle(
                                                fontSize: AppConstants
                                                    .defaultFontSize,
                                              ),
                                            ),
                                          )).toList(),),
                                  ),
                                ),
                                Visibility(
                                  visible: initialItemForSingleItem == "P.I.R.E",
                                  child: pireList.isEmpty ? const Align(
                                      alignment: Alignment.center,
                                      child: Text("P.I.R.E not shared"))
                                      : ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: MediaQuery.of(context).size.height/5,
                                        maxHeight: MediaQuery.of(context).size.height/5
                                    ),
                                    child: GridView.count(
                                        crossAxisCount: !isPhone ? 3 : 3,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 2.0,
                                        childAspectRatio: 2.5,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: List.generate(pireList.length, (index) {
                                          return Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(25),
                                                    border: Border.all(color: AppColors.primaryColor,width: 3)
                                                ),
                                                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(pireList[index].createdAt!)))),
                                              ),
                                              Positioned(
                                                top: -2,
                                                right: -2,
                                                child: InkWell(
                                                  onTap: () {
                                                    shareSingleItemDetailsForDelete(pireList[index]);
                                                    setState(() {
                                                      pireList.removeAt(index);
                                                    });
                                                    onDeleteTap();
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: AppColors.hoverColor,
                                                          borderRadius: BorderRadius.circular(100)),
                                                      child: const Icon(Icons.cancel,color: AppColors.primaryColor,)),
                                                ),
                                              )
                                            ],
                                          );
                                        })),
                                  ),
                                ),
                                Visibility(
                                  visible: initialItemForSingleItem == "Column",
                                  child: columnList.isEmpty ? const Align(
                                      alignment: Alignment.center,
                                      child: Text("Column not shared"))
                                      : ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: MediaQuery.of(context).size.height/5,
                                        maxHeight: MediaQuery.of(context).size.height/5
                                    ),
                                    child: GridView.count(
                                        crossAxisCount: !isPhone ? 3 : 3,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 2.0,
                                        childAspectRatio: 2.5,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: List.generate(columnList.length, (index) {
                                          return Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(25),
                                                    border: Border.all(color: AppColors.primaryColor,width: 3)
                                                ),
                                                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(columnList[index].createdAt!)))),
                                              ),
                                              Positioned(
                                                top: -2,
                                                right: -2,
                                                child: InkWell(
                                                  onTap: () {
                                                    shareSingleItemDetailsForDelete(columnList[index]);
                                                    setState(() {
                                                      columnList.removeAt(index);
                                                    });
                                                    onDeleteTap();
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: AppColors.hoverColor,
                                                          borderRadius: BorderRadius.circular(100)),
                                                      child: const Icon(Icons.cancel,color: AppColors.primaryColor,)),
                                                ),
                                              )
                                            ],
                                          );
                                        })),
                                  ),
                                ),
                                Visibility(
                                  visible: initialItemForSingleItem == "NAQ",
                                  child: naqList.isEmpty ? const Align(
                                      alignment: Alignment.center,
                                      child: Text("NAQ not shared"))
                                      : ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: MediaQuery.of(context).size.height/5,
                                        maxHeight: MediaQuery.of(context).size.height/5
                                    ),
                                    child: GridView.count(
                                        crossAxisCount: !isPhone ? 3 : 3,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 2.0,
                                        childAspectRatio: 2.5,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: List.generate(naqList.length, (index) {
                                          return Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(25),
                                                    border: Border.all(color: AppColors.primaryColor,width: 3)
                                                ),
                                                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(naqList[index].createdAt!)))),
                                              ),
                                              Positioned(
                                                top: -2,
                                                right: -2,
                                                child: InkWell(
                                                  onTap: () {
                                                    shareSingleItemDetailsForDelete(naqList[index]);
                                                    setState(() {
                                                      naqList.removeAt(index);
                                                    });
                                                    onDeleteTap();
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: AppColors.hoverColor,
                                                          borderRadius: BorderRadius.circular(100)),
                                                      child: const Icon(Icons.cancel,color: AppColors.primaryColor,)),
                                                ),
                                              )
                                            ],
                                          );
                                        })),
                                  ),
                                ),
                                Visibility(
                                  visible: initialItemForSingleItem == "Ladder",
                                  child: ladderList.isEmpty ? const Align(
                                      alignment: Alignment.center,
                                      child: Text("Ladder not shared"))
                                      : ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: MediaQuery.of(context).size.height/5,
                                        maxHeight: MediaQuery.of(context).size.height/5
                                    ),
                                    child: GridView.count(
                                        crossAxisCount: !isPhone ? 3 : 3,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 2.0,
                                        childAspectRatio: 2.5,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: List.generate(ladderList.length, (index) {
                                          return Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(25),
                                                    border: Border.all(color: AppColors.primaryColor,width: 3)
                                                ),
                                                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(ladderList[index].createdAt!)))),
                                              ),
                                              Positioned(
                                                top: -2,
                                                right: -2,
                                                child: InkWell(
                                                  onTap: () {
                                                    shareSingleItemDetailsForDelete(ladderList[index]);
                                                    setState(() {
                                                      ladderList.removeAt(index);
                                                    });
                                                    onDeleteTap();
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: AppColors.hoverColor,
                                                          borderRadius: BorderRadius.circular(100)),
                                                      child: const Icon(Icons.cancel,color: AppColors.primaryColor,)),
                                                ),
                                              )
                                            ],
                                          );
                                        })),
                                  ),
                                ),
                              ],
                            ) :  Align(
                                alignment: Alignment.center,
                                child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: MediaQuery.of(context).size.height/5,
                                        maxHeight: MediaQuery.of(context).size.height/5
                                    ),
                                    child: const Text("Nothing shared yet")))
                            // const Text('Ladder:',style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.columnDetailsScreenFontSize,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4),
                        child: InkWell(
                          onTap: () {
                            List<String> selectedModule1 ;
                            setState(() {
                              if(selectedModule.contains("All")) {
                                selectedModule1 = ['All'];
                              } else {
                                selectedModule1 = selectedModule;
                              }
                              selectedModuleValue(selectedModule1);
                            });
                            if(!isSendCalled){
                              onTap();
                            }
                            setState(() {
                              isSendCalled = true;
                            });

                          },
                          child: IgnorePointer(
                            ignoring: isSendCalled,
                            child: OptionMcqAnswer(
                              isSendCalled ? Center(child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                  height: 30,
                                  width: 20,
                                  child: const CircularProgressIndicator())) : Container(
                                alignment: Alignment.center,
                                child: const Text("Update",style: TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.headingFontSize),),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  });
}
