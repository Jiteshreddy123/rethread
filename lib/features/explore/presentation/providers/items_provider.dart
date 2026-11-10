import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/sample_items.dart';
import '../../domain/models/item_model.dart';

/// Notifier managing the master list of items.
/// In Phase 3, this will stream live updates from Cloud Firestore.
class ItemsListNotifier extends Notifier<List<ItemModel>> {
  @override
  List<ItemModel> build() => SampleItems.data;

  void setItems(List<ItemModel> items) {
    state = items;
  }
}

final itemsListProvider = NotifierProvider<ItemsListNotifier, List<ItemModel>>(
  ItemsListNotifier.new,
);

/// Search query notifier
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

/// Selected category filter notifier (default 'All Items')
class CategoryFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All Items';

  void setCategory(String category) {
    state = category;
  }
}

final selectedCategoryFilterProvider = NotifierProvider<CategoryFilterNotifier, String>(
  CategoryFilterNotifier.new,
);

/// Selected condition filter notifier (default 'All Conditions')
class ConditionFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All Conditions';

  void setCondition(String condition) {
    state = condition;
  }
}

final selectedConditionFilterProvider = NotifierProvider<ConditionFilterNotifier, String>(
  ConditionFilterNotifier.new,
);

/// Filtered items computed provider based on search, category and condition
final filteredItemsProvider = Provider<List<ItemModel>>((ref) {
  final allItems = ref.watch(itemsListProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final category = ref.watch(selectedCategoryFilterProvider);
  final condition = ref.watch(selectedConditionFilterProvider);

  return allItems.where((item) {
    // 1. Category Filter
    if (category != 'All Items' && item.category.toLowerCase() != category.toLowerCase()) {
      return false;
    }

    // 2. Condition Filter
    if (condition != 'All Conditions' && item.condition.toLowerCase() != condition.toLowerCase()) {
      return false;
    }

    // 3. Search Query Filter (Title, Description, Area, Category)
    if (query.isNotEmpty) {
      final inTitle = item.title.toLowerCase().contains(query);
      final inDesc = item.description.toLowerCase().contains(query);
      final inArea = item.area.toLowerCase().contains(query);
      final inCategory = item.category.toLowerCase().contains(query);
      if (!inTitle && !inDesc && !inArea && !inCategory) {
        return false;
      }
    }

    return true;
  }).toList();
});

/// Featured items provider (for Home screen showcase)
final featuredItemsProvider = Provider<List<ItemModel>>((ref) {
  final allItems = ref.watch(itemsListProvider);
  return allItems.where((item) => item.isFeatured).toList();
});

/// Recently added items provider (sorted by newest first)
final recentItemsProvider = Provider<List<ItemModel>>((ref) {
  final allItems = ref.watch(itemsListProvider);
  final list = List<ItemModel>.from(allItems);
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list;
});
