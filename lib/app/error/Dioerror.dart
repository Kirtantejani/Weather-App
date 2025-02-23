import 'dart:io';

import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioError dioError) {
    //for unautorized
    if (dioError.response?.statusCode == 401) {
      message = 'Unauthorized';

      return;
    }
    try {
      if (dioError.response?.data["message"] != null) {
        message = dioError.response?.data["message"];
        return;
      }
    } catch (e) {
      message = "Oops! Something went wrong";
      return;
    }

    if (dioError.error is SocketException) {
      message = "No Internet";
      return;
    }
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.badCertificate:
        message = "Bad certificate";
        break;
      case DioErrorType.connectionError:
        message =
            "Connection Error with server please try again after sometime";
        break;

      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioErrorType.unknown:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      default:
        message = "Oops! Something went wrong";
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return error['message'] ?? "Page not found";
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops! something went wrong';
    }
  }

  @override
  String toString() => message;
}
