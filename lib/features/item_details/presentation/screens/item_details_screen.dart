import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_badge.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../../create_listing/presentation/screens/create_listing_screen.dart';
import '../../../explore/presentation/providers/items_provider.dart';
import '../../../requests/presentation/providers/requests_provider.dart';

/// ItemDetailsScreen displays full information for a selected physical item.
class ItemDetailsScreen extends ConsumerStatefulWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  @override
  ConsumerState<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends ConsumerState<ItemDetailsScreen> {
  int _activeImageIndex = 0;

  void _showRequestDialog(BuildContext context, dynamic item) {
    final messageController = TextEditingController(
      text: 'Hello ${item.ownerName}, I would love to reuse this ${item.title}. I can collect it whenever convenient for you!',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Request This Item',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Send a friendly message to ${item.ownerName} to request this item for reuse.',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Introduce yourself and suggest a pickup arrangement...',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(requestsProvider.notifier).sendRequest(
                          itemId: item.itemId,
                          itemTitle: item.title,
                          itemImageUrl: item.imageUrls.isNotEmpty ? item.imageUrls.first : '',
                          ownerId: item.ownerId,
                          ownerName: item.ownerName,
                          message: messageController.text.trim(),
                        );

                    Navigator.pop(bottomSheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Request sent to ${item.ownerName}! Track it in your Activity tab.',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('Send Request'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteListing(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Listing'),
        content: const Text('Are you sure you want to remove this item from ReThread?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              final currentItems = ref.read(itemsListProvider);
              ref.read(itemsListProvider.notifier).setItems(
                    currentItems.where((it) => it.itemId != itemId).toList(),
                  );
              Navigator.pop(ctx);
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listing deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allItems = ref.watch(itemsListProvider);
    final user = ref.watch(authProvider);

    final item = allItems.firstWhere(
      (element) => element.itemId == widget.itemId,
      orElse: () => allItems.first,
    );

    final bool isOwner = user != null && user.uid == item.ownerId;
    final formattedDate = DateFormat('d MMMM y').format(item.createdAt);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(item.category),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (isOwner) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Listing',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => CreateListingScreen(itemToEdit: item)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
              tooltip: 'Delete Listing',
              onPressed: () => _confirmDeleteListing(context, item.itemId),
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Listing link copied to clipboard')),
                );
              },
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel / Hero Image
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: item.imageUrls.isNotEmpty
                      ? PageView.builder(
                          itemCount: item.imageUrls.length,
                          onPageChanged: (index) {
                            setState(() => _activeImageIndex = index);
                          },
                          itemBuilder: (context, index) {
                            return Image.network(
                              item.imageUrls[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.surfaceVariant,
                                child: const Center(
                                  child: Icon(Icons.eco_rounded, size: 64, color: AppColors.secondary),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.surfaceVariant,
                          child: const Center(
                            child: Icon(Icons.eco_rounded, size: 64, color: AppColors.secondary),
                          ),
                        ),
                ),
                if (item.imageUrls.length > 1)
                  Positioned(
                    bottom: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        item.imageUrls.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _activeImageIndex == index ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _activeImageIndex == index ? Colors.white : Colors.white60,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      CustomBadge.condition(item.condition),
                      CustomBadge.status(item.status),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.listingType,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Location and Date
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.locationDisplay,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        'Listed $formattedDate',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Donor Profile Summary Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            item.ownerName.isNotEmpty ? item.ownerName[0] : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.ownerName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isOwner ? 'You (Listing Owner)' : 'Community Donor • ${item.city}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.shield_outlined, size: 14, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Item Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Community Reuse Notice Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC8E6C9)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.volunteer_activism_rounded, color: AppColors.primary, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'ReThread is a free circular economy platform. Handover is coordinated respectfully between community members with no fees or payments.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryDark,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: isOwner
                    ? OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => CreateListingScreen(itemToEdit: item)),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit Your Listing'),
                      )
                    : ElevatedButton.icon(
                        onPressed: item.status == 'Available'
                            ? () => _showRequestDialog(context, item)
                            : null,
                        icon: const Icon(Icons.handshake_outlined),
                        label: Text(
                          item.status == 'Available' ? 'Request This Item' : 'Item ${item.status}',
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
