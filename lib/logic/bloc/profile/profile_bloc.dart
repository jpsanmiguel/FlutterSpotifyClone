import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify_clone/models/ModelProvider.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/utils/functions.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DataRepository dataRepository;
  final _picker = ImagePicker();

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
      yield state.copyWith(showImageModal: true);
    } else if (event is CloseImageModal) {
      yield state.copyWith(showImageModal: false);
    } else if (event is OpenImagePicker) {
      yield state.copyWith(showImageModal: false);
      final pickedImage = await _picker.getImage(source: event.imageSource);
      if (pickedImage == null) return;
      yield state.copyWith(imageUrl: pickedImage.path);
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
