class Artist {
  String name;
  String uri;

  Artist.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uri = json['uri'];
  }
}
