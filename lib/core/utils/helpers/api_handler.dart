import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:practical_tast_1/config/api_endpoints.dart';

import 'helper_functions.dart';

enum RequestType {
  post,
  get,
  put,
  patch,
  delete,
}

class ApiHandler {
  ApiHandler({required this.baseUrl});

  static final Dio dio = Dio();

  final String? baseUrl;
  static Future<void> sendRequest({
    String baseUrl = ApiEndpoints.baseUrl,
    required String endPoint,
    required RequestType type,
    Map<String, dynamic>? params,
    FormData? formData,
    bool useFormData = true,
    Map<String, dynamic>? body,
    required void Function(Response response) onSuccess,
    required void Function(Response response) onError,
  }) async {
    kDebugPrint('<<<<<<<<<<<<<< Request url : - $baseUrl$endPoint${params ?? ''} headers => ${dio.options.headers}');
    Response response = Response(requestOptions: RequestOptions());
    try {
      switch (type) {
        case RequestType.get:
          response =
              await dio.get('$baseUrl$endPoint', queryParameters: params,);
        case RequestType.post:
          response = await dio.post('$baseUrl$endPoint',
              queryParameters: params, data: useFormData ? formData : body);
        case RequestType.delete:
          response =
              await dio.delete('$baseUrl$endPoint', queryParameters: params);
        case RequestType.put:
          response = await dio.put('$baseUrl$endPoint',
              queryParameters: params, data: useFormData ? formData : body);
        default:
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        networkSuccessLog(response, response.realUri.path);
        onSuccess(response);
      } else {
        networkErrorLog(response, response.realUri.path);
        onError(response);
      }
    } on DioException catch (e) {
      kDebugPrint('<<<<<<<<<<<<<< Request url : - $baseUrl$endPoint${params ?? ''} error => ${e.response?.statusCode}');
      networkErrorLog(response, response.realUri.path);
      if(e.response != null) {
        response = e.response!;
      }
      onError(response);
    } on IOException catch (e) {
      networkClientSideError(response, response.realUri.path, e);
      onError(Response(
          requestOptions: RequestOptions(),
          statusCode: 408,
          statusMessage: 'Connection time out'));
    } catch (e) {
      networkClientSideError(response, response.realUri.path, e);
      kDebugPrint('error found');
    }
  }
}
