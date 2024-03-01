
// ignore_for_file: unused_element, avoid_print

import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_quiz_app/Screens/Chat/ChatScreen/screens/view_profile.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/model/reponse_model/Sage/sage_list_response_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../../Widgets/constants.dart';
import '../../../../main.dart';
import '../../../utill/userConstants.dart';
import '../api/apis.dart';
import '../helper/mydate.dart';
import '../models/chat_msg.dart';
import '../models/chat_user.dart';
import '../widgets/msg_card.dart';
class ChatScreen extends StatefulWidget {
  final SageData user;
  final String chatMessage;
  const ChatScreen({super.key, required this.user, required this.chatMessage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
   List<Messages> _list=[];

   String name = "";
   String id = "";
   bool _isUserDataLoading = true;
   String email = "";
   String timeZone = "";
   String userType = "";
  // _ private var 
final _textcontroller =TextEditingController();
// emoji var           image uploading 
bool _showEmoji=false;

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

    // getConnectionList();

    if (widget.chatMessage!= "")
    {
      if (_list.isEmpty) {
        // on 1st msg add the user
        Apis.sendFirstMessage(widget.user, widget.chatMessage, Type.text, id);
      } else {
        Apis.sendMessage(widget.user, widget.chatMessage, Type.text, id);
      }
    }

    setState(() {
      _isUserDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: AppColors.primaryColor));
    
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: SafeArea(
        // backbutton -> emoji win off 
        child: WillPopScope(
          onWillPop: (){
            if (_showEmoji) {
              setState(() {
                _showEmoji=!_showEmoji;
              });
              return Future.value(false);
            }else{
              return Future.value(true);
            }           
          },

          child: Scaffold(
            backgroundColor: AppColors.hoverColor,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text(!_isUserDataLoading ? name == widget.user.senderName! ? widget.user.receiverName! : widget.user.senderName! : name,overflow: TextOverflow.ellipsis,maxLines: 1,style:const TextStyle(fontWeight: FontWeight.w500,fontSize: AppConstants.userActivityFontSize),),
            ),
            body: Column( 
              children: [
                Expanded(
                  child: StreamBuilder(
                          stream: Apis.getAllMessages(widget.user),
                          builder:(context,snapshot){
                  switch (snapshot.connectionState) {
                    // if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const SizedBox();
                      // if some/all data is loaded then show it
                    case  ConnectionState.active:
                    case ConnectionState.done:  
                 
                    final data = snapshot.data?.docs;
                     _list=data?.map((e) => Messages.fromJson(e.data())).toList()?? [];
              // print('${jsonEncode(data![0].data())}');                
            //   _list.clear();
            //   _list.add(Messages(msg: "hii!!", toId: "abcd", read: '', type: Type.text, send: '10:00 am', fromId: Apis.user.uid));
            // _list.add(Messages(msg: "Fine", toId: Apis.user.uid, read: '', type: Type.text, send: '10:10 am', fromId: "abcd"));
                          if(_list.isNotEmpty){
                          return ListView.builder(
                            // last msg to show 1st
                            reverse: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: mq.height *.01),
                  itemCount:_list.length,
                  itemBuilder: (context,index){
                  return MessageCard(messages: _list[index],);
                  // return Text("msgs:${_list[index]}");        
                          });
                          }
                          // if no users available
                          else {
                  return Center(child: Text("Nothing shared yet",style: GoogleFonts.balooBhai2(fontSize: 30),),);
                          }    
                  }
                          },
                        ),
                ),
                // if(_isUploading)
                // Align(alignment: Alignment.centerRight,
                // child: Padding(
                //   padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 5),
                //   child: CircularProgressIndicator(strokeWidth: 2,),
                // )),
                // _chatInput(),
            
                // emoji select window
                if(_showEmoji)
                SizedBox(
                  height: mq.height *.35,
                  child: EmojiPicker(
                    textEditingController: _textcontroller,
                    config: Config(
                      columns: 8,
                      emojiSizeMax: 32 * (Platform.isIOS?1.3:1.0), 
                    ),
                  ),
                )
              ],
            ) ,
          ),
        ),
      ),
    );
  }
