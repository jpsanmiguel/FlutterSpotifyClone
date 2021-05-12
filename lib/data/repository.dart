import 'package:flutter/material.dart';
import 'package:spotify_clone/data/network_service.dart';
import 'package:spotify_clone/data/response/tracks_paging_response.dart';

class Repository {
  final NetworkService networkService;

  Repository({@required this.networkService}) : super();

  Future<TracksPagingResponse> fetchUserTopTracks() async {
    TracksPagingResponse response = await networkService.fetchUserTopTracks();
    if (response.error != null) {
      await getSpotifyAuthenticationToken();
      response = await networkService.fetchUserTopTracks();
    }
    return response;
  }

  Future getSpotifyAuthenticationToken() async {
    await networkService.getSpotifyAuthenticationToken();
  }
}
