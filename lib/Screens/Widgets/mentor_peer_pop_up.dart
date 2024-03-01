
import 'package:flutter/material.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/option_mcq_widget.dart';

mentorPeerPopUp(BuildContext context) {
  bool isMentor = true;

  bool isPhone;
  if(MediaQuery.of(context).size.width<= 500) {
    isPhone = true;
  } else {
    isPhone = false;
  }
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return  StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: MediaQuery.of(context).size.height/3,
                width: !isPhone ? MediaQuery.of(context).size.width/3 : MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      height: MediaQuery.of(context).size.height/5.5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    OptionMcqAnswer(
                                        GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          isMentor = true;
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/4,
                                          decoration: BoxDecoration(
                                              color: isMentor ? AppColors.primaryColor : AppColors.hoverColor,
                                              borderRadius: BorderRadius.circular(6)
                                          ),

                                          padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                          alignment: Alignment.center,
                                          child: Text("Mentors",style: TextStyle(fontWeight: FontWeight.bold,color: isMentor ? AppColors.hoverColor : AppColors.primaryColor,fontSize: AppConstants.defaultFontSize),)),
                                       )
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    OptionMcqAnswer(
                                        GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          isMentor = false;
                                        });
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context).size.width/4,
                                          decoration: BoxDecoration(
                                              color: isMentor ? AppColors.hoverColor : AppColors.primaryColor,
                                              borderRadius: BorderRadius.circular(6)
                                          ),

                                          padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                          alignment: Alignment.center,
                                          child: Text("Peers",style: TextStyle(fontWeight: FontWeight.bold,color: !isMentor ? AppColors.hoverColor : AppColors.primaryColor,fontSize: AppConstants.defaultFontSize),)),
                                        )
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                          const Divider(color: AppColors.containerBorder,),
                          Visibility(
                              visible: isMentor,
                              child:const Center(
                                child: Text("No Mentor available"),
                              )),
                          Visibility(
                              visible: !isMentor,
                              child:const Center(
                                child: Text("No Peer available"),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      });
}