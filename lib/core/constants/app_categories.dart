import 'package:flutter/material.dart';

/// AppCategories defines the 8 official ReThread item categories,
/// their associated icons, and helper metadata.
class AppCategory {
  final String id;
  final String name;
  final IconData icon;

  const AppCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

abstract class AppCategories {
  static const List<AppCategory> list = [
    AppCategory(id: 'all', name: 'All Items', icon: Icons.grid_view_rounded),
    AppCategory(id: 'electronics', name: 'Electronics', icon: Icons.devices_rounded),
    AppCategory(id: 'books', name: 'Books', icon: Icons.menu_book_rounded),
    AppCategory(id: 'clothing', name: 'Clothing', icon: Icons.checkroom_rounded),
    AppCategory(id: 'furniture', name: 'Furniture', icon: Icons.chair_rounded),
    AppCategory(id: 'home_appliances', name: 'Home Appliances', icon: Icons.blender_rounded),
    AppCategory(id: 'toys', name: 'Toys', icon: Icons.toys_rounded),
    AppCategory(id: 'school_supplies', name: 'School Supplies', icon: Icons.backpack_rounded),
    AppCategory(id: 'others', name: 'Others', icon: Icons.category_rounded),
  ];

  static const List<String> conditions = [
    'All Conditions',
    'Like new',
    'Good',
    'Fair',
    'Needs repair',
  ];

  static const List<String> listingTypes = [
    'Free donation',
    'Available for community reuse',
    'Needs repair / free for parts',
  ];
}
