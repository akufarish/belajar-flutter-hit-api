import 'package:flutter_hit_api/models/consultaion.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T data;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse(
      success: json["success"],
      message: json["message"],
      data: fromJsonT(json["data"]),
    );
  }

  static ApiResponse<List<T>> fromJsonList<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final List<dynamic> jsonList = json["data"];
    return ApiResponse<List<T>>(
      success: json["success"],
      message: json["message"],
      data: jsonList.map((item) => fromJsonT(item)).toList(),
    );
  }
}
