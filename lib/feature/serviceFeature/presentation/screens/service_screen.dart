// lib/screens/service_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/home/controllers/home_controller.dart';

import '../../../../core/widgets/promo_banner_widget.dart';


class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  int selectedService = 0;

  // final List<Map<String, dynamic>> services = [
  //   {
  //     'path': 'assets/images/ambolence.png',
  //     'label': 'Non-Emergency Medical Transportation',
  //   },
  //   {
  //     'path': 'assets/images/noaha.png', 'label': 'Taxi'
  //   },
  //   {'path': 'assets/images/taxi_ourService.png', 'label': 'Ride with kids'},
  //   {
  //     'path': 'assets/images/ambolence1.png',
  //     'label': 'Airport pick up & drop off',
  //   },
  //   {
  //     'path': 'assets/images/noaha.png',
  //     'label': 'Wheelchair Accessible Vehicles (WAV)',
  //   },
  //   {
  //     'path': 'assets/images/ambolence1.png',
  //     'label': 'Wheelchair Accessible Vehicles (WAV)',
  //   },
  //   {
  //     'path': 'assets/images/taxi_ourService.png',
  //     'label': 'Wheelchair Accessible Vehicles (WAV)',
  //   },
  // ];


  HomeController homeController = Get.find<HomeController>();


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      homeController.getAllServices();
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder:(homeController){
        final services = homeController.getAllCategoryResponseModel.data ?? [];

      return homeController.isLoading 
      ? const Center(child: CircularProgressIndicator()) 
      : Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Our Services".text22White(),
              const SizedBox(height: 8),
              "From here to there — and everything in between.".text14White(),
              const SizedBox(height: 16),
              Expanded(
                child: services.isEmpty
                ? Center(
          child: Text(
            "No services found yet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ):
                
                
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final isSelected = selectedService == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedService = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xffEA0001).withOpacity(0.04)
                              : Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Color(0xffEA0001).withOpacity(0.8)
                                : Colors.white10,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                                        service.serviceImage ?? '',
                                        fit: BoxFit.contain,
                                        height: 60,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            const Icon(Icons.broken_image,
                                                color: Colors.white, size: 40),
                                      ),
                            //Icon(Icons.local_taxi, size: 32, color: Colors.white),
                            const SizedBox(height: 8),
                            Text(
                              service.name ?? 'No Name',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            // Image.asset(
                            //   'assets/images/taxi_ourService.png',

                            //   )
                            // Icon(
                            //   service['icon'],
                            //   size: 32,
                            //   color: Colors.white,
                            // ),
                            // const SizedBox(height: 8),
                            // Text(
                            //   service['label'],
                            //   style: const TextStyle(fontSize: 13),
                            //   textAlign: TextAlign.center,
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              PromoBannerWidget(
                title: 'Enjoy 18% off next ride',
                buttonText: 'Book Now',
                onPressed: () {
                  // Your action
                },
                imagePath: 'assets/images/promoImage.png',
              ),
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.pinkAccent,
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: const Text(
              //     'Enjoy 18% off next ride',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );



    } );
  }
}
