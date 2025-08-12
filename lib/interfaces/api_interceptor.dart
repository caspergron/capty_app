import 'package:http/http.dart' as http;

import 'package:app/models/system/api_response.dart';

abstract class ApiInterceptor {
  Future<ApiResponse> getRequest({required String endpoint});
  Future<ApiResponse> postRequest({required String endpoint, Map<String, dynamic>? body});
  Future<ApiResponse> deleteRequest({required String endpoint, Map<String, dynamic>? body});
  Future<ApiResponse> putRequest({required String endpoint, Map<String, dynamic>? body});
  Future<ApiResponse> patchRequest({required String endpoint, Map<String, dynamic>? body});
  Future<ApiResponse> multipartRequest({required http.MultipartRequest request});
}
