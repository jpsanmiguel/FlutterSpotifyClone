import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_clone/data/models/aws/ModelProvider.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/utils/functions.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DataRepository dataRepository;

  ProfileBloc({
    @required this.dataRepository,
  }) : super(ProfileState());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is UserReceived) {
      yield state.copyWith(
        id: event.user.id,
        username: event.user.username,
        email: event.user.email,
      );
    } else if (event is UsernameChanged) {
      yield state.copyWith(
        username: event.username,
      );
    } else if (event is EmailChanged) {
      yield state.copyWith(
        email: event.email,
      );
    } else if (event is ImageChanged) {
      yield state.copyWith(
        imageUrl: event.imageUrl,
      );
    } else if (event is UsernameSaved) {
      User user = await dataRepository.updateUser(
        userId: state.id,
        username: state.username,
        email: state.email,
      );
      if (user != null) {
        yield state.copyWith(
          username: user.username,
          email: user.email,
        );
      }
    } else if (event is EmailSaved) {
      dataRepository.updateUser(
        userId: state.id,
        username: state.username,
        email: state.email,
      );
    } else if (event is ImageSaved) {
      print("wowow");
    }
  }
}
