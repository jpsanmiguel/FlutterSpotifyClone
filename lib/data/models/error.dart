class ErrorModel {
  String message;
  int status;

  ErrorModel({this.message, this.status});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }
}
