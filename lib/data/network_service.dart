import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/data/response/saved_tracks_paging_response.dart';
import 'package:spotify_clone/data/response/top_tracks_paging_response.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class NetworkService {
  final _baseUrl = 'https://api.spotify.com/v1/';
  static const clientId = '407d613826f145328e1d271f7efc7ac5';
  static const redirectUrl = 'http://example.com/callback/';

  SharedPreferences prefs;

  Future<TopTracksPagingResponse> fetchUserTopTracks(String nextUrl) async {
    try {
      final token = await getToken();
      final response = await get(
        Uri.parse(nextUrl ?? "${_baseUrl}me/top/tracks"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var decodeJson = jsonDecode(response.body);
      TopTracksPagingResponse tracksPagingResponse =
          TopTracksPagingResponse.fromJson(decodeJson);
      // print("RESPUESTA_TOP:::${response.body}");
      print('requestURL: $nextUrl');
      return tracksPagingResponse;
    } catch (e) {
      return null;
    }
  }

  Future<SavedTracksPagingResponse> fetchUserSavedTracks() async {
    try {
      final token = await getToken();
      final response = await get(
        Uri.parse("${_baseUrl}me/tracks"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var decodeJson = jsonDecode(response.body);
      SavedTracksPagingResponse tracksPagingResponse =
          SavedTracksPagingResponse.fromJson(decodeJson);
      print("RESPUESTA_SAVED:::${response.body}");
      return tracksPagingResponse;
    } catch (e) {
      return null;
    }
  }

  Future<String> getSpotifyAuthenticationToken() async {
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
    return token;
  }

  Future<String> getToken() async {
    String token = (await getSharedPreferences()).getString('token') ??
        await getSpotifyAuthenticationToken();
    print('TOKEN: $token');
    return token;
  }

  Future<bool> connectToSpotify() async {
    var connected = await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId, redirectUrl: redirectUrl);

    print('connected? $connected');

    return connected;
  }

  Future<SharedPreferences> getSharedPreferences() async {
    if (prefs == null) {
      return await SharedPreferences.getInstance();
    }
    return prefs;
  }
}
