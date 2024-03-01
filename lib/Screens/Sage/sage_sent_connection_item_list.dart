// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:flutter_quiz_app/Screens/Sage/sage_search_screen.dart';
import 'package:flutter_quiz_app/model/reponse_model/Sage/accepted_connections_list_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../model/request_model/Sage Request/invite_connection_request.dart';
import '../../network/http_manager.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Trellis/widgets/bottom_sheet.dart';
import '../Widgets/toast_message.dart';
import '../utill/userConstants.dart';
import 'Widgets/connection_user_list_item.dart';

class SentConnectionList extends StatefulWidget {
  SentConnectionList( this.sentConnectionsListResponse, {Key? key}) : super(key: key);

  List<AcceptedConnectionItem> sentConnectionsListResponse;

  @override
  State<SentConnectionList> createState() => _SentConnectionListState();
}

class _SentConnectionListState extends State<SentConnectionList> {

  String name = "";
  String id = "";
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

  bool _isInviteDataLoading = false;

  int badgeCount1 = 0;
  int badgeCountShared = 0;

  String selectedRole = "Mentor";
  List<String> selectedModules = [];
  String selectedModulesString = "";

  bool otherUserLoggedIn = false;


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
  void initState() {
    // TODO: implement initState

    _getUserData();

    super.initState();
  }

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
    });
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    // badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;
    otherUserLoggedIn = sharedPreferences.getBool(UserConstants().otherUserLoggedIn)!;

    if(otherUserLoggedIn) {

      id = sharedPreferences.getString(UserConstants().otherUserId)!;
      name = sharedPreferences.getString(UserConstants().otherUserName)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

    } else {
      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;
    }
    // getSearchUserList();

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
                      LogoScreen("SentConnection"),
                      // const SizedBox(height: 3),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     ConnectionCategoryItemType(
                      //             () {
                      //           setState(() {
                      //             isAllConnections = true;
                      //             isMentorConnections = false;
                      //             isPeerConnections = false;
                      //             isMenteeConnections = false;
                      //           });
                      //         },"All",isAllConnections
                      //     ),
                      //     ConnectionCategoryItemType(
                      //             () {
                      //           setState(() {
                      //             isAllConnections = false;
                      //             isMentorConnections = true;
                      //             isPeerConnections = false;
                      //             isMenteeConnections = false;
                      //           });
                      //         },"Mentor",isMentorConnections
                      //     ),
                      //     ConnectionCategoryItemType(
                      //             () {
                      //           setState(() {
                      //             isAllConnections = false;
                      //             isMentorConnections = false;
                      //             isPeerConnections = true;
                      //             isMenteeConnections = false;
                      //           });
                      //         },"Peer",isPeerConnections
                      //     ),
                      //     ConnectionCategoryItemType(
                      //             () {
                      //           setState(() {
                      //             isAllConnections = false;
                      //             isMentorConnections = false;
                      //             isPeerConnections = false;
                      //             isMenteeConnections = true;
                      //           });
                      //         },"Mentee",isMenteeConnections
                      //     ),
                      //     const SizedBox(height: 5,),
                      //     const SizedBox(height: 5,),
                      //   ],
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SageSearchScreen(badgeCount1,id,widget.sentConnectionsListResponse,"Request")));
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
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics:const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: widget.sentConnectionsListResponse.length,
                        itemBuilder: (context,index) {
                          return id == widget.sentConnectionsListResponse[index].firstUserDetail!.id ? ConnectionUserInvitedListItem(
                            otherUser: otherUserLoggedIn,
                            userItemTap: (){},
                            userEditTap:  (){
                              editConnectionItem(index,false,widget.sentConnectionsListResponse[index],widget.sentConnectionsListResponse[index].secondUserDetail!.id!);
                            },
                            imageUrl: widget.sentConnectionsListResponse[index].secondUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : widget.sentConnectionsListResponse[index].secondUserDetail!.image!,
                            userName: widget.sentConnectionsListResponse[index].secondUserDetail!.name!.capitalize(),connectionType:widget.sentConnectionsListResponse[index].connectionInfo!.role!.capitalize(),
                            // accessibleModuleList:  widget.sentConnectionsListResponse[0].connectionInfo!.acceptedModules!.isEmpty ? "None" :  widget.sentConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                            sharedModuleList:  widget.sentConnectionsListResponse[0].connectionInfo!.sharingModules!.isEmpty ? "None" :  widget.sentConnectionsListResponse[index].connectionInfo!.sharingModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                          ) : ConnectionUserInvitedListItem(
                            otherUser: otherUserLoggedIn,
                            userItemTap:  (){},
                            userEditTap:  (){
                              editConnectionItem(index,false,widget.sentConnectionsListResponse[index],widget.sentConnectionsListResponse[index].firstUserDetail!.id!);
                            },
                            imageUrl: widget.sentConnectionsListResponse[index].firstUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : widget.sentConnectionsListResponse[index].firstUserDetail!.image!,
                            userName: widget.sentConnectionsListResponse[index].firstUserDetail!.name!.capitalize(),connectionType:widget.sentConnectionsListResponse[index].connectionInfo!.role!.capitalize(),
                            // accessibleModuleList:  widget.sentConnectionsListResponse[0].connectionInfo!.acceptedModules!.isEmpty ? "None" :  widget.sentConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                            sharedModuleList:  widget.sentConnectionsListResponse[index].connectionInfo!.sharingModules!.isEmpty ? "None" :  widget.sentConnectionsListResponse[index].connectionInfo!.sharingModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                          );
                        }),
                  ),
                )
              ],
            ),
            _isInviteDataLoading ? const Center(child: CircularProgressIndicator())
                : Container()
          ],
        )
      )

    );
  }

  void editConnectionItem(int index,bool isConnectionAccept,AcceptedConnectionItem acceptedConnectionItem,String recieverId) {

    String selectedModulesForEdit = acceptedConnectionItem.connectionInfo!.sharingModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column");
    List<String> selectedItems = selectedModulesForEdit.split(",").toList();

    setState(() {
      selectedRole = acceptedConnectionItem.connectionInfo!.role!.capitalize();
    });

    if(acceptedConnectionItem.connectionInfo!.sharingModules!.isEmpty) {
      editSendConnectionBottomSheet(context,isConnectionAccept, [], acceptedConnectionItem.connectionInfo!.role!.capitalize(), (value) {
        setState(() {
          selectedModules = value;
          selectedModulesString = selectedModules.toString().replaceAll("[", "").replaceAll("]", "").replaceAll("P.I.R.E", "pire").replaceAll("NAQ", "naq").replaceAll("Column", "column").replaceAll("All", "app");
        });
      }, (){
        updateConnection(index,acceptedConnectionItem.connectionInfo!.id!,selectedModulesString,selectedRole,recieverId);
      }, (value){
        setState(() {
          selectedRole = value;

        });
      },(){},[],[],[],[],(value){});
    } else {
      editSendConnectionBottomSheet(context,isConnectionAccept, selectedItems, acceptedConnectionItem.connectionInfo!.role!.capitalize(), (value) {
        setState(() {
          selectedModules = value;
          selectedModulesString = selectedModules.toString().replaceAll("[", "").replaceAll("]", "").replaceAll("P.I.R.E", "pire").replaceAll("NAQ", "naq").replaceAll("Column", "column").replaceAll(" ", "").replaceAll("All", "app");
        });
      }, (){

        updateConnection(index,acceptedConnectionItem.connectionInfo!.id!,selectedModulesString,selectedRole,recieverId);

      }, (value){
        setState(() {
          selectedRole = value;

        });
      },(){},[],[],[],[],(value){});
    }

  }

  updateConnection(int index,String connectionID,String moduleName,String recieverRole,String recieverId) {
    setState(() {
      _isInviteDataLoading = true;
    });

    HTTPManager().editConnectionRequest(EditConnectionRequestModel(connectionId: connectionID,module: moduleName,role: recieverRole,senderId: id,recieverId: recieverId)).then((value) {


      AcceptedConnectionItem acceptedConnectionItem1 = AcceptedConnectionItem(connectionInfo: ConnectionInfo(
        id : connectionID,
        accept : widget.sentConnectionsListResponse[index].connectionInfo!.accept,
        senderId : widget.sentConnectionsListResponse[index].connectionInfo!.senderId,
        receiverId : widget.sentConnectionsListResponse[index].connectionInfo!.receiverId,
        sharingModules : widget.sentConnectionsListResponse[index].connectionInfo!.sharingModules!,
        acceptedModules: widget.sentConnectionsListResponse[index].connectionInfo!.acceptedModules,
        role : recieverRole,
        message : widget.sentConnectionsListResponse[index].connectionInfo!.message,
        senderName : widget.sentConnectionsListResponse[index].connectionInfo!.senderName,
        receiverName : widget.sentConnectionsListResponse[index].connectionInfo!.receiverName,
      ) ,
          firstUserDetail:widget.sentConnectionsListResponse[index].firstUserDetail ,
          secondUserDetail:widget.sentConnectionsListResponse[index].secondUserDetail);

      setState(() {
          widget.sentConnectionsListResponse[index] = acceptedConnectionItem1;
        _isInviteDataLoading = false;
      });

      Navigator.of(context).pop();

      showToastMessage(context, "Connection updated successfully", true);

    }).catchError((e) {
      setState(() {
        _isInviteDataLoading = false;
      });
      // Navigator.of(context).pop();
      showToastMessage(context, e.toString(), false);
    });
  }

}
