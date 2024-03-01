// ignore_for_file: must_be_immutable, avoid_print, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../../model/reponse_model/Tribe/tribe_single_item_shared_list.dart';
import '../../model/request_model/Sage Request/invite_connection_request.dart';
import '../../model/request_model/Tribe/all_single_item_shared_request.dart';
import '../../network/http_manager.dart';
import '../Column/Widgets/search_text_field.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Trellis/widgets/bottom_sheet.dart';
import '../Tribe/tribe_screen_module_single_item_list.dart';
import '../Widgets/error_text_and_button_widget.dart';
import '../Widgets/toast_message.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';
import 'Widgets/connection_user_list_item.dart';
import 'Widgets/connection_user_list_item_for_accepted.dart';
import 'Widgets/pending_connection_list_item.dart';

class SageSearchScreen extends StatefulWidget {
  SageSearchScreen(this.badgeCount,this.userId,this.connectionsListResponse,this.previousPage,{Key? key}) : super(key: key);
  String previousPage;
  List<AcceptedConnectionItem> connectionsListResponse;
  String userId;
  int badgeCount;

  @override
  State<SageSearchScreen> createState() => _SageSearchScreenState();
}

class _SageSearchScreenState extends State<SageSearchScreen> {

  List<AcceptedConnectionItem> searchAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  final TextEditingController _searchController = TextEditingController();
  late bool isPhone;
  late bool isTable;
  late bool isDesktop;
  bool _isAcceptRejectButtonLoading = false;
  int badgeCountShared = 0;
  int badgeCount1 = 0;
  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";
  bool otherUserLoggedIn = false;

  bool _isError = false;
  // bool _isError2 = false;
  String errorText = "";

  bool _isLoading = true;

  String selectedRole = "Mentor";
  List<String> selectedModules = [];
  String selectedModulesString = "";

  List<AllSingleShareItemsList> allSingleItemsShared = <AllSingleShareItemsList>[];

  @override
  void initState() {
    // TODO: implement initState
    print("Previous Page");
    print(widget.previousPage);
    searchAcceptedConnectionsListResponse = widget.connectionsListResponse;
    _getUserData();
    super.initState();
  }

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      _isUserDataLoading = true;
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

    getAllSingleSharedItemList(true);

