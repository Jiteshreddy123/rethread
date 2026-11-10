import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'create_listing_screen.dart';

/// AddItemScreen provides the entry point for listing an unused physical item.
/// In Phase 4, this screen connects image_picker and Firebase Storage uploads.
class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Give an Item Another Life'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add_photo_alternate_rounded, color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community Reuse Loop',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Snap photos of textbooks, appliances, or furniture. Help neighbours and prevent landfill waste.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            const Text(
              'Select Listing Type',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            _ListingOptionTile(
              icon: Icons.volunteer_activism_rounded,
              color: AppColors.primary,
              title: 'Free Donation',
              description: 'Give working textbooks, clothing, or household goods away to anyone who needs them.',
            ),
            const SizedBox(height: 12),

            _ListingOptionTile(
              icon: Icons.repeat_rounded,
              color: AppColors.secondaryDark,
              title: 'Available for Community Reuse',
              description: 'List functional items (monitors, chairs, kitchenware) ready for an immediate second life.',
            ),
            const SizedBox(height: 12),

            _ListingOptionTile(
              icon: Icons.build_circle_rounded,
              color: AppColors.accent,
              title: 'Needs Repair / Free for Parts',
              description: 'Got a device with a worn battery or broken dial? Pass it to DIYers or tech repair enthusiasts.',
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CreateListingScreen()),
                  );
                },
                icon: const Icon(Icons.add_circle_outline_rounded),
                label: const Text('Start Creating Listing'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingOptionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _ListingOptionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
