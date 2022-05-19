import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/youtubeSearchResult.dart';
import '../models/youtubeSearchResult.dart' as videoResult;
import '../models/youtubeVideoResponse.dart';
import '../models/youtubeVideoResponse.dart' as videoResponse;
import '../screens/search_video_detail_page.dart';
import '../services/youtube_service.dart';

class SearchVideoController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final searchResult = YoutubeSearchResult().obs;
  final videoList = <videoResult.Items>[].obs;

  searchVideos() async {
    if (videoList.isEmpty) {
      print('Empty');
      print(searchResult.value.nextPageToken);
      YoutubeSearchResult result = await YouTubeService.instance
          .searchVideos(query: searchController.text);
      searchResult(result);
      videoList(result.items);
    } else {
      print('Not Empty');
      print(searchResult.value.nextPageToken);
      YoutubeSearchResult result = await YouTubeService.instance.searchVideos(
          query: searchController.text,
          pageToken: searchResult.value.nextPageToken);
      searchResult(result);
      for (var element in result.items!) {
        videoList.add(element);
      }
    }
  }

  clearResults() {
    searchResult(YoutubeSearchResult());
    videoList([]);
  }

  viewVideoDetail(String videoId) async {
    YoutubeVideoResponse resposne =
        await YouTubeService.instance.fetchVideoInfo(id: videoId);
    Get.to(() => SearchVideoDetailPage(video: resposne));
  }
}
