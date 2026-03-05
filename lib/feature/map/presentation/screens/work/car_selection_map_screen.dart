import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/widgets/shimmer/shimmer_skeleton.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideztohealth/core/widgets/wide_custom_button.dart';
import 'package:rideztohealth/feature/home/controllers/home_controller.dart';
import 'package:rideztohealth/feature/home/domain/reponse_model/get_search_destination_for_find_Nearest_drivers_response_model.dart';
import '../../../../../utils/display_helper.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/booking_controller.dart';
import '../../../controllers/locaion_controller.dart';
import 'confirm_location_map_screen.dart';

class CarSelectionMapScreen extends StatefulWidget {
  CarSelectionMapScreen({super.key, this.isshowCancelRideStatus = false});
  bool isshowCancelRideStatus;
  @override
  State<CarSelectionMapScreen> createState() => _CarSelectionMapScreenState();
}

class _CarSelectionMapScreenState extends State<CarSelectionMapScreen> {
  final LocationController locationController = Get.find<LocationController>();

  late HomeController homeController;
  final BookingController bookingController = Get.find<BookingController>();

  final AppController appController = Get.find<AppController>();

  final RxString currentLocation = ''.obs;

  // Bottom sheet height control (adjust default to change initial height)
  static const double _sheetInitialSize = 0.45; // 40% height by default

  List<NearestDriverData> _latestNearbyDrivers = [];
  NearestDriverData? _selectedDriver;

  // Calculate estimated time based on distance
  String _calculateEstimatedTime(double distanceInMile) {
    // Assuming average speed of 30 km/h in city
    double hours = distanceInMile / 30;
    int minutes = (hours * 60).round();

    if (minutes < 1) {
      return '1 min';
    } else if (minutes < 60) {
      return '$minutes min';
    } else {
      int hrs = minutes ~/ 60;
      int mins = minutes % 60;
      return '${hrs}h ${mins}min';
    }
  }

  // Calculate estimated price based on distance
  double _calculateEstimatedPriceValue(
    double distanceInMile, {
    num? baseFare,
    num? perKmRate,
    num? minimumFare,
  }) {
    // Base fare + per km rate with graceful defaults
    final double resolvedBaseFare = (baseFare ?? 5).toDouble();
    final double resolvedPerKmRate = (perKmRate ?? 2.5).toDouble();
    double price = resolvedBaseFare + (distanceInMile * resolvedPerKmRate);

    // Respect minimum fare when provided
    if (minimumFare != null) {
      price = price < minimumFare ? minimumFare.toDouble() : price;
    }

    return price;
  }

