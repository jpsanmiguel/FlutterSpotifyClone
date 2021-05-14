class AuthRepository {
  Future<void> login() async {
    print('attempting login');
    await Future.delayed(
      Duration(seconds: 3),
    );
    print('logged in!');
    // throw Exception('A exception, lol');
  }

  Future<void> register() async {
    print('attempting register');
    await Future.delayed(
      Duration(seconds: 3),
    );
    print('registered!');
    // throw Exception('A exception, lol');
  }
}
