import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/home/domain/reponse_model/get_search_destination_for_find_Nearest_drivers_response_model.dart';
import 'package:rideztohealth/helpers/custom_snackbar.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/normal_custom_button.dart';
import '../../../../core/widgets/normal_custom_icon_button.dart';
import '../../../home/domain/reponse_model/request_ride_response_model.dart';
import '../../../profileAndHistory/presentation/screens/wallet_screen.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/locaion_controller.dart';
import 'call_screen.dart';
import 'chat_screen.dart';
// import 'chat_screen.dart'; // Uncomment if you use these
// import 'call_screen.dart'; // Uncomment if you use these
// import 'payment_screen.dart'; // Uncomment if you use these// Import the new search screen

// ignore: use_key_in_widget_constructors
class RideConfirmedScreen extends StatefulWidget {
  const RideConfirmedScreen({
  Key? key,
  this.selectedDriver, 
  this.rideBookingInfoFromResponse
  }) : super(key: key);

  final NearestDriverData? selectedDriver;
    final RequestRideResponseModel ? rideBookingInfoFromResponse;

  @override
  State<RideConfirmedScreen> createState() => _RideConfirmedScreenState();
}

class _RideConfirmedScreenState extends State<RideConfirmedScreen> {
  final LocationController locationController = Get.find<LocationController>();

  final BookingController bookingController = Get.find<BookingController>();

  final AppController appController = Get.find<AppController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125), // Default to Dhaka, Bangladesh
    zoom: 14.0,
  );

  final _formKey = GlobalKey<FormState>();

  String? _selectedPaymentType;

  bool _showProfileError = false;

  // Bottom sheet height control
  static const double _sheetHeightFactor = 0.7; // default 60%; tweak as needed

  void _onProfileSelected(String profileType) {
    setState(() {
      _selectedPaymentType = profileType;
      _showProfileError = false;
    });
  }

  Widget _buildProfileOption({
    required String type,
    required String description,
    required String imagePath,
  }) {
    final isSelected = _selectedPaymentType == type;

    return GestureDetector(
      onTap: () => _onProfileSelected(type),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              // ignore: deprecated_member_use
              ? AppColors.context(context).primaryColor.withOpacity(0.08)
              : Colors.white12,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.context(context).primaryColor
                : Colors.grey.withOpacity(0.07),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.context(context).primaryColor.withOpacity(0.1)
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
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

  double _calculatePriceValue() {
    if (widget.selectedDriver == null) {
      return bookingController.estimatedPrice.value;
    }
    final service = widget.selectedDriver!.service;
    final distance = locationController.distance.value;
    double price =
        service.baseFare.toDouble() + (distance * service.perKmRate.toDouble());
    if (service.minimumFare > 0 && price < service.minimumFare) {
      price = service.minimumFare.toDouble();
    }
    return double.parse(price.toStringAsFixed(2));
  }

  String _calculatedPrice() {
    final price = _calculatePriceValue();
    return "\$${price.toStringAsFixed(2)}";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                padding: EdgeInsets.all(8),
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
                width: 50,
                height: 50,
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
              height:
                  MediaQuery.of(context).size.height *
                  _sheetHeightFactor, // change factor to adjust default height
              padding: EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).padding.bottom + 10,
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
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                          Text(
                            'Your driver is coming in ${widget.selectedDriver?.service.estimatedArrivalTime ?? 3} min',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.grey[700], thickness: 0.5),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: widget.selectedDriver == null
                                  ? const AssetImage('assets/images/user6.png')
                                  : null,
                              backgroundColor: Colors.grey,
                              child: widget.selectedDriver != null
                                  ? Text(
                                      widget
                                          .selectedDriver!
                                          .driver
                                          .userId
                                          .fullName[0]
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget
                                            .selectedDriver
                                            ?.driver
                                            .userId
                                            .fullName ??
                                        'Max Johnson',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      "${locationController.distance.value.toStringAsFixed(1)}km"
                                          .text12White(),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      SizedBox(width: 5),
                                      (widget.selectedDriver != null
                                              ? widget
                                                    .selectedDriver!
                                                    .driver
                                                    .ratings
                                                    .average
                                                    .toStringAsFixed(1)
                                              : "4.9")
                                          .text14White(),
                                      " ("
                                              "${widget.selectedDriver?.driver.ratings.totalRatings ?? 127}"
                                              ")"
                                          .text12Grey(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            widget.selectedDriver != null
                                ? Image.network(
                                    widget.selectedDriver!.service.serviceImage,
                                    width: 80,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/privet_car.png',
                                      width: 80,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/privet_car.png',
                                    width: 80,
                                    fit: BoxFit.contain,
                                  ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey[700], thickness: 0.5),
                      SizedBox(height: 20),
                      _buildProfileOption(
                        type: "Cash",
                        description: "Pay with cash after your ride",
                        imagePath: 'assets/icons/dollarIcon.png',
                      ),
                      _buildProfileOption(
                        type: "Wallet",
                        description: "Balance: \$45.50",
                        imagePath: 'assets/icons/walletIocn.png',
                      ),
                      SizedBox(height: 20),
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
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "Total".text16White500(),
                            _calculatedPrice().text16White500(),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          // Expanded(
                          //   flex: 1,
                          //   child: NormalCustomIconButton(
                          //     icon: Icons.call_outlined,
                          //     iconSize: 25,
                          //     onPressed: () {
                          //       Get.to(CallScreen());
                          //     },
                          //   ),
                          // ),
                          SizedBox(width: 15),
                          SizedBox(
                            width: size.width * 0.4,
                            child: NormalCustomIconButton(
                              icon: Icons.messenger_outline,
                              iconSize: 32,
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
                          SizedBox(width: 15),
                          // Expanded(
                          //   flex: 3,
                          //   child: SmallSemiTranparentButton(
                          //     fillColor: Color(0xffBFC1C5),
                          //     height: 51,
                          //     fontSize: 18,
                          //     circularRadious: 30,
                          //     textColor: Colors.black,
                          //     text: "Cancel Ride",
                          //     onPressed: () {
                          //       // Handle cancel
                          //     },
                          //   ),
                          // ),
                          SizedBox(width: 8),
                          SizedBox(
                            width: size.width * 0.4,
                            child: NormalCustomButton(
                              height: 51,
                              weight: size.width * 0.4, // or double.infinity
                              fontSize: 18,
                              circularRadious: 30,
                              text: "Continue",
                              onPressed: () {
                                final fare = _calculatePriceValue();
                                final driverId =
                                    widget.selectedDriver?.driver.id ??
                                    bookingController
                                        .currentBooking
                                        .value
                                        ?.driverId ??
                                    bookingController.driver.value?.id;
                                final stripeDriverId = widget
                                    .selectedDriver
                                    ?.driver
                                    .payoutAccountId;

                                if (driverId == null ||
                                    stripeDriverId == null) {
                                  showCustomSnackBar(
                                    'Unable to continue',
                                    subMessage:
                                        'Missing driver payment information.',
                                  );
                                  return;
                                }

                                Get.to(
                                  () => WalletScreen(
                                    
                                    rideAmount: fare,
                                    driverId: driverId,
                                    stripeDriverId: stripeDriverId, 
                                    selectedDriver: widget.selectedDriver ,

                                  ),
                                );
                              },
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

          // Loading indicator (wrapped properly)
          Obx(() {
            return appController.isLoading.value
                ? Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    ),
                  )
                : SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
