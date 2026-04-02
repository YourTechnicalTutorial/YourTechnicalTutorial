import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  static const String _apiKey = "AIzaSyD0uPLegr54TBfRLYyLQrGaPKoepg2KqzI";
  static const String _channelId =
      "UCy1Miu1r_88HKhJLIHD_D6A"; // we will set this next

  static Future<Map<String, dynamic>> fetchVideos({int maxResults = 15}) async {
    final searchUrl =
        "https://www.googleapis.com/youtube/v3/search"
        "?key=$_apiKey"
        "&channelId=$_channelId"
        "&part=snippet"
        "&order=date"
        "&maxResults=$maxResults"
        "&type=video";

    final searchResponse = await http.get(Uri.parse(searchUrl));
    final searchData = json.decode(searchResponse.body);

    final items = searchData['items'];

    if (items == null || items is! List) {
      return {'items': []};
    }

    final ids = items.map((item) => item['id']['videoId']).join(",");

    final detailsUrl =
        "https://www.googleapis.com/youtube/v3/videos"
        "?key=$_apiKey"
        "&part=contentDetails"
        "&id=$ids";

    final detailsResponse = await http.get(Uri.parse(detailsUrl));
    final detailsData = json.decode(detailsResponse.body);

    final details = detailsData['items'];

    List<dynamic> filtered = [];

    for (int i = 0; i < items.length; i++) {
      final duration = details[i]['contentDetails']['duration'];

      if (!_isShort(duration)) {
        filtered.add(items[i]);
      }
    }

    return {'items': filtered};
  }

  static bool _isShort(String duration) {
    final regex = RegExp(r'PT(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(duration);

    final minutes = int.tryParse(match?.group(1) ?? "0") ?? 0;
    final seconds = int.tryParse(match?.group(2) ?? "0") ?? 0;

    final totalSeconds = minutes * 60 + seconds;

    return totalSeconds <= 61;
  }
}
