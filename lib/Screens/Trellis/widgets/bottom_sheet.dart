

// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/date_picker_field.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/save_button_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                          child: NameField(widget.titleForGController,"title",1,70,true)),
                      Container(
                          margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                          child: NameField(widget.descriptionForGController,"description",4,70,true)),
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
    BuildContext context,
    bool isGoals,
    String heading, String type,
    String initialValueForType,
    List itemsForType,
    String initialValueForGoals,
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

  String initialValueForType = "physical";
  List itemsForType = ["physical","Emotional","Relational","Work","Financial","Spiritual"];

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
                              child: Row(
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
                                        child: Text("Goals/Challenges",maxLines: 1,style: TextStyle(color: isGoals ? AppColors.backgroundColor : AppColors.primaryColor),),
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
                                        child: Text("Memories/achievements",maxLines: 1,style: TextStyle(color: !isGoals ? AppColors.backgroundColor : AppColors.primaryColor),),
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
                                      initialValueForGoals = value;
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
