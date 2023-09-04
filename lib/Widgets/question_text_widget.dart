// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/video_player_in_pop_up.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'colors.dart';

// ignore: must_be_immutable
class QuestionTextWidget extends StatefulWidget {
   QuestionTextWidget(this.questionText,this.urlText,this.onTap,this.visible,{Key? key}) : super(key: key);

  String? questionText;
   String? urlText;
  Function onTap;
  bool visible;

  @override
  // ignore: library_private_types_in_public_api
  _QuestionTextWidgetState createState() => _QuestionTextWidgetState();
}

class _QuestionTextWidgetState extends State<QuestionTextWidget> {


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  //here goes the function
  String? _parseHtmlString(String htmlString) {
    final document = parser.parse(htmlString);
    final String? parsedString = parser.parse(document.body?.text).documentElement?.text;

    return parsedString;
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: Padding(
            padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
            child: Text(_parseHtmlString(widget.questionText!)!,textAlign: TextAlign.start,style:const TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.defaultFontSize),)
            // Html(data: widget.questionText!,style: {
            //   "#" : Style(
            //       color: AppColors.textWhiteColor,
            //       fontSize: FontSize(AppConstants.defaultFontSize),
            //       textAlign: TextAlign.start,
            //
            //   ),
            // },),
          ),
        ),
        Visibility(
          visible: widget.visible,
          child: Expanded(
            flex: 1,
            child: IconButton(onPressed: (){
              String? url;
              dom.Document document = parser.parse(widget.urlText);
              dom.Element? oembedElement = document.querySelector('oembed');

              if (oembedElement != null) {
                url = oembedElement.attributes['url'];
                print("URLURLURL");
                print(url);
              } else {
                print('URL not found.');
              }
              String? videoId = YoutubePlayer.convertUrlToId(url!);
              YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                  initialVideoId: videoId!,
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                    controlsVisibleAtStart: false,
                  )

              );
              videoPopupDialog(context, "Introduction to question#1", youtubePlayerController);
            }, icon:const Icon(Icons.ondemand_video,size:30,color: AppColors.blueColor,)),
          ),
        )
      ],
    );
  }
}
