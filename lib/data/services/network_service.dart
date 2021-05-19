import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/response/saved_tracks_paging_response.dart';
import 'package:spotify_clone/data/response/top_tracks_paging_response.dart';
import 'package:spotify_clone/utils/functions.dart';
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
        Uri.parse(nextUrl ??
            "${_baseUrl}me/top/tracks?time_range=short_term&limit=50"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var decodeJson = jsonDecode(response.body);
      TopTracksPagingResponse tracksPagingResponse =
          TopTracksPagingResponse.fromJson(decodeJson);
      // print("RESPUESTA_TOP:::${response.body}");
      print('topUrl: $nextUrl');
      return tracksPagingResponse;
    } catch (e) {
      return null;
    }
  }

  Future<SavedTracksPagingResponse> fetchUserSavedTracks(String nextUrl) async {
    try {
      final token = await getToken();
      final response = await get(
        Uri.parse(nextUrl ?? "${_baseUrl}me/tracks?limit=50"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var decodeJson = jsonDecode(response.body);
      SavedTracksPagingResponse tracksPagingResponse =
          SavedTracksPagingResponse.fromJson(decodeJson);
      // print("RESPUESTA_SAVED:::${response.body}");
      print('savedUrl: $nextUrl');
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

  Future resetToken() async {
    await (await getSharedPreferences()).remove('token');
  }

  Future<bool> connectToSpotifyRemote() async {
    var connected = await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId, redirectUrl: redirectUrl);

    print('connected? $connected');

    return connected;
  }

  Future play(Track track) async {
    return await SpotifySdk.play(spotifyUri: track.uri);
  }

  Future pause() async {
    return await SpotifySdk.pause();
  }

  Future resume() async {
    return await SpotifySdk.resume();
  }

  Future removeFromLibrary(Track track) async {
    return await SpotifySdk.removeFromLibrary(spotifyUri: track.uri);
  }

  Future addToLibrary(Track track) async {
    return await SpotifySdk.addToLibrary(spotifyUri: track.uri);
  }
}