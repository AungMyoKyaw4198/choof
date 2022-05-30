import 'package:choof_app/screens/favourite_page.dart';
import 'package:choof_app/screens/settings_page.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:choof_app/utils/datetime_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controllers/landing_page_controller.dart';
import '../models/post.dart';
import '../models/youtubeVideoResponse.dart';
import '../services/youtube_service.dart';
import '../utils/app_constant.dart';
import 'widgets/shared_widgets.dart';

class FullScreenPage extends StatefulWidget {
  final int index;
  final Post post;
  const FullScreenPage({Key? key, required this.post, required this.index})
      : super(key: key);

  @override
  State<FullScreenPage> createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  final landingPagecontroller = Get.find<LandingPageController>();
  late YoutubeVideoResponse videoDetail;
  bool isLoading = true;
  bool isFinished = true;
  bool isError = false;
  bool isFullScreen = false;
  late YoutubePlayerController currentPlayer;

  @override
  void initState() {
    currentPlayer = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.post.youtubeLink)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    viewVideoDetail(widget.post.youtubeLink);
    super.initState();
  }

  viewVideoDetail(String videoLink) async {
    String videoId = YoutubePlayer.convertUrlToId(videoLink)!;
    await YouTubeService.instance.fetchVideoInfo(id: videoId).then((value) {
      setState(() {
        videoDetail = value;
        isLoading = false;
        isError = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    });
  }

  @override
  void dispose() {
    currentPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: currentPlayer,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
      ),
      builder: (context, player) => Scaffold(
        bottomNavigationBar: BottomMenu(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(mainBgColor),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Obx(() {
                  return IndexedStack(
                    index: landingPagecontroller.tabIndex.value,
                    children: [
                      widget.index == 0
                          ? Stack(
                              children: [
                                Container(
                                  child: ListView(
                                    children: [
                                      player,
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          widget.post.name,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      widget.post.tags.isNotEmpty
                                          ? Container(
                                              height: 50,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    widget.post.tags.length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    child: Chip(
                                                      backgroundColor:
                                                          Colors.grey.shade800,
                                                      label: Text(widget
                                                          .post.tags[index]),
                                                      labelStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      const SizedBox(height: 10),
                                      Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              Center(
                                                child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(
                                                                widget.post
                                                                    .creatorImageUrl)))),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Center(
                                                child: Text(
                                                  'By: ',
                                                  style: TextStyle(
                                                      color: Colors.white54,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  widget.post.creator,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              const Center(
                                                child: CircleAvatar(
                                                  radius: 2,
                                                  backgroundColor:
                                                      Colors.white54,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              const Center(
                                                child: Text(
                                                  'In: ',
                                                  style: TextStyle(
                                                      color: Colors.white54,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  widget.post.groupName
                                                          .contains('#')
                                                      ? widget.post.groupName
                                                          .substring(
                                                              0,
                                                              widget.post
                                                                  .groupName
                                                                  .indexOf('#'))
                                                      : widget.post.groupName,
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Center(
                                                child: Text(
                                                  ' | ${widget.post.addedTime.getTimeAgo()}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          )),
                                      const SizedBox(height: 10),
                                      videoDetail.items![0].snippet!
                                                  .description !=
                                              null
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Text(
                                                videoDetail.items![0].snippet!
                                                    .description!,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ))
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                // Back Button
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const FavouritePage(),
                      widget.index == 1
                          ? Stack(
                              children: [
                                Container(
                                  child: ListView(
                                    children: [
                                      player,
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          widget.post.name,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      widget.post.tags.isNotEmpty
                                          ? Container(
                                              height: 50,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    widget.post.tags.length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    child: Chip(
                                                      backgroundColor:
                                                          Colors.grey.shade800,
                                                      label: Text(widget
                                                          .post.tags[index]),
                                                      labelStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      const SizedBox(height: 10),
                                      Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              Center(
                                                child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(
                                                                widget.post
                                                                    .creatorImageUrl)))),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Center(
                                                child: Text(
                                                  'By: ',
                                                  style: TextStyle(
                                                      color: Colors.white54,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  widget.post.creator,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              const Center(
                                                child: CircleAvatar(
                                                  radius: 2,
                                                  backgroundColor:
                                                      Colors.white54,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              const Center(
                                                child: Text(
                                                  'In: ',
                                                  style: TextStyle(
                                                      color: Colors.white54,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  widget.post.groupName
                                                          .contains('#')
                                                      ? widget.post.groupName
                                                          .substring(
                                                              0,
                                                              widget.post
                                                                  .groupName
                                                                  .indexOf('#'))
                                                      : widget.post.groupName,
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Center(
                                                child: Text(
                                                  ' | ${widget.post.addedTime.getTimeAgo()}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          )),
                                      const SizedBox(height: 10),
                                      videoDetail.items![0].snippet!
                                                  .description !=
                                              null
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Text(
                                                videoDetail.items![0].snippet!
                                                    .description!,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ))
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                // Back Button
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const YourGroupsPage(),
                      SettingsPage(),
                    ],
                  );
                }),
        ),
      ),
    );
  }
}
