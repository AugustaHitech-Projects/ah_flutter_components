library custom_player;

import 'package:flutter/material.dart';
import 'package:custom_video_component/data_manager.dart';
import 'package:custom_video_component/web_video_control.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {

  final String videoUrl;
  final bool fromAsset;
  final String assetVideoPath;
  final String localCaptionsPath;

   const CustomVideoPlayer({
     Key? key,
     required this.videoUrl,
     required this.fromAsset,
     this.assetVideoPath = "",
     this.localCaptionsPath = ""
   }) : super(key: key);


  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {

  late FlickManager flickManager;
  late DataManager? dataManager;


  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: widget.fromAsset? VideoPlayerController.asset(
        widget.assetVideoPath,
        closedCaptionFile: _loadCaptions(widget.localCaptionsPath),
      ): VideoPlayerController.network(widget.videoUrl),
    );

    ///Data Manager for web
    dataManager = DataManager(flickManager: flickManager, urls: []);
  }

  ///To load the captions from assets
  Future<ClosedCaptionFile> _loadCaptions(String captionsPath) async {
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString(captionsPath);
    flickManager.flickControlManager!.toggleSubtitle();
    return SubRipCaptionFile(fileContents);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  FlickVideoPlayer(
      flickManager: flickManager,
      flickVideoWithControls: FlickVideoWithControls(
        controls: WebVideoControl(
          dataManager: dataManager!,
          iconSize: 30,
          fontSize: 14,
          progressBarSettings: FlickProgressBarSettings(
            height: 5,
            handleRadius: 5.5,
          ),
        ),
        /// To adjust for the resizing
        videoFit: BoxFit.scaleDown,
        // aspectRatioWhenLoading: 4 / 3,
      ),
    );
  }
}
