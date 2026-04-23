import 'package:flutter/material.dart';
import '../models/nutrition_model.dart';
import '../services/google_nutrition_service.dart';
import '../data/quick_foods_data.dart';

class QuickAddFoodDialog extends StatefulWidget {
  final Function(MealEntry)? onFoodAdded;
  final Function(int, String)? onXPGain;
  final String languageCode;

  const QuickAddFoodDialog({
    super.key,
    this.onFoodAdded,
    this.onXPGain,
    this.languageCode = 'en',
  });

  @override
  State<QuickAddFoodDialog> createState() => _QuickAddFoodDialogState();
}

class _QuickAddFoodDialogState extends State<QuickAddFoodDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MealType _selectedMealType = MealType.breakfast;
  TimeOfDay _consumedTime = TimeOfDay.now();

  // Search state
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  // Custom food state
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _amountController =
      TextEditingController(text: '1');
  String _selectedUnit = 'serving';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeMealType();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _initializeMealType() {
    final hour = DateTime.now().hour;
    _consumedTime = TimeOfDay.now();

    if (hour < 11) {
      _selectedMealType = MealType.breakfast;
    } else if (hour < 16) {
      _selectedMealType = MealType.lunch;
    } else if (hour < 21) {
      _selectedMealType = MealType.dinner;
    } else {
      _selectedMealType = MealType.snack;
    }
  }

  String _translate(String key) {
    final translations = {
      'en': {
        'title': 'Quick Add Food',
        'description': 'Add foods to your nutrition log',
        'mealType': 'Meal Type',
        'timeConsumed': 'Time Consumed',
        'search': 'Search',
        'quick': 'Quick',
        'custom': 'Custom',
        'searchPlaceholder': 'Search for food...',
        'searching': 'Searching...',
        'noResults': 'No results found',
        'tryDifferent': 'Try a different search term',
        'searchHint': 'Search for foods and brands',
        'searchExample': 'Try "chicken" or "apple"',
        'foodName': 'Food Name *',
        'calories': 'Calories *',
        'protein': 'Protein (g)',
        'carbs': 'Carbs (g)',
        'fat': 'Fat (g)',
        'amount': 'Amount',
        'unit': 'Unit',
        'nutritionInfo': 'Nutrition Info',
        'willBeLoggedAt': 'Will be logged at:',
        'addTo': 'Add to',
        'cal': 'cal',
        'serving': 'Serving',
        'cup': 'Cup',
        'gram': 'Gram',
        'piece': 'Piece',
        'tbsp': 'Tbsp',
        'tsp': 'Tsp',
      },
      'ar': {
        'title': 'إضافة طعام سريع',
        'description': 'أضف الأطعمة إلى سجلك الغذائي',
        'mealType': 'نوع الوجبة',
        'timeConsumed': 'وقت تناول الطعام',
        'search': 'بحث',
        'quick': 'سريع',
        'custom': 'مخصص',
        'searchPlaceholder': 'ابحث عن الطعام...',
        'searching': 'جاري البحث...',
        'noResults': 'لم يتم العثور على نتائج',
        'tryDifferent': 'جرب مصطلح بحث مختلف',
        'searchHint': 'ابحث عن الأطعمة والعلامات التجارية',
        'searchExample': 'جرب "دجاج" أو "تفاحة"',
        'foodName': 'اسم الطعام *',
        'calories': 'السعرات *',
        'protein': 'البروتين (جم)',
        'carbs': 'الكربوهيدرات (جم)',
        'fat': 'الدهون (جم)',
        'amount': 'الكمية',
        'unit': 'الوحدة',
        'nutritionInfo': 'المعلومات الغذائية',
        'willBeLoggedAt': 'سيتم تسجيله في:',
        'addTo': 'إضافة إلى',
        'cal': 'سعرة',
        'serving': 'حصة',
        'cup': 'كوب',
        'gram': 'جرام',
        'piece': 'قطعة',
        'tbsp': 'ملعقة كبيرة',
        'tsp': 'ملعقة صغيرة',
      },
    };

    return translations[widget.languageCode]?[key] ?? key;
  }

  Future<void> _handleSearch() async {
    if (_searchController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.languageCode == 'ar'
              ? 'الرجاء إدخال اسم الطعام'
              : 'Please enter a food name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    try {
      final results =
          await GoogleNutritionService.searchFood(_searchController.text);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });

      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.languageCode == 'ar'
                ? 'لم يتم العثور على نتائج'
                : 'No results found'),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.languageCode == 'ar'
              ? 'حدث خطأ في البحث'
              : 'Search error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleQuickAdd(QuickFood food, {double amount = 1.0}) {
    final mealEntry = MealEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: amount != 1 ? '${food.name} (${amount}x)' : food.name,
      calories: (food.calories * amount).round(),
      protein: (food.protein * amount * 10).round() / 10,
      carbs: (food.carbs * amount * 10).round() / 10,
      fat: (food.fat * amount * 10).round() / 10,
      mealType: _selectedMealType,
      timestamp: DateTime.now(),
      source: MealSource.quick,
      amount: amount,
      unit: food.unit,
      consumedAt:
          '${_consumedTime.hour.toString().padLeft(2, '0')}:${_consumedTime.minute.toString().padLeft(2, '0')}',
    );

    widget.onFoodAdded?.call(mealEntry);
    widget.onXPGain?.call(10, 'Quick food log');

    final mealNames = QuickFoodsData.getMealTypeNames(widget.languageCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.languageCode == 'ar'
            ? 'تم إضافة ${food.name} إلى ${mealNames[_selectedMealType.name]}'
            : '${food.name} added to ${mealNames[_selectedMealType.name]}'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  void _handleSearchAdd(SearchResult result, {double amount = 1.0}) {
    final name =
        result.brand != null ? '${result.brand} ${result.name}' : result.name;

    final mealEntry = MealEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      calories: (result.calories * amount).round(),
      protein: (result.protein * amount * 10).round() / 10,
      carbs: (result.carbs * amount * 10).round() / 10,
      fat: (result.fat * amount * 10).round() / 10,
      mealType: _selectedMealType,
      timestamp: DateTime.now(),
      source: MealSource.search,
      amount: amount,
      unit: result.servingUnit,
      consumedAt:
          '${_consumedTime.hour.toString().padLeft(2, '0')}:${_consumedTime.minute.toString().padLeft(2, '0')}',
    );

    widget.onFoodAdded?.call(mealEntry);
    widget.onXPGain?.call(15, 'Food search');

    final mealNames = QuickFoodsData.getMealTypeNames(widget.languageCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.languageCode == 'ar'
            ? 'تم إضافة ${result.name} إلى ${mealNames[_selectedMealType.name]}'
            : '${result.name} added to ${mealNames[_selectedMealType.name]}'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  void _handleCustomAdd() {
    if (_nameController.text.trim().isEmpty ||
        _caloriesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.languageCode == 'ar'
              ? 'يرجى ملء الحقول المطلوبة'
              : 'Please fill required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 1.0;
    final calories = int.tryParse(_caloriesController.text) ?? 0;
    final protein = double.tryParse(_proteinController.text) ?? 0;
    final carbs = double.tryParse(_carbsController.text) ?? 0;
    final fat = double.tryParse(_fatController.text) ?? 0;

    final mealEntry = MealEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      calories: (calories * amount).round(),
      protein: (protein * amount * 10).round() / 10,
      carbs: (carbs * amount * 10).round() / 10,
      fat: (fat * amount * 10).round() / 10,
      mealType: _selectedMealType,
      timestamp: DateTime.now(),
      source: MealSource.custom,
      amount: amount,
      unit: _selectedUnit,
      consumedAt:
          '${_consumedTime.hour.toString().padLeft(2, '0')}:${_consumedTime.minute.toString().padLeft(2, '0')}',
    );

    widget.onFoodAdded?.call(mealEntry);
    widget.onXPGain?.call(15, 'Custom food entry');

    final mealNames = QuickFoodsData.getMealTypeNames(widget.languageCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.languageCode == 'ar'
            ? 'تم إضافة ${_nameController.text} إلى ${mealNames[_selectedMealType.name]}'
            : '${_nameController.text} added to ${mealNames[_selectedMealType.name]}'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final mealTypeNames = QuickFoodsData.getMealTypeNames(widget.languageCode);
    final categoryNames = QuickFoodsData.getCategoryNames(widget.languageCode);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.restaurant_menu),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _translate('title'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _translate('description'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Meal Type and Time Selector
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _translate('mealType'),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: MealType.values.map((type) {
                      final isSelected = _selectedMealType == type;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _selectedMealType = type);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              foregroundColor:
                                  isSelected ? Colors.white : Colors.black87,
                              elevation: isSelected ? 2 : 0,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[300]!,
                                ),
                              ),
                            ),
                            child: Text(
                              mealTypeNames[type.name] ?? '',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        _translate('timeConsumed'),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _consumedTime,
                      );
                      if (time != null) {
                        setState(() => _consumedTime = time);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_consumedTime.format(context)),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search, size: 16),
                      const SizedBox(width: 4),
                      Text(_translate('search')),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.flash_on, size: 16),
                      const SizedBox(width: 4),
                      Text(_translate('quick')),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.edit, size: 16),
                      const SizedBox(width: 4),
                      Text(_translate('custom')),
                    ],
                  ),
                ),
              ],
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSearchTab(),
                  _buildQuickTab(categoryNames),
                  _buildCustomTab(mealTypeNames),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTab() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: _translate('searchPlaceholder'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: IconButton(
                icon: _isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                onPressed: _isSearching ? null : _handleSearch,
              ),
            ),
            onSubmitted: (_) => _handleSearch(),
          ),
        ),

        // Results
        Expanded(
          child: _isSearching
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(_translate('searching')),
                    ],
                  ),
                )
              : _hasSearched
                  ? _searchResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(_translate('noResults')),
                              const SizedBox(height: 8),
                              Text(
                                _translate('tryDifferent'),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final result = _searchResults[index];
                            return _buildSearchResultCard(result);
                          },
                        )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(_translate('searchHint')),
                          const SizedBox(height: 8),
                          Text(
                            _translate('searchExample'),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildSearchResultCard(SearchResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _handleSearchAdd(result),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.brand != null
                          ? '${result.brand} ${result.name}'
                          : result.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 12,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department,
                                size: 14, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              '${result.calories} ${_translate('cal')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        if (result.protein > 0)
                          Text(
                            '${result.protein}g P',
                            style: const TextStyle(fontSize: 12),
                          ),
                        if (result.carbs > 0)
                          Text(
                            '${result.carbs}g C',
                            style: const TextStyle(fontSize: 12),
                          ),
                        if (result.fat > 0)
                          Text(
                            '${result.fat}g F',
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${result.servingSize} ${result.servingUnit}',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTab(Map<String, String> categoryNames) {
    final foodsByCategory = <String, List<QuickFood>>{};
    for (final food in QuickFoodsData.commonFoods) {
      foodsByCategory.putIfAbsent(food.category, () => []).add(food);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: foodsByCategory.length,
      itemBuilder: (context, index) {
        final category = foodsByCategory.keys.elementAt(index);
        final foods = foodsByCategory[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                categoryNames[category] ?? category,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            ...foods.map((food) => _buildQuickFoodCard(food)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildQuickFoodCard(QuickFood food) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _handleQuickAdd(food),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 12,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department,
                                size: 14, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              '${food.calories} ${_translate('cal')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        if (food.protein > 0)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.fitness_center,
                                  size: 14, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text(
                                '${food.protein}g P',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  food.unit,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTab(Map<String, String> mealTypeNames) {
    final calories = int.tryParse(_caloriesController.text) ?? 0;
    final protein = double.tryParse(_proteinController.text) ?? 0;
    final carbs = double.tryParse(_carbsController.text) ?? 0;
    final fat = double.tryParse(_fatController.text) ?? 0;
    final amount = double.tryParse(_amountController.text) ?? 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: _translate('foodName'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _translate('calories'),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _proteinController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: _translate('protein'),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _carbsController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: _translate('carbs'),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _fatController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: _translate('fat'),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: _translate('amount'),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedUnit,
                  decoration: InputDecoration(
                    labelText: _translate('unit'),
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    'serving',
                    'cup',
                    'gram',
                    'piece',
                    'tbsp',
                    'tsp',
                  ].map((unit) {
                    return DropdownMenuItem(
                      value: unit,
                      child: Text(_translate(unit)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedUnit = value);
                    }
                  },
                ),
              ),
            ],
          ),
          if (calories > 0) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _translate('nutritionInfo'),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_translate('calories')}:'),
                        Text('${(calories * amount).round()}'),
                      ],
                    ),
                    if (protein > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_translate('protein')}:'),
                          Text('${(protein * amount).toStringAsFixed(1)}g'),
                        ],
                      ),
                    if (carbs > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_translate('carbs')}:'),
                          Text('${(carbs * amount).toStringAsFixed(1)}g'),
                        ],
                      ),
                    if (fat > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_translate('fat')}:'),
                          Text('${(fat * amount).toStringAsFixed(1)}g'),
                        ],
                      ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              _translate('willBeLoggedAt'),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          _consumedTime.format(context),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _handleCustomAdd,
              icon: const Icon(Icons.add),
              label: Text(
                '${_translate('addTo')} ${mealTypeNames[_selectedMealType.name]}',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
