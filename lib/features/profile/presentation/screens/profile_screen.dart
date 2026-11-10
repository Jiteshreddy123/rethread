import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

/// ProfileScreen displays community identity, personal sustainability impact,
/// and application preferences.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider);
    final nameCtrl = TextEditingController(text: user?.displayName ?? '');
    final cityCtrl = TextEditingController(text: user?.city ?? '');
    final areaCtrl = TextEditingController(text: user?.area ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Display Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cityCtrl,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: areaCtrl,
              decoration: const InputDecoration(labelText: 'Neighborhood / Area'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(authProvider.notifier).updateProfile(
                    displayName: nameCtrl.text.trim(),
                    city: cityCtrl.text.trim(),
                    area: areaCtrl.text.trim(),
                  );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Community Privacy Policy', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const SingleChildScrollView(
          child: Text(
            'ReThread is committed to privacy and community safety.\n\n'
            '1. Exact Home Addresses: We NEVER publicly display your exact street address, house number, or apartment floor. Only your general neighborhood (area) and city are visible on public listings.\n\n'
            '2. Handover Coordination: Specific pickup points (such as local community centers, metro stations, or direct addresses) are shared only when you explicitly accept a neighbor\'s request.\n\n'
            '3. Non-Commercial: ReThread is 100% non-commercial. No payment information, card details, or banking credentials are ever requested or stored.',
            style: TextStyle(fontSize: 13, height: 1.45, color: AppColors.textPrimary),
          ),
        ),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Understood')),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.eco_rounded, color: AppColors.primary, size: 28),
            SizedBox(width: 10),
            Text('About ReThread', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appTagline,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            SizedBox(height: 10),
            Text(
              'ReThread is a community-driven reuse, repair, donation and recycling platform created to foster a local circular economy: Reuse → Repair → Donate → Recycle.',
              style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.textSecondary),
            ),
            SizedBox(height: 12),
            Text('Version 1.0.0 (Phase 1-7)', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Community Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
            onPressed: () => _showEditProfileDialog(context, ref),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user != null && user.displayName.isNotEmpty ? user.displayName[0] : 'U',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'Community Member',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              user?.locationDisplay ?? 'Bengaluru',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Active Community Contributor',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Personal Impact Grid
            const Row(
              children: [
                Expanded(
                  child: _ImpactStatBox(
                    number: '5',
                    title: 'Items Donated',
                    icon: Icons.volunteer_activism_rounded,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ImpactStatBox(
                    number: '2',
                    title: 'Items Reused',
                    icon: Icons.repeat_rounded,
                    color: AppColors.secondaryDark,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ImpactStatBox(
                    number: '12 kg',
                    title: 'Waste Diverted',
                    icon: Icons.eco_rounded,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Settings Section
            _SettingsTile(
              icon: Icons.person_outline_rounded,
              title: 'Edit Profile Information',
              subtitle: 'Update your display name, city, and general area',
              onTap: () => _showEditProfileDialog(context, ref),
            ),
            _SettingsTile(
              icon: Icons.notifications_none_rounded,
              title: 'Community Notifications',
              subtitle: 'View recent request updates and announcements',
              onTap: () => context.push('/notifications'),
            ),
            _SettingsTile(
              icon: Icons.build_circle_outlined,
              title: 'Repair Directory',
              subtitle: 'Discover verified electronics and appliance repair shops',
              onTap: () => context.push('/repair'),
            ),
            _SettingsTile(
              icon: Icons.recycling_rounded,
              title: 'Recycling Facility Map',
              subtitle: 'Locate e-waste, paper, and metal drop-off stations',
              onTap: () => context.push('/recycling'),
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we safeguard your location and privacy',
              onTap: () => _showPrivacyPolicy(context),
            ),
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              title: 'About ReThread',
              subtitle: AppStrings.appTagline,
              onTap: () => _showAboutDialog(context),
            ),
            const SizedBox(height: 16),

            // Logout Action
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Log Out'),
                      content: const Text('Are you sure you want to log out of ReThread?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                          onPressed: () {
                            ref.read(authProvider.notifier).signOut();
                            Navigator.pop(ctx);
                            context.go('/login');
                          },
                          child: const Text('Log Out'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: const Text(
                  'Log Out',
                  style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error, width: 1.2),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ImpactStatBox extends StatelessWidget {
  final String number;
  final String title;
  final IconData icon;
  final Color color;

  const _ImpactStatBox({
    required this.number,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            number,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
      ),
    );
  }
}
