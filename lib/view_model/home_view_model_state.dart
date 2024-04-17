part of 'home_view_model.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class HomeViewModelState with _$HomeViewModelState {
   factory HomeViewModelState.initial({
    required List<Category> categoryList,
    required bool isCategoryListLoading,
    required bool isProductListLoading,
    required bool isErrorFoundInProductListing,
    required bool isErrorFoundInCategory,
    required Category? selectedCategory,
    required bool isSubCategoryEndLoading,
    required int subCategoryPageIndex,
    required SubCategoryModel? subCategoryData,
    required bool isSubCategoryDataMaxExtends,
    required List<bool> productListViewLoaders,
    required List<bool> productListViewDataMaxExtends,
    required List<int> productListViewDataPageIndexes,

  }) = _Initial;
}
