import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'json_parsers.dart';

class ApiBaseService {
  static const String baseUrl = 'https://gjiif.thejewelleryworld.com/';
  static final _logger = Logger();
  static const _storage = FlutterSecureStorage();
  static final http.Client _httpClient = http.Client();

  static Future<List<T>> requestList<T>(
    String endpoint, {
    String method = 'GET',
    Object? body,
    Map<String, String>? params,
    bool authenticated = true,
  }) async {
    try {
      var response = await _sendAsync(
        method,
        endpoint,
        body,
        queryParams: params,
        authenticated: authenticated,
      );
      if (response != null) {
        var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 204) {
          return jsonResponse
              .map((item) => JsonParsers.fromJson<T>(item))
              .cast<T>()
              .toList();
        } else {
          throw Exception('Error: ${response.body}');
        }
      }
    } on TimeoutException {
      Fluttertoast.showToast(
        msg: "There is a problem connecting to the server.",
      );
    } catch (exception) {
      print('Exception: $exception');
    }
    throw ApiException("No Response: something went wrong");
  }

  static Future<T> request<T>(
    String endpoint, {
    String method = 'GET',
    Object? body,
    Map<String, String>? params,
    bool authenticated = true,
  }) async {
    const timeoutDuration = Duration(seconds: 10);
    try {
      var response = await _sendAsync(
        method,
        endpoint,
        body,
        queryParams: params,
        authenticated: authenticated,
      ).timeout(timeoutDuration);
      if (response != null) {
        var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 204) {
          return JsonParsers.fromJson<T>(jsonResponse);
        } else {
          throw Exception('Error: ${response.body}');
        }
      }
    } on TimeoutException {
      Fluttertoast.showToast(
        msg: "There is a problem connecting to the server.",
      );
    } catch (exception) {
      print('Exception: $exception');
    }
    //  throw Exception("No Response: something error");
    throw ApiException("No Response: something went wrong");
  }

  static Future<http.Response?> _sendAsync(
    String method,
    String endpoint,
    Object? body, {
    Map<String, String>? queryParams,
    bool authenticated = true,
  }) async {
    var url = Uri.parse(
      baseUrl +
          endpoint +
          (queryParams != null
              ? '?${Uri(queryParameters: queryParams).query}'
              : ""),
    );
    var requestMessage = http.Request(method, url);

    print("=== API URL : $requestMessage");
    print("=== API BODY DATA : $body");

    if (body != null && body is! http.MultipartRequest) {
      requestMessage.body = json.encode(body);
    }

    requestMessage.headers.addAll(await _headers(body, authenticated));

    if (kDebugMode) {
      print("=== HEADER : ${requestMessage.headers}");
    }

    http.Response? response;

    try {
      if (body is http.MultipartRequest) {
        body.headers.addAll(requestMessage.headers);
        response = await http.Response.fromStream(await body.send());
      } else {
        response = await http.Response.fromStream(
          await _httpClient.send(requestMessage),
        );
      }
    } on HttpException catch (e) {
      if (kDebugMode) {
        print("HTTP Exception: $e");
      }
      Fluttertoast.showToast(msg: "HTTP Exception: $e");
    }

    return _handleResponse(response);
  }

  static Future<Map<String, String>> _headers(
    Object? body,
    bool authenticated,
  ) async {
    Map<String, String> headerParams = {};
    headerParams["Content-Type"] = "application/json";
    if (body is String) {
      headerParams["Content-Type"] = "application/x-www-form-urlencoded";
    } else if (body is Map) {
      headerParams['Accept'] = "application/json";
      headerParams["Content-Type"] = "application/json";
    } else if (body is http.MultipartRequest) {
      headerParams['Accept'] = "application/json";
      headerParams["Content-Type"] = "multipart/form-data";
    }

    if (authenticated) {
      String token = await _getToken(); // Fetch token

      if (token.isNotEmpty) {
        // Check if token is expired (you may need to decode the JWT token to check expiry)
        bool isExpired = await _isTokenExpired(token);

        if (isExpired) {
          // Token expired, attempt to refresh it
          String newToken = await _refreshAccessToken();

          if (newToken.isNotEmpty) {
            headerParams['Authorization'] = 'Bearer $newToken';
          } else {
            throw Exception('Token is expired and refresh failed.');
          }
        } else {
          headerParams['Authorization'] = 'Bearer $token';
        }
      } else {
        throw Exception('Token is not available.');
      }
    }

    return headerParams;
  }

  static Future<bool> _isTokenExpired(String token) async {
    try {
      final jwt = JWT.decode(token);
      final expiryTime =
          jwt.payload['exp'] *
          1000; // Expiry time is usually in seconds, so multiply by 1000 for milliseconds
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      return currentTime >
          expiryTime; // Compare current time with token expiry time
    } catch (e) {
      // Handle token decoding errors, like malformed JWT
      return true; // Return true if decoding fails
    }
  }

  static Future<String> _refreshAccessToken() async {
    // Make a request to the refresh API endpoint with the refresh token
    String refreshToken = await _getRefreshToken();

    if (refreshToken.isNotEmpty) {
      final response = await http.post(
        Uri.parse("http://192.168.1.2:3000/api/refresh-token"),
        ////////////////////////////////////////////////////////////////////////////////
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['accessToken']; // Return the new access token
      } else {
        throw Exception('Failed to refresh access token.');
      }
    } else {
      throw Exception('No refresh token available.');
    }
  }

  static Future<http.Response?> _handleResponse(http.Response? response) async {
    if (response == null) {
      return null;
    }
    debugPrint("=== RESPONSE : ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: "Your session has expired");
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      Fluttertoast.showToast(msg: "${jsonDecode(response.body)['message']}");
    } else if (response.statusCode >= 500) {
      Fluttertoast.showToast(msg: "Server Error: ${response.statusCode}");
    }
    return null;
  }

  // Future<dynamic> uploadImage(File file, String endpoint) async {
  //   var request = http.MultipartRequest('POST', Uri.parse(baseUrl + endpoint))
  //     ..files.add(await http.MultipartFile.fromPath('file', file.path));
  //
  //   var response = await _sendAsync(
  //     'POST',
  //     endpoint,
  //     request,
  //     authenticated: true,
  //   );
  //   if (response != null) {
  //     return jsonDecode(response.body)['file'];
  //   }
  //   throw Exception("Image upload failed");
  // }

  Future<dynamic> uploadImage(
      File file,
      String endpoint, {
        required String fileCategory,
        required String gstNumber,
        required String mobileNumber,
      }) async {
    var uri = Uri.parse(baseUrl + endpoint);

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('uploadedFile', file.path))
      ..fields['fileCategory'] = fileCategory
      ..fields['gstNumber'] = gstNumber
      ..fields['mobileNumber'] = mobileNumber;

    var response = await _sendAsync(
      'POST',
      endpoint,
      request,
      authenticated: false,
    );

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Image upload failed");
  }



  // Get Token from Secure Storage
  static Future<String> _getToken() async {
    return await _storage.read(key: 'auth_token') ?? '';
  }

  // Get Token from Secure Storage
  static Future<String> _getRefreshToken() async {
    return await _storage.read(key: 'refresh_token') ?? '';
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return "ApiException: $message (Status Code: $statusCode)";
  }
}
