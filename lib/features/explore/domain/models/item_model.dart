/// ItemModel represents a physical object listed by a community member in ReThread.
/// 
/// Designed to align directly with Cloud Firestore document structure for Phase 3:
/// - `itemId`: Unique identifier
/// - `ownerId`: ID of the donor/lister
/// - `ownerName`: Public display name of the donor
/// - `title`: Name of the item
/// - `description`: Detailed description of condition and usage notes
/// - `category`: One of 8 supported categories
/// - `condition`: Like new | Good | Fair | Needs repair
/// - `listingType`: Free donation | Available for community reuse | Needs repair / free for parts
/// - `imageUrls`: List of item photograph URLs
/// - `city` & `area`: General neighborhood location (no exact private home addresses)
/// - `status`: Available | Requested | Accepted | Handed Over
/// - `createdAt`: Timestamp
class ItemModel {
  final String itemId;
  final String ownerId;
  final String ownerName;
  final String title;
  final String description;
  final String category;
  final String condition;
  final String listingType;
  final List<String> imageUrls;
  final String city;
  final String area;
  final String status;
  final DateTime createdAt;
  final bool isFeatured;

  const ItemModel({
    required this.itemId,
    required this.ownerId,
    required this.ownerName,
    required this.title,
    required this.description,
    required this.category,
    required this.condition,
    required this.listingType,
    required this.imageUrls,
    required this.city,
    required this.area,
    this.status = 'Available',
    required this.createdAt,
    this.isFeatured = false,
  });

  /// Helper to get a clean location string (e.g. "Koramangala, Bengaluru")
  String get locationDisplay => '$area, $city';

  /// Helper copyWith for immutable state updates
  ItemModel copyWith({
    String? itemId,
    String? ownerId,
    String? ownerName,
    String? title,
    String? description,
    String? category,
    String? condition,
    String? listingType,
    List<String>? imageUrls,
    String? city,
    String? area,
    String? status,
    DateTime? createdAt,
    bool? isFeatured,
  }) {
    return ItemModel(
      itemId: itemId ?? this.itemId,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      listingType: listingType ?? this.listingType,
      imageUrls: imageUrls ?? this.imageUrls,
      city: city ?? this.city,
      area: area ?? this.area,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
