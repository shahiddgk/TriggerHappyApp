import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';

import 'constants.dart';

// ignore: must_be_immutable
class VideoThumbnailDesignForIPad extends StatefulWidget {
   VideoThumbnailDesignForIPad(this.onTap,this.name,this.thumbnailUrl,this.onLaunchUrl,{Key? key}) : super(key: key);
   Function onTap;
   String thumbnailUrl;
   String name;
   Function onLaunchUrl;

  @override
  // ignore: library_private_types_in_public_api
  _VideoThumbnailDesignForIPadState createState() => _VideoThumbnailDesignForIPadState();
}

class _VideoThumbnailDesignForIPadState extends State<VideoThumbnailDesignForIPad> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.thumbnailUrl,
                    fit: BoxFit.fill,
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      return Container(
                          width: 60,
                          height: 60,
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress));
                    },
                    errorWidget: (context, url, error) => Container(
                        alignment: Alignment.center,
                        child:const Icon(Icons.error,color: AppColors.redColor,)),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.onLaunchUrl();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10,right: 10,left: 5),
                          height: 35,
                          width: 35,
                          child: ClipOval(
                            child: Image.network("https://yt3.googleusercontent.com/ytc/AGIKgqOMcE11tiMtTs4rMKE29ZdPkuF9vurD2CHqx-NJqz7NuAccNgbu25tHi8bICV5M=s176-c-k-c0x00ffffff-no-rj"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            margin:const EdgeInsets.only(top: 5),
                            child: Text(widget.name,style: const TextStyle(fontWeight:FontWeight.bold,fontSize: AppConstants.defaultFontSize),)),
                      ),
                    ],
                  )
                ],
              ),

            ),
            const Icon(Icons.play_circle_fill_outlined,size: 60,color: AppColors.primaryColor,)
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class VideoThumbnailScreenForMobile extends StatefulWidget {
   VideoThumbnailScreenForMobile(this.onTap,this.name,this.thumbnailurl,this.onLaunchUrl,{Key? key}) : super(key: key);
  Function onTap;
  String name;
  String thumbnailurl;
   Function onLaunchUrl;
  @override
  // ignore: library_private_types_in_public_api
  _VideoThumbnailScreenForMobileState createState() => _VideoThumbnailScreenForMobileState();
}

class _VideoThumbnailScreenForMobileState extends State<VideoThumbnailScreenForMobile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/4,
                  child: CachedNetworkImage(
                    imageUrl: widget.thumbnailurl,
                    fit: BoxFit.fill,
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      return Container(
                          width: 60,
                          height: 60,
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress));
                    },
                    errorWidget: (context, url, error) => Container(
                        alignment: Alignment.center,
                        child: const Icon(Icons.error,color: AppColors.redColor,)),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                       widget.onLaunchUrl();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10,right: 10,left: 5),
                        height: 35,
                        width: 35,
                        child: ClipOval(
                          child: Image.network("https://yt3.googleusercontent.com/ytc/AGIKgqOMcE11tiMtTs4rMKE29ZdPkuF9vurD2CHqx-NJqz7NuAccNgbu25tHi8bICV5M=s176-c-k-c0x00ffffff-no-rj"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin:const EdgeInsets.only(top: 5),
                          child: Text(widget.name,style: const TextStyle(fontWeight:FontWeight.bold,fontSize: AppConstants.defaultFontSize),)),
                    ),
                  ],
                )

              ],
            ),

          ),
        const  Icon(Icons.play_circle_fill_outlined,size: 60,color: AppColors.primaryColor,)
        ],
      ),
    );
  }
}

