import 'package:spotify_clone/constants/constants.dart';

String getImageUrlFromUri(String rawUri) {
  var uri = rawUri.split(':').last;
  return IMAGE_BASE_URL + uri;
}
