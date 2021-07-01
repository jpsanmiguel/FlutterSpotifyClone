part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final String id;
  final String username;
  final String email;
  final String imageUrl;

  ProfileState({
    this.id,
    this.username,
    this.email,
    this.imageUrl,
  });

  ProfileState copyWith({
    String id,
    String username,
    String email,
    String imageUrl,
  }) {
    return ProfileState(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  String validateUsername(String username) {
    return validateUsernameUtils(username);
  }

  String validateEmail(String email) {
    return validateEmailUtils(email);
  }

  @override
  List<Object> get props => [id, username, email, imageUrl];
}
