import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/constants/constants.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/response/saved_tracks_paging_response.dart';
import 'package:spotify_clone/data/response/top_tracks_paging_response.dart';
import 'package:spotify_clone/utils/functions.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class NetworkService {
  static const clientId = '407d613826f145328e1d271f7efc7ac5';
  static const redirectUrl = 'http://example.com/callback/';

  SharedPreferences prefs;

  Future<TopTracksPagingResponse> fetchUserTopTracks(String nextUrl) async {
    try {
      final token = await getToken();
      final response = await get(
        Uri.parse(nextUrl ?? TOP_TRACKS_DEFAULT_URL),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var decodeJson = jsonDecode(response.body);
      TopTracksPagingResponse tracksPagingResponse =
          TopTracksPagingResponse.fromJson(decodeJson);
      var finalTopTracksPagingResponse =
          await _checkUserTopTracksInSavedTracks(tracksPagingResponse);
      return finalTopTracksPagingResponse;
    } catch (e) {
      return null;
    }
  }

  Future<TopTracksPagingResponse> _checkUserTopTracksInSavedTracks(
    TopTracksPagingResponse topTracksPagingResponse,
  ) async {
    try {
      final token = await getToken();
      final songIds =
          topTracksPagingResponse.tracks.map((track) => track.id).join(",");
      final response = await get(
        Uri.parse("$TRACKS_IN_LIBRARY_BASE_URL$songIds"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var decodeJson = jsonDecode(response.body);
      var finalTopTracksPagingResponse = topTracksPagingResponse;
      finalTopTracksPagingResponse.tracks.asMap().forEach((index, element) {
        element.inLibrary = (decodeJson[index] as bool);
      });
      return finalTopTracksPagingResponse;
    } catch (e) {
      throw e;
    }
  }

  Future<SavedTracksPagingResponse> fetchUserSavedTracks(
      {String nextUrl}) async {
    try {
      final token = await getToken();
      final response = await get(
        Uri.parse(nextUrl ?? SAVED_TRACKS_DEFAULT_URL),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var decodeJson = jsonDecode(response.body);
      SavedTracksPagingResponse tracksPagingResponse =
          SavedTracksPagingResponse.fromJson(decodeJson);
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

    await (await getSharedPreferences()).setString(TOKEN, token);
    return token;
  }

  Future<String> getToken() async {
    String token = (await getSharedPreferences()).getString(TOKEN) ??
        await getSpotifyAuthenticationToken();
    print('TOKEN: $token');
    return token;
  }

  Future resetToken() async {
    await (await getSharedPreferences()).remove(TOKEN);
  }

  Future<bool> connectToSpotifyRemote() async {
    return await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId, redirectUrl: redirectUrl);
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

  Future<bool> removeFromLibrary(Track track) async {
    try {
      await SpotifySdk.removeFromLibrary(spotifyUri: track.uri);
      return false;
    } catch (e) {
      return true;
    }
  }

  Future<bool> addToLibrary(Track track) async {
    try {
      await SpotifySdk.addToLibrary(spotifyUri: track.uri);
      return true;
    } catch (e) {
      return false;
    }
  }
}
