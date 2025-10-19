import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:word_guess/services/api_constants.dart';
import 'package:word_guess/services/storage_service.dart';

// Custom Exceptions
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'ApiException: $message (${statusCode ?? 'No Status Code'})';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

// Response Models
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? fromJsonT,
  }) {
    return ApiResponse<T>(
      success: json['success'] != null ? json['success'] as bool : true,
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'],
      statusCode: json['statusCode'] as int,
    );
  }
}

// Main API Service Class
class ApiService extends GetxService {
  static ApiService get to => Get.find();

  late Dio _dio;
  // final GetStorage _storage = GetStorage();
  final _storage = Get.find<StorageService>();

  // Configuration
  final String baseUrl;
  final int connectTimeout;
  final int receiveTimeout;

  ApiService({
    this.baseUrl = '${ApiConstants.baseUrl}api/',
    this.connectTimeout = 30000,
    this.receiveTimeout = 30000,
  });

  @override
  void onInit() {
    super.onInit();
    _setupDio();
  }

  void _setupDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: connectTimeout),
        receiveTimeout: Duration(milliseconds: receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          final token = _storage.token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired, handle logout
            _handleUnauthorized();
          }
          return handler.next(error);
        },
      ),
    );

    // Add logging interceptor in debug mode
    if (Get.isLogEnable) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
        ),
      );
    }
  }

  void _handleUnauthorized() {
    // Clear storage and redirect to login
    _storage.clearToken();
    // Get.offAllNamed('/login');
  }

  void setToken(String token) {
    _storage.setToken(token);
  }

  void clearToken() {
    _storage.clearToken();
  }

  // Generic GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJsonT,
    bool showLoading = false,
  }) async {
    return _handleRequest<T>(
      () => _dio.get(path, queryParameters: queryParameters, data: body),
      fromJsonT: fromJsonT,
      showLoading: showLoading,
    );
  }

  // Generic POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJsonT,
    bool showLoading = false,
  }) async {
    return _handleRequest<T>(
      () => _dio.post(path, data: data),
      fromJsonT: fromJsonT,
      showLoading: showLoading,
    );
  }

  // Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJsonT,
    bool showLoading = false,
  }) async {
    return _handleRequest<T>(
      () => _dio.put(path, data: data),
      fromJsonT: fromJsonT,
      showLoading: showLoading,
    );
  }

  // Generic PATCH request
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJsonT,
    bool showLoading = false,
  }) async {
    return _handleRequest<T>(
      () => _dio.patch(path, data: data),
      fromJsonT: fromJsonT,
      showLoading: showLoading,
    );
  }

  // Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJsonT,
    bool showLoading = false,
  }) async {
    return _handleRequest<T>(
      () => _dio.delete(path, data: data),
      fromJsonT: fromJsonT,
      showLoading: showLoading,
    );
  }

  // File upload
  Future<ApiResponse<T>> uploadFile<T>(
    String path,
    String filePath, {
    T Function(dynamic)? fromJsonT,
    bool showLoading = false,
    void Function(int, int)? onSendProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    return _handleRequest<T>(
      () => _dio.post(path, data: formData, onSendProgress: onSendProgress),
      fromJsonT: fromJsonT,
      showLoading: showLoading,
    );
  }

  // Generic request handler
  Future<ApiResponse<T>> _handleRequest<T>(
    Future<Response> Function() request, {
    T Function(dynamic)? fromJsonT,
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) {
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
      }

      final response = await request();

      if (showLoading) {
        Get.back();
      }

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // Handle different response formats
        final responseData = response.data;

        if (responseData is Map<String, dynamic>) {
          return ApiResponse<T>.fromJson(responseData, fromJsonT: fromJsonT);
        } else {
          return ApiResponse<T>(
            success: true,
            message: 'Success',
            data: fromJsonT != null ? fromJsonT(responseData) : responseData,
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          'Request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (showLoading) Get.back();

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData is Map
            ? errorData['message'] ?? errorData['error'] ?? 'Unknown error'
            : 'Server error: ${e.response!.statusCode}';

        throw ApiException(errorMessage, e.response!.statusCode);
      } else {
        throw ApiException(e.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      if (showLoading) Get.back();
      throw ApiException(e.toString());
    }
  }
}
