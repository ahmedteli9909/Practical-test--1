import 'package:flutter/material.dart';
import 'package:practical_tast_1/config/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_tast_1/repository/home_repository.dart';
import 'package:practical_tast_1/view_model/home_view_model.dart';


void main(){
  runApp(const PracticalTask1());
}

class PracticalTask1 extends StatelessWidget {
  const PracticalTask1({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) =>HomeViewModel(homeRepository: HomeRepository()) )
      ],
      child: const MaterialApp(
        initialRoute: AppRoutes.initialRoute,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.onGeneratedRoutes,
      ),
    );
  }
}
