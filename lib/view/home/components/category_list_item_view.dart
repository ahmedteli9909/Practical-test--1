import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_tast_1/model/sub_category_model.dart';
import 'package:practical_tast_1/view/home/components/product_item_view.dart';

import '../../../core/values/app_colors.dart';
import '../../../view_model/home_view_model.dart';

class CategoryListItemView extends StatefulWidget {
  const CategoryListItemView(
      {super.key, required this.subCategoryModel, required this.index});

  final SubCategories subCategoryModel;
  final int index;

  @override
  State<CategoryListItemView> createState() => _CategoryListItemViewState();
}

class _CategoryListItemViewState extends State<CategoryListItemView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      // if (_scrollController.position.pixels ==
      //     _scrollController.position.maxScrollExtent) {
      //   context.read<HomeViewModel>().loadMoreProducts(widget.index);
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeViewModelState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.only(left: 12),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: Text(
                    widget.subCategoryModel.name!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                  )),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.productListViewLoaders[widget.index]
                        ? widget.subCategoryModel.product!.length + 1
                        : widget.subCategoryModel.product!.length,
                    itemBuilder: (context, index) {
                      if (index ==
                          state.subCategoryData!.result!.category![0]
                              .subCategories!.length) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }
                      return ProductItemView(
                        productModel: widget.subCategoryModel.product![index],
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }
}
