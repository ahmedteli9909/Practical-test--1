import 'package:practical_tast_1/core/values/app_strings.dart';
import 'package:practical_tast_1/core/values/constants.dart';

class DataSourceError{
  late final String message;
  late int statusCode;
  late Map<String,dynamic> extraInfo;

  DataSourceError({String? message, int? statusCode, Map<String,dynamic>? extraInfo}){
    this.message = message ?? AppStrings.defaultErrorMessage;
    this.statusCode = statusCode ?? defaultStatusCode;
    this.extraInfo = extraInfo ?? {};
  }

}
