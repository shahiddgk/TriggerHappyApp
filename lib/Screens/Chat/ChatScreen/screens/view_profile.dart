

// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../main.dart';
import '../../../../model/reponse_model/Sage/sage_list_response_model.dart';
import '../helper/mydate.dart';


class ViewProfile extends StatefulWidget {
   SageData user;
   ViewProfile({super.key, required this.user});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.user.receiverName!),),
            //joined on info
               floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Joined on:",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),),
                Text(MyDate.getLastMsgTime(context: context, time: widget.user.role!,showyear: true),
                style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w300)),
              ],
            ),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Column(
            children: [
              SizedBox(width: mq.width,height: mq.height * .02,),
              ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.fill,
                      imageUrl: widget.user.image!,
                        errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
                     ),
              ),
            // SizedBox(height: mq.height * .01,),
            // Text(widget.user.email!,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w400)),
            SizedBox(height: mq.height * .02,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     // Text("About:",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22),),
            //     // // Text(widget.user.about,
            //     // // style:TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
            //   ],
            // ),


            ],
          ),
        ),

      ),
    );
  }

}