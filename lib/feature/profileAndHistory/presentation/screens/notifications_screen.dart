import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';

class NotificationsController extends GetxController {
  RxBool notificationsEnabled = true.obs;
  RxString selectedAlert = ''.obs;
}

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationsController controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(color: Colors.white),
                    Text(
                      'Notifications',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
                const SizedBox(height: 20),
                _buildToggleCard(controller),
                SizedBox(height: 20),
                if (controller.notificationsEnabled.value)
                  _buildAlertsSection(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildToggleCard(NotificationsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          "All Notifications".text16White500(),
          Obx(
            () => CustomNotificationSwitch(
              value: controller.notificationsEnabled.value,
              onChanged: (value) =>
                  controller.notificationsEnabled.value = value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection(NotificationsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alerts', style: TextStyle(color: Colors.white, fontSize: 18)),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF2D3A5C),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAlertOption(
                controller,
                icon: Icons.phone_android,
                label: 'Lock Screen',
                value: 'lock',
              ),
              _buildAlertOption(
                controller,
                icon: Icons.email_outlined,
                label: 'Email',
                value: 'email',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertOption(
    NotificationsController controller, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => controller.selectedAlert.value = value,
      child: Obx(() {
        final selected = controller.selectedAlert.value == value;
        return Column(
          children: [
            CircleAvatar(
              backgroundColor: selected ? Colors.blue[100] : Colors.transparent,
              radius: 28,
              child: Icon(
                icon,
                size: 32,
                color: selected ? Colors.blue : Colors.white,
              ),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Radio<String>(
                  value: value,
                  groupValue: controller.selectedAlert.value,
                  onChanged: (val) => controller.selectedAlert.value = val!,
                  activeColor: Colors.white,
                  fillColor: MaterialStateProperty.all(Colors.white),
                ),
                Text(label, style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class CustomNotificationSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomNotificationSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.red,
      activeTrackColor: Colors.white,
      inactiveThumbColor: Colors.red,
      inactiveTrackColor: Colors.black,

      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
