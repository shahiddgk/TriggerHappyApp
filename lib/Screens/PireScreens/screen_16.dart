// ignore_for_file: use_build_context_synchronously, must_be_immutable, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/video_screen.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Screens/Widgets/share_pop_up_dialogue.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/constants.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../network/http_manager.dart';
import '../utill/userConstants.dart';

class Screen16 extends StatefulWidget {
  Screen16(this.number,this.pireId,{Key? key}) : super(key: key);

  String number;
  String pireId;

  @override
  // ignore: library_private_types_in_public_api
  _Screen16State createState() => _Screen16State();
}

class _Screen16State extends State<Screen16> with SingleTickerProviderStateMixin {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  late final AnimationController _animationController;
  List<AcceptedConnectionItem> acceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> searchAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> selectedUserAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  bool _isLoading = true;
  late bool isPhone;


  @override
  void initState() {
    _getUserData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.repeat(reverse: true);

    // TODO: implement initState
    super.initState();
  }

  String email = "";
  String timeZone = "";
  String userType = "";
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    getConnectionList();
    
    setState(() {
      _isUserDataLoading = false;
    });
  }


  getConnectionList() {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().getAcceptedConnectionList(LogoutRequestModel(userId: id)).then((value) {
      setState(() {

        acceptedConnectionsListResponse = value.data!;
        searchAcceptedConnectionsListResponse = acceptedConnectionsListResponse;
        // searchAcceptedConnectionsListResponse = value.data!;

        for(int i = 0;i<acceptedConnectionsListResponse.length;i++ ) {
          if(id == acceptedConnectionsListResponse[i].firstUserDetail!.id) {
            acceptedConnectionsListResponse.sort((a, b) {
              return a.secondUserDetail!.name!.toLowerCase().compareTo(b.secondUserDetail!.name!.toLowerCase());
            });
            searchAcceptedConnectionsListResponse.sort((a, b) {
              return a.secondUserDetail!.name!.toLowerCase().compareTo(b.secondUserDetail!.name!.toLowerCase());
            });
          } else {
            acceptedConnectionsListResponse.sort((a, b) {
              return a.firstUserDetail!.name!.toLowerCase().compareTo(b.firstUserDetail!.name!.toLowerCase());
            });
            searchAcceptedConnectionsListResponse.sort((a, b) {
              return a.firstUserDetail!.name!.toLowerCase().compareTo(b.firstUserDetail!.name!.toLowerCase());
            });
          }
        }

          _isLoading = false;

      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
  }




  // showThumbsUpDialogue(BuildContext context,String id1) {
  //
  //   final isPhone = MediaQuery.of(context).size.width <= 500;
  //   final dialogWidth = isPhone ? MediaQuery.of(context).size.width : 400.0;
  //   final dialogHeight = isPhone
  //       ? MediaQuery.of(context).size.height * 0.8
  //       : MediaQuery.of(context).size.height * 0.6;
  //
  //   final TextEditingController _searchController = TextEditingController();
  //   bool isMultiSelection = false;
  //   bool isSharedButtonCalled = false;
  //   selectedUserAcceptedConnectionsListResponse.clear();
  //
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (BuildContext context,StateSetter setState) {
  //           return AlertDialog(
  //             shape: const RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(25))),
  //             contentPadding: const EdgeInsets.all(2),
  //             backgroundColor: AppColors.hoverColor,
  //             actionsAlignment: MainAxisAlignment.center,
  //             actionsPadding: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
  //
  //             content: SizedBox(
  //               height: dialogHeight,
  //               width: dialogWidth,
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     margin:const EdgeInsets.only(bottom: 5),
  //                     decoration: const BoxDecoration(color: AppColors.primaryColor,
  //                     borderRadius: BorderRadius.only(topLeft: Radius.circular(150),topRight: Radius.circular(150))
  //                     ),
  //                     width: MediaQuery.of(context).size.width,
  //                     alignment: Alignment.topCenter,
  //                     child:  const Text("Coaches Opinion",style: TextStyle(color:AppColors.hoverColor,fontSize: AppConstants.headingFontSize,fontWeight: FontWeight.bold),),
  //                   ),
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Expanded(
  //                         child: Column(
  //                           children: [
  //                             PopUpConnectionListItem(
  //                               showStars : true,showOnlineIcon: true,
  //                               userItemTap: (){},
  //                               imageUrl:"https://trueincrease.com/wp-content/uploads/2023/02/Aaron-Brown-Bio-Headshot-2023-300x300.jpg",
  //                               userName: "Aron Brown",connectionType: "Coaches",stars:"5",
  //                             ),
  //                             InkWell(
  //                               onTap: () {
  //                                 Navigator.of(context).push(MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         CardFormScreen("",false,true,"96",widget.pireId.toString(),"pire")));
  //                               },
  //                               child: FadeTransition(
  //                                   opacity: _animationController,
  //                                   child: Container(
  //                                     margin: const EdgeInsets.symmetric(vertical: 5),
  //                                     decoration: BoxDecoration(
  //                                         color: AppColors.primaryColor,
  //                                         borderRadius: BorderRadius.circular(8)
  //                                     ),
  //                                     child: Container(
  //                                         alignment: Alignment.center,
  //                                         child: const Row(
  //                                           mainAxisAlignment: MainAxisAlignment.center,
  //                                           children: [
  //                                             Text(" Pay 20 \$ ",style: TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.headingFontSize),),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                   ),
  //                                 ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       SizedBox(height: MediaQuery.of(context).size.height/6, child: const VerticalDivider(color: AppColors.primaryColor)),
  //                       Expanded(
  //                         child: Column(
  //                           children: [
  //                             PopUpConnectionListItem(
  //                               showStars : true,showOnlineIcon: true,
  //                               userItemTap: (){},
  //                               imageUrl:"https://trueincrease.com/wp-content/uploads/2023/02/Chris-Williams-Bio-Headshot-2023-300x300.jpg",
  //                               userName: "Chris Williams",connectionType: "Coaches",stars:"5",
  //                             ),
  //                             InkWell(
  //                               onTap: () {
  //                                 Navigator.of(context).push(MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         CardFormScreen("",false,true,"96",widget.pireId.toString(),"pire")));
  //                               },
  //                               child: FadeTransition(
  //                                 opacity: _animationController,
  //                                 child: Container(
  //                                   margin: const EdgeInsets.symmetric(vertical: 5),
  //                                   decoration: BoxDecoration(
  //                                       color: AppColors.primaryColor,
  //                                       borderRadius: BorderRadius.circular(8)
  //                                   ),
  //                                   child: Container(
  //                                     alignment: Alignment.center,
  //                                     child: const Row(
  //                                       mainAxisAlignment: MainAxisAlignment.center,
  //                                       children: [
  //                                         Text(" Pay 20 \$ ",style: TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.headingFontSize),),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const Divider(color: AppColors.primaryColor,),
  //                   Container(
  //                     margin:const EdgeInsets.symmetric(vertical: 3),
  //                     decoration: const BoxDecoration(color: AppColors.primaryColor,
  //                     ),
  //                     width: MediaQuery.of(context).size.width,
  //                     alignment: Alignment.topCenter,
  //                     child:  const Text("Search your connections",style: TextStyle(color:AppColors.hoverColor,fontSize: AppConstants.headingFontSize,fontWeight: FontWeight.bold),),
  //                   ),
  //                   // HeadingWithButtonRow("Search you connections",(){},false),
  //                   const SizedBox(height: 2,),
  //                   SearchTextField((value) {
  //                     setState(() {
  //                       if(value.isEmpty) {
  //                         searchAcceptedConnectionsListResponse = acceptedConnectionsListResponse;}
  //                       else {
  //                         // ignore: avoid_print
  //                         searchAcceptedConnectionsListResponse =
  //                             acceptedConnectionsListResponse
  //                                 .where((AcceptedConnectionItem item) =>
  //                                 (" ${item.connectionInfo!.senderName!
  //                                     .toString()} ${item
  //                                     .connectionInfo!.receiverName
  //                                     .toString()}")
  //                                     .toLowerCase()
  //                                     .contains(value.toLowerCase()))
  //                                 .toList();
  //                       }
  //
  //                     });
  //                   }, _searchController, 1, false, "search here with user name"),
  //                   const SizedBox(height: 5,),
  //                   acceptedConnectionsListResponse.isEmpty ?  const Center(
  //                     child:
  //                     Text("No Connection Yet"),
  //                   ) :  ListView.builder(
  //                       shrinkWrap: true,
  //                       scrollDirection: Axis.vertical,
  //                       itemCount: searchAcceptedConnectionsListResponse.length,
  //                       itemBuilder: (builder,index) {
  //                         return Column(
  //                           children: [
  //                             id == searchAcceptedConnectionsListResponse[index].firstUserDetail!.id ? PopUpConnectionListItem1122(
  //                                 showStars : false,stars: "",
  //                                 userItemTap: (){
  //                                   if(isMultiSelection) {
  //                                     setState(() {
  //                                       if(selectedUserAcceptedConnectionsListResponse.contains(searchAcceptedConnectionsListResponse[index])) {
  //                                         setState(() {
  //                                           isMultiSelection = true;
  //                                           selectedUserAcceptedConnectionsListResponse
  //                                               .remove(
  //                                               searchAcceptedConnectionsListResponse[index]);
  //                                         });
  //                                       } else {
  //                                         setState(() {
  //                                           isMultiSelection = true;
  //                                           selectedUserAcceptedConnectionsListResponse
  //                                               .add(
  //                                               searchAcceptedConnectionsListResponse[index]);
  //                                         });
  //                                       }
  //                                       if(selectedUserAcceptedConnectionsListResponse.isEmpty) {
  //                                         setState(() {
  //                                           isMultiSelection = false;
  //                                         });
  //                                       }
  //
  //                                       print("add called for multi selectio");
  //                                       print(isMultiSelection);
  //                                       print(selectedUserAcceptedConnectionsListResponse.length);
  //                                     });
  //                                   } else {
  //
  //                                   }
  //                                 },
  //                                 userItemLongPressTap: () {
  //                                   setState(() {
  //                                     isMultiSelection = true;
  //                                     selectedUserAcceptedConnectionsListResponse.add(searchAcceptedConnectionsListResponse[index]);
  //                                   });
  //                                 },
  //                                 selectedIcon:selectedUserAcceptedConnectionsListResponse.contains(searchAcceptedConnectionsListResponse[index]),
  //                                 imageUrl: searchAcceptedConnectionsListResponse[index].secondUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : searchAcceptedConnectionsListResponse[index].secondUserDetail!.image!,
  //                                 userName: searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!.capitalize(),connectionType: searchAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize()
  //                             ) : PopUpConnectionListItem1122(
  //                                 showStars : false,stars: "",
  //                                 userItemTap: (){
  //                                   if(isMultiSelection) {
  //                                     setState(() {
  //                                       if(selectedUserAcceptedConnectionsListResponse.contains(searchAcceptedConnectionsListResponse[index])) {
  //                                         setState(() {
  //                                           isMultiSelection = true;
  //                                           selectedUserAcceptedConnectionsListResponse
  //                                               .remove(
  //                                               searchAcceptedConnectionsListResponse[index]);
  //                                         });
  //                                       } else {
  //                                         setState(() {
  //                                           isMultiSelection = true;
  //                                           selectedUserAcceptedConnectionsListResponse
  //                                               .add(
  //                                               searchAcceptedConnectionsListResponse[index]);
  //                                         });
  //                                       }
  //                                       if(selectedUserAcceptedConnectionsListResponse.isEmpty) {
  //                                         setState(() {
  //                                           isMultiSelection = false;
  //                                         });
  //                                       }
  //
  //                                       print("add called for multi selectio");
  //                                       print(isMultiSelection);
  //                                       print(selectedUserAcceptedConnectionsListResponse.length);
  //                                     });
  //                                   } else {
  //
  //                                   }
  //                                 },
  //                                 userItemLongPressTap: () {
  //                                   if(selectedUserAcceptedConnectionsListResponse.isEmpty) {
  //                                     setState(() {
  //                                       isMultiSelection = true;
  //                                       selectedUserAcceptedConnectionsListResponse
  //                                           .add(
  //                                           searchAcceptedConnectionsListResponse[index]);
  //                                     });
  //                                   }
  //                                 },
  //                                 selectedIcon:selectedUserAcceptedConnectionsListResponse.contains(searchAcceptedConnectionsListResponse[index]),
  //                                 imageUrl: searchAcceptedConnectionsListResponse[index].firstUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : searchAcceptedConnectionsListResponse[index].firstUserDetail!.image!,
  //                                 userName: searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!.capitalize(),connectionType: searchAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize()
  //                             ),
  //                           ],
  //                         );
  //                       }),
  //
  //                  // const Align(
  //                  //     alignment: Alignment.bottomCenter,
  //                  //     child: Text("Seeking a coach's opinion is a transformative journey. Coaches provide invaluable insights and tailored strategies for personal growth and success. Embrace coaching as an investment in your development and a path to excellence.",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.defaultFontSize),))
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               Visibility(
  //                 visible: selectedUserAcceptedConnectionsListResponse.isNotEmpty,
  //                 child: Container(
  //                   margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/6),
  //                   child: InkWell(
  //                     onTap: () {
  //                       List chatId = [];
  //                       List recieverId = [];
  //
  //                       String? chatIdStrings;
  //                       String? recieverIdStrings;
  //
  //                       setState(() {
  //                         isSharedButtonCalled = true;
  //                       });
  //                       for(int i=0; i<selectedUserAcceptedConnectionsListResponse.length; i++) {
  //                         setState(() {
  //                           chatId.add(selectedUserAcceptedConnectionsListResponse[i].connectionInfo!.id);
  //                           if(id == selectedUserAcceptedConnectionsListResponse[i].firstUserDetail!.id) {
  //                             recieverId.add(selectedUserAcceptedConnectionsListResponse[i].secondUserDetail!.id);
  //                           } else {
  //                             recieverId.add(selectedUserAcceptedConnectionsListResponse[i].firstUserDetail!.id);
  //                           }
  //                         });
  //                       }
  //                       setState(() {
  //                         chatIdStrings = chatId.toString().replaceAll("[", "").replaceAll("]", "");
  //                         recieverIdStrings = recieverId.toString().replaceAll("[", "").replaceAll("]", "");
  //                       });
  //                       print("Share Clicked");
  //                       print(chatIdStrings);
  //                       print(recieverIdStrings);
  //                       print(widget.pireId);
  //
  //                       HTTPManager().addShareItemToConnectionList(SharedListItemAddRequest(senderId: id,chatId: chatIdStrings.toString(),recieverId: recieverIdStrings.toString(),type: 'pire',entityId: widget.pireId.toString())).then((value) {
  //
  //                         setState(() {
  //                           isSharedButtonCalled = false;
  //                         });
  //                         Navigator.pushAndRemoveUntil(
  //                             context,
  //                             MaterialPageRoute(builder: (BuildContext context) =>const VideoScreen()),
  //                                 (Route<dynamic> route) => false
  //                         );
  //
  //                         showToastMessage(context,"Response Shared Successfully", true);
  //
  //                       }).catchError((e) {
  //                         print(e.toString());
  //                         setState(() {
  //                           isSharedButtonCalled = false;
  //                         });
  //                         showToastMessage(context, e.toString(), false);
  //                       });
  //
  //                     },
  //                     child: OptionMcqAnswer(
  //                       Container(
  //
  //                         alignment: Alignment.center,
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             isSharedButtonCalled ? Center(child: Container(
  //                               padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
  //                                 height: 30,
  //                                 width: 30,
  //                                 child: const CircularProgressIndicator())) : const Text("Share",style: TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.headingFontSize),)
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           );
  //         });
  //       });
  // }

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const VideoScreen()),
            (Route<dynamic> route) => false
    );
    // int count = 0;
    // Navigator.of(context).popUntil((_) => count++ >= 11);
      return true;
    }


  getScreenDetails() {
    // setState(() {
    //   _isLoading = true;
    // });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:  AppBarWidget().appBarGeneralButtons(
            context,
                () {
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
              //         (Route<dynamic> route) => false
              // );
            }, true, true, true, id, false,true,badgeCount1,false,badgeCountShared),
        body: Container(
          color: AppColors.backgroundColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _isLoading ? const Center(
            child: CircularProgressIndicator(),
          ) : Container(
            margin: EdgeInsets.symmetric(horizontal: !isPhone ? MediaQuery.of(context).size.width/5 : 10),
            child: SingleChildScrollView(
              physics:const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                const  Padding(padding: EdgeInsets.only(top: 40)),
                  LogoScreen("PIRE"),
                 // QuestionTextWidget(widget.number),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(widget.number=="Worse" ?
                    "I'm so sorry…This will get easier, promise!"
                          : widget.number=="Same"
                    ? "That's okay. Often it just takes a little practice."
                          :widget.number=="Mixed Emotions"
                    ? "That's totally normal when processing hard situations. It will get better."
                          : widget.number=="Better"
                    ? "That's great! Keep up the good work."
                              : widget.number=="Awesome" ? "Yes! That's wonderful. Enjoy!":"",textAlign: TextAlign.start,style:const TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.defaultFontSize),),
                        ),
                        IconButton(onPressed: (){
                          String urlQ1 = "https://www.youtube.com/watch?v=RgdhFiv8C-g";
                          String? videoId = YoutubePlayer.convertUrlToId(urlQ1);
                          YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                              initialVideoId: videoId!,
                              flags: const YoutubePlayerFlags(
                                autoPlay: false,
                                controlsVisibleAtStart: false,
                              )

                          );
                          videoPopupDialog(context, "Introduction to question#1", youtubePlayerController);
                        }, icon:const Icon(Icons.ondemand_video,size:30,color: AppColors.blueColor,)),
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/7),
                  //   child: QuestionTextWidget(widget.number=="Worse" ?
                  //   "I'm so sorry…This will get easier, promise!"
                  //       : widget.number=="Same"
                  //       ? "That's okay. Often it just takes a little practice."
                  //       :widget.number=="Mixed Emotions"
                  //       ? "That's totally normal when processing hard situations. It will get better."
                  //       : widget.number=="Better"
                  //       ? "That's great! Keep up the good work."
                  //       : widget.number=="Awesome" ? "Yes! That's wonderful. Enjoy!" : "","https://www.youtube.com/watch?v=RgdhFiv8C-g",(){
                  //     String urlQ1 = "https://www.youtube.com/watch?v=RgdhFiv8C-g";
                  //     String? videoId = YoutubePlayer.convertUrlToId(urlQ1);
                  //     YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                  //         initialVideoId: videoId!,
                  //         flags: const YoutubePlayerFlags(
                  //           autoPlay: false,
                  //           controlsVisibleAtStart: false,
                  //         )
                  //
                  //     );
                  //     videoPopupDialog(context, "Introduction to question#1", youtubePlayerController);
                  //   },true),
                  // ),
                      const SizedBox(
                        height: 5,
                      ),
                      //QuestionTextWidget("Good luck"),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height/3,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset("assets/thumbs_up_like.gif")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) =>const VideoScreen()),
                                  (Route<dynamic> route) => false
                          );
                        },
                        child:OptionMcqAnswer(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                            child: const Column(
                              children: [
                                Icon(Icons.home,size:30,color: AppColors.primaryColor,),
                                Text("Back to Home Screen",style: TextStyle(color: AppColors.textWhiteColor))
                              ],
                            ),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          showThumbsUpDialogue(context, _animationController, id, 'pire', widget.pireId, selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
                        },
                        child:OptionMcqAnswer(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                            child: const Column(
                              children: [
                                Icon(Icons.share,size:30,color: AppColors.primaryColor,),
                                Text("Share you Response",style: TextStyle(color: AppColors.textWhiteColor))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.pushAndRemoveUntil(
                      //         context,
                      //         MaterialPageRoute(builder: (BuildContext context) =>const VideoScreen()),
                      //             (Route<dynamic> route) => false
                      //     );
                      //   },
                      //   child: OptionMcqAnswer(
                      //      TextButton(onPressed: () {
                      //        // int count = 0;
                      //        // Navigator.of(context).popUntil((_) => count++ >= 11);
                      //        Navigator.pushAndRemoveUntil(
                      //            context,
                      //            MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
                      //                (Route<dynamic> route) => false
                      //        );
                      //      }, child: const Text("Back to Home Screen",style: TextStyle(color: AppColors.textWhiteColor)),)
                      //   ),
                      // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
