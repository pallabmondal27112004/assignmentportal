import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:8000/api",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {"Accept": "application/json"},
    ),
  );

  /// Uploads an assignment file with a title
  Future<ApiResponse> uploadAssignment(String title, String filePath) async {
    try {
      if (!File(filePath).existsSync()) {
        return ApiResponse(success: false, message: "File does not exist");
      }

      FormData formData = FormData.fromMap({
        'title': title,
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split(Platform.pathSeparator).last,
        ),
      });

      final response = await dio.post('/assignments/upload', data: formData);

      return ApiResponse(
        success: true,
        message: "Upload successful",
        data: response.data,
      );
    } on DioException catch (e) {
      String msg =
          e.response?.data?['message'] ?? e.message ?? "Unknown server error";
      return ApiResponse(success: false, message: msg);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  /// Fetch all assignments
  Future<ApiResponse> getAssignments() async {
    try {
      final response = await dio.get('/assignments');
      return ApiResponse(success: true, data: response.data);
    } on DioException catch (e) {
      String msg =
          e.response?.data?['message'] ??
          e.message ??
          "Failed to fetch assignments";
      return ApiResponse(success: false, message: msg);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  /// Download a file from a URL and save to local path
  Future<ApiResponse> downloadFile(String url, String savePath) async {
    try {
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
              "Downloading: ${(received / total * 100).toStringAsFixed(0)}%",
            );
          }
        },
      );
      return ApiResponse(success: true, message: "Download completed");
    } on DioException catch (e) {
      String msg =
          e.response?.data?['message'] ?? e.message ?? "Download failed";
      return ApiResponse(success: false, message: msg);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}

/// Standardized API response
class ApiResponse {
  final bool success;
  final String? message;
  final dynamic data;

  ApiResponse({required this.success, this.message, this.data});
}
