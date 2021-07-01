part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class UserReceived extends ProfileEvent {
  final User user;

  UserReceived({this.user});
}

class UsernameChanged extends ProfileEvent {
  final String username;

  UsernameChanged({this.username});
}

class UsernameSaved extends ProfileEvent {
  final String username;

  UsernameSaved({this.username});
}

class EmailChanged extends ProfileEvent {
  final String email;

  EmailChanged({this.email});
}

class EmailSaved extends ProfileEvent {
  final String email;

  EmailSaved({this.email});
}

class ImageChanged extends ProfileEvent {
  final String imageUrl;

  ImageChanged({this.imageUrl});
}

class ImageSaved extends ProfileEvent {
  final String imageUrl;

  ImageSaved({this.imageUrl});
}
