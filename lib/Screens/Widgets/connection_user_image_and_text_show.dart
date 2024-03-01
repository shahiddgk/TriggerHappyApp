import 'package:flutter/material.dart';
import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';

class PopUpConnectionListItem extends StatelessWidget {
  final Function userItemTap;
  final String imageUrl;
  final String userName;
  final String connectionType;
  final String stars;
  final bool showStars;
  final bool showOnlineIcon;

  const PopUpConnectionListItem({super.key,
    required this.userItemTap,
    required this.imageUrl,
    required this.userName,
    required this.connectionType,
    required this.stars,
    required this.showOnlineIcon,
    required this.showStars,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        userItemTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        width: double.infinity, // Utilize the full width of the parent
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Stack(
             children: [
               Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(150),
                   border: Border.all(color: AppColors.primaryColor),
                 ),
                 width: 50,
                 height: 50,
                 margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                 child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
               ),
               Visibility(
                 visible: showOnlineIcon,
                 child: Positioned(
                   bottom: 3,
                   right: 0,
                   child: Container(
                     decoration: BoxDecoration(
                       color: AppColors.hoverColor,
                       borderRadius: BorderRadius.circular(300)
                     ),
                     padding:const EdgeInsets.all(0.1),
                     child: const Icon(Icons.fiber_manual_record,color: AppColors.primaryColor,size: 13,),
                   ),
                 ),
               ),

             ],
           ),
            const SizedBox(width: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  userName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppConstants.userActivityFontSize,
                  ),
                ),
                const SizedBox(width: 3,),
                Visibility(
                    visible: showStars,
                    child: const Icon(Icons.star,size:15,color: AppColors.primaryColor,)),
                Visibility(
                  visible: showStars,
                  child: Text(
                    stars,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppConstants.defaultFontSize,
                      color: AppColors.connectionTypeTextColor,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              connectionType,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppConstants.defaultFontSize,
              ),
            ),
            // Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //
            //       Row(
            //         children: [
            //           Expanded(
            //             child:
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}