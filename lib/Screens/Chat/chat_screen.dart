// ignore_for_file: must_be_immutable, unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/model/reponse_model/Sage/sage_list_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/Sage%20Request/chat_list_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../model/reponse_model/Sage/chat_list_response.dart';
import '../../network/http_manager.dart';
import '../utill/userConstants.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.sageData,this.chatMessage,{Key? key}) : super(key: key);

  SageData sageData;
  ChatMessage chatMessage;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late ChatMessageListResponse chatMessageListResponse;
  bool _isLoading = true;
  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";

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

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    getMessagesList();

    setState(() {
      _isUserDataLoading = false;
    });
  }

  getMessagesList() {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().chatMessagesList(ChatRequestModel(chatId: widget.sageData.id)).then((value) {

      setState(() {
        chatMessageListResponse = value;
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
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.sageData.senderId == id ? widget.sageData.receiverName! : widget.sageData.senderName!),
      ),
      body: Stack(
        
        children: <Widget>[
          _isLoading ? const Center(child: CircularProgressIndicator()) : chatMessageListResponse.response!.isEmpty ? const Align(
            alignment: Alignment.topCenter,
            child: Text("No Responses Shared yet"),
          ) : ListView.builder(
            itemCount: chatMessageListResponse.response!.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10,bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (widget.sageData.senderId == chatMessageListResponse.response![index].senderId ? Alignment.topLeft:Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: const Radius.circular(20),
                          bottomLeft: const Radius.circular(20),
                          topLeft: widget.sageData.senderId == chatMessageListResponse.response![index].senderId ? const Radius.circular(0) : const Radius.circular(20),
                          bottomRight: widget.sageData.senderId == chatMessageListResponse.response![index].senderId ? const Radius.circular(20) : const Radius.circular(0)),
                      color: (widget.sageData.senderId == chatMessageListResponse.response![index].senderId ? Colors.grey.shade200:AppColors.primaryColor),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(chatMessageListResponse.response![index].entryText!, style: const TextStyle(fontSize: 15),),
                  ),
                ),
              );
            },
          ),
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: Container(
          //     padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
          //     width: double.infinity,
          //     color: Colors.white,
          //     child: Row(
          //       children: <Widget>[
          //         // GestureDetector(
          //         //   onTap: (){
          //         //   },
          //         //   child: Container(
          //         //     height: 30,
          //         //     width: 30,
          //         //     decoration: BoxDecoration(
          //         //       color: Colors.lightBlue,
          //         //       borderRadius: BorderRadius.circular(30),
          //         //     ),
          //         //     child: const Icon(Icons.add, color: Colors.white, size: 20, ),
          //         //   ),
          //         // ),
          //          const SizedBox(width: 5,),
          //          Expanded(
          //           child: Container(
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(15),
          //               border: Border.all(color: AppColors.primaryColor)
          //             ),
          //             child: TextFormField(
          //               maxLines: 4,
          //               minLines: 1,
          //               textInputAction: TextInputAction.newline,
          //               decoration:const InputDecoration(
          //                   hintText: "Write message...",
          //                   contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          //                   hintStyle: TextStyle(color: Colors.black54),
          //                   border: InputBorder.none
          //               ),
          //             ),
          //           ),
          //         ),
          //         const SizedBox(width: 5,),
          //         FloatingActionButton(
          //           onPressed: (){},
          //           backgroundColor: AppColors.primaryColor,
          //           elevation: 0,
          //           child: const Icon(Icons.send,color: Colors.white,size: 18,),
          //         ),
          //         const SizedBox(width: 5,),
          //       ],
          //
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
