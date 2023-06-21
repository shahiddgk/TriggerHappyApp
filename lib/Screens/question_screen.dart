
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/circular_button_widget.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Widgets/colors.dart';
import '../Widgets/video_player_in_pop_up.dart';

// ignore: must_be_immutable
class QuestionScreen extends StatefulWidget {
  QuestionScreen(this.id,{Key? key}) : super(key: key);
  String id;

  @override
  // ignore: library_private_types_in_public_api
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {

  String totalQuestions = "3";
  String currentQuestion = "1";
  String? _groupValue;
  int i=0;
  int j=0;

  bool a1 = false;
  bool a2 = false;
  bool a3 = false;
  bool a4 = false;

  List questions = [];
  List answersList = [];
  List selectedAnswer = [];

  @override
  void initState() {
    // TODO: implement initState
    if(widget.id == "0") {
      setState(() {
        questions = [
          {
           "question": "When a company invites its business contacts for an anniversary, this is referred to as?",
            "radio_Button" : true
           },
          {
            "question":"These kind of events require two or more speakers and a moderator. People present their views on a particular subject and the meeting is then opened for discussion among the speakers, who may also invite comments from the audience. What are they known as?",
            "radio_Button" : false
          },
          {
            "question": "What are the organizations that organize events such as golf tournaments, wine receptions, auctions, luncheons, etc., known as?",
            "radio_Button" : true
          }
        ];
        answersList = [{"a1":"Marketing for events","a2":"Marketing for relationships.","a3":"Marketing by events.","a4":"Marketing by business-to-business."},{"a1":"Panels","a2":"Conferences","a3":"Exhibitions","a4":"Seminars"},{"a1":"Nonprofit organizatons","a2":"Tradeshows/trade fairs","a3":"Tourist attractions","a4":"Social events"}];
      });
    } else if(widget.id == "1") {
      setState(() {
        questions = [
          {
           "question": "What do you call a computer on a network that requests files from another computer?",
            "radio_Button" : true
          },
          {
              "question" : "Hardware devices that are not part of the main computer system and are often added later to the system?",
              "radio_Button" : true
          },
          {
            "question":"How can you catch a computer virus?",
            "radio_Button" : false
          }
        ];
        answersList = [{"a1":"A client","a2":"A host","a3":"A router","a4":"A Web Server"},{"a1":"Peripheral","a2":"Clip art","a3":"Highlight","a4":" Execute"},{"a1":"Sending e-mail messages","a2":"Using a laptop during the winter","a3":"Opening e-mail attachments","a4":"Shopping on-line"}];
      });
    } else if(widget.id == "2") {
      setState(() {
        questions = [
          {
           "question" : "How was the Seminar?",
            "radio_Button" : false
          },
          {
           "question" : "What did you learn from this Seminar?",
            "radio_Button" : true
          }, {
           "question" : "Is this Seminar helpful?",
            "radio_Button" : true
        }
        ];
        answersList = [{"a1":"Descent","a2":"Good","a3":"Better","a4":"Excellent"},{"a1":"Practical work","a2":"Theoretical work","a3":"Not sure what i learn","a4":"Not sure what just happened"},{"a1":"Is it helpful","a2":"Not helpful","a3":"Not Sure","a4":"Time waste"}];
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Questions"),),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: AppColors.backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(i<questions.length)
              Container(
                  margin:const EdgeInsets.only(top: 5),
                  child: Text("QUESTION ${i+1} OF ${questions.length}",style:const TextStyle(color: AppColors.totalQuestionColor,fontWeight: FontWeight.bold),)),
              if(i<questions.length)
              QuestionTextWidget(questions[i]['question'],questions[i].videoUrl,(){
                String urlQ1 = "https://www.youtube.com/watch?v=RHiFWm5-r3g";
                String? videoId = YoutubePlayer.convertUrlToId(urlQ1);
                YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                    initialVideoId: videoId!,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      controlsVisibleAtStart: false,
                    )

                );
                videoPopupDialog(context, "Introduction to question#1", youtubePlayerController);
              },false),
              if(j<answersList.length)
              OptionMcqAnswer(
              questions[i]['radio_Button'] ? RadioListTile(
                  tileColor: AppColors.textWhiteColor,
                  activeColor: AppColors.textWhiteColor,
                  value: answersList[j]['a1'].toString(),
                  title:  Text(answersList[j]['a1'],style: const TextStyle(color: AppColors.textWhiteColor)),
                  groupValue: _groupValue,
                  onChanged: (newValue){
                    setState(() {
                      _groupValue = newValue.toString();
                      _setNextQuestion();
                    });
                  },
                ) : GestureDetector(
                onTap: () {
                  setState(() {
                    a1 = !a1;
                    if(a1) {
                     addAnswersToList(0,answersList[j]['a1']);
                    } else {
                      removeAnswerFromList(0);
                    }
                  });
                },
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: AppColors.textWhiteColor,
                      checkColor: AppColors.backgroundColor,
                      value: a1,
                      onChanged: (bool? value) {
                        setState(() {
                          a1 = value!;
                          if(a1) {
                            addAnswersToList(0,answersList[j]['a1']);
                          } else {
                            removeAnswerFromList(0);
                          }
                        });
                      },
                    ),
                   const SizedBox(width: 10,),
                    Text(answersList[j]['a1'],style: const TextStyle(color: AppColors.textWhiteColor)),
                  ],
              ),
                )
              ),
              if(j<answersList.length)
              OptionMcqAnswer(

                  questions[i]['radio_Button'] ? RadioListTile(
                    tileColor: AppColors.textWhiteColor,
                    activeColor: AppColors.textWhiteColor,
                    value: answersList[j]['a2'].toString(),
                    title:  Text(answersList[j]['a2'],style: const TextStyle(color: AppColors.textWhiteColor)),
                    groupValue: _groupValue,
                    onChanged: (newValue){
                      setState(() {
                        _groupValue = newValue.toString();
                        _setNextQuestion();
                      });
                    },
                  ) : GestureDetector(
                    onTap: () {
                      setState(() {
                        a2 = !a2;
                        if(a2) {
                          addAnswersToList(1,answersList[j]['a2']);
                        } else {
                          removeAnswerFromList(1);
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: AppColors.textWhiteColor,
                          checkColor: AppColors.backgroundColor,
                          value: a2,
                          onChanged: (bool? value) {
                            setState(() {
                              a2 = value!;
                              if(a2) {
                                addAnswersToList(1,answersList[j]['a2']);
                              } else {
                                removeAnswerFromList(1);
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 10,),
                        Text(answersList[j]['a2'],style: const TextStyle(color: AppColors.textWhiteColor)),
                      ],
                    ),
                  )
              ),
              if(j<answersList.length)
              OptionMcqAnswer(
                  questions[i]['radio_Button'] ?  RadioListTile(
                    tileColor: AppColors.textWhiteColor,
                    activeColor: AppColors.textWhiteColor,
                    value: answersList[j]['a3'].toString(),
                    title:  Text(answersList[j]['a3'],style: const TextStyle(color: AppColors.textWhiteColor)),
                    groupValue: _groupValue,
                    onChanged: (newValue){
                      setState(() {
                        _groupValue = newValue.toString();
                        _setNextQuestion();
                      });
                    },
                  ) : GestureDetector(
                    onTap: () {
                      setState(() {
                        a3 = !a3;
                        if(a3) {
                          addAnswersToList(2,answersList[j]['a3']);
                        } else {
                          removeAnswerFromList(2);
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: AppColors.textWhiteColor,
                          checkColor: AppColors.backgroundColor,
                          value: a3,
                          onChanged: (bool? value) {
                            setState(() {
                              a3 = value!;
                              if(a3) {
                                addAnswersToList(2,answersList[j]['a3']);
                              } else {
                                removeAnswerFromList(2);
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 10,),
                        Text(answersList[j]['a3'],style: const TextStyle(color: AppColors.textWhiteColor)),
                      ],
                    ),
                  )
              ),
              if(j<answersList.length)
              OptionMcqAnswer(
                  questions[i]['radio_Button'] ?  RadioListTile(
                    tileColor: AppColors.textWhiteColor,
                    activeColor: AppColors.textWhiteColor,
                    value: answersList[j]['a4'].toString(),
                    title:  Text(answersList[j]['a4'],style: const TextStyle(color: AppColors.textWhiteColor)),
                    groupValue: _groupValue,
                    onChanged: (newValue){
                      setState(() {
                        _groupValue = newValue.toString();
                        _setNextQuestion();

                      });
                    },
                  ) : GestureDetector(
                    onTap: () {
                      setState(() {
                        a4 = !a4;
                        if(a4) {
                          addAnswersToList(3,answersList[j]['a4']);
                        } else {
                          removeAnswerFromList(3);
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: AppColors.textWhiteColor,
                          checkColor: AppColors.backgroundColor,
                          value: a4,
                          onChanged: (bool? value) {
                            setState(() {
                              a4 = value!;
                              if(a4) {
                                addAnswersToList(3,answersList[j]['a4']);
                              } else {
                                removeAnswerFromList(3);
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 10,),
                        Text(answersList[j]['a4'],style: const TextStyle(color: AppColors.textWhiteColor)),
                      ],
                    ),
                  )
              ),
              if(i != questions.length)
                !questions[i]['radio_Button'] && selectedAnswer.isNotEmpty ? Container(
                  margin:const EdgeInsets.only(top: 15),
                  child: CircularButton("Next", (){
                    if(selectedAnswer.isNotEmpty) {
                      _setNextQuestion();
                    } else {
                      showToast(
                          "Please select any option", shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                          context: context,
                          fullWidth: true,
                          alignment: Alignment.topCenter,
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.red
                      );
                    }
                  }),
                ) : Container(),

              if(i == questions.length)
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     const Text("Congratulation",style: TextStyle(color: AppColors.textWhiteColor,fontSize: 25),),
                      const Text("You have Completed this quiz",style: TextStyle(color: AppColors.textWhiteColor,fontSize: 20),),
                     const Divider(color: AppColors.textWhiteColor,thickness: 2,),
                      Row(
                        children: [
                         const Icon(Icons.timelapse,color: AppColors.textWhiteColor,),
                          QuestionTextWidget("You have answered total ${answersList.length} questions","",(){
                            String urlQ1 = "https://www.youtube.com/watch?v=RHiFWm5-r3g";
                            String? videoId = YoutubePlayer.convertUrlToId(urlQ1);
                            YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                                initialVideoId: videoId!,
                                flags: const YoutubePlayerFlags(
                                  autoPlay: false,
                                  controlsVisibleAtStart: false,
                                )

                            );
                            videoPopupDialog(context, "Introduction to question#1", youtubePlayerController);
                          },false),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _setNextQuestion() {
    if(i != questions.length && j != answersList.length) {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      setState(() {
        i = i+1;
        j = j+1;
        selectedAnswer.clear();
      });
    });
    }
  }

  void addAnswersToList(int index,answerSelect) {
    selectedAnswer.insert(index, answerSelect);
    // print(selectedAnswer);
  }

  void removeAnswerFromList(int index) {
    if(selectedAnswer.isNotEmpty) {
      selectedAnswer.removeAt(index);
      // print(selectedAnswer);
    }
  }
}
