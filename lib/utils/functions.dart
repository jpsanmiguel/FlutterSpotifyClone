import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/constants/constants.dart';

String getImageUrlFromUri(String rawUri) {
  var uri = rawUri.split(':').last;
  return IMAGE_BASE_URL + uri;
}

Future<SharedPreferences> getSharedPreferences() async {
  return await SharedPreferences.getInstance();
}
