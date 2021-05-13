import 'package:flutter/material.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/network_service.dart';
import 'package:spotify_clone/data/response/saved_tracks_paging_response.dart';
import 'package:spotify_clone/data/response/top_tracks_paging_response.dart';

class Repository {
  final NetworkService networkService;

  Repository({@required this.networkService}) : super();

  Future<TopTracksPagingResponse> fetchUserTopTracks(String nextUrl) async {
    TopTracksPagingResponse response =
        await networkService.fetchUserTopTracks(nextUrl);
    if (response.error != null) {
      await getSpotifyAuthenticationToken();
      response = await networkService.fetchUserTopTracks(nextUrl);
    }
    return response;
  }

  Future<SavedTracksPagingResponse> fetchUserSavedTracks() async {
    SavedTracksPagingResponse response =
        await networkService.fetchUserSavedTracks();
    if (response.error != null) {
      await getSpotifyAuthenticationToken();
      response = await networkService.fetchUserSavedTracks();
    }
    return response;
  }

  Future getSpotifyAuthenticationToken() async {
    await networkService.resetToken();
    await networkService.getToken();
  }

  Future<bool> connectToSpotifyRemote() async {
    return await networkService.connectToSpotifyRemote();
  }

  Future play(Track track) async {
    return await networkService.play(track);
  }

  Future pause() async {
    return await networkService.pause();
  }

  Future resume() async {
    return await networkService.resume();
  }
}