    setState(() {
      _isUserDataLoading = false;
    });
  }

  getAllSingleSharedItemList(bool isLoading1) {
    setState(() {
      _isLoading = isLoading1;
    });

    HTTPManager().tribeAllSingleItemsSharedRead(TribeAllSingleSharedRequestModel(requesterId: id)).then((value) {
      setState(() {
        allSingleItemsShared = value.data!;

        _isLoading = false;
        _isError = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        errorText = e.toString();
        _isError = true;
      });
    });
  }

  getScreenDetails() {
    setState(() {});
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


  rejectInvite (String senderId1,String recieverId1,String role1,int index) {
    setState(() {
      _isAcceptRejectButtonLoading = true;
    });

    HTTPManager().rejectNotificationInvite(senderId1, recieverId1, role1).then((value) {

      setState(() {
        searchAcceptedConnectionsListResponse.removeAt(index);
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

  acceptInvite (String senderId1,String recieverId1,String role1,int index) {
    setState(() {
      _isAcceptRejectButtonLoading = true;
    });

    HTTPManager().acceptNotificationInvite(senderId1, recieverId1, role1).then((value) {

      setState(() {
        searchAcceptedConnectionsListResponse.removeAt(index);
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

  setSessionForAllAppShare(bool otherUserLoggedIn, String otherUserId,
      String otherUserName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool(
        UserConstants().otherUserLoggedIn, otherUserLoggedIn);
    sharedPreferences.setString(UserConstants().otherUserId, otherUserId);
    sharedPreferences.setString(UserConstants().otherUserName, otherUserName);
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
          }, true, true, true, widget.userId, true,true,badgeCount1,false,badgeCountShared),
      body:  Container(
        margin: EdgeInsets.symmetric(horizontal: !isPhone ?  MediaQuery.of(context).size.width/5:5),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  child: Column(
                    children: [
                      LogoScreen("SearchConnection"),
                      const SizedBox(height: 3),
                      SearchTextField((value) {
                        if(value.isEmpty) {
                          setState(() {
                            searchAcceptedConnectionsListResponse = widget.connectionsListResponse;
                          });
                        } else {
                          filterList(value);
                        }
                      }, _searchController, 1, false, "search here with user name"),
                    ],
                  ),
                ),

                _isLoading ? const CircularProgressIndicator() : _isError ? ErrorTextAndButtonWidget(
                  errorText: errorText,onTap: (){
                  getAllSingleSharedItemList(true);
                },
                ) : Expanded(
                    child: SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics:const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: searchAcceptedConnectionsListResponse.length,
                      itemBuilder: (context,index) {
                        return widget.previousPage == "Accepted" ? widget.userId == searchAcceptedConnectionsListResponse[index].firstUserDetail!.id ? AcceptedConnectionListItem(
                            otherUser: otherUserLoggedIn,
                            userItemTap: (){
                              if (!otherUserLoggedIn) {
                                if (searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.contains("app")) {
                                  setSessionForAllAppShare(true,
                                      searchAcceptedConnectionsListResponse[index].secondUserDetail!.id!,
                                      searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Dashboard())).then((value) {
                                    setSessionForAllAppShare(false,
                                        searchAcceptedConnectionsListResponse[index].firstUserDetail!.id!,
                                        searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!);
                                  });
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                      TribeScreenModuleSingleItemList(
                                          searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!.toString(),
                                          searchAcceptedConnectionsListResponse[index].secondUserDetail!.id!.toString(),
                                          searchAcceptedConnectionsListResponse[index].connectionInfo!.id.toString(),
                                          searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!,
                                          searchAcceptedConnectionsListResponse[index].connectionInfo!.role!))).then((value) {
                                    setSessionForAllAppShare(false,
                                        searchAcceptedConnectionsListResponse[index].firstUserDetail!.id!,
                                        searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!);
                                  });
                                }
                              } else {
                                if (widget.userId ==
                                    searchAcceptedConnectionsListResponse[index].firstUserDetail!.id) {
                                  if (searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.contains("app")) {
                                    setSessionForAllAppShare(true,
                                        searchAcceptedConnectionsListResponse[index].secondUserDetail!.id!,
                                        searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!);
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Dashboard())).then((value) {
                                      setSessionForAllAppShare(false,
                                          searchAcceptedConnectionsListResponse[index].firstUserDetail!.id!,
                                          searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!);
                                    });
                                  } else {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TribeScreenModuleSingleItemList(
                                        searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!.toString(),
                                        searchAcceptedConnectionsListResponse[index].secondUserDetail!.id!.toString(),
                                        searchAcceptedConnectionsListResponse[index].connectionInfo!.id.toString(),
                                        searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!,
                                        searchAcceptedConnectionsListResponse[index].connectionInfo!.role!))).then((value) {
                                      setSessionForAllAppShare(false,
                                          searchAcceptedConnectionsListResponse[index].firstUserDetail!.id!,
                                          searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!);
                                    });
                                  }
                                }
                              }
                            },
                            userEditTap:  (){
                              editConnectionItem(searchAcceptedConnectionsListResponse[index],index,true,searchAcceptedConnectionsListResponse[index].secondUserDetail!.id!);
                            },
                            accessibleModuleList: searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                            sharedModuleList: searchAcceptedConnectionsListResponse[index].connectionInfo!.sharingModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                            imageUrl: searchAcceptedConnectionsListResponse[index].secondUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : searchAcceptedConnectionsListResponse[index].secondUserDetail!.image!,
                            userName: searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!.capitalize(),connectionType:searchAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize()
                        ) : AcceptedConnectionListItem(
                            otherUser: otherUserLoggedIn,
                            userItemTap: (){
                              if (!otherUserLoggedIn) {
                                if (searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.contains("app")) {
                                  setSessionForAllAppShare(true, searchAcceptedConnectionsListResponse[index].secondUserDetail!.id!,
                                      searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Dashboard())).then((value) {
                                    setSessionForAllAppShare(false,
                                        searchAcceptedConnectionsListResponse[index].firstUserDetail!.id!,
                                        searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!);
                                  });
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TribeScreenModuleSingleItemList(
                                      searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!.toString(),
                                      searchAcceptedConnectionsListResponse[index].secondUserDetail!.id!.toString(),
                                      searchAcceptedConnectionsListResponse[index].connectionInfo!.id.toString(),
                                      searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!,
                                      searchAcceptedConnectionsListResponse[index].connectionInfo!.role!))).then((value) {
                                    setSessionForAllAppShare(false, searchAcceptedConnectionsListResponse[index].firstUserDetail!.id!, searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!);
                                  });
                                }
                              } else {
                                if (widget.userId == searchAcceptedConnectionsListResponse[index].firstUserDetail!.id) {
                                  if (searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.contains("app")) {
                                    setSessionForAllAppShare(
                                        true,
                                        searchAcceptedConnectionsListResponse[index].secondUserDetail!.id!,
                                        searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!);
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Dashboard())).then((value) {
                                      setSessionForAllAppShare(
                                          false,
                                          searchAcceptedConnectionsListResponse[index].firstUserDetail!.id!,
                                          searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!);
                                    });
                                  } else {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TribeScreenModuleSingleItemList(
                                        searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!.toString(),
                                        searchAcceptedConnectionsListResponse[index].secondUserDetail!.id!.toString(),
                                        searchAcceptedConnectionsListResponse[index].connectionInfo!.id.toString(),
                                        searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!,
                                        searchAcceptedConnectionsListResponse[index].connectionInfo!.role!))).then((value) {
                                      setSessionForAllAppShare(
                                          false,
                                          searchAcceptedConnectionsListResponse[index].firstUserDetail!.id!,
                                          searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!);
                                    });
                                  }
                                }
                              }
                            },
                            userEditTap:  (){
                              editConnectionItem(searchAcceptedConnectionsListResponse[index],index,true,searchAcceptedConnectionsListResponse[index].firstUserDetail!.id!);
                            },
                            accessibleModuleList: searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                            sharedModuleList: searchAcceptedConnectionsListResponse[index].connectionInfo!.sharingModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                            imageUrl: searchAcceptedConnectionsListResponse[index].firstUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : searchAcceptedConnectionsListResponse[index].firstUserDetail!.image!,
                            userName: searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!.capitalize(),connectionType:searchAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize()
                        ) : widget.previousPage == "Pending" ? widget.userId == searchAcceptedConnectionsListResponse[index].firstUserDetail!.id ? PendingConnectionListItem(
                                (){
                              acceptInvite (searchAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,searchAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,searchAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                            },
                                (){
                              rejectInvite (searchAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,searchAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,searchAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                            },
                            searchAcceptedConnectionsListResponse[index].secondUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : searchAcceptedConnectionsListResponse[index].secondUserDetail!.image!,
                            searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!.capitalize(),searchAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),"P.I.R.E"
                        ) : PendingConnectionListItem(
                                (){
                              acceptInvite (searchAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,searchAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,searchAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                            },
                                (){
                              rejectInvite (searchAcceptedConnectionsListResponse[index].connectionInfo!.senderId!,searchAcceptedConnectionsListResponse[index].connectionInfo!.receiverId!,searchAcceptedConnectionsListResponse[index].connectionInfo!.role!,index);
                            },
                             searchAcceptedConnectionsListResponse[index].firstUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : searchAcceptedConnectionsListResponse[index].firstUserDetail!.image!,
                             searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!.capitalize(),searchAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),"P.I.R.E"
                        ) : widget.userId == searchAcceptedConnectionsListResponse[index].firstUserDetail!.id ? ConnectionUserInvitedListItem(
                          otherUser: otherUserLoggedIn,
                          userItemTap: () {
                          },
                          userEditTap:  (){
                            editConnectionItem(searchAcceptedConnectionsListResponse[index],index,false,searchAcceptedConnectionsListResponse[index].secondUserDetail!.id!);
                          },
                            imageUrl: searchAcceptedConnectionsListResponse[index].secondUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : searchAcceptedConnectionsListResponse[index].secondUserDetail!.image!,
                            userName: searchAcceptedConnectionsListResponse[index].secondUserDetail!.name!.capitalize(),connectionType:searchAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),
                          // accessibleModuleList: searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                          sharedModuleList: searchAcceptedConnectionsListResponse[index].connectionInfo!.sharingModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                        ) : ConnectionUserInvitedListItem(
                          otherUser: otherUserLoggedIn,
                          userItemTap: () {

                          },
                          userEditTap:  (){
                            editConnectionItem(searchAcceptedConnectionsListResponse[index],index,false,searchAcceptedConnectionsListResponse[index].firstUserDetail!.id!);
                          },
                            imageUrl: searchAcceptedConnectionsListResponse[index].firstUserDetail!.image == "" ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg" : searchAcceptedConnectionsListResponse[index].firstUserDetail!.image!,
                            userName: searchAcceptedConnectionsListResponse[index].firstUserDetail!.name!.capitalize(),connectionType:searchAcceptedConnectionsListResponse[index].connectionInfo!.role!.capitalize(),
                          // accessibleModuleList: searchAcceptedConnectionsListResponse[index].connectionInfo!.acceptedModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                          sharedModuleList: searchAcceptedConnectionsListResponse[index].connectionInfo!.sharingModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ").replaceAll("column", "Column"),
                        );
                      }),
                ))

              ],
            ),
            Visibility(
                visible: _isAcceptRejectButtonLoading,
                child:const Center(
                  child: CircularProgressIndicator(),
                ))
          ],
        ),
      ),

    );
  }

  void editConnectionItem(AcceptedConnectionItem acceptedConnectionItem,int index,bool isConnectionAccept,String recieverId) {

    List<ShareSingleItemDetails> pireList = <ShareSingleItemDetails>[];
    List<ShareSingleItemDetails> naqList = <ShareSingleItemDetails>[];
    List<ShareSingleItemDetails> columnList = <ShareSingleItemDetails>[];
    List<ShareSingleItemDetails> ladderList = <ShareSingleItemDetails>[];

    ShareSingleItemDetails? shareSingleItemDetailsForDelete;

    for(int i=0; i<allSingleItemsShared.length;i++) {
      if(acceptedConnectionItem.connectionInfo!.id == allSingleItemsShared[i].connectionId) {
        for(int j=0; j<allSingleItemsShared[i].shareList!.length; j++) {
          setState(() {
            if(allSingleItemsShared[i].shareList![j].type == "column") {
              columnList.add(allSingleItemsShared[i].shareList![j]);
            } else if(allSingleItemsShared[i].shareList![j].type == "pire") {
              pireList.add(allSingleItemsShared[i].shareList![j]);
            } else if(allSingleItemsShared[i].shareList![j].type == "naq") {
              naqList.add(allSingleItemsShared[i].shareList![j]);
            } else {
              ladderList.add(allSingleItemsShared[i].shareList![j]);
            }
          });
        }
      }
    }

    String selectedModulesForEdit = acceptedConnectionItem.connectionInfo!
        .sharingModules!.replaceAll("pire", "P.I.R.E").replaceAll("naq", "NAQ")
        .replaceAll("column", "Column").replaceAll("ladder", "Ladder")
        .replaceAll("trellis", "Trellis")
        .replaceAll("app", "All");

    List<String> selectedItems = selectedModulesForEdit.split(",").toList();
    setState(() {
      print("Selected Role");
      selectedRole = acceptedConnectionItem.connectionInfo!.role!.capitalize();
      print(selectedRole);
    });

    if (acceptedConnectionItem.connectionInfo!.sharingModules!.isEmpty) {
      editSendConnectionBottomSheet(
          context,
          isConnectionAccept,
          [],
          acceptedConnectionItem.connectionInfo!.role!.capitalize(), (value) {
        setState(() {
          selectedModules = value;
          selectedModulesString =
              selectedModules.toString().replaceAll("[", "").replaceAll("]", "")
                  .replaceAll("P.I.R.E", "pire").replaceAll("NAQ", "naq")
                  .replaceAll("Column", "column")
                  .replaceAll("All", "app");
        });
      }, () {
        updateConnection(
            index,
            isConnectionAccept,
            acceptedConnectionItem,
            acceptedConnectionItem.connectionInfo!.id!,
            selectedModulesString,
            selectedRole,
            recieverId);
      }, (value) {
        setState(() {
          selectedRole = value;
          print("Selected Role");
          print(selectedRole);
        });
      },(){
        _deleteSingleShareItem(shareSingleItemDetailsForDelete!.id.toString());
      },pireList,naqList,columnList,ladderList,(value){
        setState(() {
          print(value.id);
          shareSingleItemDetailsForDelete = value;
        });
      });
    } else {
      editSendConnectionBottomSheet(
          context,
          isConnectionAccept,
          selectedItems,
          acceptedConnectionItem.connectionInfo!.role!.capitalize(), (value) {
        setState(() {
          selectedModules = value;
          selectedModulesString =
              selectedModules.toString().replaceAll("[", "").replaceAll("]", "")
                  .replaceAll("P.I.R.E", "pire").replaceAll("NAQ", "naq")
                  .replaceAll("Column", "column")
                  .replaceAll("All", "app");
          print("selectedModules");
          print(selectedModulesString);
        });
      }, () {
        updateConnection(
            index,
            isConnectionAccept,
            acceptedConnectionItem,
            acceptedConnectionItem.connectionInfo!.id!,
            selectedModulesString,
            selectedRole,
            recieverId);
      }, (value) {
        setState(() {
          selectedRole = value;
          print("Selected Role");
          print(selectedRole);
        });
      },(){
        _deleteSingleShareItem(shareSingleItemDetailsForDelete!.id.toString());
      },pireList,naqList,columnList,ladderList,(value){
        setState(() {
          print(value.id);
          shareSingleItemDetailsForDelete = value;
        });
      });
    }

  }

  updateConnection(int index, bool isConnectionAccept,
      AcceptedConnectionItem acceptedConnectionItem, String connectionID,
      String moduleName, String recieverRole, String recieverId) {
    setState(() {
      _isAcceptRejectButtonLoading = true;
    });

    print(index);
    print(connectionID);
    print(moduleName);
    print(recieverRole);

    if (isConnectionAccept) {
      HTTPManager().editConnectionRequest(EditConnectionRequestModel(
          connectionId: connectionID,
          module: moduleName,
          role: recieverRole,
          senderId: id,
          recieverId: recieverId)).then((value) {
        AcceptedConnectionItem acceptedConnectionItem1 = AcceptedConnectionItem(
            connectionInfo: ConnectionInfo(
              id: connectionID,
              accept: acceptedConnectionItem.connectionInfo!.accept,
              senderId: acceptedConnectionItem.connectionInfo!.senderId,
              receiverId: acceptedConnectionItem.connectionInfo!.receiverId,
              sharingModules: isConnectionAccept ? acceptedConnectionItem
                  .connectionInfo!.sharingModules : moduleName,
              acceptedModules: acceptedConnectionItem.connectionInfo!.acceptedModules,
              role: recieverRole,
              message: acceptedConnectionItem.connectionInfo!.message,
              senderName: acceptedConnectionItem.connectionInfo!.senderName,
              receiverName: acceptedConnectionItem.connectionInfo!.receiverName,
            ),
            firstUserDetail: acceptedConnectionItem.firstUserDetail,
            secondUserDetail: acceptedConnectionItem.secondUserDetail);
        setState(() {

            searchAcceptedConnectionsListResponse[index] = acceptedConnectionItem1;


            _isAcceptRejectButtonLoading = false;
        });

        Navigator.of(context).pop();
        if(moduleName.isEmpty) {
          showToastMessage(context, "You have removed module permissions", true);
        } else {
          showToastMessage(context, "You have sent module permission request", true);
        }
      }).catchError((e) {
        setState(() {
          _isAcceptRejectButtonLoading = false;
        });
        print(e.toString());
        // Navigator.of(context).pop();
        showToastMessage(context, e.toString(), false);
      });
    } else {
      HTTPManager().editConnectionAcceptNoRequest(EditConnectionAcceptNoRequestModel(
          connectionId: connectionID,
          module: moduleName,
          role: recieverRole)).then((value) {
        AcceptedConnectionItem acceptedConnectionItem1 = AcceptedConnectionItem(
            connectionInfo: ConnectionInfo(
              id: connectionID,
              accept: acceptedConnectionItem.connectionInfo!.accept,
              senderId: acceptedConnectionItem.connectionInfo!.senderId,
              receiverId: acceptedConnectionItem.connectionInfo!.receiverId,
              sharingModules: isConnectionAccept ? acceptedConnectionItem
                  .connectionInfo!.sharingModules : moduleName,
              acceptedModules: acceptedConnectionItem.connectionInfo!.acceptedModules,
              role: recieverRole,
              message: acceptedConnectionItem.connectionInfo!.message,
              senderName: acceptedConnectionItem.connectionInfo!.senderName,
              receiverName: acceptedConnectionItem.connectionInfo!.receiverName,
            ),
            firstUserDetail: acceptedConnectionItem.firstUserDetail,
            secondUserDetail: acceptedConnectionItem.secondUserDetail);
        setState(() {
            searchAcceptedConnectionsListResponse[index] = acceptedConnectionItem1;


            _isAcceptRejectButtonLoading = false;
        });

        Navigator.of(context).pop();

        showToastMessage(context, "Your connection request is updated", true);
      }).catchError((e) {
        setState(() {
          _isAcceptRejectButtonLoading = false;
        });
        print(e.toString());
        // Navigator.of(context).pop();
        showToastMessage(context, e.toString(), false);
      });
    }
  }

  _deleteSingleShareItem(String singleShareId) {
    setState(() {
      _isAcceptRejectButtonLoading = true;
    });

    HTTPManager().tribeSingleItemsSharedDelete(TribeSingleSharedDeleteRequestModel(singleShareId: singleShareId)).then((value) {
      setState(() {
        _isAcceptRejectButtonLoading = false;
        for(int i=0; i<allSingleItemsShared.length;i++) {
          for(int j=0; j<allSingleItemsShared[i].shareList!.length; j++) {
            setState(() {
              if(allSingleItemsShared[i].shareList![j].id.toString() == singleShareId) {
                allSingleItemsShared[i].shareList!.removeAt(j);
              }
            });
          }

        }
      });

      showToastMessage(context, "You have removed this item from sharing ", true);
    }).catchError((e) {
      setState(() {
        _isAcceptRejectButtonLoading = false;
      });
    });
  }

  void filterList(String query) {
    setState(() {
      searchAcceptedConnectionsListResponse =
          widget.connectionsListResponse
              .where((AcceptedConnectionItem item) =>
              (" ${item.connectionInfo!.senderName!
                  .toString()} ${item
                  .connectionInfo!.receiverName
                  .toString()}")
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
    });
  }
}
