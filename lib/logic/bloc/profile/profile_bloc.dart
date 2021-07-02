import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_clone/models/ModelProvider.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/utils/functions.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DataRepository dataRepository;

  ProfileBloc({
    @required this.dataRepository,
    @required User user,
  }) : super(ProfileState(
          user: user,
          username: user.username,
          imageUrl: user.imageUrl,
        ));

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ChangeImageRequest) {
    } else if (event is OpenImagePicker) {
    } else if (event is SaveImageUrl) {
      yield state.copyWith(imageUrl: event.imageUrl);
    } else if (event is UsernameChanged) {
      yield state.copyWith(
        username: event.username,
      );
    } else if (event is SaveUsername) {
      await dataRepository.updateUser(
        userId: state.id,
        username: state.username,
        imageUrl: state.imageUrl,
      );
    }
  }
}
