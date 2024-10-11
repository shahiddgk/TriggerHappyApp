// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/Column/Widgets/search_text_field.dart';
import '../Screens/Payment/card_form_screen.dart';
import '../Screens/Widgets/custome_share_alert_pop_up.dart';
import '../Screens/Widgets/connection_user_image_and_text_show.dart';
import '../Screens/Widgets/error_text_and_button_widget.dart';
import '../Screens/Widgets/toast_message.dart';
import '../Screens/dashboard_tiles.dart';
import '../Screens/utill/userConstants.dart';
import '../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../model/request_model/Sage Request/add_shared_item_to_shared_list.dart';
import '../model/request_model/logout_user_request.dart';
import '../model/request_model/trellis_share_request.dart';
import '../network/http_manager.dart';
import 'colors.dart';
import 'constants.dart';
import 'option_mcq_widget.dart';

class ShareCustomAlertDialogue extends StatefulWidget {
   const ShareCustomAlertDialogue({Key? key,required this.responseId,required this.isModule,required this.responseType}) : super(key: key);

  final String responseType;
   final String responseId;
  final bool isModule;

  @override
  State<ShareCustomAlertDialogue> createState() => _ShareCustomAlertDialogueState();
}

class _ShareCustomAlertDialogueState extends State<ShareCustomAlertDialogue>  with SingleTickerProviderStateMixin {

  final TextEditingController searchController = TextEditingController();
  // bool isMultiSelection = false;
  bool isSharedButtonCalled = false;
  late final AnimationController _animationController;
  String name = "";
  String id = "";
  bool _isLoading = true;

  bool isError = false;
  String errorText = "";

  List<AcceptedConnectionItem> selectedUserAcceptedConnectionsListResponse = [];
  List<AcceptedConnectionItem> searchAcceptedConnectionsListResponse = [];
  List<AcceptedConnectionItem> acceptedConnectionsListResponse = [];

  @override
  void initState() {

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.repeat(reverse: true);

    _getUserData();

    super.initState();
  }

