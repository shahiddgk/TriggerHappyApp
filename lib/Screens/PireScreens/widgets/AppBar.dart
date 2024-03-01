
// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/dashboard_tiles.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Payment/payment_screen.dart';
import '../../Sage/pending_connection_list.dart';
import '../../UserActivity/user_activity.dart';
import '../../utill/userConstants.dart';
import 'PopMenuButton.dart';

class AppBarWidget{

  AppBar appBar(BuildContext context,bool isSummaryVisible,bool isSettingVisible,String name,String userId, bool isLeading) {
    return AppBar(
      automaticallyImplyLeading: isLeading,
      centerTitle: true,
      title: Text(name),
      actions:  [
        if(true)
         IconButton(onPressed: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> StripePayment(false)));
         }, icon:const Icon(Icons.workspace_premium,color: AppColors.totalQuestionColor,)),
        PopMenuButton(isSummaryVisible,isSettingVisible,userId)
      ],
    );
  }

  AppBar appBarGeneralButtons(BuildContext context,Function onTap,bool isUserActivityShow,bool isShowPaymentButton ,bool isPendingConnectionButton,String userId, bool isLeading,bool isHomeButtonShow,int as,bool isShowNotificationButton,int ad) {

    // int badgeCountSharedResponse;
    int badgeCount = 0;

    return AppBar(
      automaticallyImplyLeading: isLeading,
      centerTitle: true,
      leading: isLeading ? IconButton(
        icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios,color: AppColors.hoverColor,),
        onPressed: () {
          onTap();
        },
      ) : null,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Dashboard()), (route) => false);
            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Dashboard()));
          }, icon: Icon(Icons.home,size: 23,color: !isHomeButtonShow ? AppColors.totalQuestionColor : AppColors.hoverColor,)),

          IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UserActivity()));
          }, icon: Icon(Icons.list_alt,size: 23,color: !isUserActivityShow ? AppColors.totalQuestionColor : AppColors.hoverColor,)),
        IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> StripePayment(false)));
        }, icon: Icon(Icons.workspace_premium,size: 23,color: !isShowPaymentButton ? AppColors.totalQuestionColor : AppColors.hoverColor,)),

          // Stack(
          //   children: [
          //     IconButton(onPressed: (){
          //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const SharedItemList()));
          //
          //     }, icon: Icon(Icons.share,size: 23,color: isShowNotificationButton ? AppColors.totalQuestionColor : AppColors.hoverColor)),
          //
          //     StreamBuilder(
          //       stream: FirebaseFirestore.instance.collection('connections').doc(userId.isEmpty? "0" : userId).snapshots(),
          //       builder: (context, snapshot) {
          //         switch (snapshot.connectionState) {
          //
          //           case ConnectionState.waiting:
          //           case ConnectionState.none:
          //             return const SizedBox();
          //         // if some/all data is loaded then show it
          //           case  ConnectionState.active:
          //           case ConnectionState.done:
          //             if(snapshot.hasError) {
          //               badgeCountSharedResponse = 0;
          //             }else if(snapshot.data!.exists) {
          //               badgeCountSharedResponse = snapshot.data?['shared_response'];
          //             } else {
          //               badgeCountSharedResponse = 0;
          //             }
          //             return Visibility(
          //               visible: badgeCountSharedResponse>0,
          //               child: Positioned(
          //                   right: 5,
          //                   top:5,
          //                   child: Badge(
          //                     label: Text(badgeCountSharedResponse > 99 ? '99+': "$badgeCountSharedResponse",style: const TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.defaultFontSizeForWeekDays),),
          //                   ),
          //                 ),
          //             );
          //         }
          //       },
          //     ),
          //   ],
          // ),
          Stack(
            children: [
              IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const PendingConnectionList()));
              }, icon: Icon(Icons.people,size: 23,color: !isPendingConnectionButton ? AppColors.totalQuestionColor : AppColors.hoverColor)),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('connections').doc(userId.isEmpty? "0" : userId).snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {

                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const SizedBox();
                  // if some/all data is loaded then show it
                    case  ConnectionState.active:
                    case ConnectionState.done:
                      if(snapshot.hasError) {
                        badgeCount = 0;
                      }else if(snapshot.data!.exists) {

                        badgeCount = snapshot.data?['con_request'];

                      } else {
                        badgeCount = 0;
                      }
                      return Visibility(
                        visible: badgeCount>0,
                        child: Positioned(
                          right: 5,
                          top:5,
                          child: Badge(
                            label: Text(badgeCount > 99 ? '99+': "$badgeCount",style: const TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.defaultFontSizeForWeekDays),),
                          ),
                        ),
                      );
                  }
                },
              ),
            ],
          ),

        PopMenuButton(true,true,userId)
      ],),
    );
  }

  AppBar appBarGeneralButtonsWithOtherUserLogged(BuildContext context,Function onTap,bool isUserActivityShow,bool isShowPaymentButton ,bool isPendingConnectionButton,String userId, bool isLeading,bool isHomeButtonShow,int as,bool isShowNotificationButton,int ad,bool otherUserLoggedIn,String name) {

    // int badgeCountSharedResponse;
    int badgeCount = 0;

    setSessionForAllAppShare(bool otherUserLogged) async {
        otherUserLoggedIn = otherUserLogged;

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      sharedPreferences.setBool(UserConstants().otherUserLoggedIn, otherUserLogged);

    }

    return AppBar(
      automaticallyImplyLeading: isLeading,
      centerTitle: true,
      leading: isLeading ? IconButton(
        icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios,color: AppColors.hoverColor,),
        onPressed: () {
          onTap();
        },
      ) : null,
      actions: otherUserLoggedIn ?[
          InkWell(
            onTap: () {
              setSessionForAllAppShare(false);

              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const Dashboard()), (route) => false);
            },
            child: Container(
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: const Icon(Icons.swap_horiz,color: AppColors.hoverColor,size: 40,),
      ),
          )] : [],
      title: otherUserLoggedIn ? Text("$name's Burgeon",style: const TextStyle(fontSize: AppConstants.headingFontSize,color: AppColors.hoverColor,fontWeight: FontWeight.bold),) : Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Dashboard()), (route) => false);
            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Dashboard()));
          }, icon: Icon(Icons.home,size: 23,color: !isHomeButtonShow ? AppColors.totalQuestionColor : AppColors.hoverColor,)),

          IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UserActivity()));
          }, icon: Icon(Icons.list_alt,size: 23,color: !isUserActivityShow ? AppColors.totalQuestionColor : AppColors.hoverColor,)),
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> StripePayment(false)));
          }, icon: Icon(Icons.workspace_premium,size: 23,color: !isShowPaymentButton ? AppColors.totalQuestionColor : AppColors.hoverColor,)),

          // Stack(
          //   children: [
          //     IconButton(onPressed: (){
          //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const SharedItemList()));
          //
          //     }, icon: Icon(Icons.share,size: 23,color: isShowNotificationButton ? AppColors.totalQuestionColor : AppColors.hoverColor)),
          //
          //     StreamBuilder(
          //       stream: FirebaseFirestore.instance.collection('connections').doc(userId.isEmpty? "0" : userId).snapshots(),
          //       builder: (context, snapshot) {
          //         switch (snapshot.connectionState) {
          //
          //           case ConnectionState.waiting:
          //           case ConnectionState.none:
          //             return const SizedBox();
          //         // if some/all data is loaded then show it
          //           case  ConnectionState.active:
          //           case ConnectionState.done:
          //             if(snapshot.hasError) {
          //               badgeCountSharedResponse = 0;
          //             }else if(snapshot.data!.exists) {
          //               badgeCountSharedResponse = snapshot.data?['shared_response'];
          //             } else {
          //               badgeCountSharedResponse = 0;
          //             }
          //             return Visibility(
          //               visible: badgeCountSharedResponse>0,
          //               child: Positioned(
          //                 right: 5,
          //                 top:5,
          //                 child: Badge(
          //                   label: Text(badgeCountSharedResponse > 99 ? '99+': "$badgeCountSharedResponse",style: const TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.defaultFontSizeForWeekDays),),
          //                 ),
          //               ),
          //             );
          //         }
          //       },
          //     ),
          //   ],
          // ),
          Stack(
            children: [
              IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const PendingConnectionList()));
              }, icon: Icon(Icons.people,size: 23,color: !isPendingConnectionButton ? AppColors.totalQuestionColor : AppColors.hoverColor)),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('connections').doc(userId.isEmpty? "0" : userId).snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {

                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const SizedBox();
                  // if some/all data is loaded then show it
                    case  ConnectionState.active:
                    case ConnectionState.done:
                      if(snapshot.hasError) {
                        badgeCount = 0;
                      }else if(snapshot.data!.exists) {
                        badgeCount = snapshot.data?['con_request'];

                      } else {
                        badgeCount = 0;
                      }
                      return Visibility(
                        visible: badgeCount>0,
                        child: Positioned(
                          right: 5,
                          top:5,
                          child: Badge(
                            label: Text(badgeCount > 99 ? '99+': "$badgeCount",style: const TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.defaultFontSizeForWeekDays),),
                          ),
                        ),
                      );
                  }
                },
              ),
            ],
          ),

          PopMenuButton(true,true,userId)
        ],),
    );
  }


}

