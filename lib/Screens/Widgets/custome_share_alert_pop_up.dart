import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../Widgets/colors.dart';
import '../../../Widgets/constants.dart';

class CustomShareAlertConnectionItem extends StatelessWidget {
  final Function userItemTap;
  final Function userItemLongPressTap;
  final String imageUrl;
  final String userName;
  final String connectionType;
  final String stars;
  final bool showStars;
  final bool selectedIcon;

  const CustomShareAlertConnectionItem({super.key,
    required this.userItemTap,
    required this.userItemLongPressTap,
    required this.imageUrl,
    required this.userName,
    required this.connectionType,
    required this.stars,
    required this.selectedIcon,
    required this.showStars,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        userItemTap();
      },
      onLongPress: () {
        userItemLongPressTap();
      },
      child: Container(
        color: selectedIcon ? AppColors.highlightColor : null ,
        margin: const EdgeInsets.symmetric(vertical: 1),
        width: double.infinity, // Utilize the full width of the parent
        child: Row(
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
                Visibility(
                  visible: selectedIcon,
                  child: Positioned(
                    bottom: 3,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.hoverColor,
                          borderRadius: BorderRadius.circular(300)
                      ),
                      padding:const EdgeInsets.all(0.1),
                      child: const Icon(Icons.check_circle,color: AppColors.primaryColor,size: 20,),
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(width: 3),
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
                        style: const TextStyle(
                          fontSize: AppConstants.userActivityFontSize,
                        ),
                      ),
                      Visibility(
                          visible: showStars,
                          child: const Icon(Icons.star,color: AppColors.primaryColor,)),
                      Visibility(
                        visible: showStars,
                        child: Text(
                          stars,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.connectionTypeTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          connectionType,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.primaryColor,
                            fontSize: AppConstants.defaultFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}