import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/core/api_service.dart';
import 'package:todo_app/core/app_exception.dart';
import 'package:todo_app/logger.dart';

class NetworkApiService implements ApiService {
  @override
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    if (kDebugMode) {
      logDebug("GET Request URL", url);
    }

    try {
      final response = await http
          .get(Uri.parse(url), headers: _getHeaders(headers))
          .timeout(const Duration(seconds: 20));

      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet Connection");
    } on TimeoutException {
      throw FetchDataException("Request Timed Out");
    }
  }

  @override
  Future<dynamic> post(String url,
      {Map<String, String>? headers, dynamic body}) async {
    if (kDebugMode) {
      logDebug("POST Request URL", url);
      logDebug("POST Request Body", body.toString());
    }

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: _getHeaders(headers),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet Connection");
    } on TimeoutException {
      throw FetchDataException("Request Timed Out");
    } on FormatException {
      throw FetchDataException("Invalid Response Format");
    }
  }

  Map<String, String> _getHeaders(Map<String, String>? headers) {
    final defaultHeaders = {'Content-Type': 'application/json'};
    return headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;
  }

  dynamic _returnResponse(http.Response response) {
    if (kDebugMode) {
      logDebug("Response Status", response.statusCode.toString());
      logDebug("Response Body", response.body);
    }

    if (response.body.isEmpty) {
      throw FetchDataException("Empty Response");
    }

    dynamic responseJson;
    try {
      responseJson = jsonDecode(response.body);
    } catch (e) {
      throw FetchDataException("Invalid JSON Format");
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 400:
        throw BadRequestException(responseJson["error"] ?? "Bad Request");
      case 401:
      case 403:
        throw UnauthorizedException(
            "Unauthorized: ${responseJson["error"] ?? "Access Denied"}");
      case 500:
        throw FetchDataException("Internal Server Error");
      default:
        throw FetchDataException(
            "Unexpected Error: ${response.statusCode}, ${response.body}");
    }
  }
}
