import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/data/response/tracks_paging_response.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class NetworkService {
  final _baseUrl = 'https://api.spotify.com/v1/';
  static const clientId = '407d613826f145328e1d271f7efc7ac5';
  static const redirectUrl = 'http://example.com/callback/';

  SharedPreferences prefs;

  Future<TracksPagingResponse> fetchUserTopTracks() async {
    try {
      final token = await getToken();
      final response = await get(
        Uri.parse("${_baseUrl}me/top/tracks"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var decodeJson = jsonDecode(response.body);
      TracksPagingResponse tracksPagingResponse =
          TracksPagingResponse.fromJson(decodeJson);
      print("RESPUESTA:::${response.body}");
      return tracksPagingResponse;
    } catch (e) {
      return null;
    }
  }

  Future getSpotifyAuthenticationToken() async {
    String token = await SpotifySdk.getAuthenticationToken(
        clientId: clientId,
        redirectUrl: redirectUrl,
        scope: 'app-remote-control, '
            'user-modify-playback-state, '
            'user-library-read, '
            'playlist-read-private, '
            'user-top-read, '
            'playlist-modify-public,user-read-currently-playing');

    await (await getSharedPreferences()).setString('token', token);
  }

  Future<SharedPreferences> getSharedPreferences() async {
    if (prefs == null) {
      return await SharedPreferences.getInstance();
    }
    return prefs;
  }

  Future<String> getToken() async {
    return (await getSharedPreferences()).getString('token') ??
        await getSpotifyAuthenticationToken();
  }
}
