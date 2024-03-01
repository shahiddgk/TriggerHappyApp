

// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Widgets/colors.dart';
import '../../../../Widgets/constants.dart';
import '../../../../Widgets/logo_widget_for_all_screens.dart';
import '../../../../main.dart';
import '../../../../model/reponse_model/Sage/sage_list_response_model.dart';
import '../../../../model/request_model/logout_user_request.dart';
import '../../../../network/http_manager.dart';
import '../../../Payment/payment_screen.dart';
import '../../../PireScreens/widgets/PopMenuButton.dart';
import '../../../dashboard_tiles.dart';
import '../../../utill/userConstants.dart';
import '../api/apis.dart';
import '../widgets/chat_user_card.dart';

class Home extends StatefulWidget {
  String chatMessage;
   Home(this.chatMessage,{super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";

  List<SageData>? connectedPeopleList;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Apis.getProfileInfo();
    _getUserData();
    // Apis.updateActiveStatus(true);
    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {      

        if (message.toString().contains('resume')) {
          Apis.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          Apis.updateActiveStatus(false);
        }

      return Future.value(message);
    });
  }

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      _isUserDataLoading = true;
    });
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

     getConnectionList();

    setState(() {
      _isUserDataLoading = false;
    });
  }

  getConnectionList() {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().getConnectionList(LogoutRequestModel(userId: id)).then((value) {
      setState(() {

        connectedPeopleList = value.data;

        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // for hiding keyboard while tapped elsewhere
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
// back button to return to home from search ,and again to get exit from the app
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const Dashboard()),
                      (Route<dynamic> route) => false
              );
            },
          ),
          title: Text(_isUserDataLoading  ? "" : name,style:const TextStyle(fontWeight: FontWeight.w500,fontSize: AppConstants.userActivityFontSize),),
          actions:  [
            IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> StripePayment(false)));
            }, icon:const Icon(Icons.workspace_premium,color: AppColors.totalQuestionColor,)),
            PopMenuButton(false,true,id)
          ],
        ),
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom:10.0),
        //   child: FloatingActionButton(onPressed: ()  async {
        //    _addChatUserDialog();
        //   },child: Icon(Icons.add_comment_rounded),),
        // ),

        // to get only known user ids
      body: Column(
        children: [
          LogoScreen("Connections"),
          _isLoading ? const Center(
            child: CircularProgressIndicator(),
          ) : connectedPeopleList!.isEmpty ? const Center(
            child: Text("No Connections yet"),
          ) : ListView.builder(
              shrinkWrap: true,
            itemCount: connectedPeopleList!.length,
            padding: EdgeInsets.only(top: mq.height * .01),
              itemBuilder: (context, index) {
                return ChatUserCard(user:connectedPeopleList![index],chatMessage: widget.chatMessage);
              }),
        ],
      )






      // StreamBuilder(
      //     stream: Apis.getMyUsersId(),
      //
      //     //get id of only known users
      //     builder: (context, snapshot) {
      //       switch (snapshot.connectionState) {
      //         //if data is loading
      //         case ConnectionState.waiting:
      //         case ConnectionState.none:
      //           // return const Center(child: CircularProgressIndicator());
      //
      //         //if some or all data is loaded then show it
      //         case ConnectionState.active:
      //         case ConnectionState.done:
      //           return StreamBuilder(
      //             stream: getConnectionList(),
      //
      //             // Apis.getAllUsers(
      //             //     snapshot.data?.docs.map((e) => e.id).toList() ?? []),
      //
      //             //get only those user, who's ids are provided
      //             builder: (context, snapshot) {
      //               switch (snapshot.connectionState) {
      //                 //if data is loading
      //                 case ConnectionState.waiting:
      //                 case ConnectionState.none:
      //                 // return const Center(
      //                 //     child: CircularProgressIndicator());
      //
      //                 //if some or all data is loaded then show it
      //                 case ConnectionState.active:
      //                 case ConnectionState.done:
      //                   // final data = snapshot.data?.docs;
      //                   _list = connectedPeopleList!;
      //
      //                   if (_list.isNotEmpty) {
      //                     return ListView.builder(
      //                         itemCount: _isSearch
      //                             ? _searchList.length
      //                             : _list.length,
      //                         padding: EdgeInsets.only(top: mq.height * .01),
      //                         physics: const BouncingScrollPhysics(),
      //                         itemBuilder: (context, index) {
      //                           return ChatUserCard(
      //                               user: _isSearch
      //                                   ? _searchList[index]
      //                                   : _list[index]);
      //                         });
      //                   } else {
      //                     return const Center(
      //                       child: Text('No Connections Found!',
      //                           style: TextStyle(fontSize: 20)),
      //                     );
      //                   }
      //               }
      //             },
      //           );
      //       }
      //     },
      //   ),
      ),
    );
  }
  // adds new chat user
  // void _addChatUserDialog() {
  //   String email = '';
  //
  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             contentPadding: const EdgeInsets.only(
  //                 left: 24, right: 24, top: 20, bottom: 10),
  //
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20)),
  //
  //             //title
  //             title: Row(
  //               children: const [
  //                 Icon(
  //                   Icons.person_add,
  //                   color: Colors.blue,
  //                   size: 28,
  //                 ),
  //                 Text('  Add User')
  //               ],
  //             ),
  //
  //             //content
  //             content: TextFormField(
  //               maxLines: null,
  //               onChanged: (value) => email = value,
  //               decoration: InputDecoration(
  //                   hintText: 'Email Id',
  //                   prefixIcon: const Icon(Icons.email, color: Colors.blue),
  //                   border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(15))),
  //             ),
  //
  //             //actions
  //             actions: [
  //               //cancel button
  //               MaterialButton(
  //                   onPressed: () {
  //                     //hide alert dialog
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text('Cancel',
  //                       style: TextStyle(color: Colors.blue, fontSize: 16))),
  //
  //               //add button
  //               MaterialButton(
  //                   onPressed: () async {
  //                     //hide alert dialog
  //                     Navigator.pop(context);
  //                     if (email.isNotEmpty) {
  //                       await Apis.addChatUser(email).then((value) {
  //                         if (!value) {
  //                           Dialogs.showSnack(context, 'User does not Exists!');
  //                         }
  //                       });
  //                     }
  //                   },
  //                   child: const Text(
  //                     'Add',
  //                     style: TextStyle(color: Colors.blue, fontSize: 16),
  //                   ))
  //             ],
  //           ));
// }
}