  bool _isCommissionActive(Commission? commission) {
    if (commission == null) return false;
    if (commission.isActive == false) return false;
    if (commission.status != null && commission.status != 'active') {
      return false;
    }
    final now = DateTime.now();
    if (commission.startDate != null &&
        now.isBefore(commission.startDate!)) {
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

  @override
  void initState() {
    super.initState();
    homeController = Get.find<HomeController>();
    locationController.getCurrentLocation().then((value) {
      getCarData();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.isshowCancelRideStatus
          ? showCustomSnackBar("Ride cancelled successfully", isError: false)
          : null;
    });

    print(
      "Time format korar por :${_calculateEstimatedTime(locationController.distance.value)}\n",
    );
    print(
      " format korar age :${locationController.distance.value}\n",
    );

    // 1. Call the function to get current location
    // locationController.getCurrentLocation();
    // homeController = Get.find<HomeController>();
    //   print("this is for print forom car selection 00000000000000");
    // 2. React to changes in currentLocation
  }

  @override
  void dispose() {
    locationController.clearMapController();
    super.dispose();
  }

  void getCarData() async {
    final current = locationController.currentLocation.value;
    if (current != null) {
      debugPrint(
        " CarSelectionMapScreen: fetching nearby drivers for ${current.latitude}, ${current.longitude}",
      );
      try {
        await homeController.getSearchDestinationForFindNearestDrivers(
          current.latitude.toString(),
          current.longitude.toString(),
        );
      } catch (e) {
        print(
          "⚠️ Error fetching CarSelectionMapScreen : getSearchDestinationForFindNearestDrivers : $e\n",
        );
      }
    } else {
      debugPrint("location are not found");
    }
    //   ever(locationController.currentLocation, (LatLng? loc)async {
    //   if (loc != null) {
    //           print("this is for print forom car selection 99999999999999");
    //    await homeController.getSearchDestinationForFindNearestDrivers(

    //       loc.latitude.toString(),
    //       loc.longitude.toString(),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pickup = locationController.pickupLocation.value;
      final destination = locationController.destinationLocation.value;
      final current = locationController.currentLocation.value;

      // Priority: pickup -> destination -> current -> Dhaka center
      final LatLng initialTarget =
          pickup ?? destination ?? current ?? const LatLng(23.8103, 90.4125);

      final CameraPosition initialCameraPosition = CameraPosition(
        target: initialTarget,
        zoom: 14.0,
      );

      return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialCameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: locationController.markers.toSet(),
              polylines: locationController.polylines.toSet(),
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
              onMapCreated: (GoogleMapController controller) {
                locationController.setMapController(controller);

                if (pickup != null && destination != null) {
                  // Fit both markers in view
                  Future.delayed(const Duration(milliseconds: 400), () {
                    LatLngBounds bounds = LatLngBounds(
                      southwest: LatLng(
                        pickup.latitude < destination.latitude
                            ? pickup.latitude
                            : destination.latitude,
                        pickup.longitude < destination.longitude
                            ? pickup.longitude
                            : destination.longitude,
                      ),
                      northeast: LatLng(
                        pickup.latitude > destination.latitude
                            ? pickup.latitude
                            : destination.latitude,
                        pickup.longitude > destination.longitude
                            ? pickup.longitude
                            : destination.longitude,
                      ),
                    );

                    controller.animateCamera(
                      CameraUpdate.newLatLngBounds(bounds, 100),
                    );
                  });
                } else {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(initialCameraPosition),
                  );
                }
              },
              onTap: (LatLng position) {
                // User taps map to change destination
                locationController.setDestinationLocation(position);
                // No need to call _calculateDistance manually:
                // everAll in LocationController will regenerate polyline + distance
              },
            ),

            // Top-left Back button
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),

