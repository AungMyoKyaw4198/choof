import 'package:choof_app/controllers/add_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../models/youtubeVideoResponse.dart';
import '../utils/app_constant.dart';

class SearchVideoDetailPage extends StatefulWidget {
  final YoutubeVideoResponse video;
  const SearchVideoDetailPage({Key? key, required this.video})
      : super(key: key);

  @override
  State<SearchVideoDetailPage> createState() => _SearchVideoDetailPageState();
}

class _SearchVideoDetailPageState extends State<SearchVideoDetailPage> {
  final addVideocontroller = Get.find<AddVideoContoller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(bgColor),
        centerTitle: true,
        title: const Text(
          'Video Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                addVideocontroller.youtubeLink.text =
                    'https://youtu.be/${widget.video.items![0].id}';
                addVideocontroller.verifyYoutubeLink();
                addVideocontroller
                    .setTags(widget.video.items![0].snippet!.tags!);

                Get.back();
                Get.back();
              },
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.link,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(mainBgColor),
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                widget.video.items![0].snippet!.thumbnails!.high!.url!,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.video.items![0].snippet!.title!,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            widget.video.items![0].snippet!.tags!.isNotEmpty
                ? Container(
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.video.items![0].snippet!.tags!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Chip(
                            backgroundColor: Colors.grey.shade800,
                            label: Text(
                                widget.video.items![0].snippet!.tags![index]),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            widget.video.items![0].snippet!.description != null
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.video.items![0].snippet!.description!,
                      style: const TextStyle(color: Colors.white),
                    ))
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
