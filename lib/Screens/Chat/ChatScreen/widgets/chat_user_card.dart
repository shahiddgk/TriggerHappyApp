
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Chat/ChatScreen/screens/chat_screen.dart';

import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/model/reponse_model/Sage/sage_list_response_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../../utill/userConstants.dart';
import '../api/apis.dart';
import '../models/chat_msg.dart';

class ChatUserCard extends StatefulWidget {
  final SageData user;
  final String chatMessage;
  const ChatUserCard({super.key, required this.user,required this.chatMessage});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // last msg info
  Messages? _messages;

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

    // getConnectionList();

    setState(() {
      _isUserDataLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width *.03,vertical: 5),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
child: InkWell(
  onTap: () {
    Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatScreen(user: widget.user,chatMessage: widget.chatMessage,)));
  },
  // profile pic + list of chat users
  child: StreamBuilder(
    stream: Apis.getLastMessage(widget.user),
    builder: (context,snapshot){
      final data=snapshot.data?.docs;
         final list=data?.map((e) => Messages.fromJson(e.data())).toList()?? [];              

      if(list.isNotEmpty){
        _messages=list[0];
      }
      return
        Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0)
            ),
            margin: const EdgeInsets.only(top: 3),
            height: 100.0,
            padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 2),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const FadeInImage(
                  placeholder: AssetImage("assets/profile_picture_general.png"),
                  image: NetworkImage("https://images.squarespace-cdn.com/content/v1/524caf98e4b0b5e2e07fd6cc/1563833111778-9UL7SO7UQ8UP32KYMZGB/Company-Profile-template.jpg"),
                  fit: BoxFit.fill,
                )
            ),
          ),
          const SizedBox(height: 4,),

          Text(!_isUserDataLoading ? name == widget.user.senderName! ? widget.user.receiverName! : widget.user.senderName! : name,overflow: TextOverflow.ellipsis,maxLines: 1,style: GoogleFonts.balooBhai2(fontWeight: FontWeight.normal,fontSize: AppConstants.headingFontSize)),
          Text(_messages!=null?_messages!.type==Type.image?'Photo':
          _messages!.msg:
          widget.user.role!,maxLines: 1,),

        ],
      );
  //       ListTile(
  //  // user profile pic
  //   leading: ClipRRect(
  //     borderRadius: BorderRadius.circular(mq.height *.3),
  //     child: CachedNetworkImage(
  //       color: AppColors.primaryColor,
  //       width: mq.height * .050,
  //       height: mq.height *.050,
  //       imageUrl: widget.user.image!,
  //         errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
  //      ),
  //   ),
  //   // user name show
  //   title: Text(!_isUserDataLoading ? name == widget.user.senderName! ? widget.user.receiverName! : widget.user.senderName! : name,overflow: TextOverflow.ellipsis,maxLines: 1,style: GoogleFonts.balooBhai2(fontWeight: FontWeight.bold,fontSize: AppConstants.defaultFontSize)),
  //   // last msg show
  //   subtitle: Text(_messages!=null?_messages!.type==Type.image?'Photo':
  //   _messages!.msg:
  //   widget.user.role!,maxLines: 1,),
  //
  //   // trailing: Text("10:10 pm",style: TextStyle(color: Colors.black54),),
  //   // last msg time
  //   trailing: _messages==null?
  //   // show green dot for unread msg of sender
  //   null: _messages!.read.isEmpty && _messages!.fromId != id?
  //   Container(
  //     width: 10,
  //     height: 10,
  //     decoration: BoxDecoration(color: AppColors.hoverColor,borderRadius: BorderRadius.circular(10)),
  //   ):
  //   // show send time for read msg
  //   Text(MyDate.getLastMsgTime(context: context, time: _messages!.send),style: TextStyle(color: Colors.black54),)
  // );
  }
  
),
)
    );
  }
}