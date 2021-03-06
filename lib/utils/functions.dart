import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/constants/constants.dart';

String getImageUrlFromUri(String rawUri) {
  var uri = rawUri.split(':').last;
  return IMAGE_BASE_URL + uri;
}

Future<SharedPreferences> getSharedPreferences() async {
  return await SharedPreferences.getInstance();
}

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

String validateEmailUtils(String email) {
  if (email.isEmpty) {
    return 'El correo no puede ser vacío';
  }
  if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email)) {
    return 'Debes ingresar un correo válido';
  }
  return null;
}

String validatePasswordUtils(String password) {
  if (password.length < 8) {
    return 'La contraseña debe ser de 8 o más caracteres';
  }
  return null;
}

String validateUsernameUtils(String username) {
  if (username.isEmpty) {
    return 'El usuario no puede ser vacío';
  }
  return null;
}
