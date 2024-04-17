import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


void kDebugPrint(data) {
  if (kDebugMode) {
    print(data);
  }
}

void networkSuccessLog(Response? response, String requestedUrl) {
  if (kDebugMode) {
    print(
        '========= $requestedUrl || statusCode : ${response?.statusCode} <SUCCESS> =========');
    print('${response?.data}');
    print(
        '======================================================================');
  }
}

void networkErrorLog(Response response, String requestedUrl) {
  if (kDebugMode) {
    print(
        '========= $requestedUrl || statusCode : ${response.statusCode} <ERROR> =========');
    print('$response');
    print(
        '======================================================================');
  }
}

void networkClientSideError(Response response, String requestedUrl, error) {
  if (kDebugMode) {
    print(
        '========= $requestedUrl ClientSideError || statusCode : ${response.statusCode} <ERROR> =========');
    print('$error');
    print(
        '======================================================================');
  }
}
