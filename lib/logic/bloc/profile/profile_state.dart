part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final User user;
  final String username;
  final String imageUrl;

  String get email => user.email;
  String get id => user.id;

  ProfileState({
    @required User user,
    String username,
    String imageUrl,
  })  : this.user = user,
        this.username = username,
        this.imageUrl = imageUrl;

  ProfileState copyWith({
    User user,
    String username,
    String imageUrl,
  }) {
    return ProfileState(
      user: user ?? this.user,
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  String validateUsername(String username) {
    return validateUsernameUtils(username);
  }

  @override
  List<Object> get props => [user, username, imageUrl];
}
