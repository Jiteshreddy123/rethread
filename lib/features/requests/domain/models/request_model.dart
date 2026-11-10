/// RequestModel represents a request by a community member to reuse an item.
class RequestModel {
  final String requestId;
  final String itemId;
  final String itemTitle;
  final String itemImageUrl;
  final String ownerId;
  final String ownerName;
  final String requesterId;
  final String requesterName;
  final String message;
  final String status; // Requested | Accepted | Rejected | Handed Over | Cancelled
  final DateTime createdAt;
  final DateTime? updatedAt;

  const RequestModel({
    required this.requestId,
    required this.itemId,
    required this.itemTitle,
    required this.itemImageUrl,
    required this.ownerId,
    required this.ownerName,
    required this.requesterId,
    required this.requesterName,
    required this.message,
    this.status = 'Requested',
    required this.createdAt,
    this.updatedAt,
  });

  RequestModel copyWith({
    String? requestId,
    String? itemId,
    String? itemTitle,
    String? itemImageUrl,
    String? ownerId,
    String? ownerName,
    String? requesterId,
    String? requesterName,
    String? message,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RequestModel(
      requestId: requestId ?? this.requestId,
      itemId: itemId ?? this.itemId,
      itemTitle: itemTitle ?? this.itemTitle,
      itemImageUrl: itemImageUrl ?? this.itemImageUrl,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