  _getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
    });

    getConnectionList();
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

        isError = false;
        errorText = "";

        _isLoading = false;

      });
    }).catchError((e) {
      setState(() {
        isError = true;
        errorText = e.toString();
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final isPhone = MediaQuery.of(context).size.width <= 500;
    final dialogWidth = isPhone ? MediaQuery.of(context).size.width : 400.0;
    final dialogHeight = isPhone
        ? MediaQuery.of(context).size.height * 0.7
        : MediaQuery.of(context).size.height * 0.7;

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      contentPadding: const EdgeInsets.all(2),
      backgroundColor: AppColors.hoverColor,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(left: 10,right: 10,bottom: 5),

      content: SizedBox(
        height: dialogHeight,
        width: dialogWidth,
        child: _isLoading ?const Center(child: CircularProgressIndicator(),) : isError ? ErrorTextAndButtonWidget(
          errorText: errorText,onTap: (){
            getConnectionList();
        },
        )  : Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Visibility(
                  visible: false,
                  child: Column(
                    children: [
                      Container(
                        margin:const EdgeInsets.only(bottom: 5),
                        decoration: const BoxDecoration(color: AppColors.primaryColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(150),topRight: Radius.circular(150))
                        ),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        child:  const Text("Coaches Opinion",style: TextStyle(color:AppColors.hoverColor,fontSize: AppConstants.headingFontSize,fontWeight: FontWeight.bold),),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                PopUpConnectionListItem(
                                  showStars : true,showOnlineIcon: true,
                                  userItemTap: (){},
                                  imageUrl:"https://trueincrease.com/wp-content/uploads/2023/02/Aaron-Brown-Bio-Headshot-2023-300x300.jpg",
                                  userName: "Aron Brown",connectionType: "Coach",stars:"5",
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            CardFormScreen("",false,true,"96",widget.responseId,widget.responseType)));
                                  },
                                  child: FadeTransition(
                                    opacity: _animationController,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(" Pay 25 \$ ",style: TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.headingFontSize),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(),
                          // SizedBox(height: MediaQuery.of(context).size.height/6, child: const VerticalDivider(color: AppColors.primaryColor)),
                          Expanded(
                            child: Column(
                              children: [
                                PopUpConnectionListItem(
                                  showStars : true,showOnlineIcon: true,
                                  userItemTap: (){},
                                  imageUrl:"https://trueincrease.com/wp-content/uploads/2023/02/Chris-Williams-Bio-Headshot-2023-300x300.jpg",
                                  userName: "Chris Williams",connectionType: "Coach",stars:"5",
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            CardFormScreen("",false,true,"95",widget.responseId.toString(),widget.responseType)));
                                  },
                                  child: FadeTransition(
                                    opacity: _animationController,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(" Pay 25 \$ ",style: TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.headingFontSize),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: AppColors.primaryColor,),
                    ],
                  ),
                ),
                Container(
                  // margin:const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                      // borderRadius: BorderRadius.only(topLeft: Radius.circular( widget.isModule ? 150 : 0),topRight: Radius.circular(widget.isModule ? 150 : 0),)

                  ),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  child:  const Text("Search your connections",style: TextStyle(color:AppColors.hoverColor,fontSize: AppConstants.headingFontSize,fontWeight: FontWeight.bold),),
                ),
                // HeadingWithButtonRow("Search you connections",(){},false),
                const SizedBox(height: 5),
                SearchTextField((value) {
                  setState(() {
                    if(value.isEmpty) {
                      searchAcceptedConnectionsListResponse = acceptedConnectionsListResponse;}
                    else {
                      searchAcceptedConnectionsListResponse =
                          acceptedConnectionsListResponse
                              .where((AcceptedConnectionItem item) =>
                              (" ${item.connectionInfo!.senderName!
                                  .toString()} ${item
                                  .connectionInfo!.receiverName
                                  .toString()}")
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                    }

                  });
                }, searchController, 1, false, "search here with user name"),
                const SizedBox(height: 5,),
                acceptedConnectionsListResponse.isEmpty ?  const Center(
                  child:
                  Text("No Connection Yet"),
                ) :  Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: searchAcceptedConnectionsListResponse.length,
                      itemBuilder: (builder,index) {
                        return Column(
                          children: [
                            id == searchAcceptedConnectionsListResponse[index].firstUserDetail!.id ? CustomShareAlertConnectionItem(
                                showStars : false,stars: "",
                                userItemTap: (){
                                  setState(() {
                                    if(selectedUserAcceptedConnectionsListResponse.contains(searchAcceptedConnectionsListResponse[index])) {
                                      setState(() {
                                        selectedUserAcceptedConnectionsListResponse
                                            .remove(
                                            searchAcceptedConnectionsListResponse[index]);
                                      });
                                    } else {
                                      setState(() {
                                        selectedUserAcceptedConnectionsListResponse
                                            .add(
                                           searchAcceptedConnectionsListResponse[index]);
                                      });
                                    }

                                    print(selectedUserAcceptedConnectionsListResponse.length);
                                  });
                                },
                                userItemLongPressTap: () {
                                  // setState(() {
                                  //   isMultiSelection = true;
                                  //   selectedUserAcceptedConnectionsListResponse.add(searchAcceptedConnectionsListResponse[index]);
                                  // });
                                },
                                selectedIcon:selectedUserAcceptedConnectionsListResponse.contains(searchAcceptedConnectionsListResponse[index]),
                                imageUrl: searchAcceptedConnectionsListResponse[index].secondUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : searchAcceptedConnectionsListResponse[index].secondUserDetail!.image!,
                                userName: searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!.capitalize(),connectionType:searchAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize()
                            ) : CustomShareAlertConnectionItem(
                                showStars : false,stars: "",
                                userItemTap: (){

                                  setState(() {
                                    if(selectedUserAcceptedConnectionsListResponse.contains(searchAcceptedConnectionsListResponse[index])) {
                                      setState(() {
                                       selectedUserAcceptedConnectionsListResponse
                                            .remove(
                                           searchAcceptedConnectionsListResponse[index]);
                                      });
                                    } else {
                                      setState(() {
                                        selectedUserAcceptedConnectionsListResponse
                                            .add(
                                            searchAcceptedConnectionsListResponse[index]);
                                      });
                                    }

                                    print(selectedUserAcceptedConnectionsListResponse.length);
                                  });

                                },
                                userItemLongPressTap: () {
                                  // if(selectedUserAcceptedConnectionsListResponse.isEmpty) {
                                  //   setState(() {
                                  //
                                  //     selectedUserAcceptedConnectionsListResponse
                                  //         .add(
                                  //         searchAcceptedConnectionsListResponse[index]);
                                  //   });
                                  // }
                                },
                                selectedIcon:selectedUserAcceptedConnectionsListResponse.contains(searchAcceptedConnectionsListResponse[index]),
                                imageUrl: searchAcceptedConnectionsListResponse[index].firstUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : searchAcceptedConnectionsListResponse[index].firstUserDetail!.image!,
                                userName: searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!.capitalize(),connectionType: searchAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize()
                            ),
                          ],
                        );
                      }),
                ),

                Visibility(
                  visible: true,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: OptionMcqAnswer(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              margin: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                              alignment: Alignment.center,
                              child: const Text("Cancel",style: TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.headingFontSize),),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        IgnorePointer(
                          ignoring: isSharedButtonCalled,
                          child: InkWell(
                            onTap: () {
                              if(selectedUserAcceptedConnectionsListResponse.isNotEmpty) {
                                List chatId = [];
                                List recieverId = [];

                                String? chatIdStrings;
                                String? recieverIdStrings;

                                setState(() {
                                  isSharedButtonCalled = true;
                                });
                                for (int i = 0; i < selectedUserAcceptedConnectionsListResponse.length; i++) {
                                  setState(() {
                                    chatId.add(
                                        selectedUserAcceptedConnectionsListResponse[i].connectionInfo!.id);
                                    if (id == selectedUserAcceptedConnectionsListResponse[i].firstUserDetail!.id) {
                                      recieverId.add(selectedUserAcceptedConnectionsListResponse[i].secondUserDetail!.id);
                                    } else {
                                      recieverId.add(selectedUserAcceptedConnectionsListResponse[i].firstUserDetail!.id);
                                    }
                                  });
                                }
                                setState(() {
                                  chatIdStrings = chatId.toString().replaceAll("[", "").replaceAll("]", "");
                                  recieverIdStrings = recieverId.toString().replaceAll("[", "").replaceAll("]", "");
                                });
                                print("Share Clicked");
                                print(chatIdStrings);
                                print(recieverIdStrings);
                                if(widget.responseType == "trellis") {
                                  HTTPManager()
                                      .trellisShareScreen(
                                      TrellisShareRequest(
                                          connectionId: chatIdStrings.toString(),
                                          moduleType: widget.responseType
                                      ))
                                      .then((value) {
                                    setState(() {
                                      isSharedButtonCalled = false;
                                    });
                                    Navigator.of(context).pop();

                                    showToastMessage(
                                        context, "Trellis Shared Successfully", true);
                                  }).catchError((e) {
                                    print(e.toString());
                                    setState(() {
                                      isSharedButtonCalled = false;
                                    });
                                    showToastMessage(context, e.toString(), false);
                                  });
                                } else if(widget.responseType == "app") {
                                  HTTPManager()
                                      .allAppShareScreen(
                                      TrellisShareRequest(
                                          connectionId: chatIdStrings.toString(),
                                          moduleType: widget.responseType
                                      ))
                                      .then((value) {
                                    setState(() {
                                      isSharedButtonCalled = false;
                                    });
                                    Navigator.of(context).pop();

                                    showToastMessage(
                                        context, "All App Data Shared Successfully", true);
                                  }).catchError((e) {
                                    print(e.toString());
                                    setState(() {
                                      isSharedButtonCalled = false;
                                    });
                                    showToastMessage(context, e.toString(), false);
                                  });
                                } else {
                                  HTTPManager().addShareItemToConnectionList(SharedListItemAddRequest(
                                      senderId: id,
                                      chatId: chatIdStrings.toString(),
                                      recieverId: recieverIdStrings.toString(),
                                      type: widget.responseType,
                                      entityId: widget.responseId.toString())).then((value) {
                                    setState(() {
                                      isSharedButtonCalled = false;
                                    });
                                    Navigator.of(context).pop();

                                    showToastMessage(
                                        context, "${widget.responseType.capitalize()} Shared Successfully", true);
                                  }).catchError((e) {
                                    print(e.toString());
                                    setState(() {
                                      isSharedButtonCalled = false;
                                    });
                                    showToastMessage(context, e.toString(), false);
                                  });
                                }
                              } else {
                                showToastMessage(context, "Select connection for sharing", false);
                              }
                            },
                            child: OptionMcqAnswer(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                margin: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                                alignment: Alignment.center,
                                child: const Text("Share",style: TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.headingFontSize),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // const Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Text("Seeking a coach's opinion is a transformative journey. Coaches provide invaluable insights and tailored strategies for personal growth and success. Embrace coaching as an investment in your development and a path to excellence.",textAlign: TextAlign.center,style: TextStyle(fontSize: AppConstants.defaultFontSize),))
              ],
            ),
            if(isSharedButtonCalled)
              const Center(child: CircularProgressIndicator(),)
          ],
        ),
      ),
    );
  }
}
