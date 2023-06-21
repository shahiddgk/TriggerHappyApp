
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';

import '../../../Widgets/colors.dart';

// ignore: must_be_immutable
class ExpansionTileWidgetScreen extends StatefulWidget {
   ExpansionTileWidgetScreen(this.initiallyExpanded,this.heading,this.isExpandedTile,this.subHeading,this.nameHeading,this.nameHeadingAvailable,this.expansionTileStatus,this.iconOnPress,this.children,{Key? key}) : super(key: key);

  List <Widget> children;
  String heading;
   String subHeading;
   String nameHeading;
   bool nameHeadingAvailable;
   bool isExpandedTile;
  final Function(bool value) expansionTileStatus;
  Function iconOnPress;
  bool initiallyExpanded;

  @override
  // ignore: library_private_types_in_public_api
  _ExpansionTileWidgetScreenState createState() => _ExpansionTileWidgetScreenState();
}

class _ExpansionTileWidgetScreenState extends State<ExpansionTileWidgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.accordianCollapsedColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
                onExpansionChanged:(value) {
                  widget.expansionTileStatus(value);
                },
                initiallyExpanded: widget.initiallyExpanded,
                collapsedIconColor: AppColors.textWhiteColor,
                collapsedBackgroundColor: AppColors.accordianCollapsedColor,
                title: Container(
                  color: AppColors.accordianCollapsedColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(widget.heading,style: const TextStyle(fontSize:  AppConstants.headingFontSize),),
                            const  SizedBox(width: 10,),
                            IconButton(
                                onPressed: (){
                                  widget.iconOnPress();
                                },
                                icon: const Icon(Icons.ondemand_video,color: AppColors.infoIconColor,)),
                            if(widget.nameHeadingAvailable && !widget.isExpandedTile)
                            Text(widget.nameHeading,style: const TextStyle(fontSize: AppConstants.defaultFontSize),),
                          ],
                        ),
                      ),
                      if(!widget.isExpandedTile)
                      Text(widget.subHeading,style: TextStyle(fontSize: AppConstants.defaultFontSize,color: widget.nameHeadingAvailable ? null : AppColors.primaryColor),),
                    ],
                  ),
                ),
                children: widget.children,),
        ),
      ),
    );
  }
}
