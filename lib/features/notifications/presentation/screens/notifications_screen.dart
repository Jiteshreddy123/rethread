import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class InAppNotification {
  final String id;
  final String title;
  final String message;
  final String time;
  bool isRead;
  final IconData icon;
  final Color iconColor;

  InAppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    required this.icon,
    required this.iconColor,
  });
}

/// NotificationsScreen shows community alerts, request updates, and handover confirmations.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<InAppNotification> _notifications = [
    InAppNotification(
      id: 'n1',
      title: 'Request Accepted!',
      message: 'Priya Sharma accepted your request for "Engineering Mathematics & Data Structures". Coordinate pickup via chat.',
      time: '15 mins ago',
      isRead: false,
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.success,
    ),
    InAppNotification(
      id: 'n2',
      title: 'New Donation Request',
      message: 'Marcus Vance requested your "Vintage Mechanical Keyboard". Tap to review and approve.',
      time: '2 hours ago',
      isRead: false,
      icon: Icons.volunteer_activism_rounded,
      iconColor: AppColors.primary,
    ),
    InAppNotification(
      id: 'n3',
      title: 'Handover Completed',
      message: 'Your donation of "Acoustic Guitar" was marked complete. +1 item saved from landfill!',
      time: '2 days ago',
      isRead: true,
      icon: Icons.celebration_rounded,
      iconColor: AppColors.accent,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Community Notifications'),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text('Mark all read', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        separatorBuilder: (ctx, i) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return Container(
            color: n.isRead ? Colors.transparent : AppColors.surfaceVariant.withValues(alpha: 0.5),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: n.iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(n.icon, color: n.iconColor, size: 22),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(n.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  Text(n.time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  n.message,
                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.35),
                ),
              ),
              onTap: () {
                setState(() => n.isRead = true);
              },
            ),
          );
        },
      ),
    );
  }
}
