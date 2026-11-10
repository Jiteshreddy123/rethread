import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../../explore/presentation/providers/items_provider.dart';
import '../../domain/models/request_model.dart';

class RequestsNotifier extends Notifier<List<RequestModel>> {
  @override
  List<RequestModel> build() {
    return [
      RequestModel(
        requestId: 'req_1',
        itemId: 'item_1',
        itemTitle: 'Engineering Mathematics & Data Structures Textbooks',
        itemImageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80',
        ownerId: 'user_priya',
        ownerName: 'Priya Sharma',
        requesterId: 'user_alex_101',
        requesterName: 'Alex Morgan',
        message: 'Hello Priya, I am a 2nd year B.Tech student and would love to read these textbooks. I can pick them up from Koramangala this Saturday!',
        status: 'Accepted',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      RequestModel(
        requestId: 'req_2',
        itemId: 'item_2',
        itemTitle: 'Ergonomic Mesh Office Chair',
        itemImageUrl: 'https://images.unsplash.com/photo-1580481077195-c328a37db729?auto=format&fit=crop&w=800&q=80',
        ownerId: 'user_david',
        ownerName: 'David Chen',
        requesterId: 'user_alex_101',
        requesterName: 'Alex Morgan',
        message: 'Hi David! Is this chair still available? I just moved to Indiranagar and would put it to great use.',
        status: 'Requested',
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      ),
      RequestModel(
        requestId: 'req_3',
        itemId: 'item_user_listed',
        itemTitle: 'Vintage Mechanical Keyboard',
        itemImageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80',
        ownerId: 'user_alex_101',
        ownerName: 'Alex Morgan',
        requesterId: 'user_marcus',
        requesterName: 'Marcus Vance',
        message: 'Hi Alex! I am restoring a vintage PC build and would love to reuse this keyboard. Can I pick it up tomorrow evening?',
        status: 'Requested',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  /// Create a new request for an item
  void sendRequest({
    required String itemId,
    required String itemTitle,
    required String itemImageUrl,
    required String ownerId,
    required String ownerName,
    required String message,
  }) {
    final user = ref.read(authProvider);
    final newRequest = RequestModel(
      requestId: const Uuid().v4(),
      itemId: itemId,
      itemTitle: itemTitle,
      itemImageUrl: itemImageUrl,
      ownerId: ownerId,
      ownerName: ownerName,
      requesterId: user?.uid ?? 'guest_user',
      requesterName: user?.displayName ?? 'Community Member',
      message: message,
      status: 'Requested',
      createdAt: DateTime.now(),
    );

    state = [newRequest, ...state];
  }

  /// Accept a request safely: marks this request Accepted and updates item status
  void acceptRequest(String requestId) {
    String? matchedItemId;

    state = [
      for (final req in state)
        if (req.requestId == requestId) ...[
          () {
            matchedItemId = req.itemId;
            return req.copyWith(status: 'Accepted', updatedAt: DateTime.now());
          }(),
        ] else
          req,
    ];

    if (matchedItemId != null) {
      final currentItems = ref.read(itemsListProvider);
      ref.read(itemsListProvider.notifier).setItems([
        for (final it in currentItems)
          if (it.itemId == matchedItemId) it.copyWith(status: 'Accepted') else it,
      ]);
    }
  }

  /// Reject a request
  void rejectRequest(String requestId) {
    state = [
      for (final req in state)
        if (req.requestId == requestId) req.copyWith(status: 'Rejected', updatedAt: DateTime.now()) else req,
    ];
  }

  /// Mark an item as Handed Over
  void markHandedOver(String requestId) {
    String? matchedItemId;

    state = [
      for (final req in state)
        if (req.requestId == requestId) ...[
          () {
            matchedItemId = req.itemId;
            return req.copyWith(status: 'Handed Over', updatedAt: DateTime.now());
          }(),
        ] else
          req,
    ];

    if (matchedItemId != null) {
      final currentItems = ref.read(itemsListProvider);
      ref.read(itemsListProvider.notifier).setItems([
        for (final it in currentItems)
          if (it.itemId == matchedItemId) it.copyWith(status: 'Handed Over') else it,
      ]);
    }
  }

  /// Cancel an outgoing request
  void cancelRequest(String requestId) {
    state = [
      for (final req in state)
        if (req.requestId == requestId) req.copyWith(status: 'Cancelled', updatedAt: DateTime.now()) else req,
    ];
  }
}

final requestsProvider = NotifierProvider<RequestsNotifier, List<RequestModel>>(
  RequestsNotifier.new,
);

/// Outgoing requests made by current user
final myOutgoingRequestsProvider = Provider<List<RequestModel>>((ref) {
  final user = ref.watch(authProvider);
  final allRequests = ref.watch(requestsProvider);
  return allRequests.where((r) => r.requesterId == user?.uid).toList();
});

/// Incoming requests on items owned by current user
final incomingRequestsProvider = Provider<List<RequestModel>>((ref) {
  final user = ref.watch(authProvider);
  final allRequests = ref.watch(requestsProvider);
  return allRequests.where((r) => r.ownerId == user?.uid).toList();
});

/// Completed handovers involving current user
final completedHandoversProvider = Provider<List<RequestModel>>((ref) {
  final user = ref.watch(authProvider);
  final allRequests = ref.watch(requestsProvider);
  return allRequests
      .where((r) => r.status == 'Handed Over' && (r.ownerId == user?.uid || r.requesterId == user?.uid))
      .toList();
});
