class Image {
  int height;
  String url;
  int width;

  Image({this.height, this.url, this.width});

  Image.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map();
    json['height'] = height;
    json['url'] = url;
    json['width'] = width;
    return json;
  }
}
