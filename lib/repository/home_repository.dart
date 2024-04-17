import 'package:practical_tast_1/config/api_endpoints.dart';
import 'package:practical_tast_1/core/data_source_result/data_source_error.dart';
import 'package:practical_tast_1/core/data_source_result/data_source_result.dart';
import 'package:practical_tast_1/core/utils/helpers/api_handler.dart';
import 'package:practical_tast_1/model/sub_category_model.dart';

class HomeRepository {
  Future<DataSourceResult<List<Category>>> getCategoryList(
      {required String deviceManufacturer,
      required String deviceModel,
      required String deviceToken,
      required int pageIndex}) async {
    DataSourceResult<List<Category>> dataSourceResult =
        DataFailed(DataSourceError());
    await ApiHandler.sendRequest(
        endPoint: ApiEndpoints.dashboard,
        type: RequestType.post,
        useFormData: false,
        body: {
          "CategoryId": 0,
          "DeviceManufacturer": deviceToken,
          "DeviceModel": deviceModel,
          "DeviceToken": deviceToken,
          "PageIndex": pageIndex
        },
        onSuccess: (response) {
          if (response.statusCode == 200 && response.data['Status'] == 200) {
            final List<Category> categoryList = response.data['Result']
                    ['Category']
                .map<Category>((category) => Category.fromJson(category))
                .toList();
            dataSourceResult = DataSuccess(categoryList);
          }
        },
        onError: (error) {
          dataSourceResult = DataFailed(DataSourceError());
        });

    return dataSourceResult;
  }

  Future<DataSourceResult<SubCategoryModel>> getSubCategoryList(
      {required int categoryId, required int pageIndex}) async {
    DataSourceResult<SubCategoryModel> dataSourceResult =
        DataFailed(DataSourceError());
    await ApiHandler.sendRequest(
        endPoint: ApiEndpoints.dashboard,
        type: RequestType.post,
        useFormData: false,
        body: {"CategoryId": categoryId, "PageIndex": pageIndex},
        onSuccess: (response) {
          if (response.statusCode == 200 && response.data['Status'] == 200) {
            SubCategoryModel subCategoryModel =
                SubCategoryModel.fromJson(response.data);
            dataSourceResult = DataSuccess(subCategoryModel);
          }
        },
        onError: (error) {
          dataSourceResult = DataFailed(DataSourceError());
        });

    return dataSourceResult;
  }

  Future<DataSourceResult<SubCategoryModel>> getProductList(
      {required int subcategoryId, required int pageIndex}) async {
    DataSourceResult<SubCategoryModel> dataSourceResult =
        DataFailed(DataSourceError());
    await ApiHandler.sendRequest(
        endPoint: ApiEndpoints.dashboard,
        type: RequestType.post,
        useFormData: false,
        body: {"SubCategoryId": subcategoryId, "PageIndex": pageIndex},
        onSuccess: (response) {
          if (response.statusCode == 200 && response.data['Status'] == 200) {
            SubCategoryModel subCategoryModel =
                SubCategoryModel.fromJson(response.data);
            dataSourceResult = DataSuccess(subCategoryModel);
          }
        },
        onError: (error) {
          dataSourceResult = DataFailed(DataSourceError());
        });

    return dataSourceResult;
  }
}
