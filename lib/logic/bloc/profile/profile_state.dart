part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final User user;
  final String username;
  final String imageUrl;

  String get email => user.email;
  String get id => user.id;

  bool showImageModal;

  ProfileState({
    @required User user,
    String username,
    String imageUrl,
    showImageModal = false,
  })  : this.user = user,
        this.username = username,
        this.imageUrl = imageUrl,
        this.showImageModal = showImageModal;

  ProfileState copyWith({
    User user,
    String username,
    String imageUrl,
    bool showImageModal,
  }) {
    return ProfileState(
      user: user ?? this.user,
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
      showImageModal: showImageModal ?? this.showImageModal,
    );
  }

  String validateUsername(String username) {
    return validateUsernameUtils(username);
  }

  @override
  List<Object> get props => [user, username, imageUrl, showImageModal];
}
