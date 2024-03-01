// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';
import '../../Tribe/Widgets/ConnectionDetailsPopUp.dart';

class PendingConnectionListItem extends StatefulWidget {
  PendingConnectionListItem(this.userAcceptTap,this.userRejectTap,this.imageUrl,this.userName,this.connectionType,this.connectionModuleList,{Key? key}) : super(key: key);

  Function userAcceptTap;
  Function userRejectTap;
  String imageUrl;
  String userName;
  String connectionType;
  String connectionModuleList;

  @override
  State<PendingConnectionListItem> createState() => _PendingConnectionListItemState();
}

class _PendingConnectionListItemState extends State<PendingConnectionListItem> {

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;


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
    return Container(
        margin:const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  border: Border.all(color: AppColors.primaryColor)
              ),
              width: 70,
              height: 70,
              margin:const EdgeInsets.symmetric(horizontal: 1,vertical: 1),
              child:ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Container(
                        margin: const EdgeInsets.only(
                            top: 100,
                            bottom: 100
                        ),
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            color: AppColors.primaryColor
                        ),
                      ),
                  errorWidget: (context, url, error) =>  const Center(child: Icon(Icons.error,color: AppColors.redColor,)),
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Expanded(
              flex:4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userName,overflow: TextOverflow.ellipsis,style: const TextStyle(
                      fontSize: AppConstants.headingFontSize
                  ),),
                  Row(
                    children: [
                      const Text("Your ",overflow: TextOverflow.ellipsis,),
                      // ignore: prefer_const_constructors
                      Expanded(child: Text(widget.connectionType,overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.connectionTypeTextColor),)),
                    ],
                  ),
                  Row(
                    children: [
                       Text("${widget.connectionType} shared:",overflow: TextOverflow.ellipsis,),
                      // ignore: prefer_const_constructors
                      Expanded(child: Text(widget.connectionModuleList.isEmpty ? "None" : widget.connectionModuleList,overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.connectionTypeTextColor),)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),

                              ),
                              minimumSize: const Size(100, 35),
                            ),
                            onPressed: (){

                              widget.userAcceptTap();

                            }, child: const Text("Accept",style: TextStyle(color: AppColors.hoverColor),)),
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.subscriptionGreyColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: const Size(100, 34),
                            ),
                            onPressed: (){
                              widget.userRejectTap();
                            }, child: const Text("Reject",style: TextStyle(color: AppColors.textWhiteColor),)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}


class PendingConnectionListItemWidget extends StatefulWidget {
  PendingConnectionListItemWidget(this.userAcceptTap,this.userRejectTap,this.imageUrl,this.userName,this.connectionModuleList,{Key? key}) : super(key: key);

  Function userAcceptTap;
  Function userRejectTap;
  String imageUrl;
  String userName;
  String connectionModuleList;

  @override
  State<PendingConnectionListItemWidget> createState() => _PendingConnectionListItemWidgetState();
}

class _PendingConnectionListItemWidgetState extends State<PendingConnectionListItemWidget> {

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;


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
    return Container(
        margin:const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  border: Border.all(color: AppColors.primaryColor)
              ),
              width: 70,
              height: 70,
              margin:const EdgeInsets.symmetric(horizontal: 1,vertical: 1),
              child: CircleAvatar(backgroundImage: NetworkImage(widget.imageUrl)),
            ),
            const SizedBox(width: 5,),
            Expanded(
              flex:4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userName,overflow: TextOverflow.ellipsis,style: const TextStyle(
                      fontSize: AppConstants.headingFontSize
                  ),),
                  Row(
                    children: [
                      const Text("Module shared:",overflow: TextOverflow.ellipsis,),
                      // ignore: prefer_const_constructors
                      Expanded(child: Text(widget.connectionModuleList.isEmpty ? "None" : widget.connectionModuleList,overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.connectionTypeTextColor),)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),

                              ),
                              minimumSize: const Size(100, 35),
                            ),
                            onPressed: (){

                              widget.userAcceptTap();

                            }, child: const Text("Accept",style: TextStyle(color: AppColors.hoverColor),)),
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.subscriptionGreyColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: const Size(100, 34),
                            ),
                            onPressed: (){
                              widget.userRejectTap();
                            }, child: const Text("Reject",style: TextStyle(color: AppColors.textWhiteColor),)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}

class PendingConnectionRequestListItemWidget extends StatefulWidget {
  PendingConnectionRequestListItemWidget(this.imageUrl,this.userName,this.connectionModuleList,{Key? key}) : super(key: key);

  String imageUrl;
  String userName;
  String connectionModuleList;

  @override
  State<PendingConnectionRequestListItemWidget> createState() => _PendingConnectionRequestListItemWidgetState();
}

class _PendingConnectionRequestListItemWidgetState extends State<PendingConnectionRequestListItemWidget> {

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;


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
    return Container(
        margin:const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  border: Border.all(color: AppColors.primaryColor)
              ),
              width: 70,
              height: 70,
              margin:const EdgeInsets.symmetric(horizontal: 1,vertical: 1),
              child: CircleAvatar(backgroundImage: NetworkImage(widget.imageUrl)),
            ),
            const SizedBox(width: 5,),
            Expanded(
              flex:4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.userName,overflow: TextOverflow.ellipsis,style: const TextStyle(
                          fontSize: AppConstants.headingFontSize
                      ),),
                      const SizedBox(width: 5,),
                      InkWell(onTap: (){
                        showPermissionDetailsPopUp(context,widget.userName,widget.connectionModuleList);
                      }, child: const Icon(Icons.info,size: 18,color: AppColors.primaryColor,)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("You've shared:",overflow: TextOverflow.ellipsis,),
                      // ignore: prefer_const_constructors
                      Expanded(child: Text(widget.connectionModuleList.isEmpty ? "None" : widget.connectionModuleList,overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.connectionTypeTextColor),)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
