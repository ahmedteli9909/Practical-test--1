import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_tast_1/core/values/app_colors.dart';
import 'package:practical_tast_1/view_model/home_view_model.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(),
              IconButton(icon:const Icon(Icons.filter_alt_outlined,color: AppColors.secondary,),onPressed: (){},),
              IconButton(icon:const Icon(Icons.search,color: AppColors.secondary,),onPressed: (){},)
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BlocBuilder<HomeViewModel, HomeViewModelState>(
              builder: (context, state) {
                if (state.isCategoryListLoading) {
                  return Row(
                    children: List.generate(
                        10,
                        (index) =>  Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Container(
                                width: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Transform.scale(
                                  scale: 1,
                                  child: const Text(
                                    ' ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                        )),
                  );
                }
                return Row(
                  children: List.generate(
                      state.categoryList.length,
                      (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<HomeViewModel>()
                                  .categoryOnTap(state.categoryList[index]);
                            },
                            child: Container(
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: state.isCategoryListLoading
                                      ? Colors.white24
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Transform.scale(
                                scale: state.selectedCategory ==
                                        state.categoryList[index]
                                    ? 1.2
                                    : 1,
                                child: Text(
                                  state.isCategoryListLoading
                                      ? ''
                                      : '${state.categoryList[index].name}',
                                  style: TextStyle(
                                      color: state.selectedCategory ==
                                              state.categoryList[index]
                                          ? Colors.white
                                          : Colors.white54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ))),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
