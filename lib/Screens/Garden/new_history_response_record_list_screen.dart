import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../model/reponse_model/garden_response_model.dart';
import '../../model/reponse_model/level_response_model.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../utill/userConstants.dart';
import 'new_history_record_details_screen.dart';

// ignore: must_be_immutable
class NewHistoryResponseRecordListScreen extends StatefulWidget {
   NewHistoryResponseRecordListScreen(this.pireRecordList,this.isTrellisColumnLadder,this.dateHistory,{Key? key}) : super(key: key);
   List<TrellisCount>? pireRecordList;
   String isTrellisColumnLadder;
   String dateHistory;

  @override
  // ignore: library_private_types_in_public_api
  _NewHistoryResponseRecordListScreenState createState() => _NewHistoryResponseRecordListScreenState();
}

class _NewHistoryResponseRecordListScreenState extends State<NewHistoryResponseRecordListScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  late bool isPhone;
  // late NewGardenResponseModel newGardenResponseModel;
  String errorMessage = "";

  @override
  void initState() {
    _getUserData();
    // TODO: implement initState
    super.initState();
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    // getNewResponseHistoryDetails();
    setState(() {
      _isUserDataLoading = false;
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

  // getNewResponseHistoryDetails() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   HTTPManager().getNewGardenData(LogoutRequestModel(userId: id)).then((value) {
  //
  //     setState(() {
  //       newGardenResponseModel = value;
  //       errorMessage = "";
  //       _isLoading = false;
  //     });
  //     newGardenResponseModel.responseData!.sort((a,b) => b.date!.compareTo(a.date!));
  //
  //     print("History List Model");
  //     print(newGardenResponseModel.responseData?[0].date);
  //   }).catchError((e) {
  //     //print(e);
  //     setState(() {
  //       _isLoading = false;
  //       errorMessage = e.toString();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    getScreenDetails();
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    /*24 is for notification bar on Android*/
    return Scaffold(
      appBar: _isUserDataLoading ? AppBarWidget().appBar(context,false,true,"","",false) : AppBar(
        centerTitle: true,
        title: Text(name),
        actions:  [
          PopMenuButton(false,false,id)
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoScreen("Garden"),
            Container(
              margin:const EdgeInsets.only(bottom: 40),
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:!isPhone ? 5 : 4,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: itemHeight/itemWidth,
                  ),
                  itemCount:  widget.pireRecordList!.length,
                  physics:const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: GestureDetector(
                                onTap: () {
                                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AnswerDetailsScreen(widget.pireRecordList![index].responseId!,widget.isTrellisColumnLadder,widget.dateHistory)));
                                },
                                child: Container(
                                  alignment:Alignment.center,
                                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  decoration:BoxDecoration(
                                      border: Border.all(color: AppColors.primaryColor,width: 3),
                                      color: AppColors.backgroundColor,
                                    borderRadius: const BorderRadius.all(Radius.elliptical(80, 50)),
                                  ),
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text("${index + 1}")),
                                ),
                              )),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
