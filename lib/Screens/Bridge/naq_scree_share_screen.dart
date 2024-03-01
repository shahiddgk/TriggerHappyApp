// ignore_for_file: must_be_immutable, avoid_print, unused_field

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../network/http_manager.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/share_pop_up_dialogue.dart';
import '../utill/userConstants.dart';
import 'naq_list_screen.dart';

class NaqShareScreen extends StatefulWidget {
   NaqShareScreen(this.naqId,{Key? key}) : super(key: key);

   String naqId;
  @override
  State<NaqShareScreen> createState() => _NaqShareScreenState();
}

class _NaqShareScreenState extends State<NaqShareScreen> with SingleTickerProviderStateMixin {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";
  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";
  String allowEmail = "";
  String errorMessage = "";
  late bool isPhone;
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  List<AcceptedConnectionItem> acceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> searchAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> selectedUserAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  late final AnimationController _animationController;


  @override
  void initState() {
    // TODO: implement initState
    _getUserData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.repeat(reverse: true);

    super.initState();
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    // badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

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

  getScreenDetails() {
    // setState(() {
    //   _isDataLoading = true;
    // });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    // setState(() {
    //   _isDataLoading = false;
    // });
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
        margin: EdgeInsets.symmetric(horizontal: !isPhone ? MediaQuery.of(context).size.width/5 : 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              LogoScreen("NAQ"),

              _isLoading ? const Center(child: CircularProgressIndicator(),)
                  : Column(
                children: [
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
                              MaterialPageRoute(builder: (BuildContext context) =>const NaqListScreen(isSageShare: false,)),
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
                          print(widget.naqId);

                          showThumbsUpDialogue(context, _animationController, id, 'naq', widget.naqId, selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
