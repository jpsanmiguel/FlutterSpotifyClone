import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify_clone/data/repositories/storage_repository.dart';
import 'package:spotify_clone/models/ModelProvider.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/utils/functions.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DataRepository dataRepository;
  final StorageRepository storageRepository;
  final _picker = ImagePicker();

  ProfileBloc({
    @required this.dataRepository,
    @required this.storageRepository,
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

      yield state.copyWith(loadingImage: true);

      final key = await storageRepository.uploadFile(File(pickedImage.path));

      final imageUrl = await storageRepository.getImageUrl(key);

      final updatedUser = state.user.copyWith(imageUrl: imageUrl);

      await dataRepository.updateUser(user: updatedUser);

      yield state.copyWith(
        imageUrl: imageUrl,
        loadingImage: false,
        user: updatedUser,
      );
    } else if (event is SaveImageUrl) {
      yield state.copyWith(imageUrl: event.imageUrl);
    } else if (event is UsernameChanged) {
      yield state.copyWith(
        username: event.username,
      );
    } else if (event is SaveUsername) {
      final updatedUser = state.user.copyWith(username: state.username);
      await dataRepository.updateUser(user: updatedUser);
      yield state.copyWith(user: updatedUser);
    }
  }
}
