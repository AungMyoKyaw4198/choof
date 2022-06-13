import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/search_video_controller.dart';
import '../utils/app_constant.dart';

class SearchVideoPage extends StatefulWidget {
  final String? searchedWord;
  final bool isFromAddVideo;
  const SearchVideoPage(
      {Key? key, this.searchedWord, required this.isFromAddVideo})
      : super(key: key);

  @override
  State<SearchVideoPage> createState() => _SearchVideoPageState();
}

class _SearchVideoPageState extends State<SearchVideoPage> {
  final controller = Get.put(SearchVideoController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    if (widget.searchedWord != null) {
      controller.searchController.text = widget.searchedWord!;
      controller.searchVideos();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(bgColor),
        centerTitle: true,
        title: const Text(
          'Search Videos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(mainBgColor),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: controller.searchController,
                      enableInteractiveSelection: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Search Videos here",
                          fillColor: Colors.white70,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.searchController.clear();
                            },
                            icon: const Icon(Icons.close_rounded),
                          )),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        controller.clearResults();
                        controller.searchVideos();
                      },
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      controller.clearResults();
                      controller.searchVideos();
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.white,
                      size: 30,
                    ))
              ],
            ),
            Expanded(
              child: Obx(() {
                return controller.videoList.isNotEmpty
                    ? SmartRefresher(
                        controller: _refreshController,
                        enablePullUp: true,
                        enablePullDown: false,
                        footer: CustomFooter(
                          builder: (BuildContext context, LoadStatus? mode) {
                            Widget body;
                            if (mode == LoadStatus.idle) {
                              body = const Text("Pull up to load more");
                            } else if (mode == LoadStatus.loading) {
                              body = const CupertinoActivityIndicator();
                            } else if (mode == LoadStatus.failed) {
                              body = const Text("Load Failed!Click retry!");
                            } else if (mode == LoadStatus.canLoading) {
                              body = const Text("Release to load more");
                            } else {
                              body = const Text("");
                            }
                            return mode == LoadStatus.noMore
                                ? const SizedBox.shrink()
                                : Container(
                                    height: 30.0,
                                    child: Center(child: body),
                                  );
                          },
                        ),
                        onLoading: () {
                          controller.searchVideos();
                        },
                        child: ListView.builder(
                          itemCount: controller.videoList.length,
                          itemBuilder: (BuildContext context, index) {
                            return InkWell(
                              onTap: () {
                                controller.viewVideoDetail(
                                    controller.videoList[index].id!.videoId!,
                                    widget.isFromAddVideo);
                              },
                              child: Card(
                                child: Container(
                                  color: const Color(bgColor),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Image.network(
                                          controller.videoList[index].snippet!
                                              .thumbnails!.high!.url!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller
                                            .videoList[index].snippet!.title!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.videoList[index].snippet!
                                            .description!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
