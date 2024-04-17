
import 'data_source_error.dart';

abstract class DataSourceResult<T> {
  final T ? data;
  final DataSourceError? error;

  const DataSourceResult({this.data, this.error});
}

class DataSuccess<T> extends DataSourceResult<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataSourceResult<T> {
  const DataFailed(DataSourceError error) : super(error: error);
}