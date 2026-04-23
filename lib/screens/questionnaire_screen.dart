import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/nutrition_calculator.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // User inputs
  String _name = '';
  Gender _gender = Gender.male;
  int _age = 25;
  double _height = 170;
  double _weight = 70;
  GoalType _goal = GoalType.maintain;
  double _targetWeight = 70;
  ActivityLevel _activityLevel = ActivityLevel.moderatelyActive;
  bool _isProcessing = false;

  static const int _totalPages = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage == _totalPages - 1) {
      _calculate();
    } else {
      _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    }
  }

  void _prev() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _calculate() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500));

    final bmr = NutritionCalculator.calculateBMR(_gender, _weight, _height, _age);
    final tdee = NutritionCalculator.calculateTDEE(bmr, _activityLevel);
    final targetCals = NutritionCalculator.calculateTargetCalories(tdee, _goal);

    final profile = UserProfile(
      name: _name.isEmpty ? 'User' : _name,
      age: _age,
      gender: _gender,
      height: _height,
      weight: _weight,
      goal: _goal,
      targetWeight: _goal == GoalType.maintain ? _weight : _targetWeight,
      activityLevel: _activityLevel,
      dietPlan: DietPlanType.standard,
      targetCalories: targetCals,
      targetWaterMl: (30 * _weight).round().clamp(2000, 5000),
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => LoginScreen(generatedProfile: profile),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isProcessing) return _buildProcessing();
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _NameGenderStep(name: _name, gender: _gender, onNameChanged: (v) => setState(() => _name = v), onGenderChanged: (g) => setState(() => _gender = g)),
                  _StatsStep(age: _age, height: _height, weight: _weight, onAgeChanged: (v) => setState(() => _age = v), onHeightChanged: (v) => setState(() => _height = v), onWeightChanged: (v) => setState(() => _weight = v)),
                  _GoalStep(goal: _goal, targetWeight: _targetWeight, currentWeight: _weight, onGoalChanged: (g) => setState(() => _goal = g), onTargetWeightChanged: (v) => setState(() => _targetWeight = v)),
                  _ActivityStep(activityLevel: _activityLevel, onActivityChanged: (a) => setState(() => _activityLevel = a)),
                  _ConfirmStep(name: _name, goal: _goal, activityLevel: _activityLevel),
                ],
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessing() {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.science_rounded, color: AppTheme.white, size: 38),
            ),
            const SizedBox(height: 28),
            const Text('Calculating Your Plan', style: TextStyle(color: AppTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            const Text('Using Mifflin-St Jeor formula...', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            const SizedBox(height: 36),
            const SizedBox(
              width: 160,
              child: LinearProgressIndicator(
                backgroundColor: AppTheme.borderDark,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.emerald),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: _prev,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderDark)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textSecondary),
            ),
          ),
          const Spacer(),
          Text('${_currentPage + 1} of $_totalPages', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: (_currentPage + 1) / _totalPages,
          minHeight: 6,
          backgroundColor: AppTheme.borderDark,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.emerald),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _next,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.emerald,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            _currentPage == _totalPages - 1 ? 'Calculate My Plan 🚀' : 'Continue',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

// ─── STEP WIDGETS ─────────────────────────────────────────────────────────────

