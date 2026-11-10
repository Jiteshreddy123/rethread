import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_badge.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../requests/presentation/providers/requests_provider.dart';

/// ActivityScreen tracks real-time outgoing donation requests, incoming donor approvals,
/// and completed handovers.
class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outgoing = ref.watch(myOutgoingRequestsProvider);
    final incoming = ref.watch(incomingRequestsProvider);
    final handovers = ref.watch(completedHandoversProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Community Activity'),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            tabs: [
              Tab(text: 'My Requests (${outgoing.length})'),
              Tab(text: 'Incoming (${incoming.length})'),
              Tab(text: 'Handovers (${handovers.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Outgoing Requests
            outgoing.isEmpty
                ? const EmptyState(
                    icon: Icons.outbox_rounded,
                    title: 'No Active Requests',
                    message: 'Explore community items and request textbooks, furniture, or electronics you need!',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: outgoing.length,
                    itemBuilder: (context, index) {
                      final req = outgoing[index];
                      return _RequestCard(
                        title: req.itemTitle,
                        subtitle: 'Donor: ${req.ownerName}',
                        status: req.status,
                        message: req.message,
                        imageUrl: req.itemImageUrl,
                        secondaryActionText: req.status == 'Requested' ? 'Cancel Request' : null,
                        onSecondaryAction: () {
                          ref.read(requestsProvider.notifier).cancelRequest(req.requestId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Request cancelled')),
                          );
                        },
                      );
                    },
                  ),

            // Tab 2: Incoming Requests (Items I Listed)
            incoming.isEmpty
                ? const EmptyState(
                    icon: Icons.move_to_inbox_rounded,
                    title: 'No Incoming Requests',
                    message: 'When neighbors request items you listed, their requests will appear here for your review.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: incoming.length,
                    itemBuilder: (context, index) {
                      final req = incoming[index];
                      final isPending = req.status == 'Requested';
                      final isAccepted = req.status == 'Accepted';

                      return _RequestCard(
                        title: req.itemTitle,
                        subtitle: 'Requested by ${req.requesterName}',
                        status: req.status,
                        message: req.message,
                        imageUrl: req.itemImageUrl,
                        primaryActionText: isPending
                            ? 'Accept Request'
                            : (isAccepted ? 'Mark Handed Over' : null),
                        secondaryActionText: isPending ? 'Decline' : null,
                        onPrimaryAction: () {
                          if (isPending) {
                            ref.read(requestsProvider.notifier).acceptRequest(req.requestId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.primary,
                                content: Text('Accepted ${req.requesterName}\'s request! Item is reserved.'),
                              ),
                            );
                          } else if (isAccepted) {
                            ref.read(requestsProvider.notifier).markHandedOver(req.requestId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: AppColors.success,
                                content: Text('Item marked as Handed Over! Thank you for supporting the circular economy.'),
                              ),
                            );
                          }
                        },
                        onSecondaryAction: () {
                          ref.read(requestsProvider.notifier).rejectRequest(req.requestId);
                        },
                      );
                    },
                  ),

            // Tab 3: Completed Handovers
            handovers.isEmpty
                ? const EmptyState(
                    icon: Icons.check_circle_outline_rounded,
                    title: 'No Completed Handovers Yet',
                    message: 'Once an item has been successfully handed over to a neighbor, it will be memorialized here.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: handovers.length,
                    itemBuilder: (context, index) {
                      final req = handovers[index];
                      return _RequestCard(
                        title: req.itemTitle,
                        subtitle: 'Handed over between ${req.ownerName} & ${req.requesterName}',
                        status: 'Handed Over',
                        message: 'Successfully diverted from landfill and given another life!',
                        imageUrl: req.itemImageUrl,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final String message;
  final String imageUrl;
  final String? primaryActionText;
  final String? secondaryActionText;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;

  const _RequestCard({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.message,
    required this.imageUrl,
    this.primaryActionText,
    this.secondaryActionText,
    this.onPrimaryAction,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, trace) => Container(
                              color: AppColors.surfaceVariant,
                              child: const Icon(Icons.eco_rounded, color: AppColors.secondary),
                            ),
                          )
                        : Container(
                            color: AppColors.surfaceVariant,
                            child: const Icon(Icons.eco_rounded, color: AppColors.secondary),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                CustomBadge.status(status),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.35),
              ),
            ),

            if (primaryActionText != null || secondaryActionText != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (secondaryActionText != null)
                    OutlinedButton(
                      onPressed: onSecondaryAction,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      child: Text(secondaryActionText!, style: const TextStyle(fontSize: 12)),
                    ),
                  if (secondaryActionText != null && primaryActionText != null)
                    const SizedBox(width: 8),
                  if (primaryActionText != null)
                    ElevatedButton(
                      onPressed: onPrimaryAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      child: Text(primaryActionText!, style: const TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