            // Current location button
            // Current location button
            Positioned(
              top: MediaQuery.of(context).size.height * 0.45,
              right: 20,
              child: GestureDetector(
                onTap: () async {
                  // 🔹 Force-refresh current location
                  await locationController.getCurrentLocation();

                  if (locationController.currentLocation.value != null) {
                    // Pickup = current GPS again (in case it changed)
                    locationController.setPickupLocation(
                      locationController.currentLocation.value!,
                    );

                    // Camera to current location
                    locationController.mapController.value?.animateCamera(
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
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),

            // Bottom Sheet (draggable, defaults to 40% height)
            DraggableScrollableSheet(
              initialChildSize: _sheetInitialSize,
              minChildSize: 0.45,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).padding.bottom + 10,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E2E38),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 5,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Set Ride',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 24),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Distance and time info
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Distance',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Obx(
                                    () => Text(
                                      '${locationController.distance.value.toStringAsFixed(1)} Miles',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey[700],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Est. Time',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Obx(
                                    () => Text(
                                      _calculateEstimatedTime(
                                        locationController.distance.value,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        GetBuilder<HomeController>(
                          builder: (homeController) {
                            final isBusy =
                                homeController.isLoading ||
                                locationController.currentLocation.value ==
                                    null;

                            if (isBusy) {
                              return _buildDriverLoadingShimmer();
                            }

                            final model = homeController
                                .getSearchDestinationForFindNearestDriversResponseModel;
                            final nearbyDrivers = model.data ?? [];
                            _latestNearbyDrivers = nearbyDrivers;

                            final selectedDriverId =
                                _selectedDriver?.driver?.id;
                            final selectedStillExists =
                                selectedDriverId != null &&
                                nearbyDrivers.any(
                                  (driver) =>
                                      driver.driver.id == selectedDriverId,
                                );

                            if (nearbyDrivers.length == 1) {
                              // Auto-pick when only one option exists.
                              _selectedDriver = nearbyDrivers.first;
                            } else if (!selectedStillExists) {
                              // Require an explicit tap when multiple cars are available.
                              _selectedDriver = null;
                            }

                            if (nearbyDrivers.isEmpty) {
                              return const Center(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      "No nearby drivers found",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: nearbyDrivers.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final data = nearbyDrivers[index];
                                final vehicle = data.vehicle;
                                final driver = data.driver;
                                final user = driver.userId;
                                final service = data.service;

                                final carName =
                                    (service?.name.trim().isNotEmpty ?? false)
                                    ? service!.name
                                    : vehicle?.model ?? "Unknown Car";
                                final driverName = user?.fullName;
                                final carDetails =
                                    "${vehicle?.taxiName ?? 'TAXI'} • Plate ${vehicle?.plateNumber ?? 'N/A'}";
                                final carImage = service?.serviceImage ?? "";
                                final originalPriceValue =
                                    _calculateEstimatedPriceValue(
                                      locationController.distance.value,
                                      baseFare: service?.baseFare,
                                      perKmRate: service?.perKmRate,
                                      minimumFare: service?.minimumFare,
                                    );
                                final discountedPriceValue =
                                    _applyCommissionDiscount(
                                      originalPriceValue,
                                      data.commission,
                                    );
                                final hasDiscount =
                                    discountedPriceValue < originalPriceValue;
                                final price = (hasDiscount
                                        ? discountedPriceValue
                                        : originalPriceValue)
                                    .toStringAsFixed(2);
                                final originalPrice =
                                    originalPriceValue.toStringAsFixed(2);
                                final rating = driver.ratings.average
                                    .toStringAsFixed(1);
                                final isSelected =
                                    _selectedDriver?.driver.id ==
                                    data.driver.id;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedDriver = data;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white24
                                          : Colors.white10,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.redAccent
                                            : Colors.transparent,
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Vehicle Image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: (carImage.trim().isEmpty)
                                              ? Image.asset(
                                                  'assets/images/privet_car.png',
                                                  height: 60,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  carImage,
                                                  height: 60,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) {
                                                    return Image.asset(
                                                      'assets/images/privet_car.png',
                                                      height: 60,
                                                      width: 80,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                        ),
                                        const SizedBox(width: 15),

                                        // Vehicle + Driver Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                carName,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                carDetails,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Driver: $driverName • ⭐ $rating",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            if (hasDiscount)
                                              Text(
                                                '\$$originalPrice',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                            Text(
                                              '\$$price',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),

                                            Obx(
                                              () => Text(
                                                _calculateEstimatedTime(
                                                  locationController
                                                      .distance
                                                      .value,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            // Text(
                                            //   eta,
                                            //   style: const TextStyle(
                                            //     color: Colors.grey,
                                            //     fontSize: 12,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 2),

                        if (_latestNearbyDrivers.length > 1 &&
                            _selectedDriver == null)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Select a car to enable the button',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ),

                        WideCustomButton(
                          text: 'Choose car',
                          enabled: _selectedDriver != null,
                          isLoading: appController.isLoading.value,
                          onPressed: () {
                            if (_selectedDriver == null &&
                                _latestNearbyDrivers.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select a car to continue',
                                  ),
                                ),
                              );
                              return;
                            }

                            final chosen =
                                _selectedDriver ??
                                (_latestNearbyDrivers.isNotEmpty
                                    ? _latestNearbyDrivers.first
                                    : null);
                            if (chosen == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select a car to continue',
                                  ),
                                ),
                              );
                              return;
                            }

                            appController.setCurrentScreen('confirm');
                            Get.to(
                              () => ConfirmYourLocationScreen(
                                selectedDriver: chosen,
                              ),
                            );
                          },
                        ),

                        // Choose car button
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       if (_selectedDriver == null &&
                        //           _latestNearbyDrivers.isEmpty) {
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           const SnackBar(
                        //             content:
                        //                 Text('Please select a car to continue'),
                        //           ),
                        //         );
                        //         return;
                        //       }

                        //       final chosen = _selectedDriver ??
                        //           (_latestNearbyDrivers.isNotEmpty
                        //               ? _latestNearbyDrivers.first
                        //               : null);
                        //       if (chosen == null) {
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           const SnackBar(
                        //             content:
                        //                 Text('Please select a car to continue'),
                        //           ),
                        //         );
                        //         return;
                        //       }

                        //       appController.setCurrentScreen('confirm');
                        //       Get.to(
                        //         () => ConfirmYourLocationScreen(
                        //           selectedDriver: chosen,
                        //         ),
                        //       );
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: const Color(0xFFC0392B),
                        //       padding: const EdgeInsets.symmetric(vertical: 15),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //     ),
                        //     child: const Text(
                        //       'Choose car',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Loading overlay
            if (appController.isLoading.value)
              Container(
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
              ),
          ],
        ),
      );
    });
  }

  Widget _buildDriverLoadingShimmer() {
    return Column(
      children: [
        const SizedBox(height: 12),
        _buildDriverCardShimmer(),
        const SizedBox(height: 12),
        _buildDriverCardShimmer(),
        const SizedBox(height: 12),
        _buildDriverCardShimmer(),
      ],
    );
  }

  Widget _buildDriverCardShimmer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Row(
        children: const [
          ShimmerBox(
            width: 80,
            height: 60,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLine(width: 160, height: 14),
                SizedBox(height: 6),
                ShimmerLine(width: 140, height: 12),
                SizedBox(height: 6),
                ShimmerLine(width: 120, height: 12),
              ],
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerLine(width: 50, height: 14),
              SizedBox(height: 6),
              ShimmerLine(width: 40, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../../controllers/app_controller.dart';
// import '../../../controllers/booking_controller.dart';
// import '../../../controllers/locaion_controller.dart';
// import 'confirm_location_map_screen.dart';

// class CarSelectionMapScreen extends StatelessWidget {
//   final LocationController locationController = Get.find<LocationController>();
//   final BookingController bookingController = Get.find<BookingController>();
//   final AppController appController = Get.find<AppController>();

//   static const CameraPosition _initialPosition = CameraPosition(
//     target: LatLng(37.7749, -122.4194),
//     zoom: 14.0,
//   );

//   // Calculate estimated time based on distance
//   String _calculateEstimatedTime(double distanceInMile) {
//     // Assuming average speed of 30 km/h in city
//     double hours = distanceInMile / 30;
//     int minutes = (hours * 60).round();
    
//     if (minutes < 1) {
//       return '1 min';
//     } else if (minutes < 60) {
//       return '$minutes min';
//     } else {
//       int hrs = minutes ~/ 60;
//       int mins = minutes % 60;
//       return '${hrs}h ${mins}min';
//     }
//   }

//   // Calculate estimated price based on distance
//   String _calculateEstimatedPrice(double distanceInMile) {
//     // Base fare + per km rate
//     double baseFare = 5.0;
//     double perKmRate = 2.5;
//     double price = baseFare + (distanceInMile * perKmRate);
//     return price.toStringAsFixed(2);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(
//         () => Stack(
//           children: [
//             GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 locationController.setMapController(controller);
                
//                 // Fit both markers in view
//                 if (locationController.pickupLocation.value != null &&
//                     locationController.destinationLocation.value != null) {
//                   Future.delayed(Duration(milliseconds: 500), () {
//                     LatLng pickup = locationController.pickupLocation.value!;
//                     LatLng destination = locationController.destinationLocation.value!;
                    
//                     LatLngBounds bounds = LatLngBounds(
//                       southwest: LatLng(
//                         pickup.latitude < destination.latitude
//                             ? pickup.latitude
//                             : destination.latitude,
//                         pickup.longitude < destination.longitude
//                             ? pickup.longitude
//                             : destination.longitude,
//                       ),
//                       northeast: LatLng(
//                         pickup.latitude > destination.latitude
//                             ? pickup.latitude
//                             : destination.latitude,
//                         pickup.longitude > destination.longitude
//                             ? pickup.longitude
//                             : destination.longitude,
//                       ),
//                     );
                    
//                     controller.animateCamera(
//                       CameraUpdate.newLatLngBounds(bounds, 100),
//                     );
//                   });
//                 }
//               },
//               initialCameraPosition: _initialPosition,
//               markers: locationController.markers,
//               polylines: locationController.polylines,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: false,
//               onTap: (LatLng position) {
//                 locationController.setDestinationLocation(position);
//                 locationController.generatePolyline();
//               },
//             ),

//             // Back button
//             Positioned(
//               top: 50,
//               left: 20,
//               child: GestureDetector(
//                 onTap: () => Get.back(),
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.arrow_back, color: Colors.black),
//                 ),
//               ),
//             ),

//             // Current location button
//             Positioned(
//               top: MediaQuery.of(context).size.height * 0.45,
//               right: 20,
//               child: GestureDetector(
//                 onTap: () {
//                   if (locationController.currentLocation.value != null) {
//                     locationController.mapController.value?.animateCamera(
//                       CameraUpdate.newLatLngZoom(
//                         locationController.currentLocation.value!,
//                         14.0,
//                       ),
//                     );
//                   }
//                 },
//                 child: Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.my_location,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ),

//             // Bottom Sheet
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: EdgeInsets.only(
//                   top: 10,
//                   left: 20,
//                   right: 20,
//                   bottom: MediaQuery.of(context).padding.bottom + 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF2E2E38),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       height: 5,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[700],
//                         borderRadius: BorderRadius.circular(2.5),
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () => Get.back(),
//                           child: Icon(Icons.arrow_back, color: Colors.white),
//                         ),
//                         Text(
//                           'Set Ride',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(width: 24),
//                       ],
//                     ),
//                     SizedBox(height: 20),

//                     // Distance and time info
//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF3B3B42),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Column(
//                             children: [
//                               Text(
//                                 'Distance',
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Obx(() => Text(
//                                 '${locationController.distance.value.toStringAsFixed(1)} km',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               )),
//                             ],
//                           ),
//                           Container(
//                             height: 30,
//                             width: 1,
//                             color: Colors.grey[700],
//                           ),
//                           Column(
//                             children: [
//                               Text(
//                                 'Est. Time',
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Obx(() => Text(
//                                 _calculateEstimatedTime(
//                                   locationController.distance.value,
//                                 ),
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               )),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20),

//                     // Car option 1
//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF3B3B42),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             'assets/images/privet_car.png',
//                             width: 80,
//                             height: 50,
//                             fit: BoxFit.contain,
//                           ),
//                           SizedBox(width: 15),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Copen GR SPORT',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Affordable rides for everyday',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Obx(() => Text(
//                                 '\$${_calculateEstimatedPrice(locationController.distance.value)}',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               )),
//                               Obx(() => Text(
//                                 _calculateEstimatedTime(
//                                   locationController.distance.value,
//                                 ),
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 13,
//                                 ),
//                               )),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20),

//                     // Car option 2
//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF3B3B42),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             'assets/images/texi.png',
//                             width: 80,
//                             height: 50,
//                             fit: BoxFit.contain,
//                           ),
//                           SizedBox(width: 15),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Taxi Service',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Standard taxi service',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Obx(() => Text(
//                                 '\$${(double.parse(_calculateEstimatedPrice(locationController.distance.value)) * 0.9).toStringAsFixed(2)}',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               )),
//                               Obx(() => Text(
//                                 _calculateEstimatedTime(
//                                   locationController.distance.value,
//                                 ),
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 13,
//                                 ),
//                               )),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 30),

//                     // Choose car button
//                     Container(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           appController.setCurrentScreen('confirm');
//                           Get.to(() => ConfirmYourLocationScreen());
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFC0392B),
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Text(
//                           'Choose car',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Loading overlay
//             if (appController.isLoading.value)
//               Container(
//                 color: Colors.black54,
//                 child: Center(
//                   child: CircularProgressIndicator(color: Colors.red),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../../controllers/app_controller.dart';
// import '../../../controllers/booking_controller.dart';
// import '../../../controllers/locaion_controller.dart';
// import 'confirm_location_map_screen.dart';


// class CarSelectionMapScreen extends StatelessWidget {
//   final LocationController locationController = Get.find<LocationController>();
//   final BookingController bookingController = Get.find<BookingController>();
//   final AppController appController = Get.find<AppController>();

//   static const CameraPosition _initialPosition = CameraPosition(
//     target: LatLng(
//       37.7749,
//       -122.4194,
//     ), // Default to San Francisco if no location
//     zoom: 14.0,
//   );

  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(
//         () => Stack(
//           children: [
//             GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 locationController.setMapController(controller);
//                 // Move camera to current location if available
//                 if (locationController.currentLocation.value != null) {
//                   controller.animateCamera(
//                     CameraUpdate.newLatLngZoom(
//                       locationController.currentLocation.value!,
//                       14.0,
//                     ),
//                   );
//                 }
//               },
//               initialCameraPosition: _initialPosition,
//               markers: locationController.markers,
//               polylines: locationController.polylines, // Display polyline
//               myLocationEnabled: true,
//               myLocationButtonEnabled: false,
//               onTap: (LatLng position) {
//                 // Allow changing destination by tapping on the map
//                 locationController.setDestinationLocation(position);
//                 locationController
//                     .generatePolyline(); // Regenerate polyline on destination change
//               },
//             ),

//             // Back button and other controls (as seen in the image - top left)
//             Positioned(
//               top: 50,
//               left: 20,
//               child: GestureDetector(
//                 onTap: () => Get.back(),
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.arrow_back, color: Colors.black),
//                 ),
//               ),
//             ),
//             // Red target icon in the middle right
//             Positioned(
//               top:
//                   MediaQuery.of(context).size.height *
//                   0.45, // Approximately center vertically
//               right: 20,
//               child: GestureDetector(
//                 onTap: () {
//                   // This is a static icon from the screenshot, no specific action implied.
//                   // You might want to assign a function to recenter the map on the destination.
//                 },
//                 child: Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.my_location,
//                     color: Colors.white,
//                     size: 30,
//                   ), // Example icon, adjust as needed
//                 ),
//               ),
//             ),

//             // Bottom Sheet
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: EdgeInsets.only(
//                   top: 10,
//                   left: 20,
//                   right: 20,
//                   bottom: MediaQuery.of(context).padding.bottom + 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF2E2E38), // Dark grey from the image
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       height: 5,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[700],
//                         borderRadius: BorderRadius.circular(2.5),
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () => Get.back(), // Go back to previous screen
//                           child: Icon(Icons.arrow_back, color: Colors.white),
//                         ),
//                         Text(
//                           'Set Ride',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(width: 24), // For alignment
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 15,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(
//                           0xFF3B3B42,
//                         ), // Slightly lighter dark grey
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             'assets/images/privet_car.png', // Replace with your actual image path
//                             width: 80,
//                             height: 50,
//                             fit: BoxFit.contain,
//                           ),
//                           SizedBox(width: 15),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Copen GR SPORT',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Affordable rides for everyday',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 '\$12.50', // Replace with dynamic price from bookingController
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 '5 min away', // Replace with dynamic time from bookingController
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 15,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(
//                           0xFF3B3B42,
//                         ), // Slightly lighter dark grey
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             'assets/images/texi.png', // Replace with your actual image path
//                             width: 80,
//                             height: 50,
//                             fit: BoxFit.contain,
//                           ),
//                           SizedBox(width: 15),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Copen GR SPORT',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Affordable rides for everyday',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 '\$12.50', // Replace with dynamic price from bookingController
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 '5 min away', // Replace with dynamic time from bookingController
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     Container(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Action for "Choose car"
//                           appController.setCurrentScreen('confirm');
//                           Get.to(() => ConfirmYourLocationScreen());
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFC0392B), // Red color
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Text(
//                           'Choose car',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Loading overlay
//             if (appController.isLoading.value)
//               Container(
//                 color: Colors.black54,
//                 child: Center(
//                   child: CircularProgressIndicator(color: Colors.red),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
