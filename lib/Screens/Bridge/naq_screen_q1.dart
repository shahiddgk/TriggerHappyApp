// ignore_for_file: avoid_print, unused_element

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/model/request_model/response_email_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../model/reponse_model/naq__response_model.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../Widgets/toast_message.dart';
import '../utill/userConstants.dart';
import 'bridge_category_screen.dart';
import 'naq_prev_next_button.dart';
import 'package:circular_progress_stack/circular_progress_stack.dart';

class NaqScreen1 extends StatefulWidget {
  const NaqScreen1({Key? key}) : super(key: key);

  @override
  State<NaqScreen1> createState() => _NaqScreen1State();
}

class _NaqScreen1State extends State<NaqScreen1> {

  final confettiController = ConfettiController();
  bool isConfettiPlaying = false;

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isLoading = true;
  bool _isDataLoading = false;
  String email = "";
  String timeZone = "";
  String userType = "";

  bool isTextField = true;
  bool isYesNo = false;
  bool isOptions = false;

  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";
  String allowEmail = "";
  String errorMessage = "";
  bool isValidatedQ1 = false;
  bool isRadioValidatedQ1 = false;
  bool isValidatedQ2 = false;
  bool isRadioValidatedQ2 = false;
  bool isValidatedQ3 = false;
  bool isRadioValidatedQ3 = false;

  bool isValidatedQ1TextField = false;
  bool isValidatedQ2TextField = false;

  int index = 0;
  List <dynamic> optionListSampleArray = [];
  List  optionListSampleArrayForTextEditingController = [];
  List <dynamic> selectedItemsID = [];
  List <dynamic> formKeys = [];
  List selectedItems = [];
  List simpleSelectedItems = [];
  Map<String, dynamic> myAnswerMap= {};
  late bool isPhone;

  String answer1 = "";
  String answer2 = "";

  String naqListLength = "";

  late NaqModelClassResponse naqModelClassResponse;
  // List<naq_reponse_model> naqListResponse = <naq_reponse_model>[];
  int naqModelClassResponseLength = 0;

  List <TextEditingController> fieldController = <TextEditingController>[TextEditingController(),TextEditingController()];

