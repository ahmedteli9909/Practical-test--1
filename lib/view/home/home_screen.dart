import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_tast_1/core/values/app_colors.dart';
import 'package:practical_tast_1/view/home/components/custom_app_bar.dart';
import 'package:practical_tast_1/view/home/components/home_screen_item_list_view.dart';
import 'package:practical_tast_1/view_model/home_view_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String route = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    context.read<HomeViewModel>().fetchCategoryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          children: [
            CustomAppBar(),
            Expanded(child: HomeScreenItemListView())
          ],
        ),
      ),
    );
  }
}
