import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/locaion_controller.dart';
import 'map_screen.dart';
import 'chat_screen.dart';
import 'payment_screen.dart';

class SearchDestinationScreen extends StatelessWidget {
  final ScrollController? scrollController;

  const SearchDestinationScreen({super.key, this.scrollController});
  @override
  Widget build(BuildContext context) {
    // Use Get.find with fallback initialization
    final LocationController locationController =
        Get.find<LocationController>();
    final AppController appController = Get.find<AppController>();
    final TextEditingController searchTextController = TextEditingController();

    return Obx(
      () => SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: Colors.white),
                'Search your destination'.text16White(),
                const SizedBox(width: 50),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: searchTextController,
                onChanged: (value) => locationController.searchLocation(value),
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Where are you going?',

                  hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                      top: 18,
                      bottom: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Image.asset(
                      "assets/icons/destinationIcon.png",
                      height: 20,
                      width: 20,
                    ),
                  ),
                  suffixIcon: searchTextController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            searchTextController.clear();
                            locationController.clearSearch();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            if (locationController.isSearching.value)
              Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: Colors.red),
              ),
            if (locationController.searchResults.isNotEmpty)
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: locationController.searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.location_on, color: Colors.white),
                      title: Text(
                        locationController.searchResults[index],
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        locationController.selectSearchResult(index);
                        searchTextController.text =
                            locationController.searchResults[index];
                      },
                    );
                  },
                ),
              ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // _buildLocationItem(
                  //   icon: Icons.location_on,
                  //   title: 'Current Location',
                  //   subtitle: locationController.pickupAddress.value.isEmpty
                  //       ? 'Using GPS'
                  //       : locationController.pickupAddress.value,
                  //   onTap: () => locationController.getCurrentLocation(),
                  // ),
                  _buildLocationItem(
                    icon: Icons.access_time,
                    title: 'Home',
                    subtitle: locationController.homeAddress.value,
                    onTap: () => locationController.selectSavedLocation('home'),
                  ),
                  _buildLocationItem(
                    icon: Icons.access_time,
                    title: 'Work',
                    subtitle: locationController.workAddress.value,
                    onTap: () => locationController.selectSavedLocation('work'),
                  ),
                  _buildLocationItem(
                    icon: Icons.access_time,
                    title: 'Favorite Location',
                    subtitle: locationController.favoriteAddress.value,
                    onTap: () =>
                        locationController.selectSavedLocation('favorite'),
                  ),
                  SizedBox(height: 20),
                  _buildQuickActionButtons(),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: appController.isLoading.value
                    ? null
                    : () {
                        appController.setCurrentScreen('map');
                        Get.to(() => MapScreen());
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: appController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Choose car',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          // color: Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            "2.7km".text14White(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionButton(
          icon: Icons.payment,
          label: 'Payment',
          onTap: () => Get.to(() => PaymentScreen()),
        ),
        _buildQuickActionButton(
          icon: Icons.chat,
          label: 'Support',
          onTap: () => Get.to(() => ChatScreen()),
        ),
        _buildQuickActionButton(
          icon: Icons.history,
          label: 'History',
          onTap: () => Get.snackbar('Info', 'History feature coming soon!'),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFF34495E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