  List <String> questionOptions = [];
  String? selectedItem;
    String? selectedString;
  Future<bool> _onWillPop() async {
    // if(nameController.text.isNotEmpty || descriptionController.text.isNotEmpty || purposeController.text.isNotEmpty || mentorNameController.text.isNotEmpty || mentorDescriptionController.text.isNotEmpty || peerNameController.text.isNotEmpty || peerDescriptionController.text.isNotEmpty || menteeNameController.text.isNotEmpty || menteeDescriptionController.text.isNotEmpty) {
    //   _setTrellisData();
    // }

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));

    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    confettiController.play();
    _getQuestions();
    _getUserData();

    super.initState();
  }



  _getAnswerData() async {
    // setState(() {
    //   _isUserDataLoading = true;
    // });
    print("Data List getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.setInt("NaqIndex", index-1);

    final storedAnswerList = sharedPreferences.getString("answerList");
    final storedQuestionIdList = sharedPreferences.getString("answerIdList");

    setState(() {
       index  = sharedPreferences.getInt("NaqIndex")!;
      fieldController[0].text = sharedPreferences.getString("answer1forQ1")!;
      fieldController[1].text = sharedPreferences.getString("answer2forQ2")!;
    });



    optionListSampleArray = jsonDecode(storedAnswerList!);
    selectedItemsID = jsonDecode(storedQuestionIdList!);


    for (int i = 0; i < naqModelClassResponse.questions.length; i++) {
      for (int j = 0; j < naqModelClassResponse.questions[i].length; j++ ) {

        if(naqModelClassResponse.questions[i][j].responseType == "open_text") {
          print("Answer Text");
          print(optionListSampleArray[i][j]);
          if(optionListSampleArray[i][j]!="-1") {
            setState(() {
              optionListSampleArrayForTextEditingController[i][j].text =
              optionListSampleArray[i][j];
            });
          }
        }
      }
      }

  }

  @override
  void dispose() {
    // Dispose the controllers when they are no longer needed
    confettiController.dispose();
    super.dispose();
  }

  _getQuestions()  {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().getNaqQuestions("naq").then((value) {
      print(value);
      // ignore: duplicate_ignore
      setState(() {

        naqModelClassResponseLength = value.questions.length;
        print("List Length");
        print(naqModelClassResponseLength);
        //  if(value.values.isNotEmpty) {
        //  questionListResponseLength = value.values.length;
        naqModelClassResponse = value;
        print(naqModelClassResponse);
        for(int i =0;i<naqModelClassResponse.questions.length; i++) {
            print(i);
              optionListSampleArray.insert(i, ["-1","-1","-1"]);
              optionListSampleArrayForTextEditingController.insert(i, [TextEditingController(),TextEditingController(),TextEditingController()]);
            selectedItemsID.insert(i, ["-1","-1","-1"]);
            formKeys.insert(i, GlobalKey<FormState>());
        }
        _getAnswerData();
        //  } else {

        // }
        print("Option Sample arrya list");
        print(formKeys);
        print(optionListSampleArray);
        print(optionListSampleArrayForTextEditingController);
        print(optionListSampleArray.length);
        _isLoading = false;
      });
    }).catchError((e){
      print(e.toString());
      setState(() {
        naqModelClassResponseLength == 0;
        _isLoading = false;
        errorMessage = e.toString();
      });
      showToastMessage(context, e.toString(),false);
    });
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    allowEmail = sharedPreferences.getString(UserConstants().allowEmail)!;
    userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
    userPremiumType = sharedPreferences.getString(UserConstants().userPremiumType)!;
    userCustomerId = sharedPreferences.getString(UserConstants().userCustomerId)!;
    userSubscriptionId = sharedPreferences.getString(UserConstants().userSubscriptionId)!;

    //_getTrellisReadData();
   // _getNAQResonseList(id);
    setState(() {
      _isUserDataLoading = false;
    });
  }

  // _getNAQResonseList(String id) {
  //   setState(() {
  //     _isLoading2 = true;
  //   });
  //
  //   HTTPManager().naqResponseList(LogoutRequestModel(userId: id)).then((value) {
  //     print(value);
  //     setState(() {
  //       _isLoading2 = false;
  //       naqListResponse = value.values;
  //       naqListLength = value.values.length.toString();
  //     });
  //     print("Naq list length");
  //     print(naqListLength);
  //   }).catchError((e){
  //     print(e);
  //     setState(() {
  //       _isLoading2 = false;
  //     });
  //   });
  // }

  getScreenDetails() {
    // setState(() {
    //   _isDataLoading = true;
    // });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    // setState(() {
    //   _isDataLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
            onPressed: () {
              // if(nameController.text.isNotEmpty || descriptionController.text.isNotEmpty || purposeController.text.isNotEmpty || mentorNameController.text.isNotEmpty  || peerNameController.text.isNotEmpty || menteeNameController.text.isNotEmpty ) {
              //   _setTrellisData();
              // }
              Navigator.of(context).pop();
            },
          ),
          title: Text(_isUserDataLoading ? "" : name),
          actions:  [
            PopMenuButton(false,true,id)
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding:const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LogoScreen("NAQ"),
                          // const SizedBox(width: 20,),
                          // IconButton(onPressed: (){
                          //   // String? videoId = YoutubePlayer.convertUrlToId(introUrl);
                          //   // YoutubePlayerController playerController = YoutubePlayerController(
                          //   //     initialVideoId: videoId!,
                          //   //     flags: const YoutubePlayerFlags(
                          //   //       autoPlay: false,
                          //   //       controlsVisibleAtStart: false,
                          //   //     )
                          //   //
                          //   // );
                          //   // videoPopupDialog(context,"Introduction to Trellis",playerController);
                          //   //bottomSheet(context,"Trellis","Welcome to Trellis, the part of the Brugeon app designed to help you flourish and live life intentionally. Trellis is a light structure that provides structure and focus, and helps propel you towards your desired outcomes. Invest at least five minutes a day in reviewing and meditating on your Trellis. If you don't have any answers yet, spend your time meditating, praying, or journaling on the questions/sections. If you have partial answers, keep taking your time daily to consider the questions and your answers. By consistently returning to your Trellis, you will become more clear and focused on creating the outcomes you desire. Enjoy your Trellis!","");
                          // }, icon: const Icon(Icons.ondemand_video,size:30,color: AppColors.infoIconColor,)),
                          // const SizedBox(height: 5,),

                        ],
                      ),
                    ),
                  ),
                  const Divider(color: AppColors.primaryColor,
                  thickness: 1,
                  ),
                 _isLoading ? const CircularProgressIndicator() : naqModelClassResponse.questions.isEmpty ? QuestionTextWidget("", "urlText", (){}, false)  : Column(
                    children: [
                      QuestionTextWidget("Step # ${index+1} / ${naqModelClassResponse.questions.length}", "urlText", (){}, false),
                      // index+1 == naqModelClassResponse.questions.length ?
                      // QuestionTextWidget(naqModelClassResponse.questions[index-1].title, "urlText", (){}, false)
                      // : QuestionTextWidget(naqModelClassResponse.questions[index].title, "urlText", (){}, false),

                      ListView.builder(
                        physics:const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                          itemCount: naqModelClassResponse.questions[index].length,
                          itemBuilder: (context, questionIndex) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                QuestionTextWidget(naqModelClassResponse.questions[index][questionIndex].title, "urlText", (){}, false),
                                Visibility(
                                  visible: isRadioValidatedQ1 && naqModelClassResponse.questions[index][0].responseType == "radio_btn" && questionIndex == 0,
                                  child: const Align(alignment: Alignment.centerLeft,
                                    child: Text("   Please select any option  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                  ),
                                ),
                                Visibility(
                                  visible: isRadioValidatedQ2 && naqModelClassResponse.questions[index][1].responseType == "radio_btn" && questionIndex == 1,
                                  child: const Align(alignment: Alignment.centerLeft,
                                    child: Text("   Please select any option  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                  ),
                                ),
                                Visibility(
                                  visible: isRadioValidatedQ3 && naqModelClassResponse.questions[index][2].responseType == "radio_btn" && questionIndex == 2,
                                  child: const Align(alignment: Alignment.centerLeft,
                                    child: Text("   Please select any option",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                  ),
                                ),
                                Visibility(
                                  visible: naqModelClassResponse.questions[index][questionIndex].responseType == "radio_btn",
                                  child: GridView(
                                    physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: isPhone ? 2 : 4,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: index == 0 ? 3 : 4,
                                      ),
                                      children: List.generate(naqModelClassResponse.questions[index][questionIndex].options.length, (index1) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            listTileTheme:const ListTileThemeData(
                                              horizontalTitleGap: 1,//here adjust based on your need
                                            ),
                                          ),
                                          child: RadioListTile<String>(
                                              title:naqModelClassResponse.questions[index][questionIndex].options[index1].length > 3 ? Text("${index1 + 1} - ${naqModelClassResponse.questions[index][questionIndex].options[index1]}",style:const TextStyle( fontSize: AppConstants.defaultFontSize),) : Text(naqModelClassResponse.questions[index][questionIndex].options[index1],style:const TextStyle( fontSize: AppConstants.defaultFontSize),),
                                              value: naqModelClassResponse.questions[index][questionIndex].options[index1] + naqModelClassResponse.questions[index][questionIndex].id,
                                              groupValue: optionListSampleArray[index][questionIndex],
                                              controlAffinity: ListTileControlAffinity.leading,
                                              hoverColor: AppColors.backgroundColor,
                                              onChanged: (String? value) {
                                                // if(questionIndex == 0 && value!.substring(0,2) == "No" ) {
                                                //   fieldController[0].text = "";
                                                //   fieldController[0].clear();
                                                // } else if(questionIndex == 1 && value!.substring(0,2) == "No") {
                                                //   fieldController[1].text = "";
                                                //   fieldController[1].clear();
                                                // }
                                                print(value);
                                                print(naqModelClassResponse.questions[index][questionIndex].options[index1]);
                                                setState(() {
                                                  print("Selected value");
                                                  print(value);
                                                  optionListSampleArray[index][questionIndex] = value!;
                                                  selectedItemsID[index][questionIndex] = naqModelClassResponse.questions[index][questionIndex].id;
                                                  print("Question with radio buttons");
                                                  print(naqModelClassResponse.questions[index][questionIndex]);
                                                  print(value);
                                                  print(optionListSampleArray);
                                                  // selectedString = naqModelClassResponse.questions[index][questionIndex].options[index1].toString().substring(0,2);
                                                });
                                              }),
                                        );
                                      } ),

                                  ),
                                ),
                                Visibility(
                                  visible: isValidatedQ1TextField && naqModelClassResponse.questions[index][0].responseType == "radio_btn" && questionIndex == 0,
                                  child: const Align(alignment: Alignment.centerLeft,
                                    child: Text("   Please enter detail for yes!  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                  ),
                                ),
                                Visibility(
                                  visible: isValidatedQ2TextField && naqModelClassResponse.questions[index][1].responseType == "radio_btn"&& questionIndex == 1,
                                  child: const Align(alignment: Alignment.centerLeft,
                                    child: Text("   Please enter detail for yes!  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                  ),
                                ),
                                if(naqModelClassResponse.questions[index][questionIndex].responseType == "radio_btn" && index == 0 && questionIndex < 2)
                                Visibility(
                                  visible: optionListSampleArray[0][questionIndex].toString().substring(0,2) == "Ye",
                                  child: Container(
                                      padding:const EdgeInsets.symmetric(horizontal: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.naqFieldColor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: TextFormField(
                                          // autofocus: true,
                                          controller: fieldController[questionIndex],
                                          textInputAction: TextInputAction.done,
                                          style: const TextStyle(fontSize: AppConstants.defaultFontSize),
                                          decoration:const InputDecoration(
                                              hintText: "Why yes?",
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                              border: InputBorder.none
                                          ),
                                          validator: (value) {
                                            if(value!.trim().isEmpty) {
                                              setState(() {
                                                errorMessage = "";
                                                //isValidated = true;
                                              });
                                              return "";
                                            } else {
                                              setState(() {
                                                errorMessage = "";
                                               // isValidated = false;
                                              });
                                              return null;
                                            }
                                          },
                                          onTapOutside: (value) {
                                            setState(() {
                                              answer1 = fieldController[0].text;
                                              answer2 = fieldController[1].text;
                                            });
                                            // print(answer1);
                                            // print(answer2);
                                            },
                                          maxLines: 2,
                                          maxLength: 100,
                                        ),
                                      )
                                  ),
                                ),

                                Visibility(
                                  visible: isValidatedQ1 && naqModelClassResponse.questions[index][0].responseType == "open_text" && questionIndex == 0,
                                  child: const Align(alignment: Alignment.centerLeft,
                                    child: Text("   Write Some thing here  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                  ),
                                ),
                                Visibility(
                                  visible: isValidatedQ2 && naqModelClassResponse.questions[index][1].responseType == "open_text"&& questionIndex == 1,
                                  child: const Align(alignment: Alignment.centerLeft,
                                    child: Text("   Write Some thing here  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                  ),
                                ),
                                Visibility(
                                  visible: isValidatedQ3 && naqModelClassResponse.questions[index][2].responseType == "open_text" && questionIndex == 2,
                                  child: const Align(alignment: Alignment.centerLeft,
                                    child: Text("   Write Some thing here  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                  ),
                                ),
                                Visibility(
                                  visible: naqModelClassResponse.questions[index][questionIndex].responseType == "open_text",
                                  child: Container(
                                      padding:const EdgeInsets.symmetric(horizontal: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.naqFieldColor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: TextFormField(
                                          // autofocus: true,
                                          controller: optionListSampleArrayForTextEditingController[index][questionIndex],
                                          textInputAction: TextInputAction.done,
                                          style: const TextStyle(fontSize: AppConstants.defaultFontSize),
                                          decoration:const InputDecoration(
                                              hintText: "write something here",
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                              border: InputBorder.none
                                          ),
                                          validator: (value) {
                                            if(value!.trim().isEmpty) {
                                              setState(() {
                                                errorMessage = "write something here ";
                                                // isValidated = true;
                                              });
                                              return "";
                                            } else {
                                              setState(() {
                                                errorMessage = "";
                                                // isValidated = false;
                                              });
                                              return null;
                                            }
                                          },
                                          onTapOutside: (value) {
                                            if(optionListSampleArrayForTextEditingController[index][questionIndex].text != "") {
                                                        optionListSampleArray[index][questionIndex] = optionListSampleArrayForTextEditingController[index][questionIndex].text;
                                                        selectedItemsID[index][questionIndex] = naqModelClassResponse.questions[index][questionIndex].id;
                                                      } else {
                                              optionListSampleArray[index][questionIndex] = "-1";
                                              selectedItemsID[index][questionIndex] = "-1";
                                            }
                                                      // optionListSampleArray.insert(questionIndex, optionListSampleArrayForTextEditingController[questionIndex].text);
                                            print("Question with text field");
                                            print(questionIndex);
                                            print(optionListSampleArray);
                                            print(selectedItemsID);

                                          },
                                          maxLines: 5,
                                        ),
                                      )
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Divider(color: AppColors.primaryColor,
                                  thickness: 1,
                                ),
                              ],
                            );
                          }),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // const Divider(color: AppColors.primaryColor,
                      //   thickness: 1,
                      // ),
                      naqPrevNextButton(()  {


                        setState(() {
                          errorMessage = "";
                          isValidatedQ1 = false;
                          isRadioValidatedQ1 = false;
                          isValidatedQ2 = false;
                          isRadioValidatedQ2 = false;
                          isValidatedQ3 = false;
                          isRadioValidatedQ3 = false;
                          isValidatedQ1TextField = false;
                          isValidatedQ2TextField = false;
                          if(index != 0) {
                            index = index - 1;
                          }
                          // removeAnswerFromLocal(index);
                          // isTextField = false;
                          // isYesNo = true;
                          // isOptions = false;
                        });
                        print("Previous pressed!");
                        print(index);
                        print(optionListSampleArray);
                      },() async {
                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

                        final answerListJasonStore = jsonEncode(optionListSampleArray);
                        final selectedItemsIdJsonStore = jsonEncode(selectedItemsID);

                        sharedPreferences.setString("answerList", answerListJasonStore);
                        sharedPreferences.setString("answerIdList", selectedItemsIdJsonStore);

                        sharedPreferences.setString("answer1forQ1", fieldController[0].text);
                        sharedPreferences.setString("answer2forQ2", fieldController[1].text);
                        if(_validateForm() ) {
                          setState(() {
                            errorMessage = "";
                            isValidatedQ1 = false;
                            isRadioValidatedQ1 = false;
                            isValidatedQ2 = false;
                            isRadioValidatedQ2 = false;
                            isValidatedQ3 = false;
                            isRadioValidatedQ3 = false;
                            isValidatedQ1TextField = false;
                            isValidatedQ2TextField = false;
                            if(index+1 != naqModelClassResponse.questions.length) {
                              index = index + 1;
                            }

                            sharedPreferences.setInt("NaqIndex", index);

                          });
                          print("Next pressed!");
                          // print(optionListSampleArray);
                          print(selectedItemsID);
                           print(index);
                        }

                      },index == 0 ? false : true, index+1 == naqModelClassResponse.questions.length ? false : true),
                      //
                      Visibility(
                          visible: index+1 == naqModelClassResponse.questions.length,
                          child: ElevatedButton(
                              onPressed: (){
                                if(_validateForm()) {
                                  setState(() {
                                    errorMessage = "";
                                    isValidatedQ1 = false;
                                    isRadioValidatedQ1 = false;
                                    isValidatedQ2 = false;
                                    isRadioValidatedQ2 = false;
                                    isValidatedQ3 = false;
                                    isRadioValidatedQ3 = false;

                                    saveAnswerOnLocal(selectedItemsID,optionListSampleArray,fieldController[0].text,fieldController[1].text);

                                  });
                                  print("Next pressed!");
                                  print(optionListSampleArray);
                                  print(selectedItemsID);
                                  print(index);
                                }

                              },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(MediaQuery.of(context).size.width/2, 40), // Set the minimum width and height
                              padding: EdgeInsets.zero, // Remove any default padding
                            ),
                              child:const Text("Submit",style: TextStyle(color: AppColors.backgroundColor),),
                          )),
                      const SizedBox(height: 10,),
                    ],
                  )

                ],
              ),
            ),
            _isDataLoading ?
            const Center(child: CircularProgressIndicator())
                : Container() ,
          ],
        ),
      ),
    );
  }

  String _validateField(String value) {
      if (value.isEmpty) {
        setState(() {
          errorMessage = "write something here ";
          // isValidated = true;
        });
        return 'write something here';
      } else {
        setState(() {
          errorMessage = "";
          // isValidated = false;
        });
        return "";
      }
  }

  bool _validateForm() {
    print("Next pressed22");
    print(fieldController[0].text);
    print(fieldController[1].text);
    // print(optionListSampleArray[index][0]);
    // print(optionListSampleArray[index][1]);
    // print(optionListSampleArray[index][2]);
    // print(optionListSampleArray[index].length);

    setState(() {
      isValidatedQ1 = false;
      isRadioValidatedQ1 = false;
      isValidatedQ2 = false;
      isRadioValidatedQ2 = false;
      isValidatedQ3 = false;
      isRadioValidatedQ3 = false;
      isValidatedQ1TextField = false;
       isValidatedQ2TextField = false;
    });

    String a1 = "";
    String a2 = "";
    String a3 = "";

    if(naqModelClassResponse.questions[index].length == 3) {
      setState(() {
        a1 = optionListSampleArray[index][0];
        a2 = optionListSampleArray[index][1];
        a3 = optionListSampleArray[index][2];
      });
    } else if(naqModelClassResponse.questions[index].length == 2) {
      setState(() {
        a1 = optionListSampleArray[index][0];
        a2 = optionListSampleArray[index][1];
      });
    } else if(naqModelClassResponse.questions[index].length == 1) {
      setState(() {
        a1 = optionListSampleArray[index][0];
      });
    }

    if(a1 == "-1") {
      if(naqModelClassResponse.questions[index][0].responseType == "open_text") {
        setState(() {
          errorMessage = "write something here ";
          isValidatedQ1 = true;
        });
      } else {
        setState(() {
                errorMessage = "Please Select any option ";
                isRadioValidatedQ1 = true;
              });
      }
      return false;
    } else if(fieldController[0].text == "" && optionListSampleArray[0][0].toString().substring(0,2) == "Ye") {
      setState(() {
        isValidatedQ1TextField = true;
      });
      return false;
    } else if(fieldController[1].text == "" && optionListSampleArray[0][1].toString().substring(0,2) == "Ye") {
      setState(() {
        isValidatedQ2TextField = true;
      });
      return false;
    } else if(a2 == "-1") {
      if(naqModelClassResponse.questions[index][1].responseType == "open_text") {
        setState(() {
          errorMessage = "write something here ";
          isValidatedQ2 = true;
        });
      } else {
        setState(() {
          errorMessage = "Please Select any option ";
          isRadioValidatedQ2 = true;
        });
      }
      return false;
    } else if(a3 == "-1") {
      if(naqModelClassResponse.questions[index][2].responseType == "open_text") {
        setState(() {
          errorMessage = "write something here ";
          isValidatedQ3 = true;
        });
      } else {
        setState(() {
          errorMessage = "Please Select any option ";
          isRadioValidatedQ3 = true;
        });
      }
      return false;
    } else {
      return true;
    }
  }
  setMapForApi(List answerList,List idList) async {
    for (int i = 0; i < idList.length; i++) {
      myAnswerMap[idList[i]] = answerList[i];
    }

    print("Answer Map List");
    print(myAnswerMap);
    print(answerList.length);
    print(idList.length);

    if(myAnswerMap.isNotEmpty) {
      final String encodedData = jsonEncode(myAnswerMap);
      setState(() {
        _isDataLoading = true;
      });
       SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      HTTPManager().userNaqResponseEmail(UserResponseRequestModel(name: name, email: email, userId: id, answerMap: encodedData)).then((value) {
        confettiController.play();
        print(value);
        sharedPreferences.remove("answerList");
        sharedPreferences.remove("NaqIndex");
        sharedPreferences.remove("answer1forQ1");
        sharedPreferences.remove("answer2forQ2");
        sharedPreferences.remove("answerIdList");
        showScorePopUp(int.parse(value['total_score'].toString()));

        if(allowEmail == "yes") {
          showToastMessage(context, value['message'].toString(), true);
        } else {
          showToastMessage(context, "Submitted successfully", true);
        }
        //Navigator.of(context).pop();
        setState(() {
          _isDataLoading = false;
        });
      }).catchError((e) {
        print(e);
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Dashboard()), (route) => false);
    }
  }

  saveAnswerOnLocal(List <dynamic> answerArray,List <dynamic> questionIdArray,String an1,String an2) {
   print("Save Pressed");
    print(an1);
    print(an2);

    List answerTextList = [];
  List questionIdList = [];
  String? answer;

    for (int i = 0; i < naqModelClassResponse.questions.length; i++) {
      for (int j = 0; j < naqModelClassResponse.questions[i].length; j++ ) {
        if(optionListSampleArray[i][j] != "-1" || optionListSampleArray[i][j] != "" ) {
          if(naqModelClassResponse.questions[i][j].responseType == "radio_btn") {
            if (optionListSampleArray[i][j].toString().substring(0, 2) == "Ye") {
              setState(() {
                answer = "yes";
              });
            } else if (optionListSampleArray[i][j].toString().substring(0, 2) == "No") {
              setState(() {
                answer = "No";
              });
            } else if (optionListSampleArray[i][j].toString().substring(0, 2) == "Ne") {
              setState(() {
                answer = "Never";
              });
            } else if (optionListSampleArray[i][j].toString().substring(0, 2) == "Ra") {
              setState(() {
                answer = "Rarely";
              });
            } else if (optionListSampleArray[i][j].toString().substring(0, 2) == "Of") {
              setState(() {
                answer = "Often";
              });
            } else if (optionListSampleArray[i][j].toString().substring(0, 2) == "Al") {
              setState(() {
                answer = "Always";
              });
            }
          } else {
            setState(() {
              answer = optionListSampleArray[i][j];
            });
          }
          if(answer == "yes" && optionListSampleArray[i][j].toString().substring(0,2) == "Ye" && naqModelClassResponse.questions[i][j].responseType == "radio_btn") {
           if(i == 0 && j == 0) {
            setState(() {
              dynamic answerText1 = {
                "type": naqModelClassResponse.questions[i][j].responseType,
                "answer": [answer],
                "res_text":an1
              };
              questionIdList.add(selectedItemsID[i][j]);
              answerTextList.add(answerText1);
            });
           } else if(i == 0 && j == 1) {
             setState(() {
               dynamic answerText2 = {
                 "type": naqModelClassResponse.questions[0][1].responseType,
                 "answer": [answer],
                 "res_text":an2
               };
               questionIdList.add(selectedItemsID[i][j]);
               answerTextList.add(answerText2);
             });
           }

            // if(numberExecution == 0) {
            // setState(() {
            //
            //
            //   answerTextList.add(answerText2);
            //   numberExecution = 1;
            //   });
            // }
          }  else {
            setState(() {
              dynamic answerText = {
                "type": naqModelClassResponse.questions[i][j].responseType,
                "answer": [answer]
              };
              answerTextList.add(answerText);
              questionIdList.add(selectedItemsID[i][j]);
            });
          }
        }
      }
    }
  print("Any Option addition to list");
    print(answerTextList.length);
    print(questionIdList.length);
    print(answerTextList);
    print(questionIdList);
    if(answerTextList.isNotEmpty && questionIdList.isNotEmpty) {
      setMapForApi(answerTextList,questionIdList);
    }
  }
  showScorePopUp(int score) {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: _onWillPop,
            child: SafeArea(
              child: AlertDialog(
                shape: CircularAlertDialogShape(),
                content:Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height/3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: AnimatedStackCircularProgressBar(
                              size: MediaQuery.of(context).size.height/4,
                              progressStrokeWidth: 15,
                              backStrokeWidth: 15,
                              startAngle: 0,
                              backColor: const Color(0xffD7DEE7),
                              bars: [
                                AnimatedBarValue(
                                  barColor: AppColors.primaryColor,
                                  barValues: score.toDouble(),
                                  fullProgressColors: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin:const EdgeInsets.only(bottom: 10),
                                child: const Text('Congratulation!',style: TextStyle(
                                    fontSize: AppConstants.headingFontSize,
                                    color: AppColors.primaryColor
                                ),),
                              ),
                              Container(
                                  margin:const EdgeInsets.only(bottom: 10),
                                  child: const Text('Your score is',style: TextStyle(
                                      fontSize: AppConstants.headingFontSize
                                  ),)),
                              Text('$score',style:const TextStyle(
                                  fontSize: AppConstants.logoFontSizeForMobile,
                                color: AppColors.primaryColor
                              ),),
                            ],
                          ),
                          Center(
                            child: ConfettiWidget(
                              blastDirection: -pi /2,
                              confettiController: confettiController,
                              shouldLoop: false,
                              emissionFrequency: 0.10,
                              blastDirectionality: BlastDirectionality.explosive,
                              numberOfParticles: 10,
                              minBlastForce: 5,
                              maxBlastForce: 30,
                            ),
                          ),
                        ],
                      ),
                     const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const BridgeCategoryScreen()));
                      },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          minimumSize: Size(MediaQuery.of(context).size.width/2, 40), // Set the minimum width and height
                          padding: EdgeInsets.zero, // Remove any default padding
                        ),
                        child:const Text("Back to Home Screen",style: TextStyle(color: AppColors.backgroundColor),),)
                    ],
                  )
                ),
              ),
            ),
          );
        });
  }
}

class CircularAlertDialogShape extends RoundedRectangleBorder {
   CircularAlertDialogShape({this.radius = 20.0})
      : super(
    side: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );

  final double radius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(radius);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect).deflate(10.0));
  }
}
