// ignore_for_file: avoid_print, duplicate_ignore, unused_field

import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:flutter_quiz_app/Screens/Sage/sage_search_screen.dart';
import 'package:flutter_quiz_app/Screens/Tribe/tribe_screen_module_single_item_list.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/model/request_model/Tribe/all_single_item_shared_request.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/email_field.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../../model/reponse_model/Sage/user_search_list_response.dart';
import '../../model/reponse_model/Tribe/tribe_single_item_shared_list.dart';
import '../../model/request_model/Sage Request/invite_connection_request.dart';
import '../../model/request_model/Sage Request/search_request_model.dart';

import '../../model/request_model/Tribe/pending_permission_sent_request.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Sage/Widgets/connection_user_list_item.dart';
import '../Sage/Widgets/connection_user_list_item_for_accepted.dart';
import '../Sage/Widgets/heading_with_button_in_row.dart';
import '../Sage/Widgets/pending_connection_list_item.dart';
import '../Trellis/widgets/bottom_sheet.dart';
import '../Widgets/error_text_and_button_widget.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';

class TribeScreen extends StatefulWidget {
  const TribeScreen({Key? key}) : super(key: key);

  @override
  State<TribeScreen> createState() => _TribeScreenState();
}

class _TribeScreenState extends State<TribeScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isError = false;
  bool _isError1 = false;
  // bool _isError2 = false;
  String errorText = "";

  bool _isLoading = true;
  bool _isAcceptLoading = true;
  // bool _isRequestLoading = true;

  bool _isInviteDataLoading = false;
  String email = "";
  String timeZone = "";
  String userType = "";
  bool otherUserLoggedIn = false;
  String? currentUserID;

  String selectedRole = "Mentor";
  List<String> selectedModules = [];
  String selectedModulesString = "";
  late UsersSearchData selectedUsersData;
  final _formKey = GlobalKey<FormState>();

  List<UsersSearchData> connectionUserListResponse1 = <UsersSearchData>[];

  // late List <UsersSearchData> usersSearchData;


  final TextEditingController _emailController = TextEditingController();

  List<AcceptedConnectionItem> acceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> mentorAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> peerAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> menteeAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> searchAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];

  List<AcceptedConnectionItem> sentConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> mentorSentConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> peerSentConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> menteeSentConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> searchSentConnectionsListResponse = <AcceptedConnectionItem>[];

  List<PendingPermissionSentItem> pendingPermissionListDetails = <PendingPermissionSentItem>[];

  List<AllSingleShareItemsList> allSingleItemsShared = <AllSingleShareItemsList>[];

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;


  bool isAllConnections = true;
  bool isMentorConnections = false;
  bool isPeerConnections = false;
  bool isMenteeConnections = false;

  bool isSearchConnections = false;
  int badgeCount1 = 0;
  int badgeCountShared = 0;
  int selectedRadio = 1;

  final List<String> roleItems = [
    'All',
    'Mentor',
    'Peer',
    'Mentee',
  ];
  String roleInitialItem = "All";

  bool isConnectedConnections = true;
  bool isPendingConnections = false;
  bool isPermissionConnections = false;
  // bool _isLoading1 = true;

  final List<String> connectionItems = [
    'Connected',
    'Pending',
    'Permission',
  ];
  String connectionInitialItem = "Connected";

  @override
  void initState() {
    // TODO: implement initState

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

    otherUserLoggedIn =
    sharedPreferences.getBool(UserConstants().otherUserLoggedIn)!;
    currentUserID = sharedPreferences.getString(UserConstants().userId)!;
    if (otherUserLoggedIn) {
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
    getSearchUserList(true);

    getConnectionList(true);

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

  getSearchUserList(bool isLoading1) {
    setState(() {
      _isLoading = isLoading1;
    });

    HTTPManager().getSearchConnectionUserList(
        SearchConnectionUserRequestModel(senderId: id)).then((value) {
      setState(() {
        connectionUserListResponse1 = value.usersData!;

        connectionUserListResponse1.sort((a, b) {
          return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });

        selectedUsersData = connectionUserListResponse1[0];

        _isLoading = false;
        _isError = false;
        errorText = "";
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        print("User Search API");
        print(e.toString());
        errorText = e.toString();
        _isError = true;
      });
    });
  }

  getPendingPermissonList(bool isLoading1) {
    setState(() {
      _isAcceptLoading = isLoading1;
    });

    HTTPManager()
        .getPendingPermssionRequestList(LogoutRequestModel(userId: id))
        .then((value) {
      setState(() {
        pendingPermissionListDetails = value.data!;

        _isError1 = false;
        // timer = Timer.periodic(const Duration(seconds: 10), (Timer t) =>  getConnectionList(false));
        errorText = "";
        _isAcceptLoading = false;
      });
    }).catchError((e) {
      _isError1 = true;
      setState(() {
        errorText = e.toString();
        _isAcceptLoading = false;
      });
    });
  }

  getConnectionList(bool isLoading1) {
    setState(() {
      _isAcceptLoading = isLoading1;
    });

    HTTPManager()
        .getAcceptedConnectionList(LogoutRequestModel(userId: id))
        .then((value) {
      setState(() {
        acceptedConnectionsListResponse = value.data!;
        searchAcceptedConnectionsListResponse = value.data!;

        for (int i = 0; i < acceptedConnectionsListResponse.length; i++) {
          if (id == acceptedConnectionsListResponse[i].firstUserDetail!.id) {
            acceptedConnectionsListResponse.sort((a, b) {
              return a.secondUserDetail!.name!.toLowerCase().compareTo(
                  b.secondUserDetail!.name!.toLowerCase());
            });
            searchAcceptedConnectionsListResponse.sort((a, b) {
              return a.secondUserDetail!.name!.toLowerCase().compareTo(
                  b.secondUserDetail!.name!.toLowerCase());
            });
          } else {
            acceptedConnectionsListResponse.sort((a, b) {
              return a.firstUserDetail!.name!.toLowerCase().compareTo(
                  b.firstUserDetail!.name!.toLowerCase());
            });
            searchAcceptedConnectionsListResponse.sort((a, b) {
              return a.firstUserDetail!.name!.toLowerCase().compareTo(
                  b.firstUserDetail!.name!.toLowerCase());
            });
          }
        }

        for (int i = 0; i < acceptedConnectionsListResponse.length; i++) {
          if (acceptedConnectionsListResponse[i].connectionInfo!.role ==
              "peer") {
            peerAcceptedConnectionsListResponse.add(
                acceptedConnectionsListResponse[i]);
          } else if (acceptedConnectionsListResponse[i].connectionInfo!.role ==
              "mentor") {
            mentorAcceptedConnectionsListResponse.add(
                acceptedConnectionsListResponse[i]);
          } else {
            menteeAcceptedConnectionsListResponse.add(
                acceptedConnectionsListResponse[i]);
          }
        }
        errorText = "";
        _isAcceptLoading = false;
        _isError1 = false;
      });
    }).catchError((e) {
      setState(() {
        errorText = e.toString();
        _isAcceptLoading = false;
        _isError1 = true;
      });
    });
  }

  getSentConnectionList(bool isLoading1) {
    setState(() {
      _isAcceptLoading = isLoading1;
    });

    HTTPManager().getSentConnectionList(LogoutRequestModel(userId: id)).then((
        value) {
      setState(() {
        sentConnectionsListResponse = value.data!;
        searchSentConnectionsListResponse = value.data!;

        for (int i = 0; i < sentConnectionsListResponse.length; i++) {
          if (id == sentConnectionsListResponse[i].firstUserDetail!.id) {
            sentConnectionsListResponse.sort((a, b) {
              return a.secondUserDetail!.name!.toLowerCase().compareTo(
                  b.secondUserDetail!.name!.toLowerCase());
            });
            searchSentConnectionsListResponse.sort((a, b) {
              return a.secondUserDetail!.name!.toLowerCase().compareTo(
                  b.secondUserDetail!.name!.toLowerCase());
            });
          } else {
            sentConnectionsListResponse.sort((a, b) {
              return a.firstUserDetail!.name!.toLowerCase().compareTo(
                  b.firstUserDetail!.name!.toLowerCase());
            });
            searchSentConnectionsListResponse.sort((a, b) {
              return a.firstUserDetail!.name!.toLowerCase().compareTo(
                  b.firstUserDetail!.name!.toLowerCase());
            });
          }
        }

        for (int i = 0; i < sentConnectionsListResponse.length; i++) {
          if (sentConnectionsListResponse[i].connectionInfo!.role == "peer") {
            peerSentConnectionsListResponse.add(sentConnectionsListResponse[i]);
          } else
          if (sentConnectionsListResponse[i].connectionInfo!.role == "mentor") {
            mentorSentConnectionsListResponse.add(
                sentConnectionsListResponse[i]);
          } else {
            mentorSentConnectionsListResponse.add(
                sentConnectionsListResponse[i]);
          }
        }
        errorText = "";
        _isAcceptLoading = false;
        _isError1 = false;
      });
    }).catchError((e) {
      setState(() {
        errorText = e.toString();
        _isAcceptLoading = false;
        _isError1 = true;
      });
    });
  }

  getScreenDetails() {
    setState(() {});
    if (MediaQuery
        .of(context)
        .size
        .width < 650) {
      isPhone = true;
      isDesktop = false;
      isTable = false;
    } else if (MediaQuery
        .of(context)
        .size
        .width >= 650 && MediaQuery
        .of(context)
        .size
        .width < 1100) {
      isTable = true;
      isPhone = false;
      isDesktop = false;
    } else if (MediaQuery
        .of(context)
        .size
        .width >= 1100) {
      isPhone = false;
      isDesktop = true;
      isTable = false;
    }
    setState(() {});
  }

  setSelectedRadio(int val) {
    // print(val);
    setState(() {
      selectedRadio = val;
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
        backgroundColor: AppColors.hoverColor,
        floatingActionButton: Visibility(
          visible: !_isLoading && !_isError && !otherUserLoggedIn,
          child: FloatingActionButton(
            onPressed: () {
              sendConnectionBottomSheet(
                  context, (value) {
                setState(() {
                  selectedUsersData = value;
                });
              }, (value) {
                setState(() {
                  selectedRole = value;

                  print(selectedRole);
                });
              }, () {
                late String selectedRole1;
                if (selectedRole == "Mentor") {
                  setState(() {
                    selectedRole1 = "mentor";
                  });
                } else if (selectedRole == "Peer") {
                  setState(() {
                    selectedRole1 = "peer";
                  });
                } else {
                  setState(() {
                    selectedRole1 = "mentee";
                  });
                }
                if (selectedRadio == 1) {
                  sendConnectionInvite(
                      selectedUsersData.email!, selectedModulesString,
                      selectedRole1);
                } else {
                  if (_formKey.currentState!.validate()) {
                    sendConnectionInviteEmail(
                        _emailController.text, selectedModulesString,
                        selectedRole1);
                  }
                }
              },
                  connectionUserListResponse1, (value) {
                setState(() {
                  selectedRadio = value;
                });
              },
                  selectedRadio,
                  Form(
                      key: _formKey,
                      child: EmailField(
                          _emailController, "Type email here...")), (value) {
                setState(() {
                  selectedModules = value;
                  selectedModulesString = selectedModules.toString().replaceAll(
                      "[", "").replaceAll("]", "").replaceAll("P.I.R.E", "pire")
                      .replaceAll("NAQ", "naq").replaceAll("Column", "column")
                      .replaceAll("Trellis", "trellis").replaceAll(
                      "Garden", "garden")
                      .replaceAll("Ladder", "ladder");
                  print("selectedModules");
                  print(selectedModulesString);
                });
              });
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const AddNewConnection()));
            },
            child: const Icon(
              Icons.add, color: AppColors.hoverColor, size: 25,),),
        ),
        appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
            context,
                () {
              if (otherUserLoggedIn) {
                Navigator.of(context).pop();
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const Dashboard()),
                        (Route<dynamic> route) => false
                );
              }
            },
            true,
            true,
            true,
            id,
            true,
            true,
            badgeCount1,
            false,
            badgeCountShared,
            otherUserLoggedIn,
            name),
        body: Container(
          padding: const EdgeInsets.only(bottom: 50),
          margin: EdgeInsets.symmetric(horizontal: !isPhone ? MediaQuery
              .of(context)
              .size
              .width / 6 : 5),
          child: Stack(
            children: [
              Column(
                children: [
                  LogoScreen("Tribe"),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, left: 2, right: 2),
                      decoration: const BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          )
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: OptionMcqAnswer(
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2 <String>(
                                      isExpanded: true,
                                      value: connectionInitialItem,
                                      onChanged: (String? value) {
                                        setState(() {
                                          connectionInitialItem = value!;
                                        });
                                        if (connectionInitialItem ==
                                            "Connected") {
                                          isAllConnections = true;
                                          isMentorConnections = false;
                                          isPeerConnections = false;
                                          isMenteeConnections = false;

                                          roleInitialItem = "All";

                                          getConnectionList(true);

                                          isConnectedConnections = true;
                                          isPendingConnections = false;
                                          isPermissionConnections = false;
                                        } else if (connectionInitialItem ==
                                            "Pending") {
                                          isConnectedConnections = false;
                                          isPendingConnections = true;
                                          isPermissionConnections = false;

                                          getSentConnectionList(true);
                                        } else {
                                          isConnectedConnections = false;
                                          isPendingConnections = false;
                                          isPermissionConnections = true;

                                          getPendingPermissonList(true);
                                        }
                                      },
                                      items: connectionItems.map((e) =>
                                          DropdownMenuItem<String>(
                                            value: e.toString(),
                                            child: Text(
                                              e.toString(),
                                              style: const TextStyle(
                                                fontSize: AppConstants
                                                    .defaultFontSize,
                                              ),
                                            ),
                                          )).toList(),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5,),
                              Visibility(
                                visible: isConnectedConnections,
                                child: Expanded(
                                  child: OptionMcqAnswer(
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2 <String>(
                                        isExpanded: true,
                                        value: roleInitialItem,
                                        onChanged: (String? value) {
                                          setState(() {
                                            roleInitialItem = value!;
                                          });
                                          if (roleInitialItem == "All") {
                                            isAllConnections = true;
                                            isMentorConnections = false;
                                            isPeerConnections = false;
                                            isMenteeConnections = false;
                                          } else
                                          if (roleInitialItem == "Mentor") {
                                            isAllConnections = false;
                                            isMentorConnections = true;
                                            isPeerConnections = false;
                                            isMenteeConnections = false;
                                          } else
                                          if (roleInitialItem == "Peer") {
                                            isAllConnections = false;
                                            isMentorConnections = false;
                                            isPeerConnections = true;
                                            isMenteeConnections = false;
                                          } else {
                                            isAllConnections = false;
                                            isMentorConnections = false;
                                            isPeerConnections = false;
                                            isMenteeConnections = true;
                                          }
                                        },
                                        items: roleItems.map((e) =>
                                            DropdownMenuItem<String>(
                                              value: e.toString(),
                                              child: Text(
                                                e.toString(),
                                                style: const TextStyle(
                                                  fontSize: AppConstants
                                                      .defaultFontSize,
                                                ),
                                              ),
                                            )).toList(),),
                                    ),
                                  ),
                                ),
                              ),
                              // ConnectionCategoryItemType(
                              //         () {
                              //       setState(() {
                              //         isAllConnections = true;
                              //         isMentorConnections = false;
                              //         isPeerConnections = false;
                              //         isMenteeConnections = false;
                              //       });
                              //     },"All",isAllConnections
                              // ),
                              // ConnectionCategoryItemType(
                              //         () {
                              //       setState(() {
                              //         isAllConnections = false;
                              //         isMentorConnections = true;
                              //         isPeerConnections = false;
                              //         isMenteeConnections = false;
                              //       });
                              //     },"Mentor",isMentorConnections
                              // ),
                              // ConnectionCategoryItemType(
                              //         () {
                              //       setState(() {
                              //         isAllConnections = false;
                              //         isMentorConnections = false;
                              //         isPeerConnections = true;
                              //         isMenteeConnections = false;
                              //       });
                              //     },"Peer",isPeerConnections
                              // ),
                              // ConnectionCategoryItemType(
                              //         () {
                              //       setState(() {
                              //         isAllConnections = false;
                              //         isMentorConnections = false;
                              //         isPeerConnections = false;
                              //         isMenteeConnections = true;
                              //       });
                              //     },"Mentee",isMenteeConnections
                              // ),
                            ],
                          ),
                          // const SizedBox(height: 5,),
                          // InkWell(
                          //   onTap: () {
                          //     if(acceptedConnectionsListResponse.isNotEmpty) {
                          //       Navigator.of(context).push(MaterialPageRoute(
                          //           builder: (context) =>
                          //               SageSearchScreen(badgeCount1, id,
                          //                   acceptedConnectionsListResponse,
                          //                   "Accepted")));
                          //     }
                          //   },
                          //   child: OptionMcqAnswer(
                          //       Container(
                          //         alignment: Alignment.centerLeft,
                          //         padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                          //         height: 30,
                          //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                          //         child: const Text("search here with title"),
                          //       )
                          //   ),
                          // ),

                          _isLoading || _isAcceptLoading ? const Center(
                              child: CircularProgressIndicator()) : _isError1 ?
                          Expanded(
                              child:  ErrorTextAndButtonWidget(
                                errorText: errorText,onTap: (){
                                getSearchUserList(true);

                                if (connectionInitialItem ==
                                    "Connected") {
                                  isAllConnections = true;
                                  isMentorConnections = false;
                                  isPeerConnections = false;
                                  isMenteeConnections = false;

                                  roleInitialItem = "All";

                                  getConnectionList(true);

                                  isConnectedConnections = true;
                                  isPendingConnections = false;
                                  isPermissionConnections = false;
                                } else if (connectionInitialItem ==
                                    "Pending") {
                                  isConnectedConnections = false;
                                  isPendingConnections = true;
                                  isPermissionConnections = false;

                                  getSentConnectionList(true);
                                } else {
                                  isConnectedConnections = false;
                                  isPendingConnections = false;
                                  isPermissionConnections = true;

                                  getPendingPermissonList(true);
                                }
                              },
                              ))
                              : Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5,),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      _isLoading ? Container() :
                                      Visibility(
                                          visible: isPendingConnections,
                                          child: Column(
                                            children: [
                                              HeadingWithButtonRow(
                                                  "Pending Request", () {},
                                                  false, () {
                                                if (sentConnectionsListResponse
                                                    .isNotEmpty) {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SageSearchScreen(
                                                                  badgeCount1,
                                                                  id,
                                                                  sentConnectionsListResponse,
                                                                  "Request")));
                                                }
                                              }, true),
                                              const SizedBox(height: 5,),
                                              sentConnectionsListResponse
                                                  .isNotEmpty ? ListView
                                                  .builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  scrollDirection: Axis
                                                      .vertical,
                                                  itemCount: sentConnectionsListResponse
                                                      .length,
                                                  itemBuilder: (context,
                                                      index) {
                                                    return id ==
                                                        sentConnectionsListResponse[index]
                                                            .firstUserDetail!.id
                                                        ? ConnectionUserInvitedListItem(
                                                      otherUser: otherUserLoggedIn,
                                                      userItemTap: () {

                                                      },
                                                      userEditTap: () {
                                                        editConnectionItem(
                                                            index, false,
                                                            sentConnectionsListResponse[index],
                                                            sentConnectionsListResponse[index]
                                                                .secondUserDetail!
                                                                .id!);
                                                      },
                                                      imageUrl: sentConnectionsListResponse[index]
                                                          .secondUserDetail!
                                                          .image == ""
                                                          ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                          : sentConnectionsListResponse[index]
                                                          .secondUserDetail!
                                                          .image!,
                                                      userName: sentConnectionsListResponse[index]
                                                          .secondUserDetail!
                                                          .name!.capitalize(),
                                                      connectionType: sentConnectionsListResponse[index]
                                                          .connectionInfo!.role!
                                                          .capitalize(),
                                                      // accessibleModuleList: sentConnectionsListResponse[index]
                                                      //     .connectionInfo!
                                                      //     .acceptedModules!.isEmpty
                                                      //     ? "None"
                                                      //     : sentConnectionsListResponse[index]
                                                      //     .connectionInfo!
                                                      //     .acceptedModules!.contains(
                                                      //     "app")
                                                      //     ? "All"
                                                      //     : sentConnectionsListResponse[index]
                                                      //     .connectionInfo!
                                                      //     .acceptedModules!.replaceAll(
                                                      //     "pire", "P.I.R.E")
                                                      //     .replaceAll(
                                                      //     "naq", "NAQ")
                                                      //     .replaceAll(
                                                      //     "column", "Column")
                                                      //     .replaceAll(
                                                      //     "ladder", "Ladder")
                                                      //     .replaceAll(
                                                      //     "trellis", "Trellis"),
                                                      sharedModuleList: sentConnectionsListResponse[index]
                                                          .connectionInfo!
                                                          .sharingModules!.isEmpty
                                                          ? "None"
                                                          : sentConnectionsListResponse[index]
                                                          .connectionInfo!
                                                          .sharingModules!.contains(
                                                          "app")
                                                          ? "All"
                                                          : sentConnectionsListResponse[index]
                                                          .connectionInfo!
                                                          .sharingModules!.replaceAll(
                                                          "pire", "P.I.R.E")
                                                          .replaceAll(
                                                          "naq", "NAQ")
                                                          .replaceAll(
                                                          "column", "Column")
                                                          .replaceAll(
                                                          "ladder", "Ladder")
                                                          .replaceAll(
                                                          "trellis", "Trellis"),
                                                    )
                                                        : ConnectionUserInvitedListItem(
                                                      otherUser: otherUserLoggedIn,
                                                      userItemTap: () {

                                                      },
                                                      userEditTap: () {
                                                        editConnectionItem(
                                                            index, false,
                                                            sentConnectionsListResponse[index],
                                                            sentConnectionsListResponse[index]
                                                                .firstUserDetail!
                                                                .id!);
                                                      },
                                                      imageUrl: sentConnectionsListResponse[index]
                                                          .firstUserDetail!
                                                          .image == ""
                                                          ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                          : sentConnectionsListResponse[index]
                                                          .firstUserDetail!
                                                          .image!,
                                                      userName: sentConnectionsListResponse[index]
                                                          .firstUserDetail!
                                                          .name!.capitalize(),
                                                      connectionType: sentConnectionsListResponse[index]
                                                          .connectionInfo!.role!
                                                          .capitalize(),
                                                      // accessibleModuleList: sentConnectionsListResponse[index]
                                                      //     .connectionInfo!
                                                      //     .acceptedModules!.isEmpty
                                                      //     ? "None"
                                                      //     : sentConnectionsListResponse[index]
                                                      //     .connectionInfo!
                                                      //     .acceptedModules!.contains(
                                                      //     "app")
                                                      //     ? "All"
                                                      //     : sentConnectionsListResponse[index]
                                                      //     .connectionInfo!
                                                      //     .acceptedModules!.replaceAll(
                                                      //     "pire", "P.I.R.E")
                                                      //     .replaceAll(
                                                      //     "naq", "NAQ")
                                                      //     .replaceAll(
                                                      //     "column", "Column")
                                                      //     .replaceAll(
                                                      //     "ladder", "Ladder")
                                                      //     .replaceAll(
                                                      //     "trellis", "Trellis"),
                                                      sharedModuleList: sentConnectionsListResponse[index]
                                                          .connectionInfo!
                                                          .sharingModules!.isEmpty
                                                          ? "None"
                                                          : sentConnectionsListResponse[index]
                                                          .connectionInfo!
                                                          .sharingModules!.contains(
                                                          "app")
                                                          ? "All"
                                                          : sentConnectionsListResponse[index]
                                                          .connectionInfo!
                                                          .sharingModules!.replaceAll(
                                                          "pire", "P.I.R.E")
                                                          .replaceAll(
                                                          "naq", "NAQ")
                                                          .replaceAll(
                                                          "column", "Column")
                                                          .replaceAll(
                                                          "ladder", "Ladder")
                                                          .replaceAll(
                                                          "trellis", "Trellis"),
                                                    );
                                                  }) : const Center(
                                                child: Text(
                                                    "No Connections Request sent"),)
                                            ],
                                          )
                                      ),
                                      Visibility(
                                          visible: isPermissionConnections,
                                          child: Column(
                                            children: [
                                              HeadingWithButtonRow(
                                                  "Pending Permission", () {},
                                                  false, () {
                                                // if(acceptedConnectionsListResponse.isNotEmpty) {
                                                //   Navigator.of(context).push(MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           SageSearchScreen(badgeCount1, id,
                                                //               acceptedConnectionsListResponse,
                                                //               "Accepted")));
                                                // }
                                              }, false),
                                              const SizedBox(height: 5,),
                                              pendingPermissionListDetails
                                                  .isEmpty ? const Center(
                                                child: Text(
                                                    "No Permission Request sent"),
                                              ) :
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  scrollDirection: Axis
                                                      .vertical,
                                                  itemCount: pendingPermissionListDetails
                                                      .length,
                                                  itemBuilder: (context,
                                                      index) {
                                                    return id ==
                                                        pendingPermissionListDetails[index]
                                                            .firstUserDetail!.id
                                                        ? PendingConnectionRequestListItemWidget(

                                                      pendingPermissionListDetails[index]
                                                          .secondUserDetail!
                                                          .image == ""
                                                          ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                          : pendingPermissionListDetails[index]
                                                          .secondUserDetail!
                                                          .image!,
                                                      pendingPermissionListDetails[index]
                                                          .secondUserDetail!
                                                          .name!.capitalize(),
                                                      pendingPermissionListDetails[index]
                                                          .module!.toString()
                                                          .replaceAll("[", "")
                                                          .replaceAll("]", "")
                                                          .replaceAll(
                                                          "app", "All")
                                                          .replaceAll(
                                                          "pire", "P.I.R.E")
                                                          .replaceAll(
                                                          "naq", "NAQ")
                                                          .replaceAll(
                                                          "column", "Column")
                                                          .replaceAll(
                                                          "ladder", "Ladder")
                                                          .replaceAll(
                                                          "trellis", "Trellis"),
                                                    )
                                                        : PendingConnectionRequestListItemWidget(
                                                      pendingPermissionListDetails[index]
                                                          .firstUserDetail!
                                                          .image == ""
                                                          ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                          : pendingPermissionListDetails[index]
                                                          .firstUserDetail!
                                                          .image!,
                                                      pendingPermissionListDetails[index]
                                                          .firstUserDetail!
                                                          .name!.capitalize(),
                                                      pendingPermissionListDetails[index]
                                                          .module!.toString()
                                                          .replaceAll("[", "")
                                                          .replaceAll("]", "")
                                                          .replaceAll(
                                                          "app", "All")
                                                          .replaceAll(
                                                          "pire", "P.I.R.E")
                                                          .replaceAll(
                                                          "naq", "NAQ")
                                                          .replaceAll(
                                                          "column", "Column")
                                                          .replaceAll(
                                                          "ladder", "Ladder")
                                                          .replaceAll(
                                                          "trellis", "Trellis"),
                                                    );
                                                  }),
                                            ],
                                          )),
                                      Visibility(
                                        visible: isConnectedConnections,
                                        child: Column(
                                          children: [
                                            HeadingWithButtonRow(
                                                "Connected People", () {},
                                                false, () {
                                              if (acceptedConnectionsListResponse
                                                  .isNotEmpty) {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SageSearchScreen(
                                                                badgeCount1, id,
                                                                acceptedConnectionsListResponse,
                                                                "Accepted")));
                                              }
                                            }, true),
                                            const SizedBox(height: 5,),
                                            Visibility(
                                              visible: isSearchConnections,
                                              child: searchAcceptedConnectionsListResponse
                                                  .isEmpty ? const Center(
                                                child: Text(
                                                    "No Connections yet"),
                                              ) : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  scrollDirection: Axis
                                                      .vertical,
                                                  itemCount: searchAcceptedConnectionsListResponse
                                                      .length,
                                                  itemBuilder: (context,
                                                      index) {
                                                    return id ==
                                                        searchAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!.id
                                                        ? AcceptedConnectionListItem(
                                                        otherUser: otherUserLoggedIn,
                                                        userItemTap: () async {
                                                          if (!otherUserLoggedIn) {
                                                            if (searchAcceptedConnectionsListResponse[index]
                                                                .connectionInfo!
                                                                .acceptedModules!
                                                                .contains(
                                                                "app")) {
                                                              setSessionForAllAppShare(
                                                                  true,
                                                                  searchAcceptedConnectionsListResponse[index]
                                                                      .secondUserDetail!
                                                                      .id!,
                                                                  searchAcceptedConnectionsListResponse[index]
                                                                      .secondUserDetail!
                                                                      .name!);

                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) => const Dashboard()))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);
                                                              });
                                                            } else {
                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          TribeScreenModuleSingleItemList(
                                                                              searchAcceptedConnectionsListResponse[index]
                                                                                  .secondUserDetail!
                                                                                  .name!
                                                                                  .toString(),
                                                                              searchAcceptedConnectionsListResponse[index]
                                                                                  .secondUserDetail!
                                                                                  .id!
                                                                                  .toString(),
                                                                              searchAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .id
                                                                                  .toString(),
                                                                              searchAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .acceptedModules!,
                                                                              searchAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .role!)))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);

                                                                getSearchUserList(
                                                                    false);

                                                                getConnectionList(
                                                                    false);

                                                                getSentConnectionList(
                                                                    false);

                                                                getPendingPermissonList(
                                                                    false);
                                                              });
                                                            }
                                                          } else {
                                                            if (currentUserID ==
                                                                searchAcceptedConnectionsListResponse[index]
                                                                    .firstUserDetail!
                                                                    .id) {
                                                              if (searchAcceptedConnectionsListResponse[index]
                                                                  .connectionInfo!
                                                                  .acceptedModules!
                                                                  .contains(
                                                                  "app")) {
                                                                setSessionForAllAppShare(
                                                                    true,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);

                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) => const Dashboard()))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      searchAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .id!,
                                                                      searchAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .name!);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TribeScreenModuleSingleItemList(
                                                                                searchAcceptedConnectionsListResponse[index]
                                                                                    .secondUserDetail!
                                                                                    .name!
                                                                                    .toString(),
                                                                                searchAcceptedConnectionsListResponse[index]
                                                                                    .secondUserDetail!
                                                                                    .id!
                                                                                    .toString(),
                                                                                searchAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .id
                                                                                    .toString(),
                                                                                searchAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .acceptedModules!,
                                                                                searchAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .role!)))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      searchAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .id!,
                                                                      searchAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .name!);

                                                                  getSearchUserList(
                                                                      false);

                                                                  getConnectionList(
                                                                      false);

                                                                  getSentConnectionList(
                                                                      false);

                                                                  getPendingPermissonList(
                                                                      false);
                                                                });
                                                              }
                                                            }
                                                          }
                                                        },
                                                        userEditTap: () {
                                                          editConnectionItem(
                                                              index, true,
                                                              searchAcceptedConnectionsListResponse[index],
                                                              searchAcceptedConnectionsListResponse[index]
                                                                  .secondUserDetail!
                                                                  .id!);
                                                        },
                                                        accessibleModuleList: searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.isEmpty
                                                            ? "None"
                                                            : searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        sharedModuleList: searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.isEmpty
                                                            ? "None"
                                                            : searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        imageUrl: searchAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .image == ""
                                                            ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                            : searchAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .image!,
                                                        userName: searchAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .name!.capitalize(),
                                                        connectionType: searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .role!.capitalize()
                                                    )
                                                        : AcceptedConnectionListItem(
                                                        otherUser: otherUserLoggedIn,
                                                        userItemTap: () {
                                                          if (!otherUserLoggedIn) {
                                                            if (searchAcceptedConnectionsListResponse[index]
                                                                .connectionInfo!
                                                                .acceptedModules!
                                                                .contains(
                                                                "app")) {
                                                              setSessionForAllAppShare(
                                                                  true,
                                                                  searchAcceptedConnectionsListResponse[index]
                                                                      .firstUserDetail!
                                                                      .id!,
                                                                  searchAcceptedConnectionsListResponse[index]
                                                                      .firstUserDetail!
                                                                      .name!);

                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) => const Dashboard()))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);
                                                              });
                                                            } else {
                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          TribeScreenModuleSingleItemList(
                                                                              searchAcceptedConnectionsListResponse[index]
                                                                                  .firstUserDetail!
                                                                                  .name!
                                                                                  .toString(),
                                                                              searchAcceptedConnectionsListResponse[index]
                                                                                  .firstUserDetail!
                                                                                  .id!
                                                                                  .toString(),
                                                                              searchAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .id
                                                                                  .toString(),
                                                                              searchAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .acceptedModules!,
                                                                              searchAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .role!)))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);
                                                                getSearchUserList(
                                                                    false);

                                                                getConnectionList(
                                                                    false);

                                                                getSentConnectionList(
                                                                    false);

                                                                getPendingPermissonList(
                                                                    false);
                                                              });
                                                            }
                                                          } else {
                                                            if (currentUserID ==
                                                                searchAcceptedConnectionsListResponse[index]
                                                                    .secondUserDetail!
                                                                    .id!) {
                                                              if (searchAcceptedConnectionsListResponse[index]
                                                                  .connectionInfo!
                                                                  .acceptedModules!
                                                                  .contains(
                                                                  "app")) {
                                                                setSessionForAllAppShare(
                                                                    true,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    searchAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);

                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) => const Dashboard()))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      searchAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .id!,
                                                                      searchAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .name!);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TribeScreenModuleSingleItemList(
                                                                                searchAcceptedConnectionsListResponse[index]
                                                                                    .firstUserDetail!
                                                                                    .name!
                                                                                    .toString(),
                                                                                searchAcceptedConnectionsListResponse[index]
                                                                                    .firstUserDetail!
                                                                                    .id!
                                                                                    .toString(),
                                                                                searchAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .id
                                                                                    .toString(),
                                                                                searchAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .acceptedModules!,
                                                                                searchAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .role!)))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      searchAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .id!,
                                                                      searchAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .name!);

                                                                  getSearchUserList(
                                                                      false);

                                                                  getConnectionList(
                                                                      false);

                                                                  getSentConnectionList(
                                                                      false);

                                                                  getPendingPermissonList(
                                                                      false);
                                                                });
                                                              }
                                                            }
                                                          }
                                                        },
                                                        userEditTap: () {
                                                          editConnectionItem(
                                                              index, true,
                                                              searchAcceptedConnectionsListResponse[index],
                                                              searchAcceptedConnectionsListResponse[index]
                                                                  .firstUserDetail!
                                                                  .id!);
                                                        },
                                                        accessibleModuleList: searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.isEmpty
                                                            ? "None"
                                                            : searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        sharedModuleList: searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.isEmpty
                                                            ? "None"
                                                            : searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        imageUrl: searchAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .image == ""
                                                            ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                            : searchAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .image!,
                                                        userName: searchAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .name!.capitalize(),
                                                        connectionType: searchAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .role!.capitalize()
                                                    );
                                                  }),),
                                            Visibility(
                                              visible: isAllConnections,
                                              child: acceptedConnectionsListResponse
                                                  .isEmpty ? const Center(
                                                child: Text(
                                                    "No Connections yet"),
                                              ) : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  scrollDirection: Axis
                                                      .vertical,
                                                  itemCount: acceptedConnectionsListResponse
                                                      .length,
                                                  itemBuilder: (context,
                                                      index) {
                                                    return id ==
                                                        acceptedConnectionsListResponse[index]
                                                            .firstUserDetail!.id
                                                        ? AcceptedConnectionListItem(
                                                        otherUser: otherUserLoggedIn,
                                                        userItemTap: () {
                                                          print(currentUserID);
                                                          print(
                                                              acceptedConnectionsListResponse[index]
                                                                  .firstUserDetail!
                                                                  .id!);

                                                          if (!otherUserLoggedIn) {
                                                            if (acceptedConnectionsListResponse[index]
                                                                .connectionInfo!
                                                                .acceptedModules!
                                                                .contains(
                                                                "app")) {
                                                              setSessionForAllAppShare(
                                                                  true,
                                                                  acceptedConnectionsListResponse[index]
                                                                      .secondUserDetail!
                                                                      .id!,
                                                                  acceptedConnectionsListResponse[index]
                                                                      .secondUserDetail!
                                                                      .name!);

                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) => const Dashboard()))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);
                                                              });
                                                            } else {
                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          TribeScreenModuleSingleItemList(
                                                                              acceptedConnectionsListResponse[index]
                                                                                  .secondUserDetail!
                                                                                  .name!
                                                                                  .toString(),
                                                                              acceptedConnectionsListResponse[index]
                                                                                  .secondUserDetail!
                                                                                  .id!
                                                                                  .toString(),
                                                                              acceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .id
                                                                                  .toString(),
                                                                              acceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .acceptedModules!,
                                                                              acceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .role!)))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);

                                                                getSearchUserList(
                                                                    false);

                                                                getConnectionList(
                                                                    false);

                                                                getSentConnectionList(
                                                                    false);

                                                                getPendingPermissonList(
                                                                    false);
                                                              });
                                                            }
                                                          } else {
                                                            if (currentUserID ==
                                                                acceptedConnectionsListResponse[index]
                                                                    .firstUserDetail!
                                                                    .id!) {
                                                              if (acceptedConnectionsListResponse[index]
                                                                  .connectionInfo!
                                                                  .acceptedModules!
                                                                  .contains(
                                                                  "app")) {
                                                                setSessionForAllAppShare(
                                                                    true,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);

                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) => const Dashboard()))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      acceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .id!,
                                                                      acceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .name!);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TribeScreenModuleSingleItemList(
                                                                                acceptedConnectionsListResponse[index]
                                                                                    .secondUserDetail!
                                                                                    .name!
                                                                                    .toString(),
                                                                                acceptedConnectionsListResponse[index]
                                                                                    .secondUserDetail!
                                                                                    .id!
                                                                                    .toString(),
                                                                                acceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .id
                                                                                    .toString(),
                                                                                acceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .acceptedModules!,
                                                                                acceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .role!)))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      acceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .id!,
                                                                      acceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .name!);

                                                                  getSearchUserList(
                                                                      false);

                                                                  getConnectionList(
                                                                      false);

                                                                  getSentConnectionList(
                                                                      false);

                                                                  getPendingPermissonList(
                                                                      false);
                                                                });
                                                              }
                                                            }
                                                          }
                                                        },
                                                        userEditTap: () {
                                                          editConnectionItem(
                                                              index, true,
                                                              acceptedConnectionsListResponse[index],
                                                              acceptedConnectionsListResponse[index]
                                                                  .secondUserDetail!
                                                                  .id!);
                                                        },
                                                        accessibleModuleList: acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.isEmpty
                                                            ? "None"
                                                            : acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        sharedModuleList: acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.isEmpty
                                                            ? "None"
                                                            : acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        imageUrl: acceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .image == ""
                                                            ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                            : acceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .image!,
                                                        userName: acceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .name!.capitalize(),
                                                        connectionType: acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .role!.capitalize()
                                                    )
                                                        : AcceptedConnectionListItem(
                                                        otherUser: otherUserLoggedIn,
                                                        userItemTap: () {
                                                          print(currentUserID);
                                                          print(
                                                              acceptedConnectionsListResponse[index]
                                                                  .secondUserDetail!
                                                                  .id!);

                                                          if (!otherUserLoggedIn) {
                                                            if (acceptedConnectionsListResponse[index]
                                                                .connectionInfo!
                                                                .acceptedModules!
                                                                .contains(
                                                                "app")) {
                                                              setSessionForAllAppShare(
                                                                  true,
                                                                  acceptedConnectionsListResponse[index]
                                                                      .firstUserDetail!
                                                                      .id!,
                                                                  acceptedConnectionsListResponse[index]
                                                                      .firstUserDetail!
                                                                      .name!);

                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) => const Dashboard()))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);
                                                              });
                                                            } else {
                                                              Navigator.of(
                                                                  context).push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          TribeScreenModuleSingleItemList(
                                                                              acceptedConnectionsListResponse[index]
                                                                                  .firstUserDetail!
                                                                                  .name!
                                                                                  .toString(),
                                                                              acceptedConnectionsListResponse[index]
                                                                                  .firstUserDetail!
                                                                                  .id!
                                                                                  .toString(),
                                                                              acceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .id
                                                                                  .toString(),
                                                                              acceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .acceptedModules!,
                                                                              acceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .role!)))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);

                                                                getSearchUserList(
                                                                    false);

                                                                getConnectionList(
                                                                    false);

                                                                getSentConnectionList(
                                                                    false);

                                                                getPendingPermissonList(
                                                                    false);
                                                              });
                                                            }
                                                          } else {
                                                            if (currentUserID ==
                                                                acceptedConnectionsListResponse[index]
                                                                    .secondUserDetail!
                                                                    .id!) {
                                                              if (acceptedConnectionsListResponse[index]
                                                                  .connectionInfo!
                                                                  .acceptedModules!
                                                                  .contains(
                                                                  "app")) {
                                                                setSessionForAllAppShare(
                                                                    true,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    acceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);

                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) => const Dashboard()))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      acceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .id!,
                                                                      acceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .name!);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TribeScreenModuleSingleItemList(
                                                                                acceptedConnectionsListResponse[index]
                                                                                    .firstUserDetail!
                                                                                    .name!
                                                                                    .toString(),
                                                                                acceptedConnectionsListResponse[index]
                                                                                    .firstUserDetail!
                                                                                    .id!
                                                                                    .toString(),
                                                                                acceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .id
                                                                                    .toString(),
                                                                                acceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .acceptedModules!,
                                                                                acceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .role!)))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      acceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .id!,
                                                                      acceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .name!);

                                                                  getSearchUserList(
                                                                      false);

                                                                  getConnectionList(
                                                                      false);

                                                                  getSentConnectionList(
                                                                      false);

                                                                  getPendingPermissonList(
                                                                      false);
                                                                });
                                                              }
                                                            }
                                                          }
                                                        },
                                                        userEditTap: () {
                                                          editConnectionItem(
                                                              index, true,
                                                              acceptedConnectionsListResponse[index],
                                                              acceptedConnectionsListResponse[index]
                                                                  .firstUserDetail!
                                                                  .id!);
                                                        },
                                                        accessibleModuleList: acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.isEmpty
                                                            ? "None"
                                                            : acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        sharedModuleList: acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.isEmpty
                                                            ? "None"
                                                            : acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        imageUrl: acceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .image == ""
                                                            ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                            : acceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .image!,
                                                        userName: acceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .name!.capitalize(),
                                                        connectionType: acceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .role!.capitalize()
                                                    );
                                                  }),),
                                            Visibility(
                                              visible: isMentorConnections,
                                              child: mentorAcceptedConnectionsListResponse
                                                  .isEmpty ? const Center(
                                                child: Text(
                                                    "No Connections yet"),
                                              ) : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  scrollDirection: Axis
                                                      .vertical,
                                                  itemCount: mentorAcceptedConnectionsListResponse
                                                      .length,
                                                  itemBuilder: (context,
                                                      index) {
                                                    return id ==
                                                        mentorAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!.id
                                                        ? AcceptedConnectionListItem(
                                                        otherUser: otherUserLoggedIn,
                                                        userItemTap: () {
                                                          if (!otherUserLoggedIn) {
                                                            if (mentorAcceptedConnectionsListResponse[index]
                                                                .connectionInfo!
                                                                .acceptedModules!
                                                                .contains(
                                                                "all")) {
                                                              setSessionForAllAppShare(
                                                                  true,
                                                                  mentorAcceptedConnectionsListResponse[index]
                                                                      .secondUserDetail!
                                                                      .id!,
                                                                  mentorAcceptedConnectionsListResponse[index]
                                                                      .secondUserDetail!
                                                                      .name!);

                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) => const Dashboard()))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);
                                                              });
                                                            } else {
                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          TribeScreenModuleSingleItemList(
                                                                              mentorAcceptedConnectionsListResponse[index]
                                                                                  .secondUserDetail!
                                                                                  .name!
                                                                                  .toString(),
                                                                              mentorAcceptedConnectionsListResponse[index]
                                                                                  .secondUserDetail!
                                                                                  .id!
                                                                                  .toString(),
                                                                              mentorAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .id
                                                                                  .toString(),
                                                                              mentorAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .acceptedModules!,
                                                                              mentorAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .role!)))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);

                                                                getSearchUserList(
                                                                    false);

                                                                getConnectionList(
                                                                    false);

                                                                getSentConnectionList(
                                                                    false);

                                                                getPendingPermissonList(
                                                                    false);
                                                              });
                                                            }
                                                          } else {
                                                            if (currentUserID ==
                                                                mentorAcceptedConnectionsListResponse[index]
                                                                    .firstUserDetail!
                                                                    .id!) {
                                                              if (mentorAcceptedConnectionsListResponse[index]
                                                                  .connectionInfo!
                                                                  .acceptedModules!
                                                                  .contains(
                                                                  "app")) {
                                                                setSessionForAllAppShare(
                                                                    true,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);

                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) => const Dashboard()))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      mentorAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .id!,
                                                                      mentorAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .name!);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TribeScreenModuleSingleItemList(
                                                                                mentorAcceptedConnectionsListResponse[index]
                                                                                    .secondUserDetail!
                                                                                    .name!
                                                                                    .toString(),
                                                                                mentorAcceptedConnectionsListResponse[index]
                                                                                    .secondUserDetail!
                                                                                    .id!
                                                                                    .toString(),
                                                                                mentorAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .id
                                                                                    .toString(),
                                                                                mentorAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .acceptedModules!,
                                                                                mentorAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .role!)))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      mentorAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .id!,
                                                                      mentorAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .name!);

                                                                  getSearchUserList(
                                                                      false);

                                                                  getConnectionList(
                                                                      false);

                                                                  getSentConnectionList(
                                                                      false);

                                                                  getPendingPermissonList(
                                                                      false);
                                                                });
                                                              }
                                                            }
                                                          }
                                                        },
                                                        userEditTap: () {
                                                          editConnectionItem(
                                                              index, true,
                                                              mentorAcceptedConnectionsListResponse[index],
                                                              mentorAcceptedConnectionsListResponse[index]
                                                                  .secondUserDetail!
                                                                  .id!);
                                                        },
                                                        accessibleModuleList: mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.isEmpty
                                                            ? "None"
                                                            : mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        sharedModuleList: mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.isEmpty
                                                            ? "None"
                                                            : mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.contains(
                                                            "all")
                                                            ? "All"
                                                            : mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        imageUrl: mentorAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .image == ""
                                                            ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                            : mentorAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .image!,
                                                        userName: mentorAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .name!.capitalize(),
                                                        connectionType: mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .role!.capitalize()
                                                    )
                                                        : AcceptedConnectionListItem(
                                                        otherUser: otherUserLoggedIn,
                                                        userItemTap: () {
                                                          if (!otherUserLoggedIn) {
                                                            if (mentorAcceptedConnectionsListResponse[index]
                                                                .connectionInfo!
                                                                .acceptedModules!
                                                                .contains(
                                                                "all")) {
                                                              setSessionForAllAppShare(
                                                                  true,
                                                                  mentorAcceptedConnectionsListResponse[index]
                                                                      .firstUserDetail!
                                                                      .id!,
                                                                  mentorAcceptedConnectionsListResponse[index]
                                                                      .firstUserDetail!
                                                                      .name!);

                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) => const Dashboard()))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);
                                                              });
                                                            } else {
                                                              Navigator.of(
                                                                  context).push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          TribeScreenModuleSingleItemList(
                                                                              mentorAcceptedConnectionsListResponse[index]
                                                                                  .firstUserDetail!
                                                                                  .name!
                                                                                  .toString(),
                                                                              mentorAcceptedConnectionsListResponse[index]
                                                                                  .firstUserDetail!
                                                                                  .id!
                                                                                  .toString(),
                                                                              mentorAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .id
                                                                                  .toString(),
                                                                              mentorAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .acceptedModules!,
                                                                              mentorAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .role!)))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);

                                                                getSearchUserList(
                                                                    false);

                                                                getConnectionList(
                                                                    false);

                                                                getSentConnectionList(
                                                                    false);

                                                                getPendingPermissonList(
                                                                    false);
                                                              });
                                                            }
                                                          } else {
                                                            if (currentUserID ==
                                                                mentorAcceptedConnectionsListResponse[index]
                                                                    .secondUserDetail!
                                                                    .id!) {
                                                              if (mentorAcceptedConnectionsListResponse[index]
                                                                  .connectionInfo!
                                                                  .acceptedModules!
                                                                  .contains(
                                                                  "app")) {
                                                                setSessionForAllAppShare(
                                                                    true,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    mentorAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);

                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) => const Dashboard()))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      mentorAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .id!,
                                                                      mentorAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .name!);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TribeScreenModuleSingleItemList(
                                                                                mentorAcceptedConnectionsListResponse[index]
                                                                                    .firstUserDetail!
                                                                                    .name!
                                                                                    .toString(),
                                                                                mentorAcceptedConnectionsListResponse[index]
                                                                                    .firstUserDetail!
                                                                                    .id!
                                                                                    .toString(),
                                                                                mentorAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .id
                                                                                    .toString(),
                                                                                mentorAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .acceptedModules!,
                                                                                mentorAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .role!)))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      mentorAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .id!,
                                                                      mentorAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .name!);

                                                                  getSearchUserList(
                                                                      false);

                                                                  getConnectionList(
                                                                      false);

                                                                  getSentConnectionList(
                                                                      false);

                                                                  getPendingPermissonList(
                                                                      false);
                                                                });
                                                              }
                                                            }
                                                          }
                                                        },
                                                        userEditTap: () {
                                                          editConnectionItem(
                                                              index, true,
                                                              mentorAcceptedConnectionsListResponse[index],
                                                              mentorAcceptedConnectionsListResponse[index]
                                                                  .firstUserDetail!
                                                                  .id!);
                                                        },
                                                        accessibleModuleList: mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.isEmpty
                                                            ? "None"
                                                            : mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        sharedModuleList: mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.isEmpty
                                                            ? "None"
                                                            : mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        imageUrl: mentorAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .image == ""
                                                            ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                            : mentorAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .image!,
                                                        userName: mentorAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .name!.capitalize(),
                                                        connectionType: mentorAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .role!.capitalize()
                                                    );
                                                  }),),
                                            Visibility(
                                              visible: isPeerConnections,
                                              child: peerAcceptedConnectionsListResponse
                                                  .isEmpty ? const Center(
                                                child: Text(
                                                    "No Connections yet"),
                                              ) : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  scrollDirection: Axis
                                                      .vertical,
                                                  itemCount: peerAcceptedConnectionsListResponse
                                                      .length,
                                                  itemBuilder: (context,
                                                      index) {
                                                    return id ==
                                                        peerAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!.id
                                                        ? AcceptedConnectionListItem(
                                                        otherUser: otherUserLoggedIn,
                                                        userItemTap: () {
                                                          if (!otherUserLoggedIn) {
                                                            if (peerAcceptedConnectionsListResponse[index]
                                                                .connectionInfo!
                                                                .acceptedModules!
                                                                .contains(
                                                                "app")) {
                                                              setSessionForAllAppShare(
                                                                  true,
                                                                  peerAcceptedConnectionsListResponse[index]
                                                                      .secondUserDetail!
                                                                      .id!,
                                                                  peerAcceptedConnectionsListResponse[index]
                                                                      .secondUserDetail!
                                                                      .name!);


                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) => const Dashboard()))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);
                                                              });
                                                            } else {
                                                              Navigator.of(
                                                                  context).push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          TribeScreenModuleSingleItemList(
                                                                              peerAcceptedConnectionsListResponse[index]
                                                                                  .secondUserDetail!
                                                                                  .name!
                                                                                  .toString(),
                                                                              peerAcceptedConnectionsListResponse[index]
                                                                                  .secondUserDetail!
                                                                                  .id!
                                                                                  .toString(),
                                                                              peerAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .id
                                                                                  .toString(),
                                                                              peerAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .acceptedModules!,
                                                                              peerAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .role!)))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);

                                                                getSearchUserList(
                                                                    false);

                                                                getConnectionList(
                                                                    false);

                                                                getSentConnectionList(
                                                                    false);

                                                                getPendingPermissonList(
                                                                    false);
                                                              });
                                                            }
                                                          } else {
                                                            if (currentUserID ==
                                                                peerAcceptedConnectionsListResponse[index]
                                                                    .firstUserDetail!
                                                                    .id!) {
                                                              if (peerAcceptedConnectionsListResponse[index]
                                                                  .connectionInfo!
                                                                  .acceptedModules!
                                                                  .contains(
                                                                  "app")) {
                                                                setSessionForAllAppShare(
                                                                    true,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);


                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) => const Dashboard()))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      peerAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .id!,
                                                                      peerAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .name!);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TribeScreenModuleSingleItemList(
                                                                                peerAcceptedConnectionsListResponse[index]
                                                                                    .secondUserDetail!
                                                                                    .name!
                                                                                    .toString(),
                                                                                peerAcceptedConnectionsListResponse[index]
                                                                                    .secondUserDetail!
                                                                                    .id!
                                                                                    .toString(),
                                                                                peerAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .id
                                                                                    .toString(),
                                                                                peerAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .acceptedModules!,
                                                                                peerAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .role!)))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      peerAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .id!,
                                                                      peerAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .name!);

                                                                  getSearchUserList(
                                                                      false);

                                                                  getConnectionList(
                                                                      false);

                                                                  getSentConnectionList(
                                                                      false);

                                                                  getPendingPermissonList(
                                                                      false);
                                                                });
                                                              }
                                                            }
                                                          }
                                                        },
                                                        userEditTap: () {
                                                          editConnectionItem(
                                                              index, true,
                                                              peerAcceptedConnectionsListResponse[index],
                                                              peerAcceptedConnectionsListResponse[index]
                                                                  .secondUserDetail!
                                                                  .id!);
                                                        },
                                                        accessibleModuleList: peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.isEmpty
                                                            ? "None"
                                                            : peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        sharedModuleList: peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.isEmpty
                                                            ? "None"
                                                            : peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        imageUrl: peerAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .image == ""
                                                            ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                            : peerAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .image!,
                                                        userName: peerAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .name!.capitalize(),
                                                        connectionType: peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .role!.capitalize()
                                                    )
                                                        : AcceptedConnectionListItem(
                                                        otherUser: otherUserLoggedIn,
                                                        userItemTap: () {
                                                          if (!otherUserLoggedIn) {
                                                            if (peerAcceptedConnectionsListResponse[index]
                                                                .connectionInfo!
                                                                .acceptedModules!
                                                                .contains(
                                                                "app")) {
                                                              setSessionForAllAppShare(
                                                                  true,
                                                                  peerAcceptedConnectionsListResponse[index]
                                                                      .firstUserDetail!
                                                                      .id!,
                                                                  peerAcceptedConnectionsListResponse[index]
                                                                      .firstUserDetail!
                                                                      .name!);

                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) => const Dashboard()))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);
                                                              });
                                                            } else {
                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          TribeScreenModuleSingleItemList(
                                                                              peerAcceptedConnectionsListResponse[index]
                                                                                  .firstUserDetail!
                                                                                  .name!
                                                                                  .toString(),
                                                                              peerAcceptedConnectionsListResponse[index]
                                                                                  .firstUserDetail!
                                                                                  .id!
                                                                                  .toString(),
                                                                              peerAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .id
                                                                                  .toString(),
                                                                              peerAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .acceptedModules!,
                                                                              peerAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .role!)))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);

                                                                getSearchUserList(
                                                                    false);

                                                                getConnectionList(
                                                                    false);

                                                                getSentConnectionList(
                                                                    false);

                                                                getPendingPermissonList(
                                                                    false);
                                                              });
                                                            }
                                                          } else {
                                                            if (currentUserID ==
                                                                peerAcceptedConnectionsListResponse[index]
                                                                    .secondUserDetail!
                                                                    .id!) {
                                                              if (peerAcceptedConnectionsListResponse[index]
                                                                  .connectionInfo!
                                                                  .acceptedModules!
                                                                  .contains(
                                                                  "app")) {
                                                                setSessionForAllAppShare(
                                                                    true,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    peerAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);

                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) => const Dashboard()))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      peerAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .id!,
                                                                      peerAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .name!);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TribeScreenModuleSingleItemList(
                                                                                peerAcceptedConnectionsListResponse[index]
                                                                                    .firstUserDetail!
                                                                                    .name!
                                                                                    .toString(),
                                                                                peerAcceptedConnectionsListResponse[index]
                                                                                    .firstUserDetail!
                                                                                    .id!
                                                                                    .toString(),
                                                                                peerAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .id
                                                                                    .toString(),
                                                                                peerAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .acceptedModules!,
                                                                                peerAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .role!)))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      peerAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .id!,
                                                                      peerAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .name!);
                                                                });
                                                              }
                                                            }
                                                          }
                                                        },
                                                        userEditTap: () {
                                                          editConnectionItem(
                                                              index, true,
                                                              peerAcceptedConnectionsListResponse[index],
                                                              peerAcceptedConnectionsListResponse[index]
                                                                  .firstUserDetail!
                                                                  .id!);
                                                        },
                                                        accessibleModuleList: peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.isEmpty
                                                            ? "None"
                                                            : peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        sharedModuleList: peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.isEmpty
                                                            ? "None"
                                                            : peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        imageUrl: peerAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .image == ""
                                                            ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                            : peerAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .image!,
                                                        userName: peerAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .name!.capitalize(),
                                                        connectionType: peerAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .role!.capitalize()
                                                    );
                                                  }),),
                                            Visibility(
                                              visible: isMenteeConnections,
                                              child: menteeAcceptedConnectionsListResponse
                                                  .isEmpty ? const Center(
                                                child: Text(
                                                    "No Connections yet"),
                                              ) : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  scrollDirection: Axis
                                                      .vertical,
                                                  itemCount: menteeAcceptedConnectionsListResponse
                                                      .length,
                                                  itemBuilder: (context,
                                                      index) {
                                                    return id ==
                                                        menteeAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!.id
                                                        ? AcceptedConnectionListItem(
                                                        otherUser: otherUserLoggedIn,
                                                        userItemTap: () {
                                                          if (!otherUserLoggedIn) {
                                                            if (menteeAcceptedConnectionsListResponse[index]
                                                                .connectionInfo!
                                                                .acceptedModules!
                                                                .contains(
                                                                "app")) {
                                                              setSessionForAllAppShare(
                                                                  true,
                                                                  menteeAcceptedConnectionsListResponse[index]
                                                                      .secondUserDetail!
                                                                      .id!,
                                                                  menteeAcceptedConnectionsListResponse[index]
                                                                      .secondUserDetail!
                                                                      .name!);


                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) => const Dashboard()))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);
                                                              });
                                                            } else {
                                                              Navigator.of(
                                                                  context).push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          TribeScreenModuleSingleItemList(
                                                                              menteeAcceptedConnectionsListResponse[index]
                                                                                  .secondUserDetail!
                                                                                  .name!
                                                                                  .toString(),
                                                                              menteeAcceptedConnectionsListResponse[index]
                                                                                  .secondUserDetail!
                                                                                  .id!
                                                                                  .toString(),
                                                                              menteeAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .id
                                                                                  .toString(),
                                                                              menteeAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .acceptedModules!,
                                                                              menteeAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .role!)))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);

                                                                getSearchUserList(
                                                                    false);

                                                                getConnectionList(
                                                                    false);

                                                                getSentConnectionList(
                                                                    false);

                                                                getPendingPermissonList(
                                                                    false);
                                                              });
                                                            }
                                                          } else {
                                                            if (currentUserID ==
                                                                menteeAcceptedConnectionsListResponse[index]
                                                                    .firstUserDetail!
                                                                    .id!) {
                                                              if (menteeAcceptedConnectionsListResponse[index]
                                                                  .connectionInfo!
                                                                  .acceptedModules!
                                                                  .contains(
                                                                  "app")) {
                                                                setSessionForAllAppShare(
                                                                    true,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);


                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) => const Dashboard()))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      menteeAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .id!,
                                                                      menteeAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .name!);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TribeScreenModuleSingleItemList(
                                                                                menteeAcceptedConnectionsListResponse[index]
                                                                                    .secondUserDetail!
                                                                                    .name!
                                                                                    .toString(),
                                                                                menteeAcceptedConnectionsListResponse[index]
                                                                                    .secondUserDetail!
                                                                                    .id!
                                                                                    .toString(),
                                                                                menteeAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .id
                                                                                    .toString(),
                                                                                menteeAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .acceptedModules!,
                                                                                menteeAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .role!)))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      menteeAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .id!,
                                                                      menteeAcceptedConnectionsListResponse[index]
                                                                          .firstUserDetail!
                                                                          .name!);

                                                                  getSearchUserList(
                                                                      false);

                                                                  getConnectionList(
                                                                      false);

                                                                  getSentConnectionList(
                                                                      false);

                                                                  getPendingPermissonList(
                                                                      false);
                                                                });
                                                              }
                                                            }
                                                          }
                                                        },
                                                        userEditTap: () {
                                                          editConnectionItem(
                                                              index, true,
                                                              menteeAcceptedConnectionsListResponse[index],
                                                              menteeAcceptedConnectionsListResponse[index]
                                                                  .secondUserDetail!
                                                                  .id!);
                                                        },
                                                        accessibleModuleList: menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.isEmpty
                                                            ? "None"
                                                            : menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        sharedModuleList: menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.isEmpty
                                                            ? "None"
                                                            : menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        imageUrl: menteeAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .image == ""
                                                            ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                            : menteeAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .image!,
                                                        userName: menteeAcceptedConnectionsListResponse[index]
                                                            .secondUserDetail!
                                                            .name!.capitalize(),
                                                        connectionType: menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .role!.capitalize()
                                                    )
                                                        : AcceptedConnectionListItem(
                                                        otherUser: otherUserLoggedIn,
                                                        userItemTap: () {
                                                          if (!otherUserLoggedIn) {
                                                            if (menteeAcceptedConnectionsListResponse[index]
                                                                .connectionInfo!
                                                                .acceptedModules!
                                                                .contains(
                                                                "app")) {
                                                              setSessionForAllAppShare(
                                                                  true,
                                                                  menteeAcceptedConnectionsListResponse[index]
                                                                      .firstUserDetail!
                                                                      .id!,
                                                                  menteeAcceptedConnectionsListResponse[index]
                                                                      .firstUserDetail!
                                                                      .name!);

                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) => const Dashboard()))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);
                                                              });
                                                            } else {
                                                              Navigator.of(
                                                                  context).push(
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          TribeScreenModuleSingleItemList(
                                                                              menteeAcceptedConnectionsListResponse[index]
                                                                                  .firstUserDetail!
                                                                                  .name!
                                                                                  .toString(),
                                                                              menteeAcceptedConnectionsListResponse[index]
                                                                                  .firstUserDetail!
                                                                                  .id!
                                                                                  .toString(),
                                                                              menteeAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .id
                                                                                  .toString(),
                                                                              menteeAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .acceptedModules!,
                                                                              menteeAcceptedConnectionsListResponse[index]
                                                                                  .connectionInfo!
                                                                                  .role!)))
                                                                  .then((
                                                                  value) {
                                                                setSessionForAllAppShare(
                                                                    false,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .id!,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .secondUserDetail!
                                                                        .name!);

                                                                getSearchUserList(
                                                                    false);

                                                                getConnectionList(
                                                                    false);

                                                                getSentConnectionList(
                                                                    false);

                                                                getPendingPermissonList(
                                                                    false);
                                                              });
                                                            }
                                                          } else {
                                                            if (currentUserID ==
                                                                menteeAcceptedConnectionsListResponse[index]
                                                                    .secondUserDetail!
                                                                    .id!) {
                                                              if (menteeAcceptedConnectionsListResponse[index]
                                                                  .connectionInfo!
                                                                  .acceptedModules!
                                                                  .contains(
                                                                  "app")) {
                                                                setSessionForAllAppShare(
                                                                    true,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .id!,
                                                                    menteeAcceptedConnectionsListResponse[index]
                                                                        .firstUserDetail!
                                                                        .name!);

                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) => const Dashboard()))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      menteeAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .id!,
                                                                      menteeAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .name!);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                    context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TribeScreenModuleSingleItemList(
                                                                                menteeAcceptedConnectionsListResponse[index]
                                                                                    .firstUserDetail!
                                                                                    .name!
                                                                                    .toString(),
                                                                                menteeAcceptedConnectionsListResponse[index]
                                                                                    .firstUserDetail!
                                                                                    .id!
                                                                                    .toString(),
                                                                                menteeAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .id
                                                                                    .toString(),
                                                                                menteeAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .acceptedModules!,
                                                                                menteeAcceptedConnectionsListResponse[index]
                                                                                    .connectionInfo!
                                                                                    .role!)))
                                                                    .then((
                                                                    value) {
                                                                  setSessionForAllAppShare(
                                                                      false,
                                                                      menteeAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .id!,
                                                                      menteeAcceptedConnectionsListResponse[index]
                                                                          .secondUserDetail!
                                                                          .name!);

                                                                  getSearchUserList(
                                                                      false);

                                                                  getConnectionList(
                                                                      false);

                                                                  getSentConnectionList(
                                                                      false);

                                                                  getPendingPermissonList(
                                                                      false);
                                                                });
                                                              }
                                                            }
                                                          }
                                                        },
                                                        userEditTap: () {
                                                          editConnectionItem(
                                                              index, true,
                                                              menteeAcceptedConnectionsListResponse[index],
                                                              menteeAcceptedConnectionsListResponse[index]
                                                                  .firstUserDetail!
                                                                  .id!);
                                                        },
                                                        accessibleModuleList: menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.isEmpty
                                                            ? "None"
                                                            : menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .acceptedModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        sharedModuleList: menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.isEmpty
                                                            ? "None"
                                                            : menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!.contains(
                                                            "app")
                                                            ? "All"
                                                            : menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .sharingModules!
                                                            .replaceAll(
                                                            "pire", "P.I.R.E")
                                                            .replaceAll("naq",
                                                            "NAQ").replaceAll(
                                                            "column", "Column")
                                                            .replaceAll(
                                                            "ladder", "Ladder")
                                                            .replaceAll(
                                                            "trellis",
                                                            "Trellis"),
                                                        imageUrl: menteeAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .image == ""
                                                            ? "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg"
                                                            : menteeAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .image!,
                                                        userName: menteeAcceptedConnectionsListResponse[index]
                                                            .firstUserDetail!
                                                            .name!.capitalize(),
                                                        connectionType: menteeAcceptedConnectionsListResponse[index]
                                                            .connectionInfo!
                                                            .role!.capitalize()
                                                    );
                                                  }),),
                                          ],),
                                      )
                                    ],
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              _isInviteDataLoading ? const Center(
                  child: CircularProgressIndicator())
                  : Container()
            ],
          ),
        )
    );
  }

  void filterSearchResults(String query) {
    // ignore: avoid_print
    print(query);
    print("THis IS Search item");
    setState(() {
      // ignore: avoid_print
      searchAcceptedConnectionsListResponse = acceptedConnectionsListResponse
          .where((AcceptedConnectionItem item) =>
          (" ${item.connectionInfo!.senderName!.toString()} ${item
              .connectionInfo!.receiverName.toString()}")
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  sendConnectionInvite(String recieverEmail, String moduleName,
      String recieverRole) {
    setState(() {
      _isInviteDataLoading = true;
    });

    HTTPManager().getInviteConnectionRequest(InviteConnectionRequestModel(
        userId: id,
        module: moduleName,
        email: recieverEmail,
        role: recieverRole)).then((value) {
      setState(() {
        sentConnectionsListResponse.add(value);

        _isInviteDataLoading = false;
      });

      setState(() {
        for (int i = 0; i < sentConnectionsListResponse.length; i++) {
          if (id == sentConnectionsListResponse[i].firstUserDetail!.id) {
            sentConnectionsListResponse.sort((a, b) {
              return a.secondUserDetail!.name!.toLowerCase().compareTo(
                  b.secondUserDetail!.name!.toLowerCase());
            });
            searchSentConnectionsListResponse.sort((a, b) {
              return a.secondUserDetail!.name!.toLowerCase().compareTo(
                  b.secondUserDetail!.name!.toLowerCase());
            });
          } else {
            sentConnectionsListResponse.sort((a, b) {
              return a.firstUserDetail!.name!.toLowerCase().compareTo(
                  b.firstUserDetail!.name!.toLowerCase());
            });
            searchSentConnectionsListResponse.sort((a, b) {
              return a.firstUserDetail!.name!.toLowerCase().compareTo(
                  b.firstUserDetail!.name!.toLowerCase());
            });
          }
        }
      });

      Navigator.of(context).pop();

      showToastMessage(context, "Connection request sent", true);
    }).catchError((e) {
      print("Connection Request sending");
      print(e.toString());
      setState(() {
        _isInviteDataLoading = false;
      });
      Navigator.of(context).pop();
      showToastMessage(context, e.toString(), false);
    });
  }

  sendConnectionInviteEmail(String recieverEmail, String moduleName,
      String recieverRole) {
    setState(() {
      _isInviteDataLoading = true;
    });

    HTTPManager().getInviteConnectionRequestForEmail(
        InviteConnectionRequestModel(userId: id,
            module: moduleName,
            email: recieverEmail,
            role: recieverRole)).then((value) {
      setState(() {
        _isInviteDataLoading = false;
        _emailController.clear();
        _emailController.text = "";
      });

      Navigator.of(context).pop();

      showToastMessage(context, "Connection request sent on email", true);
    }).catchError((e) {
      setState(() {
        _isInviteDataLoading = false;
      });
      Navigator.of(context).pop();
      showToastMessage(context, e.toString(), false);
    });
  }

  void editConnectionItem(int index, bool isConnectionAccept, AcceptedConnectionItem acceptedConnectionItem, String recieverId) {

    List<ShareSingleItemDetails> pireList = <ShareSingleItemDetails>[];
    List<ShareSingleItemDetails> naqList = <ShareSingleItemDetails>[];
    List<ShareSingleItemDetails> columnList = <ShareSingleItemDetails>[];
    List<ShareSingleItemDetails> ladderList = <ShareSingleItemDetails>[];

    ShareSingleItemDetails? shareSingleItemDetailsForDelete;

    for(int i=0; i<allSingleItemsShared.length;i++) {
      if(acceptedConnectionItem.connectionInfo!.id.toString() == allSingleItemsShared[i].connectionId.toString()) {
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
      _isInviteDataLoading = true;
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
            getConnectionList(false);
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
          if (!isConnectionAccept) {
            sentConnectionsListResponse[index] = acceptedConnectionItem1;
          } else {
            if (isAllConnections) {
              acceptedConnectionsListResponse[index] = acceptedConnectionItem1;
            } else if (isMentorConnections) {
              mentorAcceptedConnectionsListResponse[index] =
                  acceptedConnectionItem1;
            } else if (isPeerConnections) {
              peerAcceptedConnectionsListResponse[index] =
                  acceptedConnectionItem1;
            } else if (isMenteeConnections) {
              menteeAcceptedConnectionsListResponse[index] =
                  acceptedConnectionItem1;
            } else if (isSearchConnections) {
              searchAcceptedConnectionsListResponse[index] =
                  acceptedConnectionItem1;
            }
          }


          _isInviteDataLoading = false;
        });

        Navigator.of(context).pop();

        if(moduleName.isEmpty) {
          showToastMessage(context, "You have removed module permissions", true);
        } else {
          showToastMessage(context, "You have sent module permission request", true);
        }
      }).catchError((e) {
        setState(() {
          _isInviteDataLoading = false;
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
          if (!isConnectionAccept) {
            sentConnectionsListResponse[index] = acceptedConnectionItem1;
          } else {
            if (isAllConnections) {
              acceptedConnectionsListResponse[index] = acceptedConnectionItem1;
            } else if (isMentorConnections) {
              mentorAcceptedConnectionsListResponse[index] =
                  acceptedConnectionItem1;
            } else if (isPeerConnections) {
              peerAcceptedConnectionsListResponse[index] =
                  acceptedConnectionItem1;
            } else if (isMenteeConnections) {
              menteeAcceptedConnectionsListResponse[index] =
                  acceptedConnectionItem1;
            } else if (isSearchConnections) {
              searchAcceptedConnectionsListResponse[index] =
                  acceptedConnectionItem1;
            }
          }


          _isInviteDataLoading = false;
        });

        Navigator.of(context).pop();

        showToastMessage(context, "Your connection request is updated", true);
      }).catchError((e) {
        setState(() {
          _isInviteDataLoading = false;
        });
        print(e.toString());
        // Navigator.of(context).pop();
        showToastMessage(context, e.toString(), false);
      });
    }
  }

  _deleteSingleShareItem(String singleShareId) {
    setState(() {
      _isInviteDataLoading = true;
    });

    HTTPManager().tribeSingleItemsSharedDelete(TribeSingleSharedDeleteRequestModel(singleShareId: singleShareId)).then((value) {
      setState(() {
        _isInviteDataLoading = false;
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
      showToastMessage(context, "You have removed this item from sharing.", true);
    }).catchError((e) {
      setState(() {
        _isInviteDataLoading = false;
      });
    });
  }
}
