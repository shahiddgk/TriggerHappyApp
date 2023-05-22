
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';

class LogoScreen extends StatefulWidget {
  LogoScreen(this.screen,{Key? key}) : super(key: key);
  String screen;

  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  late bool isPhone;

  getScreenDetails() {

    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }

  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    getScreenDetails();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
        child: widget.screen == "" ?  Text("Burgeon",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
            : widget.screen == "PIRE" ?  Text("Burgeon-PIRE",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
            : widget.screen == "Trellis" ?  Text("Burgeon-Trellis",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
            : widget.screen == "Garden" ?  Text("Burgeon-Garden",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor) ,)
            :  widget.screen == "Column" ?  Text("Burgeon-Column",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
            :Text("Burgeon",style: TextStyle(fontSize: !isPhone ? AppConstants.logoFontSizeForIpad : AppConstants.logoFontSizeForMobile,fontWeight: FontWeight.w700,color: AppColors.primaryColor),)
      // Image.asset(widget.screen == "" ? "assets/trigger_logo.png"
      //     : widget.screen == "PIRE" ? "assets/burgeon_pire.png"
      //     :widget.screen == "Trellis" ? "assets/burgeon_trellis.png" :
      //   widget.screen == "Garden" ? "assets/burgeon_garden.png" : "assets/burgeon_trellis.png" ,fit: BoxFit.fill,height: MediaQuery.of(context).size.width/4.7,width: MediaQuery.of(context).size.width,),
    );
  }
}
