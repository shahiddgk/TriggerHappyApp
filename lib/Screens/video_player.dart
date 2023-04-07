import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class VideoPlayer extends StatefulWidget {
   VideoPlayer(this.name,this.userId,this.videoId,{Key? key}) : super(key: key);

   String name;
   String userId;
   String videoId;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {

    late final YoutubePlayerController _playerController;

  @override
  void initState() {
    // TODO: implement initState
    _playerController = YoutubePlayerController(
        initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        controlsVisibleAtStart: false,
      )

    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget().appBar(false, false, widget.name, widget.userId, true),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: YoutubePlayer(
            controller: _playerController,
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
    );
  }
}
