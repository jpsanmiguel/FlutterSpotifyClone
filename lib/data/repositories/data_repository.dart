import 'package:amplify_flutter/amplify.dart';
import 'package:spotify_clone/models/ModelProvider.dart';

class DataRepository {
  Future<User> getUserById(String userId) async {
    try {
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.ID.eq(userId),
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      throw e;
    }
  }

  Future<User> createUser({
    String userId,
    String username,
    String email,
  }) async {
    final newUser = User(id: userId, username: username, email: email);
    try {
      await Amplify.DataStore.save(newUser);
      return newUser;
    } catch (e) {
      throw e;
    }
  }

  Future<User> updateUser({User user}) async {
    try {
      await Amplify.DataStore.save(user);
      return user;
    } catch (e) {
      throw e;
    }
  }
}
