import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/widgets/shimmer/shimmer_skeleton.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideztohealth/feature/auth/controllers/auth_controller.dart';
import 'package:rideztohealth/feature/auth/presentation/screens/user_login_screen.dart';
import 'package:rideztohealth/feature/home/controllers/home_controller.dart';
import 'package:rideztohealth/feature/home/domain/reponse_model/get_search_destination_for_find_Nearest_drivers_response_model.dart';
import 'package:rideztohealth/helpers/custom_snackbar.dart';
import 'chat_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/normal_custom_button.dart';
import '../../../../core/widgets/normal_custom_icon_button.dart';
import '../../../home/domain/reponse_model/request_ride_response_model.dart';
import '../../../profileAndHistory/presentation/screens/wallet_screen.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/locaion_controller.dart';

// import 'chat_screen.dart'; // Uncomment if you use these
// import 'call_screen.dart'; // Uncomment if you use these
// import 'payment_screen.dart'; // Uncomment if you use these// Import the new search screen

// ignore: use_key_in_widget_constructors
class RideConfirmedScreen extends StatefulWidget {
  const RideConfirmedScreen({
    Key? key,
    this.selectedDriver,
    this.rideBookingInfoFromResponse,
    this.snackberMessage,
  }) : super(key: key);

  final NearestDriverData? selectedDriver;
  final RequestRideResponseModel? rideBookingInfoFromResponse;
  final String? snackberMessage;

  @override
  State<RideConfirmedScreen> createState() => _RideConfirmedScreenState();
}

class _RideConfirmedScreenState extends State<RideConfirmedScreen> {
  final LocationController locationController = Get.find<LocationController>();

  final BookingController bookingController = Get.find<BookingController>();

  final HomeController homeController = Get.find<HomeController>();
  final AuthController authController = Get.find<AuthController>();

