// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/model/request_model/response_email_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../model/reponse_model/naq__response_model.dart';
import '../../model/reponse_model/naq_response_model.dart';
import '../../model/reponse_model/question_answer_response_model.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../Widgets/toast_message.dart';
import '../utill/userConstants.dart';
import 'naq_prev_next_button.dart';

class NaqScreen1 extends StatefulWidget {
  const NaqScreen1({Key? key}) : super(key: key);

  @override
  State<NaqScreen1> createState() => _NaqScreen1State();
}

class _NaqScreen1State extends State<NaqScreen1> {

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

  final _formKey = GlobalKey<FormState>();

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
  // Future<bool> _onWillPop() async {
  //   // if(nameController.text.isNotEmpty || descriptionController.text.isNotEmpty || purposeController.text.isNotEmpty || mentorNameController.text.isNotEmpty || mentorDescriptionController.text.isNotEmpty || peerNameController.text.isNotEmpty || peerDescriptionController.text.isNotEmpty || menteeNameController.text.isNotEmpty || menteeDescriptionController.text.isNotEmpty) {
  //   //   _setTrellisData();
  //   // }
  //
  //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
  //
  //   return true;
  // }

  @override
  void initState() {
    // TODO: implement initState
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
    final storedAnswerList = sharedPreferences.getString("answerList");
    int? naqIndexStored = sharedPreferences.getInt("NaqIndex");
    fieldController[0].text = sharedPreferences.getString("answer1forQ1")!;
    fieldController[1].text = sharedPreferences.getString("answer2forQ2")!;

    index  = naqIndexStored!;

    optionListSampleArray = jsonDecode(storedAnswerList!);


    for (int i = 0; i < naqModelClassResponse.questions.length; i++) {
      for (int j = 0; j < naqModelClassResponse.questions[i].length; j++ ) {

        if(naqModelClassResponse.questions[i][j].responseType == "open_text") {
          print("Answer Text");
          print(optionListSampleArray[i][j]);

          setState(() {
            optionListSampleArrayForTextEditingController[i][j].text =
                optionListSampleArray[i][j];
          });
        }
      }
      }

  }

  // @override
  // void dispose() {
  //   // Dispose the controllers when they are no longer needed
  //   for (var controller in optionListSampleArrayForTextEditingController) {
  //     controller.dispose();
  //   }
  //   super.dispose();
  // }

