part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ChangeImageRequest extends ProfileEvent {}

class OpenImagePicker extends ProfileEvent {}

class SaveImageUrl extends ProfileEvent {
  final String imageUrl;

  SaveImageUrl({this.imageUrl});
}

class UsernameChanged extends ProfileEvent {
  final String username;

  UsernameChanged({this.username});
}

class SaveUsername extends ProfileEvent {
  final String username;

  SaveUsername({this.username});
}
