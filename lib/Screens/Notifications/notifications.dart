

// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../model/reponse_model/Sage/invite_connection_notification_list.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../network/http_manager.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../utill/userConstants.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isLoading = true;
  bool _isAcceptRejectButtonLoading = false;
  // bool _isRejectButtonLoading = false;
  String email = "";
  String timeZone = "";
  String userType = "";
  late bool isPhone;
  late bool isTable;
  late bool isDesktop;
  String introUrl = "https://youtu.be/O4fsrMcxRqc";
  late YoutubePlayerController youtubePlayerController;
  late InvitedNotificationConnectionListResponse invitedNotificationConnectionListResponse;

  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      _isUserDataLoading = true;
    });
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    getInviteNotificationList();

    setState(() {
      _isUserDataLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    super.initState();
  }

  getInviteNotificationList() {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().getInviteNotificationConnectionList(LogoutRequestModel(userId: id)).then((value) {
      setState(() {

        invitedNotificationConnectionListResponse = value;


      });

      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  rejectInvite (String senderId1,String recieverId1,String role1,) {
    setState(() {
      _isAcceptRejectButtonLoading = true;
    });

    HTTPManager().rejectNotificationInvite(senderId1, recieverId1, role1).then((value) {

      setState(() {
        Navigator.of(context).pop();
        showToastMessage(context, "You have rejected this connection", true);
        _isAcceptRejectButtonLoading = false;
    });

    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
      setState(() {
        _isAcceptRejectButtonLoading = false;
      });
    });
  }

  acceptInvite (String senderId1,String recieverId1,String role1,) {
    setState(() {
      _isAcceptRejectButtonLoading = true;
    });

    HTTPManager().acceptNotificationInvite(senderId1, recieverId1, role1).then((value) {

      setState(() {
        Navigator.of(context).pop();

        showToastMessage(context, "You have accepted this connection", true);
        _isAcceptRejectButtonLoading = false;
      });

    }).catchError((e) {
      setState(() {
        showToastMessage(context, e.toString(), false);
        _isAcceptRejectButtonLoading = false;
      });
    });
  }


  showStatusPopUp(String senderId,String recieverId,String mentorOrPeer,int index,String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("$mentorOrPeer !"),
            content: IgnorePointer(
              ignoring: _isAcceptRejectButtonLoading,
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height/5,
                    width: !isPhone ? MediaQuery.of(context).size.width/3 : MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.redColor,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    rejectInvite(senderId,recieverId,mentorOrPeer);
                                  }, child: const Text("  Decline  ",style: TextStyle(color: AppColors.hoverColor),)),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: TextButton(onPressed: () {
                                acceptInvite(senderId,recieverId,mentorOrPeer);
                              }, child: const Text("  Accept  ",style: TextStyle(color: AppColors.hoverColor),)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: _isAcceptRejectButtonLoading? const CircularProgressIndicator() : Container(),
                  ),
                ],
              ),
            )
          );
        });
  }

  getScreenDetails() {
    setState(() {
    });
    if(MediaQuery.of(context).size.width< 650) {
      isPhone = true;
      isDesktop = false;
      isTable = false;
    } else if (MediaQuery.of(context).size.width >= 650 && MediaQuery.of(context).size.width < 1100) {
      isTable = true;
      isPhone = false;
      isDesktop = false;
    } else if(MediaQuery.of(context).size.width >= 1100) {
      isPhone = false;
      isDesktop = true;
      isTable = false;
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      appBar: AppBarWidget().appBarGeneralButtons(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared),
      body: Column(
        children: [
          LogoScreen("Notifications"),
          _isLoading ? const Center(
            child: CircularProgressIndicator(),
          ) : invitedNotificationConnectionListResponse.data!.isEmpty ? const Center(
            child: Text("No Notifications yet"),
          ) : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: invitedNotificationConnectionListResponse.data!.length,
              itemBuilder: (context,index) {
                return InkWell(
                  onTap: () {
                    showStatusPopUp(invitedNotificationConnectionListResponse.data![index].senderId!,invitedNotificationConnectionListResponse.data![index].receiverId!,invitedNotificationConnectionListResponse.data![index].role!,index,invitedNotificationConnectionListResponse.data![index].message!,);
                  },
                  child: Card(
                    child: Container(
                        margin:const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            ClipOval(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  margin:const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                  child: Image.network("https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"),
                                )
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/1.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(invitedNotificationConnectionListResponse.data![index].receiverName!,style: const TextStyle(
                                      color: AppColors.primaryColor,fontSize: AppConstants.headingFontSize
                                  ),),
                                  Text(invitedNotificationConnectionListResponse.data![index].message!,overflow:TextOverflow.ellipsis,style: const TextStyle(
                                     color: AppColors.textWhiteColor,fontSize: AppConstants.defaultFontSize
                                      ),)
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                );
              })
        ],
      )
    );
  }
}