  _getQuestions(){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          PopMenuButton(false,false,id)
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
                                child: const Align(alignment: Alignment.centerRight,
                                  child: Text("Please select any option  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                ),
                              ),
                              Visibility(
                                visible: isRadioValidatedQ2 && naqModelClassResponse.questions[index][1].responseType == "radio_btn" && questionIndex == 1,
                                child: const Align(alignment: Alignment.centerRight,
                                  child: Text("Please select any option  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                ),
                              ),
                              Visibility(
                                visible: isRadioValidatedQ3 && naqModelClassResponse.questions[index][2].responseType == "radio_btn" && questionIndex == 2,
                                child: const Align(alignment: Alignment.centerRight,
                                  child: Text("Please select any option  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                ),
                              ),
                              Visibility(
                                visible: naqModelClassResponse.questions[index][questionIndex].responseType == "radio_btn",
                                child: GridView(
                                  physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio:  3  ,
                                    ),
                                    children: List.generate(naqModelClassResponse.questions[index][questionIndex].options.length, (index1) {
                                      return RadioListTile<String>(
                                          title: Text(naqModelClassResponse.questions[index][questionIndex].options[index1]),
                                          value: naqModelClassResponse.questions[index][questionIndex].options[index1] + naqModelClassResponse.questions[index][questionIndex].id,
                                          groupValue: optionListSampleArray[index][questionIndex],
                                          onChanged: (String? value) {
                                            if(questionIndex == 0 && value!.substring(0,2) == "Ye" || value!.substring(0,2) == "No" ) {
                                              fieldController[0].text = "";
                                              fieldController[0].clear();
                                            } else if(questionIndex == 1 && value.substring(0,2) == "Ye" || value.substring(0,2) == "No") {
                                              fieldController[1].text = "";
                                              fieldController[1].clear();
                                            }
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
                                          });
                                    } ),

                                ),
                              ),
                              Visibility(
                                visible: isValidatedQ1TextField && naqModelClassResponse.questions[index][0].responseType == "radio_btn" && questionIndex == 0,
                                child: const Align(alignment: Alignment.centerRight,
                                  child: Text("Please enter detail for yes!  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                ),
                              ),
                              Visibility(
                                visible: isValidatedQ2TextField && naqModelClassResponse.questions[index][1].responseType == "radio_btn"&& questionIndex == 1,
                                child: const Align(alignment: Alignment.centerRight,
                                  child: Text("Please enter detail for yes!  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                ),
                              ),
                              if(naqModelClassResponse.questions[index][questionIndex].responseType == "radio_btn" && index == 0)
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
                                      ),
                                    )
                                ),
                              ),

                              Visibility(
                                visible: isValidatedQ1 && naqModelClassResponse.questions[index][0].responseType == "open_text" && questionIndex == 0,
                                child: const Align(alignment: Alignment.centerRight,
                                  child: Text("Write Some thing here  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                ),
                              ),
                              Visibility(
                                visible: isValidatedQ2 && naqModelClassResponse.questions[index][1].responseType == "open_text"&& questionIndex == 1,
                                child: const Align(alignment: Alignment.centerRight,
                                  child: Text("Write Some thing here  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
                                ),
                              ),
                              Visibility(
                                visible: isValidatedQ3 && naqModelClassResponse.questions[index][2].responseType == "open_text" && questionIndex == 2,
                                child: const Align(alignment: Alignment.centerRight,
                                  child: Text("Write Some thing here  ",style: TextStyle(color: AppColors.redColor,fontSize: 13),),
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
                    },() async {
                      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

                      final answerListJasonStore = jsonEncode(optionListSampleArray);

                      sharedPreferences.setString("answerList", answerListJasonStore);

                      sharedPreferences.setString("answer1forQ1", answer1);
                      sharedPreferences.setString("answer2forQ2", answer2);

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

                          index = index + 1;

                          sharedPreferences.setInt("NaqIndex", index);

                        });
                        print("Next pressed!");
                        print(optionListSampleArray);
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

                                  saveAnswerOnLocal(selectedItemsID,optionListSampleArray);

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
                        ))
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
    );
  }

  // String _validateRadioOption(String value) {
  //   print("Radio_validation");
  //   print(value);
  //   print(isRadioValidated);
  //
  //   if (value == "-1") {
  //     setState(() {
  //       errorMessage = "Please Select any option ";
  //       isRadioValidated = true;
  //     });
  //     return 'Please Select any option';
  //   } else {
  //     setState(() {
  //       errorMessage = "";
  //       isRadioValidated = false;
  //     });
  //     return "";
  //   }
  // }
  //
  // bool _validateFormRadio() {
  //   print("Next pressed11");
  //   print(optionListSampleArrayForTextEditingController[index].length);
  //   for (int i = 0; i< optionListSampleArrayForTextEditingController[index].length; i++) {
  //     if (naqModelClassResponse.questions[index][i].responseType ==
  //         "radio_btn") {
  //       String error = _validateRadioOption(
  //           optionListSampleArray[index][i]);
  //       if (error == "") {
  //         return true;
  //       }
  //     }
  //   }
  //   return false;
  // }

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
    print(answer1);
    print(answer2);
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
    } else if(answer1 == "" && optionListSampleArray[0][0].toString().substring(0,2) == "Ye") {
      setState(() {
        isValidatedQ1TextField = true;
      });
      return false;
    } else if(answer2 == "" && optionListSampleArray[0][1].toString().substring(0,2) == "Ye") {
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

    if(myAnswerMap.isNotEmpty) {
      final String encodedData = jsonEncode(myAnswerMap);
      setState(() {
        _isDataLoading = true;
      });
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      HTTPManager().userNaqResponseEmail(UserResponseRequestModel(name: name, email: email, userId: id, answerMap: encodedData)).then((value) {

        print(value);
        sharedPreferences.remove("answerList");
        sharedPreferences.remove("NaqIndex");
        sharedPreferences.remove("answer1forQ1");
        sharedPreferences.remove("answer2forQ2");

        if(allowEmail == "yes") {
          showToastMessage(context, value['message'].toString(), true);
        }
        Navigator.of(context).pop();
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

  saveAnswerOnLocal(List <dynamic> answerArray,List <dynamic> questionIdArray) {
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
          setState(() {
           dynamic answerText = { "type": naqModelClassResponse.questions[i][j].responseType, "answer": [answer]};
           answerTextList.add(answerText);
           questionIdList.add(selectedItemsID[i][j]);
         });
        }
      }
    }
  print("Any Option addition to list");
    print(answerTextList);
    print(questionIdList);
    if(answerTextList.isNotEmpty && questionIdList.isNotEmpty) {
      setMapForApi(answerTextList,questionIdList);
    }
  }

  // removeAnswerFromLocal(int questionIndex) {
  //   print("Item removing index");
  //   print(questionIndex);
  //   print(questionListResponse[questionIndex].responseType);
  //    if(questionListResponse[questionIndex].responseType == "radio_btn") {
  //      if(questionListResponse[questionIndex].options.length == 2) {
  //        print("ForQuestion1 and 2");
  //        print(simpleSelectedItems[selectedItemsID.length-1]);
  //        if(simpleSelectedItems[selectedItemsID.length-1] == "No") {
  //          setState(() {
  //            selectedItem = 1;
  //          });
  //        } else {
  //          setState(() {
  //            selectedItem = 0;
  //          });
  //        }
  //        print(selectedItem);
  //      } else {
  //        print("For Question 6 till last ");
  //        if(simpleSelectedItems[selectedItemsID.length-1] == "Never") {
  //          setState(() {
  //            selectedItem = 0;
  //          });
  //        } else if(simpleSelectedItems[selectedItemsID.length-1] == "Rarely") {
  //          setState(() {
  //            selectedItem = 1;
  //          });
  //        } else if(simpleSelectedItems[selectedItemsID.length-1] == "Often") {
  //          setState(() {
  //            selectedItem = 2;
  //          });
  //        } else if(simpleSelectedItems[selectedItemsID.length-1] == "Always") {
  //          setState(() {
  //            selectedItem = 3;
  //          });
  //        }
  //        print(selectedItem);
  //      }
  //    } else {
  //      print("For Question 3,4,5,6 ");
  //      setState(() {
  //        _fieldController.text = simpleSelectedItems[selectedItemsID.length-1].toString();
  //      });
  //      print(_fieldController.text);
  //    }
  //   selectedItemsID.removeAt(selectedItemsID.length-1);
  //   selectedItems.removeAt(selectedItems.length-1);
  //   simpleSelectedItems.removeAt(simpleSelectedItems.length-1);
  // }
}
