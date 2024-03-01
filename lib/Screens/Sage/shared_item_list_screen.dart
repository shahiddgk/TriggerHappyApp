// ignore_for_file: avoid_print, depend_on_referenced_packages, unused_field


import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Sage/sage_share_detail_screen.dart';
import 'package:flutter_quiz_app/Screens/Sage/sage_sharing_category_screen.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/option_mcq_widget.dart';
import '../../model/reponse_model/Sage/shared_list_response.dart';
import '../../network/http_manager.dart';
import '../Column/Widgets/search_text_field.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/error_text_and_button_widget.dart';
import '../utill/userConstants.dart';
import 'Widgets/sage_share_list_item.dart';
import 'package:intl/intl.dart';

class SharedItemList extends StatefulWidget {
  const SharedItemList({Key? key}) : super(key: key);

  @override
  State<SharedItemList> createState() => _SharedItemListState();
}

class _SharedItemListState extends State<SharedItemList> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final bool _isLoading = true;
  bool _isShareWithOtherLoading = true;
  final bool _isError = false;
  bool _isError1 = false;
  String errorText = "";
  String email = "";
  String timeZone = "";
  String userType = "";
  bool isSharedByMe = true;
  // Timer? timer;
  // Timer? timer1;
  bool isSearch = false;

  bool otherUserLoggedIn = false;

  // http.Client _client = http.Client();

  List<ResponsesForOther> sharedListResponseWithMe = [];
  List<ResponsesForMe> sharedListResponseWithOther = [];

  List<ResponsesForOther> searchSharedListResponseWithMe = [];
  List<ResponsesForMe> searchSharedListResponseWithOther = [];

  final TextEditingController _searchController = TextEditingController();

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;
  int badgeCount1 = 0;
  int badgeCountShared = 0;

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
    // timer1!.cancel();
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
  //         timer = Timer.periodic(const Duration(seconds: 10), (Timer t) =>  getSharedItemWithMe(false));
  //         timer1 = Timer.periodic(const Duration(seconds: 10), (Timer t) =>  getSharedItemWithOther(false));
  //       });
  //       print("RESUMED");
  //       break;
  //     case AppLifecycleState.inactive:
  //       setState(() {
  //         timer!.cancel();
  //         timer1!.cancel();
  //         _client.close();
  //       });
  //       print("INACTIVE");
  //       break;
  //     case AppLifecycleState.paused:
  //       setState(() {
  //         timer!.cancel();
  //         timer1!.cancel();
  //         _client.close();
  //       });
  //       print("PAUSED");
  //       break;
  //     case AppLifecycleState.detached:
  //       setState(() {
  //         timer!.cancel();
  //         timer1!.cancel();
  //         _client.close();
  //       });
  //       print("DETACHED");
  //       break;
  //     case AppLifecycleState.hidden:
  //       // TODO: Handle this case.
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

      // getSharedItemWithMe(true);

    }
    getSharedItemWithOther(true);

    setState(() {
      _isUserDataLoading = false;
    });
  }

  // getSharedItemWithMe(bool isLoading) {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   HTTPManager().getShareItemListWithMe(LogoutRequestModel(userId: "354")).then((value) {
  //
  //
  //     setState(() {
  //       sharedListResponseWithMe = value.responses!;
  //       searchSharedListResponseWithMe = value.responses!;
  //
  //       sharedListResponseWithMe.sort((a,b) => b.createdAt!.compareTo(a.createdAt.toString()));
  //       searchSharedListResponseWithMe.sort((a,b) => b.createdAt!.compareTo(a.createdAt.toString()));
  //       _isLoading = false;
  //       errorText = "";
  //       _isError = false;
  //     });
  //
  //   }).catchError((e) {
  //     print("Shared WIth Me");
  //     print(e.toString());
  //     setState(() {
  //       _isError = true;
  //       errorText = e.toString();
  //       _isLoading = false;
  //     });
  //   });
  //
  // }

  getSharedItemWithOther(bool isLoading) {
    setState(() {
      _isShareWithOtherLoading = isLoading;
    });
    HTTPManager().getShareItemListWithCoach(SenderRequestModel(userId: id)).then((value) {


      setState(() {
        sharedListResponseWithOther = value.responses!;
        searchSharedListResponseWithOther = value.responses!;

        // timer = Timer.periodic(const Duration(seconds: 15), (Timer t) =>  getSharedItemWithMe(false));
        // timer1 = Timer.periodic(const Duration(seconds: 15), (Timer t) =>  getSharedItemWithOther(false));
        sharedListResponseWithOther.sort((a,b) => b.createdAt!.compareTo(a.createdAt.toString()));
        searchSharedListResponseWithOther.sort((a,b) => b.createdAt!.compareTo(a.createdAt.toString()));
        errorText = "";
        _isShareWithOtherLoading = false;
        _isError1 = false;
      });


    }).catchError((e) {
      print(e.toString());
      setState(() {
        _isError1 = true;
        errorText = e.toString();
        _isShareWithOtherLoading = false;
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


  @override
  Widget build(BuildContext context) {
    getScreenDetails();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.hoverColor,
      appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,true,badgeCount1,true,badgeCountShared,otherUserLoggedIn,name),
      floatingActionButton: Visibility(
        visible: !otherUserLoggedIn,
        child: FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)),
            child: Icon(Icons.add,color: AppColors.hoverColor,size: !isPhone ? 60 : 40,),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SageSharingCategoryScreen())).then((value) {
                getSharedItemWithOther(false);
              });
            }),
      ),
      body: Stack(
        children: [
          // Container(
          //   margin: const EdgeInsets.only(top: 2),
          //   alignment: Alignment.topCenter,
          //   width: MediaQuery.of(context).size.width,
          //   // height:!isPhone ? MediaQuery.of(context).size.height/15 : MediaQuery.of(context).size.height/10,
          //   decoration: const BoxDecoration(
          //     color: AppColors.primaryColor,
          //   ),
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: !isPhone ?  MediaQuery.of(context).size.width/5:5),
          //     child: Column(
          //       children: [
          //         SingleChildScrollView(
          //           child: Container(
          //               margin: const EdgeInsets.symmetric(vertical: 10),
          //               child: Text(!isPhone ? "Shared Pulses" : "Shared Pulses",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.hoverColor),)),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Column(
            children: [
              LogoScreen("Expertly Process One Issue"),
              // Text("Pay 25\$ ",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForMobile : AppConstants.userActivityCardRadius,fontWeight: FontWeight.w700,color: AppColors.primaryColor),),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50)),
                  ),
                  child: _isShareWithOtherLoading ? const Center(
                    child: CircularProgressIndicator(),
                  ) : _isError  || _isError1 ?
                  Expanded(
                      child: ErrorTextAndButtonWidget(
                        errorText: errorText,
                        onTap: (){
                        getSharedItemWithOther(true);
                      },
                      ))
                      : Container(
                    margin: EdgeInsets.symmetric(horizontal: !isPhone ?  MediaQuery.of(context).size.width/6:5),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: SearchTextField((value) {
                                  if(value.isEmpty) {
                                    setState(() {
                                      isSearch = false;
                                    });
                                    if(isSharedByMe) {
                                      setState(() {
                                        searchSharedListResponseWithMe = sharedListResponseWithMe;
                                      });
                                    } else {
                                      setState(() {
                                        searchSharedListResponseWithOther = sharedListResponseWithOther;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      isSearch = true;
                                      filterList(value);
                                    });
                                  }
                                }, _searchController, 1, false, "search here with username or type"),
                              ),
                              IconButton(onPressed: (){}, icon: const Icon(Icons.sort,color: AppColors.primaryColor,))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: isSharedByMe,
                          child: searchSharedListResponseWithOther.isEmpty ? const Expanded(child: Center(
                            child: Text("Nothing Shared Yet"),
                          )) : Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: searchSharedListResponseWithOther.length,
                                itemBuilder: (context,index) {

                                  DateTime date = DateTime.parse(searchSharedListResponseWithOther[index].createdAt.toString());
                                  String formattedDate = DateFormat('MM-dd-yy').format(date);

                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SageShareDetailsScreen(searchSharedListResponseWithOther[index].receiverName!,searchSharedListResponseWithOther[index].id!,searchSharedListResponseWithOther[index].entityId!,searchSharedListResponseWithOther[index].type!,searchSharedListResponseWithOther[index].paid! == "false" ? false : true,searchSharedListResponseWithOther[index].receiverId!)));
                                    },
                                    child: SageShareScreenListItem(
                                      title: searchSharedListResponseWithOther[index].type! == "pire" ? "P.I.R.E"
                                          : searchSharedListResponseWithOther[index].type! == "ladder" ? "Ladder"
                                          : searchSharedListResponseWithOther[index].type! == "trellis" ? "Trellis"
                                          : searchSharedListResponseWithOther[index].type! == "column" ? "Column" : "NAQ",
                                      isPaid: searchSharedListResponseWithOther[index].paid! == "false" ? false : true,
                                      date: formattedDate,
                                      name: searchSharedListResponseWithOther[index].receiverName!, isSharedByMe: !isSharedByMe,

                                    ),
                                  );

                                }),
                          ),
                        ),
                        Visibility(
                          visible: !isSharedByMe,
                          child: searchSharedListResponseWithMe.isEmpty ? const Expanded(child: Center(
                            child: Text("No Responses Shared Yet"),
                          )) : Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: searchSharedListResponseWithMe.length,
                                itemBuilder: (context,index) {

                                  DateTime date = DateTime.parse(searchSharedListResponseWithMe[index].createdAt.toString());
                                  String formattedDate = DateFormat('MM-dd-yy').format(date);

                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SageShareDetailsScreen(searchSharedListResponseWithMe[index].senderName!,searchSharedListResponseWithMe[index].id!,searchSharedListResponseWithMe[index].entityId!,searchSharedListResponseWithMe[index].type!,searchSharedListResponseWithMe[index].paid! == "false" ? false : true,searchSharedListResponseWithMe[index].receiverId!)));
                                    },
                                    child: SageShareScreenListItem(
                                      title: searchSharedListResponseWithMe[index].type! == "pire" ? "P.I.R.E"
                                          : searchSharedListResponseWithMe[index].type! == "ladder" ? "Ladder"
                                          : searchSharedListResponseWithMe[index].type! == "trellis" ? "Trellis"
                                          : searchSharedListResponseWithMe[index].type! == "column" ? "Column" : "NAQ",
                                      isPaid: searchSharedListResponseWithMe[index].paid! == "false" ? false : true,
                                      date: formattedDate,
                                      name: searchSharedListResponseWithMe[index].senderName!, isSharedByMe: !isSharedByMe,

                                    ),
                                  );
                                }),
                          ),
                        ),
                        const SizedBox(height: 10,)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

    );
  }
  void filterList(String query) {

    if(!isSharedByMe) {
      setState(() {
        searchSharedListResponseWithMe = sharedListResponseWithMe.where((ResponsesForOther item) => (" ${item.senderName!.toString()} ${item.type.toString()}").toLowerCase().contains(query.toLowerCase())).toList();
      });

    } else {
      setState(() {
        searchSharedListResponseWithOther = sharedListResponseWithOther.where((ResponsesForMe item) => (" ${item.receiverName!.toString()} ${item.type.toString()}").toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
    print("Filete calling");
    print(searchSharedListResponseWithMe);
    print(searchSharedListResponseWithOther);
  }
}
