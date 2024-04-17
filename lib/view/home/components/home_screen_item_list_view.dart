import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_tast_1/core/values/app_colors.dart';
import 'package:practical_tast_1/core/values/app_strings.dart';
import 'package:practical_tast_1/view/home/components/category_list_item_view.dart';
import 'package:practical_tast_1/view_model/home_view_model.dart';

class HomeScreenItemListView extends StatefulWidget {
  const HomeScreenItemListView({super.key});

  @override
  State<HomeScreenItemListView> createState() => _HomeScreenItemListViewState();
}

class _HomeScreenItemListViewState extends State<HomeScreenItemListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<HomeViewModel>().loadMoreSubCategoryData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          )),
      padding: const EdgeInsets.only(
        left: 12,
        top: 12,
      ),
      margin: const EdgeInsets.only(top: 5),
      child: BlocBuilder<HomeViewModel, HomeViewModelState>(
        builder: (context, state) {
          if (state.isProductListLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }
          if (state.isErrorFoundInProductListing) {
            return const Center(
              child: Text(
                AppStrings.defaultErrorMessage,
              ),
            );
          }

          return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              controller: _scrollController,
              itemCount: state.isSubCategoryEndLoading
                  ? (state.subCategoryData?.result!.category![0].subCategories!
                              .length ??
                          0) +
                      1
                  : state.subCategoryData?.result!.category![0].subCategories!
                          .length ??
                      0,
              itemBuilder: (context, index) {
                if (index ==
                    state.subCategoryData!.result!.category![0].subCategories!
                        .length) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }
                return CategoryListItemView(
                  index: index,
                    subCategoryModel: state.subCategoryData!.result!
                        .category![0].subCategories![index]);
              });
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }
}
