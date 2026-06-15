import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart'; // Add this for IOHttpClientAdapter
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../config/app_shared_key.dart';

class ApiHandler {
  static Logger logger = Logger();
  
  static Future<bool> hasInternet() async {
    final List<ConnectivityResult> result = await Connectivity().checkConnectivity();

    if (result.contains(ConnectivityResult.none)) {
      return false;
    }
    return result.contains(ConnectivityResult.mobile) || 
           result.contains(ConnectivityResult.wifi) || 
           result.contains(ConnectivityResult.ethernet);
  }

  static Future<Map<String, dynamic>> getHeaders() async {
    String? token = Pref.getToken();
    debugPrint("Token =====> $token");
    if (token != null && token.isNotEmpty) {
      return {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization': "Bearer $token",
      };
    } else {
      return {'Content-type': 'application/json', 'Accept': '*/*'};
    }
  }

  static Dio createRequest() {
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 50),
        sendTimeout: const Duration(seconds: 50),
        receiveTimeout: const Duration(seconds: 50),
        receiveDataWhenStatusError: true,
        validateStatus: (int? statusCode) {
          return statusCode != null && statusCode >= 100 && statusCode <= 599;
        },
      ),
    );

    // Bypassing SSL for UAT/Testing (Common cause for mobile failure)
    // ONLY use this for UAT/Debug environments
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    return dio;
  }

  /// get api
  static Future<Response> getRequest(String url) async {
    logger.i("GET $url");
    try {
      Response response = await createRequest().get(
        url,
        options: Options(headers: await getHeaders(), responseType: ResponseType.plain),
      );
      logger.i("Response [${response.statusCode}] for $url");
      return response;
    } on DioException catch (e) {
      logger.e("Dio Error on GET $url: ${e.message}");
      // Return a dummy response with the error status to avoid crashes
      return e.response ?? Response(requestOptions: RequestOptions(path: url), statusCode: 500, statusMessage: e.message);
    } catch (e) {
      logger.e("Unexpected Error on GET $url: $e");
      rethrow;
    }
  }

  /// post api
  static Future<Response> postRequest({required String url, required Map body}) async {
    logger.i("POST $url");
    logger.i("Body: $body");
    try {
      Response response = await createRequest().post(
        url,
        data: body,
        options: Options(headers: await getHeaders()),
      );
      logger.i("Response [${response.statusCode}] for $url");
      return response;
    } on DioException catch (e) {
      logger.e("Dio Error on POST $url: ${e.message}");
      return e.response ?? Response(requestOptions: RequestOptions(path: url), statusCode: 500, statusMessage: e.message);
    } catch (e) {
      logger.e("Unexpected Error on POST $url: $e");
      rethrow;
    }
  }

  /// post token api
  static Future<Response> postTokenRequest({required String url, required String body}) async {
    logger.i("POST Token $url");
    try {
      Response response = await createRequest().post(
        url,
        data: body,
        options: Options(
            method: 'POST',
            headers: {
              'accept': '*/*',
              'Content-Type': 'application/json',
              'Authorization': "Bearer ${Pref.getToken()}",
            },
            responseType: ResponseType.plain),
      );
      logger.i(response);
      return response;
    } on DioException catch (e) {
      logger.e("Dio Error on Token POST: ${e.message}");
      return e.response ?? Response(requestOptions: RequestOptions(path: url), statusCode: 500);
    }
  }

  /// multi part
  static Future multiPartRequest({required String url, File? image, Map<String, String>? data}) async {
    logger.i("Multipart POST $url");
    var headers = {
      'accept': '*/*',
      'Authorization': "Bearer ${Pref.getToken()}",
    };
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    if (data != null) request.fields.addAll(data);
    
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        "SupportingDocument",
        image.path,
      ));
    }

    try {
      http.StreamedResponse response = await request.send();
      return response;
    } catch (e) {
      logger.e("Multipart Error: $e");
      return null;
    }
  }
}

bool isUnAuthorized(Response response) {
  final int? statusCode = response.statusCode;
  if (statusCode == 401) return true;
  return false;
}
