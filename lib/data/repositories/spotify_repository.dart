import 'package:flutter/material.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/services/network_service.dart';
import 'package:spotify_clone/data/response/saved_tracks_paging_response.dart';
import 'package:spotify_clone/data/response/top_tracks_paging_response.dart';

class SpotifyRepository {
  final NetworkService networkService;

  SpotifyRepository({@required this.networkService}) : super();

  Future<TopTracksPagingResponse> fetchUserTopTracks() async {
    TopTracksPagingResponse response =
        await networkService.fetchUserTopTracks();
    if (response.error != null) {
      await getSpotifyAuthenticationToken();
      response = await networkService.fetchUserTopTracks();
    }
    return response;
  }

  Future<TopTracksPagingResponse> fetchMoreUserTopTracks(
      {String nextUrl}) async {
    TopTracksPagingResponse response =
        await networkService.fetchUserTopTracks(nextUrl: nextUrl);
    if (response.error != null) {
      await getSpotifyAuthenticationToken();
      response = await networkService.fetchUserTopTracks(nextUrl: nextUrl);
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

  Future<SavedTracksPagingResponse> fetchMoreUserSavedTracks(
      {String nextUrl}) async {
    SavedTracksPagingResponse response =
        await networkService.fetchUserSavedTracks(nextUrl: nextUrl);
    if (response.error != null) {
      await getSpotifyAuthenticationToken();
      response = await networkService.fetchUserSavedTracks(nextUrl: nextUrl);
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

  Future<bool> removeFromLibrary(Track track) async {
    return await networkService.removeFromLibrary(track);
  }

  Future<bool> addToLibrary(Track track) async {
    return await networkService.addToLibrary(track);
  }
}
