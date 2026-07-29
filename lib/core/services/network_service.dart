import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// network result model wrapper
class NetworkResult<T> {
  final T? data;
  final int? statusCode;
  final String? message;
  final bool isSuccess;

  NetworkResult._({
    this.data,
    this.statusCode,
    this.message,
    required this.isSuccess,
  });

  factory NetworkResult.success(T data, int? statusCode, String? message) {
    return NetworkResult._(
      data: data,
      statusCode: statusCode,
      message: message,
      isSuccess: true,
    );
  }

  factory NetworkResult.failure(int? statusCode, String? message) {
    return NetworkResult._(
      statusCode: statusCode,
      message: message,
      isSuccess: false,
    );
  }
}

/// network api service using dio
class NetworkService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.malamal.com.bd/api/v1',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  static final NetworkService _instance = NetworkService._internal();

  NetworkService._internal();

  static NetworkService get instance => _instance;

  /// set authorization token dynamically for authenticated requests
  void setToken(String? token) {
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// extract message from response dynamic data or fallback statusMessage
  String? _extractMessage(dynamic responseData, String? fallback) {
    if (responseData is Map) {
      return responseData['message']?.toString();
    }
    return fallback;
  }

  /// perform get request
  Future<NetworkResult<dynamic>> get(String endpoint) async {
    try {
      final Response response = await _dio.get(endpoint);
      log(
        const JsonEncoder.withIndent('  ').convert(response.data),
        name:
            '\n🚨\n[STATUS CODE] ${response.statusCode}\n[GET][ENDPOINT] $endpoint\n[RESPONSE]\n',
      );

      final String? message = _extractMessage(
        response.data,
        response.statusMessage,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return NetworkResult.success(
          response.data,
          response.statusCode,
          message,
        );
      } else {
        return NetworkResult.failure(
          response.statusCode,
          message,
        );
      }
    } on DioException catch (e) {
      debugPrint(
        '🚨\n[ERROR]\n[STATUS CODE] ${e.response?.statusCode ?? 0}\n[GET][ENDPOINT] $endpoint\n[MESSAGE] $e',
      );

      final String? errorMessage = _extractMessage(
        e.response?.data,
        e.response?.statusMessage ??
            e.message ??
            "Something went wrong on our side. Please try again.",
      );

      return NetworkResult.failure(
        e.response?.statusCode ?? 0,
        errorMessage,
      );
    }
  }

  /// perform post request
  Future<NetworkResult<dynamic>> post(String endpoint, {dynamic data}) async {
    try {
      final Response response = await _dio.post(endpoint, data: data);
      log(
        const JsonEncoder.withIndent('  ').convert(response.data),
        name:
            '\n🚨\n[STATUS CODE] ${response.statusCode}\n[POST][ENDPOINT] $endpoint\n[RESPONSE]\n',
      );

      final String? message = _extractMessage(
        response.data,
        response.statusMessage,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return NetworkResult.success(
          response.data,
          response.statusCode,
          message,
        );
      } else {
        return NetworkResult.failure(
          response.statusCode,
          message,
        );
      }
    } on DioException catch (e) {
      debugPrint(
        '🚨\n[ERROR]\n[STATUS CODE] ${e.response?.statusCode ?? 0}\n[POST][ENDPOINT] $endpoint\n[MESSAGE] $e',
      );

      final String? errorMessage = _extractMessage(
        e.response?.data,
        e.response?.statusMessage ??
            e.message ??
            "Something went wrong on our side. Please try again.",
      );

      return NetworkResult.failure(
        e.response?.statusCode ?? 0,
        errorMessage,
      );
    }
  }

  /// perform put request
  Future<NetworkResult<dynamic>> put(String endpoint, {dynamic data}) async {
    try {
      final Response response = await _dio.put(endpoint, data: data);
      log(
        const JsonEncoder.withIndent('  ').convert(response.data),
        name:
            '\n🚨\n[STATUS CODE] ${response.statusCode}\n[PUT][ENDPOINT] $endpoint\n[RESPONSE]\n',
      );

      final String? message = _extractMessage(
        response.data,
        response.statusMessage,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return NetworkResult.success(
          response.data,
          response.statusCode,
          message,
        );
      } else {
        return NetworkResult.failure(
          response.statusCode,
          message,
        );
      }
    } on DioException catch (e) {
      debugPrint(
        '🚨\n[ERROR]\n[STATUS CODE] ${e.response?.statusCode ?? 0}\n[PUT][ENDPOINT] $endpoint\n[MESSAGE] $e',
      );

      final String? errorMessage = _extractMessage(
        e.response?.data,
        e.response?.statusMessage ??
            e.message ??
            "Something went wrong on our side. Please try again.",
      );

      return NetworkResult.failure(
        e.response?.statusCode ?? 0,
        errorMessage,
      );
    }
  }

  /// perform patch request
  Future<NetworkResult<dynamic>> patch(String endpoint, {dynamic data}) async {
    try {
      final Response response = await _dio.patch(endpoint, data: data);
      log(
        const JsonEncoder.withIndent('  ').convert(response.data),
        name:
            '\n🚨\n[STATUS CODE] ${response.statusCode}\n[PATCH][ENDPOINT] $endpoint\n[RESPONSE]\n',
      );

      final String? message = _extractMessage(
        response.data,
        response.statusMessage,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return NetworkResult.success(
          response.data,
          response.statusCode,
          message,
        );
      } else {
        return NetworkResult.failure(
          response.statusCode,
          message,
        );
      }
    } on DioException catch (e) {
      debugPrint(
        '🚨\n[ERROR]\n[STATUS CODE] ${e.response?.statusCode ?? 0}\n[PATCH][ENDPOINT] $endpoint\n[MESSAGE] $e',
      );

      final String? errorMessage = _extractMessage(
        e.response?.data,
        e.response?.statusMessage ??
            e.message ??
            "Something went wrong on our side. Please try again.",
      );

      return NetworkResult.failure(
        e.response?.statusCode ?? 0,
        errorMessage,
      );
    }
  }

  /// perform delete request
  Future<NetworkResult<dynamic>> delete(String endpoint, {dynamic data}) async {
    try {
      final Response response = await _dio.delete(endpoint, data: data);
      log(
        const JsonEncoder.withIndent('  ').convert(response.data),
        name:
            '\n🚨\n[STATUS CODE] ${response.statusCode}\n[DELETE][ENDPOINT] $endpoint\n[RESPONSE]\n',
      );

      final String? message = _extractMessage(
        response.data,
        response.statusMessage,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return NetworkResult.success(
          response.data,
          response.statusCode,
          message,
        );
      } else {
        return NetworkResult.failure(
          response.statusCode,
          message,
        );
      }
    } on DioException catch (e) {
      debugPrint(
        '🚨\n[ERROR]\n[STATUS CODE] ${e.response?.statusCode ?? 0}\n[DELETE][ENDPOINT] $endpoint\n[MESSAGE] $e',
      );

      final String? errorMessage = _extractMessage(
        e.response?.data,
        e.response?.statusMessage ??
            e.message ??
            "Something went wrong on our side. Please try again.",
      );

      return NetworkResult.failure(
        e.response?.statusCode ?? 0,
        errorMessage,
      );
    }
  }
}
