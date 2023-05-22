import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../model/reponse_model/response_history_model.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../utill/userConstants.dart';
import 'image_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
   bool _isLoading = true;
  late bool isPhone;
  List historyResponseModel = [];
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

    getResponseHistory();
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

  getResponseHistory() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().responseHistory(LogoutRequestModel(userId: id)).then((value) {

      setState(() {
        historyResponseModel = value["response_history"];
        errorMessage = "";
        _isLoading = false;
      });

    }).catchError((e) {
      //print(e);
      setState(() {
        _isLoading = false;
        errorMessage = e.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    getScreenDetails();
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
        appBar: _isUserDataLoading ? AppBarWidget().appBar(false,true,"","",false) : AppBar(
          centerTitle: true,
          title: Text(name),
          actions:  [
            PopMenuButton(false,false,id)
          ],
        ),
       body: Container(
         child: Column(
         //  mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             LogoScreen("Garden"),
             _isLoading ? const Center(
               child: CircularProgressIndicator(),
             ) : errorMessage != "" ? Center(
               child: Container(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(errorMessage,style:const TextStyle(fontSize: 25),),
                       const SizedBox(height: 5,),
                       GestureDetector(
                         onTap: () {
                           getResponseHistory();
                         },
                         child: OptionMcqAnswer(
                             TextButton(onPressed: () {
                               getResponseHistory();
                             }, child: const Text("Reload",style: TextStyle(fontSize:25,color: AppColors.redColor)),)
                         ),
                       )
                     ],
                   )
               ),
             ) : historyResponseModel.isEmpty ? OptionMcqAnswer(
                 const Text( "No data available",style: TextStyle(fontSize:25,color: AppColors.textWhiteColor),)
             )  : ListView.builder(
                 itemCount: historyResponseModel.length,
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   return GestureDetector(
                     onTap: () {
                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageScreen(historyResponseModel[index]['score']!.toString())));
                     },
                     child: Container(
                       margin: const EdgeInsets.symmetric(horizontal: 10),
                       child: OptionMcqAnswer(
                         Container(
                             padding: const EdgeInsets.symmetric(vertical: 10),
                             child: Text( historyResponseModel[index]['date']!,style:const TextStyle(fontSize:AppConstants.defaultFontSize,color: AppColors.textWhiteColor))),
                       ),
                     ),
                   );
                 }),
           ],
         )
       ),
    );
  }
}
