import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'colors.dart';
import 'constants.dart';

Future videoPopupDialog(BuildContext context,String title,YoutubePlayerController youtubePlayerController) {
  return showDialog(context: context,
      builder: (context) {
        return  AlertDialog(
          backgroundColor: AppColors.lightGreyColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          title: Align(alignment: Alignment.centerRight,
          child:  GestureDetector(
              onTap: () {
                YoutubePlayerController.of(context)?.pause();
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.cancel)),),
          content:  Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.backgroundColor,
            ),
           // padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
            child:SizedBox(
              width: MediaQuery.of(context).size.width,
              child: YoutubePlayer(
                controller: youtubePlayerController,
                showVideoProgressIndicator: true,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(
                    isExpanded: true,
                    colors: const ProgressBarColors(
                        playedColor: AppColors.primaryColor,
                        handleColor: AppColors.primaryColor
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}