import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenPage extends StatefulWidget {
  final String name;
  final String youtubeLink;
  const FullScreenPage(
      {Key? key, required this.name, required this.youtubeLink})
      : super(key: key);

  @override
  State<FullScreenPage> createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  bool isFinished = true;
  late YoutubePlayerController currentPlayer;

  @override
  void initState() {
    currentPlayer = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.youtubeLink)!);
    super.initState();
  }

  @override
  void dispose() {
    currentPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      if (orientation == Orientation.landscape) {
        return Scaffold(
          body: youtubeHierarchy(),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(widget.name),
          ),
          body: isFinished
              ? youtubeHierarchy()
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }
    });
  }

  youtubeHierarchy() {
    return Container(
      color: Colors.black,
      child: Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fill,
          child: YoutubePlayer(
            controller: currentPlayer,
            thumbnail: Image.network(
              YoutubePlayer.getThumbnail(
                  videoId: YoutubePlayer.convertUrlToId(widget.youtubeLink)!),
              fit: BoxFit.fitWidth,
              height: 200,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }
}
