import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/navigation_cubit.dart';
import '../widgets/bottom_navigation.dart';
import 'home_screen.dart';
import 'meals_screen.dart';
import 'guide_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return IndexedStack(
            index: currentIndex,
            children: const [
              HomeScreen(),
              MealsScreen(),
              GuideScreen(),
              ProfileScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
