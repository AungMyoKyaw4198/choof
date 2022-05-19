import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/youtubeSearchResult.dart';
import '../models/youtubeVideoResponse.dart';
import '../utils/app_constant.dart';

class YouTubeService {
  YouTubeService._instantiate();

  static final YouTubeService instance = YouTubeService._instantiate();

//https://www.googleapis.com/youtube/v3/search?&q=meme&part=snippet&maxResult=5&type=video&key=AIzaSyAZ9Xod6t6J34i26sUAlC3hkJRp5obrFkc
// https://www.googleapis.com/youtube/v3/videos?part=snippet&key=AIzaSyAZ9Xod6t6J34i26sUAlC3hkJRp5obrFkc&id=pmLfNkDtB44

//final String _searchBaseUrl =
//      'https://www.googleapis.com/youtube/v3/search?part=snippet' +
//          '&maxResults=$MAX_SEARCH_RESULTS&type=video&key=$API_KEY';

  // final String _videoBaseUrl =
  //    'https://www.googleapis.com/youtube/v3/videos?part=snippet&key=$API_KEY';

  final String _baseUrl = 'www.googleapis.com';

  Future<YoutubeSearchResult> searchVideos({
    String? query,
    String? pageToken,
  }) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'maxResults': '15',
      'type': 'video',
      'key': YotubeAPIKey,
      'q': query ?? '',
      'pageToken': pageToken ?? '',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/search',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Vides
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return YoutubeSearchResult.fromJson(data);
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<YoutubeVideoResponse> fetchVideoInfo({required String id}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'key': YotubeAPIKey,
      'id': id
    };
    Uri uri = Uri.https(
      _baseUrl,
      'youtube/v3/videos',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return YoutubeVideoResponse.fromJson(data);
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
