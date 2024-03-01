
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Widgets/colors.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.footerBackgroundColor,
      alignment: Alignment.topCenter,
      height: Platform.isAndroid ? 55 : 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Web version available",style: TextStyle(color: AppColors.backgroundColor),),
         TextButton(onPressed: (){
           _launchURL();
         }, child: const Text("@ Burgeon.app",style: TextStyle(color: AppColors.backgroundColor,fontStyle: FontStyle.italic),),)
        ],
      )
    );
  }
  void _launchURL() async {
    const url = 'https://burgeon.app/'; // Replace with your desired URL
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
