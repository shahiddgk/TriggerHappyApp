
// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:flutter_quiz_app/Screens/Sage/sage_search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../../model/request_model/Tribe/pending_permission_request_model.dart';
import '../../model/request_model/Tribe/pending_permission_sent_request.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../network/http_manager.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/error_text_and_button_widget.dart';
import '../Widgets/toast_message.dart';
import '../utill/userConstants.dart';
import 'Widgets/connection_category_item_type.dart';
import 'Widgets/heading_with_button_in_row.dart';
import 'Widgets/pending_connection_list_item.dart';

class PendingConnectionList extends StatefulWidget {
  const PendingConnectionList({Key? key}) : super(key: key);

  @override
  State<PendingConnectionList> createState() => _PendingConnectionListState();
}

class _PendingConnectionListState extends State<PendingConnectionList> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;

  bool _isLoading = true;
  bool _isLoading1 = true;

  bool _isError = false;
  String errorText = "";

  String email = "";
  String timeZone = "";
  String userType = "";

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;


  bool isAllConnections = true;
  bool isMentorConnections = false;
  bool isPeerConnections = false;
  bool isMenteeConnections = false;

  List<AcceptedConnectionItem> acceptedConnectionsListResponse = <AcceptedConnectionItem>[];

  List<AcceptedConnectionItem> mentorAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> peerAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> menteeAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> searchAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];

  List<PendingPermissionSentItem> pendingPermissionListDetails  = <PendingPermissionSentItem>[];


  bool _isAcceptRejectButtonLoading = false;
  int badgeCount1 = 0;
  int badgeCountShared = 0;
  // Timer? timer;
  // http.Client _client = http.Client();

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    // WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // timer!.cancel();
    // _client.close();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       setState(() {
  //         timer = Timer.periodic(const Duration(seconds: 10), (Timer t) =>  getConnectionList(false));
  //       });
  //       print("RESUMED");
  //       break;
  //     case AppLifecycleState.inactive:
  //       setState(() {
  //         timer!.cancel();
  //         _client.close();
  //       });
  //       print("INACTIVE");
  //       break;
  //     case AppLifecycleState.paused:
  //       setState(() {
  //         timer!.cancel();
  //         _client.close();
  //       });
  //       print("PAUSED");
  //       break;
  //     case AppLifecycleState.detached:
  //       setState(() {
  //         timer!.cancel();
  //         _client.close();
  //       });
  //       print("DETACHED");
  //       break;
  //     case AppLifecycleState.hidden:
  //     // TODO: Handle this case.
  //   }
  // }

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      _isUserDataLoading = true;
    });
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    // badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    getConnectionList(true);
    getPendingPermissonList(true);

    setState(() {
      _isUserDataLoading = false;
    });
  }

  getPendingPermissonList(bool isLoading) {
    setState(() {
      _isLoading1 = isLoading;
    });

    HTTPManager().getPendingPermssionList(LogoutRequestModel(userId: id)).then((value) {
      setState(() {

        pendingPermissionListDetails = value.data!;

        _isError = false;
        // timer = Timer.periodic(const Duration(seconds: 10), (Timer t) =>  getConnectionList(false));
        errorText = "";
        _isLoading1 = false;
      });
    }).catchError((e) {
      _isError = true;
      setState(() {
        errorText = e.toString();
        _isLoading1 = false;
      });
    });
  }

  getConnectionList(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });

    HTTPManager().getPendingConnectionList(LogoutRequestModel(userId: id)).then((value) {
      setState(() {

        acceptedConnectionsListResponse = value.data!;

        for(int i = 0;i<acceptedConnectionsListResponse.length;i++ ) {
          if(id == acceptedConnectionsListResponse[i].firstUserDetail!.id) {
            acceptedConnectionsListResponse.sort((a, b) {
              return a.secondUserDetail!.name!.toLowerCase().compareTo(b.secondUserDetail!.name!.toLowerCase());
            });
          } else {
            acceptedConnectionsListResponse.sort((a, b) {
              return a.firstUserDetail!.name!.toLowerCase().compareTo(b.firstUserDetail!.name!.toLowerCase());
            });
          }
        }

        for(int i =0;i<acceptedConnectionsListResponse.length; i++) {
          if(acceptedConnectionsListResponse[i].connectionInfo!.role == "peer") {
            peerAcceptedConnectionsListResponse.add(acceptedConnectionsListResponse[i]);
          } else if(acceptedConnectionsListResponse[i].connectionInfo!.role == "mentor") {
            mentorAcceptedConnectionsListResponse.add(acceptedConnectionsListResponse[i]);
          } else {
            menteeAcceptedConnectionsListResponse.add(acceptedConnectionsListResponse[i]);
          }

        }


        _isError = false;
        // timer = Timer.periodic(const Duration(seconds: 10), (Timer t) =>  getConnectionList(false));
        errorText = "";
        _isLoading = false;
      });
    }).catchError((e) {
      _isError = true;
      setState(() {
        errorText = e.toString();
        _isLoading = false;
      });
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

  rejectInvite (String senderId1,String recieverId1,String role1,int index) async {
    setState(() {
      _isAcceptRejectButtonLoading = true;
    });

    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    HTTPManager().rejectNotificationInvite(senderId1, recieverId1, role1).then((value) {

      setState(() {
        acceptedConnectionsListResponse.removeAt(index);
        // badgeCount1 = badgeCount1-1;
        // sharedPreferences.setInt("BadgeCount", badgeCount1);
        showToastMessage(context, "Connection Rejected", true);
        _isAcceptRejectButtonLoading = false;
      });

    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
      setState(() {
        _isAcceptRejectButtonLoading = false;
      });
    });
  }

  acceptPendingPermission(int index,String connectionId,String permission) {
    setState(() {
      _isAcceptRejectButtonLoading = true;
    });
    HTTPManager().acceptRejectPendingPermission(PendingPermissionRequestModel(approverId:id,connectionId: connectionId,permission: permission)).then((value) {
      setState(() {
        _isAcceptRejectButtonLoading = false;
        pendingPermissionListDetails.removeAt(index);
        if(permission == "accept") {
          showToastMessage(context, "Permission request accepted", true);
        } else {
          showToastMessage(context, "Permission request rejected", true);
        }
      });
    }).catchError((e) {
      setState(() {
        _isAcceptRejectButtonLoading = false;
      });
      print("Permission reject");
      print(e.toString());
      showToastMessage(context, e.toString(), false);
    });
  }

  acceptInvite (String senderId1,String recieverId1,String role1,int index) async {
    setState(() {
      _isAcceptRejectButtonLoading = true;
    });
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    HTTPManager().acceptNotificationInvite(senderId1, recieverId1, role1).then((value) {

      setState(() {
        acceptedConnectionsListResponse.removeAt(index);
        // badgeCount1 = badgeCount1-1;
        // sharedPreferences.setInt("BadgeCount", badgeCount1);
        showToastMessage(context, "Connection Accepted successfully", true);
        _isAcceptRejectButtonLoading = false;
      });

    }).catchError((e) {
      setState(() {
        showToastMessage(context, e.toString(), false);
        _isAcceptRejectButtonLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:  AppBarWidget().appBarGeneralButtons(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, false, id, true,true,badgeCount1,false,badgeCountShared),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: !isPhone ?  MediaQuery.of(context).size.width/5:5),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  child: Column(
                    children: [
                      LogoScreen("Pending"),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConnectionCategoryItemType(
                                  () {
                                setState(() {
                                  isAllConnections = true;
                                  isMentorConnections = false;
                                  isPeerConnections = false;
                                  isMenteeConnections = false;
                                });
                              },"All",isAllConnections
                          ),
                          ConnectionCategoryItemType(
                                  () {
                                setState(() {
                                  isAllConnections = false;
                                  isMentorConnections = true;
                                  isPeerConnections = false;
                                  isMenteeConnections = false;
                                });
                              },"Mentor",isMentorConnections
                          ),
                          ConnectionCategoryItemType(
                                  () {
                                setState(() {
                                  isAllConnections = false;
                                  isMentorConnections = false;
                                  isPeerConnections = true;
                                  isMenteeConnections = false;
                                });
                              },"Peer",isPeerConnections
                          ),
                          ConnectionCategoryItemType(
                                  () {
                                setState(() {
                                  isAllConnections = false;
                                  isMentorConnections = false;
                                  isPeerConnections = false;
                                  isMenteeConnections = true;
                                });
                              },"Mentee",isMenteeConnections
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SageSearchScreen(badgeCount1,id,acceptedConnectionsListResponse,"Pending")));
                        },
                        child: OptionMcqAnswer(
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                              height: 30,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                              child: const Text("search here with title"),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                _isLoading || _isLoading1 ? const Center(
                  child: CircularProgressIndicator(),
                ) : _isError ?
                Expanded(
                  child:  ErrorTextAndButtonWidget(
                    errorText: errorText,onTap: (){
                    getConnectionList(true);
                    getPendingPermissonList(true);
                  },
                  ))
                    :   Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if(pendingPermissionListDetails.isNotEmpty)
                        HeadingWithButtonRow("Pending Permission",(){},false,(){
                          // if(acceptedConnectionsListResponse.isNotEmpty) {
                          //   Navigator.of(context).push(MaterialPageRoute(
                          //       builder: (context) =>
                          //           SageSearchScreen(badgeCount1, id,
                          //               acceptedConnectionsListResponse,
                          //               "Accepted")));
                          // }
                        },false),
                        const SizedBox(height: 5,),
                        pendingPermissionListDetails.isEmpty ?  Container() :
                        ListView.builder(
                            shrinkWrap: true,
                            physics:const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: pendingPermissionListDetails.length,
                            itemBuilder: (context,index) {
                              return id == pendingPermissionListDetails[index].firstUserDetail!.id ? PendingConnectionListItemWidget(
                                    (){
                                      acceptPendingPermission(index,pendingPermissionListDetails[index].pendingInfo![0].connectionId!,"accept");
                                },
                                    (){
                                      acceptPendingPermission(index,pendingPermissionListDetails[index].pendingInfo![0].connectionId!,"reject");
                                },
                                pendingPermissionListDetails[index].secondUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : pendingPermissionListDetails[index].secondUserDetail!.image!,
                                pendingPermissionListDetails[index].secondUserDetail!.name!.capitalize(),pendingPermissionListDetails[index].module!.isEmpty ? "None":pendingPermissionListDetails[index].module!.toString().replaceAll("[", "").replaceAll("]", "").replaceAll("app", "All").replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column").replaceAll("ladder", "Ladder").replaceAll("trellis", "Trellis"),
                              ) : PendingConnectionListItemWidget(
                                    (){
                                      acceptPendingPermission(index,pendingPermissionListDetails[index].pendingInfo![0].connectionId!,"accept");
                                },
                                    (){
                                      acceptPendingPermission(index,pendingPermissionListDetails[index].pendingInfo![0].connectionId!,"reject");
                                },
                                pendingPermissionListDetails[index].firstUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : pendingPermissionListDetails[index].firstUserDetail!.image!,
                                pendingPermissionListDetails[index].firstUserDetail!.name!.capitalize(),pendingPermissionListDetails[index].module!.isEmpty ? "None": pendingPermissionListDetails[index].module!.toString().replaceAll("[", "").replaceAll("]", "").replaceAll("app", "All").replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column").replaceAll("ladder", "Ladder").replaceAll("trellis", "Trellis"),
                              );
                            }),
                        const SizedBox(height: 5,),
                        HeadingWithButtonRow("Pending Requests",(){},false,(){
                          // if(acceptedConnectionsListResponse.isNotEmpty) {
                          //   Navigator.of(context).push(MaterialPageRoute(
                          //       builder: (context) =>
                          //           SageSearchScreen(badgeCount1, id,
                          //               acceptedConnectionsListResponse,
                          //               "Accepted")));
                          // }
                        },false),
                        const SizedBox(height: 5,),
                        acceptedConnectionsListResponse.isEmpty ? const Center(
                          child: Text("No Connections yet"),
                        )  : Column(
                          children: [
                            Visibility(
                              visible: isAllConnections,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics:const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: acceptedConnectionsListResponse.length,
                                  itemBuilder: (context,index) {
                                    return id == acceptedConnectionsListResponse[index].firstUserDetail!.id ? PendingConnectionListItem(
                                            (){
                                          acceptInvite (acceptedConnectionsListResponse[index].connectionInfo!.senderId!,acceptedConnectionsListResponse[index].connectionInfo!.receiverId!,acceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                            (){
                                          rejectInvite (acceptedConnectionsListResponse[index].connectionInfo!.senderId!,acceptedConnectionsListResponse[index].connectionInfo!.receiverId!,acceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                        acceptedConnectionsListResponse[index].secondUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : acceptedConnectionsListResponse[index].secondUserDetail!.image!,
                                        acceptedConnectionsListResponse[index].secondUserDetail!.name!.capitalize(),acceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),acceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.isEmpty? "None" :acceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("app", "All").replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column").replaceAll("ladder", "Ladder").replaceAll("trellis", "Trellis"),
                                    ) : PendingConnectionListItem(
                                            (){
                                          acceptInvite (acceptedConnectionsListResponse[index].connectionInfo!.senderId!,acceptedConnectionsListResponse[index].connectionInfo!.receiverId!,acceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                            (){
                                          rejectInvite (acceptedConnectionsListResponse[index].connectionInfo!.senderId!,acceptedConnectionsListResponse[index].connectionInfo!.receiverId!,acceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                        acceptedConnectionsListResponse[index].firstUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : acceptedConnectionsListResponse[index].firstUserDetail!.image!,
                                        acceptedConnectionsListResponse[index].firstUserDetail!.name!.capitalize(),acceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),acceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.isEmpty? "None" :acceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("app", "All").replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column").replaceAll("ladder", "Ladder").replaceAll("trellis", "Trellis"),
                                    );
                                  }),
                            ),
                            Visibility(
                              visible: isMentorConnections,
                              child: mentorAcceptedConnectionsListResponse.isEmpty ? const Center(
                                child: Text("No Connections yet"),
                              )  : ListView.builder(
                                  shrinkWrap: true,
                                  physics:const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: mentorAcceptedConnectionsListResponse.length,
                                  itemBuilder: (context,index) {
                                    return id == mentorAcceptedConnectionsListResponse[index].firstUserDetail!.id ? PendingConnectionListItem(
                                            (){
                                          acceptInvite (mentorAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,mentorAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,mentorAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                            (){
                                          rejectInvite (mentorAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,mentorAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,mentorAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                        mentorAcceptedConnectionsListResponse[index].secondUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : mentorAcceptedConnectionsListResponse[index].secondUserDetail!.image!,
                                        mentorAcceptedConnectionsListResponse[index].secondUserDetail!.name!.capitalize(),mentorAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),mentorAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column").replaceAll("ladder", "Ladder").replaceAll("trellis", "Trellis").replaceAll("app", "All"),
                                    ) : PendingConnectionListItem(
                                            (){
                                          acceptInvite (mentorAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,mentorAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,mentorAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                            (){
                                          rejectInvite (mentorAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,mentorAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,mentorAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                        mentorAcceptedConnectionsListResponse[index].firstUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : mentorAcceptedConnectionsListResponse[index].firstUserDetail!.image!,
                                        mentorAcceptedConnectionsListResponse[index].firstUserDetail!.name!.capitalize(),mentorAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),mentorAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column").replaceAll("ladder", "Ladder").replaceAll("trellis", "Trellis").replaceAll("app", "All"),
                                    );
                                  }),),
                            Visibility(
                              visible: isPeerConnections,
                              child: peerAcceptedConnectionsListResponse.isEmpty ? const Center(
                                child: Text("No Connections yet"),
                              )  : ListView.builder(
                                  shrinkWrap: true,
                                  physics:const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: peerAcceptedConnectionsListResponse.length,
                                  itemBuilder: (context,index) {
                                    return id == peerAcceptedConnectionsListResponse[index].firstUserDetail!.id ? PendingConnectionListItem(
                                            (){
                                          acceptInvite (peerAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,peerAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,peerAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                            (){
                                          rejectInvite (peerAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,peerAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,peerAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                        peerAcceptedConnectionsListResponse[index].secondUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : peerAcceptedConnectionsListResponse[index].secondUserDetail!.image!,
                                        peerAcceptedConnectionsListResponse[index].secondUserDetail!.name!.capitalize(),peerAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),peerAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column").replaceAll("ladder", "Ladder").replaceAll("trellis", "Trellis").replaceAll("app", "All"),
                                    ) : PendingConnectionListItem(
                                            (){
                                          acceptInvite (peerAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,peerAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,peerAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                            (){
                                          rejectInvite (peerAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,peerAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,peerAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                        peerAcceptedConnectionsListResponse[index].firstUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : peerAcceptedConnectionsListResponse[index].firstUserDetail!.image!,
                                        peerAcceptedConnectionsListResponse[index].firstUserDetail!.name!.capitalize(),peerAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),peerAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column").replaceAll("ladder", "Ladder").replaceAll("trellis", "Trellis").replaceAll("app", "All"),
                                    );
                                  }),),
                            Visibility(
                              visible: isMenteeConnections,
                              child: menteeAcceptedConnectionsListResponse.isEmpty ? const Center(
                                child: Text("No Connections yet"),
                              )  : ListView.builder(
                                  shrinkWrap: true,
                                  physics:const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: menteeAcceptedConnectionsListResponse.length,
                                  itemBuilder: (context,index) {
                                    return id == menteeAcceptedConnectionsListResponse[index].firstUserDetail!.id ? PendingConnectionListItem(
                                            (){
                                          acceptInvite (menteeAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,menteeAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,menteeAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                            (){
                                          rejectInvite (menteeAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,menteeAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,menteeAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                        menteeAcceptedConnectionsListResponse[index].secondUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : menteeAcceptedConnectionsListResponse[index].secondUserDetail!.image!,
                                        menteeAcceptedConnectionsListResponse[index].secondUserDetail!.name!.capitalize(),menteeAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),menteeAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column").replaceAll("ladder", "Ladder").replaceAll("trellis", "Trellis").replaceAll("app", "All"),
                                    ) : PendingConnectionListItem(
                                            (){
                                          acceptInvite (menteeAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,menteeAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,menteeAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                            (){
                                          rejectInvite (menteeAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,menteeAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,menteeAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                                        },
                                        menteeAcceptedConnectionsListResponse[index].firstUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : menteeAcceptedConnectionsListResponse[index].firstUserDetail!.image!,
                                        menteeAcceptedConnectionsListResponse[index].firstUserDetail!.name!.capitalize(),menteeAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),menteeAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column").replaceAll("ladder", "Ladder").replaceAll("trellis", "Trellis").replaceAll("app", "All"),
                                    );
                                  }),),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Visibility(
                visible: _isAcceptRejectButtonLoading,
                child:const Center(
                  child: CircularProgressIndicator(),
                ))
          ],
        ),
      )
    );
  }
}
