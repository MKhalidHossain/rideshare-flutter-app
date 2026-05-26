import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/feature/profileAndHistory/controllers/profile_and_history_controller.dart';
import 'package:rideztohealth/core/widgets/shimmer/shimmer_skeleton.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ProfileAndHistoryController profileController =
      Get.find<ProfileAndHistoryController>();

  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileAndHistoryController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(
                        color: Colors.white,
                        onPressed: () => Get.back(),
                      ),
                      const Text(
                        'Notifications',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildToggleCard(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: controller.notificationsLoading
                        ? _buildNotificationsShimmer()
                        : _buildNotificationsList(controller),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "All Notifications",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Switch(
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() => notificationsEnabled = value);
            },
            activeThumbColor: Colors.red,
            activeTrackColor: Colors.white,
            inactiveThumbColor: Colors.red,
            inactiveTrackColor: Colors.black,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(ProfileAndHistoryController controller) {
    if (!notificationsEnabled) {
      return const Center(
        child: Text(
          'Notifications are turned off',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final items = controller.notifications;
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No notifications yet',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        final sender = item.senderId;
        final created = _formatDate(item.createdAt);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: sender?.profileImage != null &&
                        sender!.profileImage!.isNotEmpty
                    ? Image.network(
                        sender.profileImage!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 48,
                        height: 48,
                        color: Colors.grey.shade800,
                        child: const Icon(
                          Icons.notifications_none,
                          color: Colors.white70,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      created,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.isRead == false)
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String? date) {
    if (date == null) return '';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return '';
    return '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
  }

  Widget _buildNotificationsShimmer() {
    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerCircle(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerLine(width: 200, height: 14),
                    SizedBox(height: 8),
                    ShimmerLine(width: 240, height: 12),
                    SizedBox(height: 6),
                    ShimmerLine(width: 160, height: 12),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const ShimmerCircle(size: 10),
            ],
          ),
        );
      },
    );
  }
}