// input keyboard + send button
Widget _chatInput(){
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: mq.height * .01,horizontal: mq.width * .02),
    child: Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                // emoji func
                IconButton(onPressed: (){
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _showEmoji=!_showEmoji; 
                  });
                },
                 icon: const Icon(Icons.emoji_emotions,color: Colors.blue,size: 28,)),
                 Expanded(
                  child:TextField(
                    controller: _textcontroller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: (){
                      if(_showEmoji) {
                        setState(() {
                    _showEmoji=!_showEmoji; 
                  });
                      }
                    },
                  decoration: const InputDecoration(
                    hintText: 'Start Chatting....',hintStyle: TextStyle(fontSize: 18),border: InputBorder.none
                  ),
                 ) ),
                //  select gallery multiple images
                 IconButton(
                  onPressed: () async {
                  final ImagePicker picker=ImagePicker();
                  final List<XFile> images = await picker.pickMultiImage();
                    for(var i in images){
                    await Apis.sendChatImage(widget.user,File(i.path),id);

                    }
                      
                    },
                
                 icon: const Icon(Icons.image,color: Colors.blue,size: 30,)),

                //  camera button
                 IconButton(
                  onPressed: () async {
                  final ImagePicker picker=ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                    if(image!=null){
                      print("image path: ${image.path}");

                    Apis.sendChatImage(widget.user,File(image.path),id);

                    }
                 },
                 icon: const Icon(Icons.camera_alt_rounded,color: Colors.blue,size: 30,)),
                 SizedBox(width: mq.width * .01,)
              ],
            ),
          ),
        ),
        // click to send msgs
        MaterialButton(onPressed: (){
          if(_textcontroller.text.isNotEmpty){
            if(_list.isEmpty){
              // on 1st msg add the user
                    Apis.sendFirstMessage(widget.user, _textcontroller.text,Type.text,id);
            }else{
                    Apis.sendMessage(widget.user, _textcontroller.text,Type.text,id);
            }            
          }
          _textcontroller.text='';
        },
        shape: const CircleBorder(),
        minWidth: 0,
        padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 5),
        color: Colors.redAccent,
        child: const Icon(Icons.send,color: Colors.white,size: 28,),)
      ],
    ),
  );
}


  // chat screen  custom appbar
  Widget _appBar(){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewProfile(user: widget.user))); 
      },
      child: StreamBuilder(stream: Apis.getUserInfo(widget.user),builder: (context, snapshot) {  
        final data=snapshot.data?.docs;  
        final list=data?.map((e) => ChatUser.fromJson(e.data())).toList()?? []; 
      return Row(
        children: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back,color: Colors.white,)),
          ClipRRect(
            // profile pic 
        borderRadius: BorderRadius.circular(mq.height *.3),
        child: CachedNetworkImage(
          width: mq.height * .045,
          height: mq.height *.045,
          imageUrl:list.isNotEmpty?list[0].image:widget.user.image!,
            errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
         ),
      ),
      SizedBox(width: mq.width * .03,),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,   
        children: [
          // user name
        Text(list.isNotEmpty?list[0].name:!_isUserDataLoading ? name == widget.user.senderName! ? widget.user.receiverName! : widget.user.senderName! : name,style: GoogleFonts.balooBhai2(
          color: Colors.white,fontSize: 20,fontWeight: FontWeight.w300),),
          // SizedBox(height: .005,),
          // last seen status
        Text(list.isNotEmpty?list[0].isOnline?'Online':
        MyDate.getLastActiveTime(context: context, lastActive: list[0].lastActive):
        MyDate.getLastActiveTime(context: context, lastActive: "widget.user.lastActive"),
        style: GoogleFonts.balooBhai2(color: Colors.white,fontSize: 13),)
    
      ],)
        ],
      );
      },)
    );
  }
}