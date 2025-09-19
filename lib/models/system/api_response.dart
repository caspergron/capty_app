class ApiResponse {
  int status;
  dynamic response;

  ApiResponse({required this.status, required this.response});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['response'] = response;
    return map;
  }
}
