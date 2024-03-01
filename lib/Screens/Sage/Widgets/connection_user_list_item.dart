import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';
import '../../Tribe/Widgets/ConnectionDetailsPopUp.dart';

class ConnectionUserInvitedListItem extends StatelessWidget {
  final Function userItemTap;
  final Function userEditTap;
  final String imageUrl;
  final String userName;
  final String connectionType;
  final String sharedModuleList;
  // final String accessibleModuleList;

  final bool otherUser;

  const ConnectionUserInvitedListItem({super.key,
    required this.userItemTap,
    required this.userEditTap,
    required this.imageUrl,
    required this.userName,
    required this.connectionType,
    required this.sharedModuleList,
    // required this.accessibleModuleList,
    required this.otherUser,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor,width: 1),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
            onTap: () {
              userItemTap();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              width: screenWidth, // Takes the full width of the screen
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      border: Border.all(color: AppColors.primaryColor),
                    ),
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
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
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              userName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: AppConstants.headingFontSize),
                            ),
                            const SizedBox(width: 5,),
                            InkWell(onTap: (){
                              showConnectionDetailsPopUp(context,userName,connectionType,sharedModuleList,"");
                            }, child: const Icon(Icons.info,size: 18,color: AppColors.primaryColor,))
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Invite as: ",
                              style: TextStyle(
                                color: AppColors.textWhiteColor,
                                fontSize: AppConstants.defaultFontSize,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                connectionType,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColors.connectionTypeTextColor),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              " You've shared: ",
                              style: TextStyle(
                                color: AppColors.textWhiteColor,
                                fontSize: AppConstants.defaultFontSize,
                              ),
                            ),
                            Expanded(
                              child: Text(
                               sharedModuleList.isEmpty ? "None" : sharedModuleList.replaceAll(",", "/"),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColors.connectionTypeTextColor),
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     const Text(
                        //       "Accessible Modules: ",
                        //       style: TextStyle(
                        //         color: AppColors.textWhiteColor,
                        //         fontSize: AppConstants.defaultFontSize,
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Text(
                        //         accessibleModuleList.replaceAll(",", "/"),
                        //         overflow: TextOverflow.ellipsis,
                        //         style: const TextStyle(color: AppColors.connectionTypeTextColor),
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
          Visibility(
            visible: !otherUser,
            child: InkWell(
              onTap: () {
                userEditTap();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: const Text("Edit",style: TextStyle(color: AppColors.hoverColor,fontSize: AppConstants.defaultFontSize),),
              ),
            ),
          )
        ],
      ),
    );
  }
}