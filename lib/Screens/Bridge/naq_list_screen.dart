import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Bridge/bridge_category_screen.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../model/reponse_model/pire_naq_list_response_model.dart';
import '../../model/request_model/pire_naq_request_model.dart';
import '../Bridge/pire_naq_details_screen.dart';
import '../Widgets/error_text_and_button_widget.dart';
import '../utill/userConstants.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'naq_screen_q1.dart';

class NaqListScreen extends StatefulWidget {
  const NaqListScreen({Key? key,required this.isSageShare}) : super(key: key);
  final bool isSageShare;
  @override
  State<NaqListScreen> createState() => _NaqListScreenState();
}

class _NaqListScreenState extends State<NaqListScreen> {

  String name = "";
  String id = "";

  bool otherUserLoggedIn = false;

  bool _isUserDataLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";
  bool _isLoading = true;
  late bool isPhone;

  bool isError = false;
  String errorText = "";

  List<PireNaqListItem> pireNaqListItem = <PireNaqListItem>[];

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
    if(!otherUserLoggedIn) {
      setState(() {
        _isLoading = true;
      });
    }

    _getNaqList();

    setState(() {
      _isUserDataLoading = false;
    });
  }

  _getNaqList() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().pireNaqListResponse(PireNaqListRequestModel(userId: id,type: "naq")).then((value) {
      setState(() {
        pireNaqListItem = value.responses!;
        _isLoading = false;
        isError = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        isError = true;
        errorText = e.toString();
      });
    });
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
  void initState() {
    // TODO: implement initState
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      appBar: _isUserDataLoading ? AppBar() : AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
              if(widget.isSageShare) {
                Navigator.of(context).pop();
              } else {
                if (otherUserLoggedIn) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const BridgeCategoryScreen()),
                      (Route<dynamic> route) => false);
                }
              }
            }, true, true, true, id, true,false,0,false,0,otherUserLoggedIn,name),
      floatingActionButton: Visibility(
        visible: !otherUserLoggedIn,
        child: FloatingActionButton(
            child: const Icon(Icons.add,size: 18,color: AppColors.hoverColor,),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (
                  context) => const NaqScreen1()));
            }),
      ),
      body: Column(
        children: [
          LogoScreen("NAQ Collection"),

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: !isPhone ? MediaQuery.of(context).size.width/5 : 5 ),
              child: _isLoading ? const Center(child: CircularProgressIndicator(),)
                  : isError ? ErrorTextAndButtonWidget(
                errorText: errorText,onTap: (){
                _getNaqList();
              },
              ) : pireNaqListItem.isEmpty ? const Center(child: Text("NAQ Not added yet"),) :  GridView.count(
                  crossAxisCount: !isPhone ? 3 : 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 2.0,
                  childAspectRatio: 3,
                  scrollDirection: Axis.vertical,
                  children: List.generate(pireNaqListItem.length, (index) {
                    return InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PireDetailsScreen(responseId: pireNaqListItem[index].responseId! ,type: "naq",score: pireNaqListItem[index].score!,)));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: AppColors.primaryColor,width: 3)
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          child: Text(DateFormat('MM-dd-yy').format(DateTime.parse(pireNaqListItem[index].createdAt!))),
                        )
                    );
                  })),
            ),
          )
        ],),
    );
  }
}
