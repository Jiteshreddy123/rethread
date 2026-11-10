import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_categories.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/item_card.dart';
import '../providers/items_provider.dart';

/// ExploreScreen provides interactive searching, category filtering,
/// and condition filtering across all community listings.
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = ref.watch(filteredItemsProvider);
    final selectedCategory = ref.watch(selectedCategoryFilterProvider);
    final selectedCondition = ref.watch(selectedConditionFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Explore Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              _searchController.clear();
              ref.read(searchQueryProvider.notifier).setQuery('');
              ref.read(selectedCategoryFilterProvider.notifier).setCategory('All Items');
              ref.read(selectedConditionFilterProvider.notifier).setCondition('All Conditions');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(searchQueryProvider.notifier).setQuery(val);
              },
              decoration: InputDecoration(
                hintText: 'Search items, titles, neighborhoods...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).setQuery('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Category Filter Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              itemCount: AppCategories.list.length,
              itemBuilder: (context, index) {
                final cat = AppCategories.list[index];
                final isSelected = selectedCategory.toLowerCase() == cat.name.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(cat.name),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    onSelected: (selected) {
                      ref.read(selectedCategoryFilterProvider.notifier).setCategory(cat.name);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // Condition Filter Chips
          SizedBox(
            height: 38,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              itemCount: AppCategories.conditions.length,
              itemBuilder: (context, index) {
                final condition = AppCategories.conditions[index];
                final isSelected = selectedCondition == condition;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(condition),
                    selected: isSelected,
                    selectedColor: AppColors.secondaryLight.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                    ),
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    onSelected: (selected) {
                      ref.read(selectedConditionFilterProvider.notifier).setCondition(condition);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Results Count Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${filteredItems.length} community ${filteredItems.length == 1 ? 'item' : 'items'} available',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Listings Grid View
          Expanded(
            child: filteredItems.isEmpty
                ? EmptyState(
                    title: 'No Items Found',
                    message: 'Try adjusting your search terms or clearing your category & condition filters.',
                    actionLabel: 'Reset All Filters',
                    onAction: () {
                      _searchController.clear();
                      ref.read(searchQueryProvider.notifier).setQuery('');
                      ref.read(selectedCategoryFilterProvider.notifier).setCategory('All Items');
                      ref.read(selectedConditionFilterProvider.notifier).setCondition('All Conditions');
                    },
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: filteredItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ItemCard(
                        item: item,
                        onTap: () => context.push('/item/${item.itemId}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
