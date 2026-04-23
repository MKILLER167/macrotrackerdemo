import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/user_model.dart';
import '../utils/nutrition_calculator.dart';
import 'login_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({Key? key}) : super(key: key);

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form State
  String _name = '';
  Gender _gender = Gender.male;
  int _age = 25;
  double _height = 170; // cm
  double _weight = 70; // kg
  GoalType _goal = GoalType.maintain;
  double _targetWeight = 70;
  ActivityLevel _activityLevel = ActivityLevel.moderatelyActive;

  bool _isProcessing = false;

  void _nextPage() {
    if (_currentPage == 4) {
      _processProfile();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _processProfile() async {
    setState(() => _isProcessing = true);
    // Simulate complex API/AI calculation time
    await Future.delayed(const Duration(seconds: 3));

    // Calculate BMR and Target Calories
    final bmr =
        NutritionCalculator.calculateBMR(_gender, _weight, _height, _age);
    final tdee = NutritionCalculator.calculateTDEE(bmr, _activityLevel);
    final targetCals = NutritionCalculator.calculateTargetCalories(tdee, _goal);

    final generatedProfile = UserProfile(
      name: _name.isEmpty ? 'Tracker' : _name,
      age: _age,
      gender: _gender,
      height: _height,
      weight: _weight,
      goal: _goal,
      targetWeight: _goal == GoalType.maintain ? _weight : _targetWeight,
      activityLevel: _activityLevel,
      dietPlan: DietPlanType.standard, // Default, can be changed later
      targetCalories: targetCals,
      targetWaterMl:
          2500 + (_weight * 30).round(), // Rough estimate: 30ml per kg + base
    );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) =>
            LoginScreen(generatedProfile: generatedProfile),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: SafeArea(
        child: _isProcessing ? _buildProcessingScreen() : _buildQuestionnaire(),
      ),
    );
  }

  Widget _buildProcessingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF34D399)),
          const SizedBox(height: 24),
          Text(
            'Analyzing your profile...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crafting your custom nutrition journey',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionnaire() {
    return Column(
      children: [
        _buildProgressBar(),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics:
                const NeverScrollableScrollPhysics(), // Prevent manual swipe
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              _buildNameAndGenderStep(),
              _buildStatsStep(),
              _buildGoalStep(),
              _buildActivityStep(),
              _buildSummaryStep(),
            ],
          ),
        ),
        _buildBottomNav(),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: Colors.white70, size: 20),
            onPressed: () {
              if (_currentPage > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          Text(
            'Step ${_currentPage + 1} of 5',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 40), // Balance the row
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _nextPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF34D399),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            _currentPage == 4 ? 'Calculate Plan' : 'Continue',
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // --- STEPS ---

  Widget _buildNameAndGenderStep() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Let\'s build your profile',
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            'What should we call you?',
            style: TextStyle(
                fontSize: 16, color: Colors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 24),
          TextField(
            style: const TextStyle(color: Colors.white, fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Your name',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) => setState(() => _name = val),
          ),
          const SizedBox(height: 48),
          const Text(
            'Biological Gender',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSelectionCard(
                title: 'Male',
                icon: Icons.male,
                isSelected: _gender == Gender.male,
                onTap: () => setState(() => _gender = Gender.male),
              ),
              const SizedBox(width: 16),
              _buildSelectionCard(
                title: 'Female',
                icon: Icons.female,
                isSelected: _gender == Gender.female,
                onTap: () => setState(() => _gender = Gender.female),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsStep() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your body metrics',
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'This helps us accurately calculate your BMR',
            style: TextStyle(
                fontSize: 16, color: Colors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 40),
          _buildSliderOption('Age', '$_age', 'years', 14, 100, _age.toDouble(),
              (val) => setState(() => _age = val.toInt())),
          const SizedBox(height: 32),
          _buildSliderOption('Height', '${_height.round()}', 'cm', 100, 250,
              _height, (val) => setState(() => _height = val)),
          const SizedBox(height: 32),
          _buildSliderOption('Weight', '${_weight.round()}', 'kg', 30, 200,
              _weight, (val) => setState(() => _weight = val)),
        ],
      ),
    );
  }

  Widget _buildGoalStep() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'What is your goal?',
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 32),
          _buildGoalCard(
              'Lose Weight', GoalType.loseWeight, Icons.trending_down),
          const SizedBox(height: 12),
          _buildGoalCard(
              'Maintain Weight', GoalType.maintain, Icons.compare_arrows),
          const SizedBox(height: 12),
          _buildGoalCard(
              'Gain Muscle', GoalType.gainMuscle, Icons.fitness_center),
          if (_goal != GoalType.maintain) ...[
            const SizedBox(height: 40),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _goal != GoalType.maintain ? 1.0 : 0.0,
              child: _buildSliderOption(
                  'Target Weight',
                  '${_targetWeight.round()}',
                  'kg',
                  30,
                  200,
                  _targetWeight,
                  (val) => setState(() => _targetWeight = val)),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildGoalCard(String title, GoalType goalType, IconData icon) {
    final isSelected = _goal == goalType;
    return InkWell(
      onTap: () => setState(() {
        _goal = goalType;
        if (goalType == GoalType.loseWeight && _targetWeight >= _weight) {
          _targetWeight = _weight - 5;
        } else if (goalType == GoalType.gainMuscle &&
            _targetWeight <= _weight) {
          _targetWeight = _weight + 5;
        }
      }),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF34D399).withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF34D399) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFF34D399) : Colors.white70),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityStep() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Activity Level',
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'How active are you in daily life?',
            style: TextStyle(
                fontSize: 16, color: Colors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildActivityCard(ActivityLevel.sedentary, 'Sedentary',
                    'Little or no exercise, desk job'),
                _buildActivityCard(ActivityLevel.lightlyActive,
                    'Lightly Active', 'Light exercise 1-3 days/week'),
                _buildActivityCard(ActivityLevel.moderatelyActive,
                    'Moderately Active', 'Moderate exercise 3-5 days/week'),
                _buildActivityCard(ActivityLevel.veryActive, 'Very Active',
                    'Heavy exercise 6-7 days/week'),
                _buildActivityCard(ActivityLevel.extraActive, 'Extra Active',
                    'Very heavy exercise, physical job'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
      ActivityLevel level, String title, String subtitle) {
    final isSelected = _activityLevel == level;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _activityLevel = level),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF34D399).withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF34D399) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? const Color(0xFF34D399) : Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryStep() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF34D399).withValues(alpha: 0.2),
            ),
            child: const Icon(Icons.check_circle_outline,
                size: 80, color: Color(0xFF34D399)),
          ),
          const SizedBox(height: 32),
          const Text(
            'Ready to Calculate!',
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'We have everything we need to build your hyper-personalized nutrition plan based on science.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.5),
          ),
        ],
      ),
    );
  }

  // --- UTILS ---
  Widget _buildSliderOption(String title, String value, String unit, double min,
      double max, double current, Function(double) onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            Text('$value $unit',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF34D399))),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFF34D399),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
            thumbColor: const Color(0xFF34D399),
            trackHeight: 8,
          ),
          child: Slider(
            value: current,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionCard(
      {required String title,
      required IconData icon,
      required bool isSelected,
      required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF34D399)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 40, color: isSelected ? Colors.white : Colors.white54),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