  final AppController appController = Get.find<AppController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125), // Default to Dhaka, Bangladesh
    zoom: 14.0,
  );

  String? _selectedPaymentType;

  bool _isSavingRide = false;

  // Bottom sheet height control
  static const double _sheetHeightFactor = 0.7;
  static const List<String> _savedPlaceTypes = ['Home', 'Work', 'Favorite'];

  void _onProfileSelected(String profileType) {
    setState(() {
      _selectedPaymentType = profileType;
    });
  }

  String _buildDefaultSavedPlaceName(String address) {
    final trimmedAddress = address.trim();
    if (trimmedAddress.isEmpty) {
      return 'Saved Place';
    }
    final parts = trimmedAddress.split(',');
    final firstPart = parts.first.trim();
    return firstPart.isEmpty ? trimmedAddress : firstPart;
  }

  Future<bool> _showLoginRequiredDialog() async {
    final shouldLogin = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF303644),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        title: const Text('Sign in required'),
        content: const Text('You need to sign in to save this ride for later.'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Not now'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCE0000),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Sign in'),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: true,
    );

    return shouldLogin ?? false;
  }

  Future<Map<String, String>?> _showSaveRideDialog(String address) async {
    final nameController = TextEditingController(
      text: _buildDefaultSavedPlaceName(address),
    );
    String selectedType = _savedPlaceTypes.last;

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF303644),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              title: const Text('Save Ride'),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Place name',
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintText: 'Home, Clinic, Office...',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      address,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _savedPlaceTypes.map((type) {
                        final isSelected = selectedType == type;
                        return ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (_) {
                            setDialogState(() {
                              selectedType = type;
                            });
                          },
                          selectedColor: const Color(0xFFCE0000),
                          backgroundColor: Colors.white10,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      showCustomSnackBar(
                        'Place name is required',
                        isError: true,
                      );
                      return;
                    }
                    Navigator.of(
                      dialogContext,
                    ).pop({'name': name, 'type': selectedType});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCE0000),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    return result;
  }

  Future<void> _handleSaveRide() async {
    if (_isSavingRide) return;

    if (!authController.isLoggedIn()) {
      final shouldLogin = await _showLoginRequiredDialog();
      if (shouldLogin) {
        Get.to(() => const UserLoginScreen());
      }
      return;
    }

    final destination = locationController.destinationLocation.value;
    final address = locationController.destinationAddress.value.trim();

    if (destination == null || address.isEmpty) {
      showCustomSnackBar(
        'Unable to save ride',
        subMessage: 'Select a valid destination before saving this ride.',
        isError: true,
      );
      return;
    }

    final existingSavedPlaces =
        homeController.getSavedPlacesResponseModel.data ?? [];
    final alreadySaved = existingSavedPlaces.any(
      (place) => place.address.trim().toLowerCase() == address.toLowerCase(),
    );
    if (alreadySaved) {
      showCustomSnackBar('This place is already saved', isError: false);
      return;
    }

    final saveDetails = await _showSaveRideDialog(address);
    if (saveDetails == null) return;

    setState(() {
      _isSavingRide = true;
    });

    await homeController.addSavedPlaces(
      saveDetails['name']!,
      address,
      destination.latitude,
      destination.longitude,
      saveDetails['type']!,
    );

    if (!mounted) return;

    final response = homeController.addSavedPlacesResponseModel;
    if (response.success == true) {
      await homeController.getSavedPlaces();
      showCustomSnackBar(
        response.message ?? 'Ride saved successfully',
        isError: false,
      );
    } else {
      showCustomSnackBar(
        response.message ?? 'Failed to save ride',
        isError: true,
      );
    }

    if (mounted) {
      setState(() {
        _isSavingRide = false;
      });
    }
  }

  Future<bool> _handlePaymentSelection() async {
    if (_selectedPaymentType == null) {
      showCustomSnackBar(
        'Select a payment method',
        subMessage: 'Choose Wallet or Cash before continuing.',
        isError: true,
      );
      return false;
    }

    if (_selectedPaymentType == 'Cash') {
      final shouldSwitchToWallet = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: const Color(0xFF303644),
          title: const Text('Cash Payment Coming Soon'),
          content: const Text(
            'Cash payments will be available in an upcoming update. Please use Wallet to continue this ride.',
          ),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Not now'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE0000),
                foregroundColor: Colors.white,
              ),
              child: const Text('Use Wallet'),
            ),
          ],
        ),
        barrierDismissible: true,
      );

      if (shouldSwitchToWallet == true) {
        _onProfileSelected('Wallet');
        return true;
      }
      return false;
    }

    return true;
  }

  void _handleContinueToWallet() async {
    final canContinue = await _handlePaymentSelection();
    if (!canContinue) return;

    final fare =
        widget.rideBookingInfoFromResponse?.data?.totalFare ??
        _calculatePriceValue().toStringAsFixed(2);

    print("Fare: wallet screen: $fare");
    final driverId =
        widget.selectedDriver?.driver.id ??
        bookingController.currentBooking.value?.driverId ??
        bookingController.driver.value?.id;
    final stripeDriverId = widget.selectedDriver?.driver.payoutAccountId;

    if (driverId == null || stripeDriverId == null) {
      showCustomSnackBar(
        'Unable to continue',
        subMessage: 'Missing driver payment information.',
      );
      return;
    }

    Get.to(
      () => WalletScreen(
        rideId: widget.rideBookingInfoFromResponse?.data?.rideId ?? "",
        rideAmount: fare,
        driverId: driverId,
        stripeDriverId: stripeDriverId,
        selectedDriver: widget.selectedDriver,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showCustomSnackBar("${widget.snackberMessage}", isError: false);
      }
    });
  }

  Widget _buildProfileOption({
    required String type,
    required String description,
    required String imagePath,
  }) {
    final isSelected = _selectedPaymentType == type;
    const contentScale = 0.9;

    return GestureDetector(
      onTap: () => _onProfileSelected(type),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8 * contentScale),
        padding: EdgeInsets.symmetric(
          vertical: 8 * contentScale,
          horizontal: 16 * contentScale,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.context(context).primaryColor.withValues(alpha: 0.08)
              : Colors.white12,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.context(context).primaryColor
                : Colors.grey.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16 * contentScale),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.context(
                        context,
                      ).primaryColor.withValues(alpha: 0.1)
                    : Colors.white12,
              ),
              child: Image.asset(imagePath, height: 30, width: 30),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: 16 * contentScale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4 * contentScale),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14 * contentScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isCommissionActive(Commission? commission) {
    if (commission == null) return false;
    if (commission.isActive == false) return false;
    if (commission.status != null && commission.status != 'active') {
      return false;
    }
    final now = DateTime.now();
    if (commission.startDate != null && now.isBefore(commission.startDate!)) {
      return false;
    }
    if (commission.endDate != null && now.isAfter(commission.endDate!)) {
      return false;
    }
    return commission.commission != null &&
        commission.commission!.toDouble() > 0;
  }

  double _applyCommissionDiscount(
    double originalPrice,
    Commission? commission,
  ) {
    if (!_isCommissionActive(commission)) return originalPrice;
    final discountValue = commission!.commission!.toDouble();
    final discountType = commission.discountType?.toLowerCase().trim();

    double discountedPrice;
    if (discountType == 'percentage') {
      discountedPrice = originalPrice * (1 - (discountValue / 100));
    } else {
      discountedPrice = originalPrice - discountValue;
    }

    return discountedPrice < 0 ? 0 : discountedPrice;
  }

  double _calculateOriginalPriceValue() {
    if (widget.selectedDriver == null) {
      return bookingController.estimatedPrice.value;
    }
    final service = widget.selectedDriver!.service;
    final distance = locationController.distance.value;
    double price =
        (service?.baseFare.toDouble() ?? 0.00) +
        (distance * (service?.perKmRate.toDouble() ?? 0.00));
    if ((service?.minimumFare ?? 0) > 0 &&
        price < (service?.minimumFare ?? 0)) {
      price = service?.minimumFare.toDouble() ?? 0.00;
    }
    return double.parse(price.toStringAsFixed(2));
  }

  double _calculatePriceValue() {
    final originalPrice = _calculateOriginalPriceValue();
    final discountedPrice = _applyCommissionDiscount(
      originalPrice,
      widget.selectedDriver?.commission,
    );
    return double.parse(discountedPrice.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const contentScale = 0.9;
    final horizontalPadding = 20.0 * contentScale;
    final topPadding = 10.0 * contentScale;
    final sectionGap = 16.0 * contentScale;
    final largeGap = 20.0 * contentScale;
    final avatarRadius = 30.0 * contentScale;
    final vehicleImageWidth = 80.0 * contentScale;
    final actionButtonHeight = 51.0 * contentScale;
    final actionButtonFontSize = 18.0 * contentScale;
    final actionIconSize = 32.0 * contentScale;
    final saveButtonHeight = 36.0 * contentScale;
    final saveButtonWidth = 100.0 * contentScale;
    final saveButtonFontSize = 13.0 * contentScale;
    final titleFontSize = 15.0 * contentScale;
    final driverNameFontSize = 18.0 * contentScale;
    final secondaryIconSize = 16.0 * contentScale;
    final ratingFontSize = 14.0 * contentScale;
    final detailFontSize = 12.0 * contentScale;
    final priceFontSize = 16.0 * contentScale;
    final strikePriceFontSize = 12.0 * contentScale;
    final floatingButtonSize = 50.0;
    final originalPriceValue = _calculateOriginalPriceValue();
    final discountedPriceValue = _calculatePriceValue();
    final responsePriceValue = double.tryParse(
      widget.rideBookingInfoFromResponse?.data?.totalFare ?? '',
    );
    final effectivePriceValue = responsePriceValue ?? discountedPriceValue;
    final hasDiscount = effectivePriceValue < originalPriceValue;
    // print("price check: ${widget.rideBookingInfoFromResponse?.data?.totalFare}");
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              locationController.setMapController(controller);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (locationController.currentLocation.value != null) {
                  controller.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      locationController.currentLocation.value!,
                      14.0,
                    ),
                  );
                }
              });
            },
            initialCameraPosition: _initialPosition,
            markers: locationController.markers,
            polylines: locationController.polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            zoomControlsEnabled: true,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            onTap: (LatLng position) {
              locationController.setDestinationLocation(position);
            },
          ),

          // Back button
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),

          // Re-center button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.30,
            right: 20,
            child: GestureDetector(
              onTap: () {
                if (locationController.currentLocation.value != null &&
                    locationController.mapController.value != null) {
                  locationController.mapController.value!.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      locationController.currentLocation.value!,
                      14.0,
                    ),
                  );
                }
              },
              child: Container(
                width: floatingButtonSize,
                height: floatingButtonSize,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.my_location, color: Colors.white, size: 30),
              ),
            ),
          ),

          // BOTTOM SHEET
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * _sheetHeightFactor,
              padding: EdgeInsets.only(
                top: topPadding,
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: MediaQuery.of(context).padding.bottom + topPadding,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF303644),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Obx(
                    () => Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Get.back(),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Your driver is coming...',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleFontSize,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            NormalCustomButton(
                              text: _isSavingRide ? "Saving..." : "Save Ride",
                              height: saveButtonHeight,
                              weight: saveButtonWidth,
                              fontSize: saveButtonFontSize,
                              onPressed: _handleSaveRide,
                            ),
                          ],
                        ),
                        SizedBox(height: largeGap),
                        Divider(color: Colors.grey[700], thickness: 0.5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8 * contentScale,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: avatarRadius,
                                backgroundImage: widget.selectedDriver == null
                                    ? const AssetImage(
                                        'assets/images/user6.png',
                                      )
                                    : null,
                                backgroundColor: Colors.grey,
                                child: widget.selectedDriver != null
                                    ? Text(
                                        (widget
                                                    .selectedDriver!
                                                    .driver
                                                    .userId
                                                    ?.fullName ??
                                                'U')[0]
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18 * contentScale,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                              SizedBox(width: 12 * contentScale),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget
                                              .selectedDriver
                                              ?.driver
                                              .userId
                                              ?.fullName ??
                                          'Max Johnson',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: driverNameFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8 * contentScale),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.white,
                                          size: secondaryIconSize,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${locationController.distance.value.toStringAsFixed(1)} Miles",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: detailFontSize,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4 * contentScale),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: secondaryIconSize,
                                        ),
                                        SizedBox(width: 5 * contentScale),
                                        Text(
                                          widget.selectedDriver != null
                                              ? widget
                                                    .selectedDriver!
                                                    .driver
                                                    .ratings
                                                    .average
                                                    .toStringAsFixed(1)
                                              : "4.9",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ratingFontSize,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          " (${widget.selectedDriver?.driver.ratings.totalRatings ?? 127})",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: detailFontSize,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              (widget.selectedDriver?.service?.serviceImage
                                          ?.trim()
                                          .isNotEmpty ??
                                      false)
                                  ? Image.network(
                                      widget
                                          .selectedDriver!
                                          .service!
                                          .serviceImage!,
                                      width: vehicleImageWidth,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        'assets/images/privet_car.png',
                                        width: vehicleImageWidth,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/images/privet_car.png',
                                      width: vehicleImageWidth,
                                      fit: BoxFit.contain,
                                    ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey[700], thickness: 0.5),
                        SizedBox(height: largeGap),
                        _buildProfileOption(
                          type: "Cash",
                          description: "Available in an upcoming update",
                          imagePath: 'assets/icons/dollarIcon.png',
                        ),
                        _buildProfileOption(
                          type: "Wallet",
                          description: "Balance: \$45.50",
                          imagePath: 'assets/icons/walletIocn.png',
                        ),
                        SizedBox(height: sectionGap),
                        // Row(
                        //   children: [
                        //     SizedBox(
                        //       height: 51,
                        //       width: size.width * 0.7,
                        //       child: TextField(
                        //         decoration: InputDecoration(
                        //           filled: true,
                        //           fillColor: Colors.white12,
                        //           hintText: 'Enter coupon code',
                        //           hintStyle: const TextStyle(
                        //             color: Colors.white54,
                        //           ),
                        //           border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(8),
                        //             borderSide: BorderSide.none,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     NormalCustomButton(
                        //       height: 51,
                        //       weight: size.width * 0.2,
                        //       text: "Apply",
                        //       onPressed: () {},
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 20),
                        Divider(color: Colors.grey[700], thickness: 1.5),
                        Container(
                          padding: EdgeInsets.all(15 * contentScale),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (hasDiscount)
                                Text(
                                  '\$${originalPriceValue.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: strikePriceFontSize,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: priceFontSize,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "\$${effectivePriceValue.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: priceFontSize,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: sectionGap),

                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: NormalCustomIconButton(
                                  icon: Icons.messenger_outline,
                                  iconSize: actionIconSize,
                                  onPressed: () {
                                    Get.to(
                                      () => ChatScreenRTH(
                                        selectedDriver: widget.selectedDriver,
                                        rideBookingInfoFromResponse:
                                            widget.rideBookingInfoFromResponse,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 12 * contentScale),
                            Expanded(
                              flex: 2,
                              child: NormalCustomButton(
                                height: actionButtonHeight,
                                weight: double.infinity,
                                fontSize: actionButtonFontSize,
                                circularRadious: 30,
                                text: "Continue",
                                onPressed: _handleContinueToWallet,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Loading indicator (wrapped properly)
          Obx(() {
            return appController.isLoading.value
                ? Container(
                    color: Colors.black54,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            ShimmerCircle(size: 32),
                            SizedBox(height: 12),
                            ShimmerLine(width: 180, height: 14),
                            SizedBox(height: 8),
                            ShimmerLine(width: 240, height: 12),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
