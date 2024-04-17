import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:practical_tast_1/core/data_source_result/data_source_result.dart';
import 'package:practical_tast_1/core/utils/helpers/helper_functions.dart';
import 'package:practical_tast_1/model/sub_category_model.dart';
import 'package:practical_tast_1/repository/home_repository.dart';

import 'package:device_info_plus/device_info_plus.dart';

part 'home_view_model_state.dart';

part 'home_view_model.freezed.dart';

class HomeViewModel extends Cubit<HomeViewModelState> {
  HomeViewModel({required this.homeRepository})
      : super(HomeViewModelState.initial(
            categoryList: [],
            productListViewDataPageIndexes: [],
            subCategoryPageIndex: 1,
            isSubCategoryDataMaxExtends: false,
            isCategoryListLoading: false,
            isErrorFoundInCategory: false,
            selectedCategory: null,
            isProductListLoading: false,
            subCategoryData: null,
            isSubCategoryEndLoading: false,
            productListViewDataMaxExtends: [],
            productListViewLoaders: [],
            isErrorFoundInProductListing: false));

  Future<AndroidDeviceInfo> _getAndroidDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return await deviceInfo.androidInfo;
  }

  Future<IosDeviceInfo> _getIosDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return await deviceInfo.iosInfo;
  }

  final HomeRepository homeRepository;

  void fetchCategoryData() async {
    emit(state.copyWith(
        isErrorFoundInCategory: false, isCategoryListLoading: true));
    String deviceManufacturer = '';
    String deviceModel = '';
    String deviceToken = '';
    if (Platform.isAndroid) {
      final deviceData = await _getAndroidDeviceInfo();
      deviceManufacturer = deviceData.manufacturer;
      deviceModel = deviceData.model;
      deviceToken = deviceData.id;
    } else if (Platform.isIOS) {
      final deviceData = await _getIosDeviceInfo();
      deviceManufacturer = deviceData.name;
      deviceModel = deviceData.model;
      deviceToken = deviceData.identifierForVendor ?? '';
    }
    final result = await homeRepository.getCategoryList(
        deviceManufacturer: deviceManufacturer,
        deviceModel: deviceModel,
        deviceToken: deviceToken,
        pageIndex: 1);
    if (result is DataSuccess) {
      emit(state.copyWith(
          categoryList: result.data ?? [],
          isErrorFoundInCategory: false,
          isCategoryListLoading: false,
          selectedCategory:
              state.categoryList.isNotEmpty ? state.categoryList[0] : null));
    } else {
      emit(state.copyWith(
          isCategoryListLoading: false, isErrorFoundInCategory: true));
    }

    if (state.categoryList.isNotEmpty) {
      categoryOnTap(state.categoryList.first);
    }
  }

  void categoryOnTap(Category categoryModel) {
    if (categoryModel != state.selectedCategory) {
      emit(state.copyWith(
          productListViewLoaders: [],
          productListViewDataMaxExtends: [],
          productListViewDataPageIndexes: [],
          selectedCategory: categoryModel,
          subCategoryPageIndex: 1,
          isSubCategoryEndLoading: false,
          isSubCategoryDataMaxExtends: false));
      _getListingData();
    }
  }

  void _getListingData() async {
    emit(state.copyWith(
        isErrorFoundInProductListing: false, isProductListLoading: true));
    final result = await homeRepository.getSubCategoryList(
        categoryId: state.selectedCategory!.id!,
        pageIndex: state.subCategoryPageIndex);
    if (result is DataSuccess) {
      emit(state.copyWith(
          subCategoryData: result.data,
          isErrorFoundInProductListing: false,
          isProductListLoading: false,
          isCategoryListLoading: false));
      state.productListViewLoaders.addAll(List.generate(
          state.subCategoryData!.result!.category![0].subCategories!.length,
          (index) => false));
      state.productListViewDataMaxExtends.addAll(List.generate(
          state.subCategoryData!.result!.category![0].subCategories!.length,
          (index) => false));
      state.productListViewDataPageIndexes.addAll(List.generate(
          state.subCategoryData!.result!.category![0].subCategories!.length,
          (index) => 1));
    } else {
      emit(state.copyWith(
          isErrorFoundInProductListing: true, isProductListLoading: false));
    }
  }

  void loadMoreSubCategoryData() async {
    if (state.isSubCategoryEndLoading == false &&
        state.isSubCategoryDataMaxExtends == false) {
      emit(state.copyWith(isSubCategoryEndLoading: true));
      final result = await homeRepository.getSubCategoryList(
          categoryId: state.selectedCategory!.id!,
          pageIndex: state.subCategoryPageIndex + 1);
      if (result is DataSuccess) {
        if (result.data!.result!.category![0].subCategories == null) {
          emit(state.copyWith(
              isSubCategoryDataMaxExtends: true,
              isSubCategoryEndLoading: false,
              subCategoryPageIndex: state.subCategoryPageIndex + 1));
          return;
        }
        state.productListViewLoaders.addAll(List.generate(
            state.subCategoryData!.result!.category![0].subCategories!.length,
            (index) => false));
        state.productListViewDataMaxExtends.addAll(List.generate(
            state.subCategoryData!.result!.category![0].subCategories!.length,
            (index) => false));
        state.productListViewDataPageIndexes.addAll(List.generate(
            state.subCategoryData!.result!.category![0].subCategories!.length,
            (index) => 1));
        state.subCategoryData!.result!.category![0].subCategories!
            .addAll(result.data!.result!.category![0].subCategories!.toList());
        emit(state.copyWith(
            subCategoryData: state.subCategoryData,
            isSubCategoryEndLoading: false,
            subCategoryPageIndex: state.subCategoryPageIndex + 1));
      } else {
        emit(state.copyWith(isSubCategoryEndLoading: false));
      }
    }
  }

  void loadMoreProducts(index) async {
    if (state.productListViewLoaders[index] == false &&
        state.productListViewDataMaxExtends[index] == false) {
      state.productListViewLoaders[index] = true;
      emit(state.copyWith(
          productListViewLoaders: List.of(state.productListViewLoaders)));
      kDebugPrint(state
          .subCategoryData!.result!.category![0].subCategories![index].id!);

      final result = await homeRepository.getProductList(
          subcategoryId: state
              .subCategoryData!.result!.category![0].subCategories![index].id!,
          pageIndex: state.productListViewDataPageIndexes[index] + 1);
      if (result is DataSuccess) {
        if (result.data!.result!.category![0].subCategories == null) {
          state.productListViewDataPageIndexes[index] + 1;
          state.productListViewLoaders[index] = false;
          state.productListViewDataMaxExtends[index] = true;
          state.productListViewDataMaxExtends[index] = true;
          emit(state.copyWith(
              productListViewDataMaxExtends:
                  List.of(state.productListViewDataMaxExtends),
              productListViewLoaders: List.of(state.productListViewLoaders),
              productListViewDataPageIndexes:
                  List.of(state.productListViewDataPageIndexes)));
          return;
        }
        state.subCategoryData!.result!.category![0].subCategories![index]
            .product!
            .addAll(result.data!.result!.category![0].subCategories!
                .firstWhere((element) =>
                    element.id ==
                    state.subCategoryData!.result!.category![0]
                        .subCategories![index].id)
                .product!
                .toList());
        state.productListViewDataPageIndexes[index] + 1;
        state.productListViewLoaders[index] = false;
        emit(state.copyWith(
            subCategoryData: state.subCategoryData,
            productListViewLoaders: List.of(state.productListViewLoaders),
            productListViewDataPageIndexes:
                List.of(state.productListViewDataPageIndexes)));
      } else {
        emit(state.copyWith(isSubCategoryEndLoading: false));
      }
    }
  }
}
