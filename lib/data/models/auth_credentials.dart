import 'package:flutter/material.dart';

class AuthCredentials {
  final String email;
  final String password;
  final String username;
  String userId;

  AuthCredentials({
    @required this.email,
    this.password,
    this.username,
    this.userId,
  });
}