class _NameGenderStep extends StatelessWidget {
  final String name;
  final Gender gender;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<Gender> onGenderChanged;
  const _NameGenderStep({required this.name, required this.gender, required this.onNameChanged, required this.onGenderChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome! 👋', style: TextStyle(color: AppTheme.emerald, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text("Let's build your\npersonalized plan", style: TextStyle(color: AppTheme.textPrimary, fontSize: 30, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 32),
          const Text('What should we call you?', style: TextStyle(color: AppTheme.textSecondary, fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          TextField(
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(hintText: 'Your name', prefixIcon: Icon(Icons.person_outline_rounded)),
            onChanged: onNameChanged,
          ),
          const SizedBox(height: 32),
          const Text('Biological Sex', style: TextStyle(color: AppTheme.textSecondary, fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _GenderCard(icon: Icons.male_rounded, label: 'Male', selected: gender == Gender.male, onTap: () => onGenderChanged(Gender.male))),
              const SizedBox(width: 12),
              Expanded(child: _GenderCard(icon: Icons.female_rounded, label: 'Female', selected: gender == Gender.female, onTap: () => onGenderChanged(Gender.female))),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _GenderCard({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: selected ? AppTheme.emerald.withValues(alpha: 0.12) : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppTheme.emerald : AppTheme.borderDark, width: selected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: selected ? AppTheme.emerald : AppTheme.textSecondary),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(color: selected ? AppTheme.emerald : AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _StatsStep extends StatelessWidget {
  final int age;
  final double height;
  final double weight;
  final ValueChanged<int> onAgeChanged;
  final ValueChanged<double> onHeightChanged;
  final ValueChanged<double> onWeightChanged;
  const _StatsStep({required this.age, required this.height, required this.weight, required this.onAgeChanged, required this.onHeightChanged, required this.onWeightChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Body Metrics', style: TextStyle(color: AppTheme.emerald, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('Tell us about\nyour body', style: TextStyle(color: AppTheme.textPrimary, fontSize: 30, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 32),
          _SliderRow(label: 'Age', value: '$age', unit: 'years', min: 14, max: 85, current: age.toDouble(), onChanged: (v) => onAgeChanged(v.toInt())),
          const SizedBox(height: 28),
          _SliderRow(label: 'Height', value: '${height.round()}', unit: 'cm', min: 120, max: 230, current: height, onChanged: onHeightChanged),
          const SizedBox(height: 28),
          _SliderRow(label: 'Weight', value: '${weight.round()}', unit: 'kg', min: 30, max: 200, current: weight, onChanged: onWeightChanged),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final double min;
  final double max;
  final double current;
  final ValueChanged<double> onChanged;
  const _SliderRow({required this.label, required this.value, required this.unit, required this.min, required this.max, required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 15, fontWeight: FontWeight.w600)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: const TextStyle(color: AppTheme.emerald, fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(width: 4),
                Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(unit, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Slider(value: current, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}

class _GoalStep extends StatelessWidget {
  final GoalType goal;
  final double targetWeight;
  final double currentWeight;
  final ValueChanged<GoalType> onGoalChanged;
  final ValueChanged<double> onTargetWeightChanged;
  const _GoalStep({required this.goal, required this.targetWeight, required this.currentWeight, required this.onGoalChanged, required this.onTargetWeightChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Goal', style: TextStyle(color: AppTheme.emerald, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('What do you want\nto achieve?', style: TextStyle(color: AppTheme.textPrimary, fontSize: 30, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 28),
          _GoalCard(goalType: GoalType.loseWeight, icon: Icons.trending_down_rounded, label: 'Lose Weight', subtitle: '-500 kcal daily deficit', color: AppTheme.white, selected: goal == GoalType.loseWeight, onTap: () { onGoalChanged(GoalType.loseWeight); if (targetWeight >= currentWeight) onTargetWeightChanged((currentWeight - 5).clamp(30, 200)); }),
          const SizedBox(height: 10),
          _GoalCard(goalType: GoalType.maintain, icon: Icons.compare_arrows_rounded, label: 'Maintain Weight', subtitle: 'Keep current weight', color: const Color(0xFFCCCCCC), selected: goal == GoalType.maintain, onTap: () => onGoalChanged(GoalType.maintain)),
          const SizedBox(height: 10),
          _GoalCard(goalType: GoalType.gainMuscle, icon: Icons.trending_up_rounded, label: 'Gain Muscle', subtitle: '+300 kcal surplus', color: const Color(0xFF999999), selected: goal == GoalType.gainMuscle, onTap: () { onGoalChanged(GoalType.gainMuscle); if (targetWeight <= currentWeight) onTargetWeightChanged((currentWeight + 5).clamp(30, 200)); }),
          if (goal != GoalType.maintain) ...[
            const SizedBox(height: 28),
            _SliderRow(label: 'Target Weight', value: '${targetWeight.round()}', unit: 'kg', min: 30, max: 200, current: targetWeight, onChanged: onTargetWeightChanged),
          ],
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final GoalType goalType;
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _GoalCard({required this.goalType, required this.icon, required this.label, required this.subtitle, required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? color : AppTheme.borderDark, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: selected ? color : AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 22, height: 22,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActivityStep extends StatelessWidget {
  final ActivityLevel activityLevel;
  final ValueChanged<ActivityLevel> onActivityChanged;
  const _ActivityStep({required this.activityLevel, required this.onActivityChanged});

  @override
  Widget build(BuildContext context) {
    final levels = [
      _ActivityOption(ActivityLevel.sedentary, Icons.chair_rounded, 'Sedentary', 'Desk job, little to no exercise'),
      _ActivityOption(ActivityLevel.lightlyActive, Icons.directions_walk_rounded, 'Lightly Active', 'Light exercise 1–3 days/week'),
      _ActivityOption(ActivityLevel.moderatelyActive, Icons.directions_bike_rounded, 'Moderately Active', 'Moderate exercise 3–5 days/week'),
      _ActivityOption(ActivityLevel.veryActive, Icons.directions_run_rounded, 'Very Active', 'Hard exercise 6–7 days/week'),
      _ActivityOption(ActivityLevel.extraActive, Icons.fitness_center_rounded, 'Extra Active', 'Physical job + hard training'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 32, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Activity Level', style: TextStyle(color: AppTheme.emerald, fontSize: 15, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text('How active are\nyou daily?', style: TextStyle(color: AppTheme.textPrimary, fontSize: 30, fontWeight: FontWeight.w800, height: 1.2)),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            itemCount: levels.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final level = levels[i];
              final isSelected = activityLevel == level.level;
              return GestureDetector(
                onTap: () => onActivityChanged(level.level),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.white.withValues(alpha: 0.08) : AppTheme.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSelected ? AppTheme.white : AppTheme.border, width: isSelected ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Icon(level.icon, color: isSelected ? AppTheme.white : AppTheme.muted, size: 24),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(level.label, style: TextStyle(color: isSelected ? AppTheme.white : AppTheme.white, fontWeight: FontWeight.w700, fontSize: 15)),
                            Text(level.subtitle, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (isSelected) const Icon(Icons.check_circle_rounded, color: AppTheme.white, size: 22),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActivityOption {
  final ActivityLevel level;
  final IconData icon;
  final String label;
  final String subtitle;
  const _ActivityOption(this.level, this.icon, this.label, this.subtitle);
}

class _ConfirmStep extends StatelessWidget {
  final String name;
  final GoalType goal;
  final ActivityLevel activityLevel;
  const _ConfirmStep({required this.name, required this.goal, required this.activityLevel});

  @override
  Widget build(BuildContext context) {
    final goalLabel = {GoalType.loseWeight: 'Lose Weight', GoalType.maintain: 'Maintain', GoalType.gainMuscle: 'Gain Muscle'}[goal] ?? '';
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border2, width: 2),
            ),
            child: const Icon(Icons.check_rounded, color: AppTheme.white, size: 52),
          ),
          const SizedBox(height: 28),
          Text('Ready, ${name.isEmpty ? "Champion" : name}!', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 32, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(
            'Goal: $goalLabel • Activity: ${activityLevel.name}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderDark),
            ),
            child: const Column(
              children: [
                Row(children: [const Icon(Icons.check_circle_outline_rounded, color: AppTheme.white, size: 18), const SizedBox(width: 10), const Text('Personalized calorie targets', style: TextStyle(color: AppTheme.white))]),
                const SizedBox(height: 12),
                Row(children: [const Icon(Icons.check_circle_outline_rounded, color: AppTheme.muted, size: 18), const SizedBox(width: 10), const Text('Macro split optimization', style: TextStyle(color: AppTheme.white))]),
                const SizedBox(height: 12),
                Row(children: [const Icon(Icons.check_circle_outline_rounded, color: AppTheme.muted, size: 18), const SizedBox(width: 10), const Text('Timeline to your goal weight', style: TextStyle(color: AppTheme.white))]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
