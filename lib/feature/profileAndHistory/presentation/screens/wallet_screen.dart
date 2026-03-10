import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/widgets/wide_custom_button.dart';
import 'package:rideztohealth/feature/home/controllers/home_controller.dart';
import 'package:rideztohealth/feature/home/domain/reponse_model/get_search_destination_for_find_Nearest_drivers_response_model.dart';
import 'package:rideztohealth/feature/map/presentation/screens/work/finding_your_driver_screen.dart';
import 'package:rideztohealth/feature/payment/domain/create_payment_request_model.dart';
import 'package:rideztohealth/feature/payment/presentation/payment_webview_screen.dart';
import '../../../map/controllers/locaion_controller.dart';
import '../widgets/payment_method_card.dart';
import 'add_card_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({
    super.key,
    this.rideId,
    this.rideAmount,
    this.driverId,
    this.stripeDriverId,
    required this.selectedDriver,
  });
  final String? rideId;
  final String? rideAmount;
  final String? driverId;
  final String? stripeDriverId;
  final NearestDriverData? selectedDriver;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<PaymentMethod> paymentMethods = [
    PaymentMethod('Stripe', 'assets/images/Stripe_Logo.png', true),
    // PaymentMethod('Visa', 'assets/images/Stripe_Logo.png', false),
  ];
  final LocationController locationController = Get.find<LocationController>();
  late final HomeController _homeController;
  bool _isProcessingPayment = false;

  bool get _canStartPayment =>
      widget.rideAmount != null &&
      widget.driverId != null &&
      widget.driverId!.isNotEmpty &&
      widget.stripeDriverId != null &&
      widget.stripeDriverId!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _homeController = Get.find<HomeController>();

    print("ride Id from wallet screen: ${widget.rideId}");

    locationController.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: Colors.white, onPressed: () => Get.back()),
                Text(
                  'Continue to Pay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 20),
            if (widget.rideAmount != null) ...[
              const SizedBox(height: 20),
              _buildFareSummaryCard(),
            ],
            const SizedBox(height: 40),
            _buildPaymentMethodsSection(),
            const Spacer(),
            WideCustomButton(
              text: _canStartPayment ? 'Continue to Pay' : 'Continue',
              isLoading: _isProcessingPayment,
              loadingText: 'Processing...',
              onPressed: () {
                final rideDuration = locationController.distance.value
                    .toString();
                print("ride duration from wallet screen: $rideDuration");
                if (_canStartPayment) {
                  if (_isProcessingPayment) return;
                  _handleContinue(rideDuration);
                } else {
                  _showRemoveCardDialog();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFareSummaryCard() {
    final amount = widget.rideAmount;
    if (amount == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Fare',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            "\$$amount",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'The payment link will open once you continue.',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Payment Methods',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        ...paymentMethods.map(
          (method) => PaymentMethodCard(
            method: method,
            onTap: () => _handlePaymentMethodTap(method),
          ),
        ),
      ],
    );
  }

  void _navigateToAddCard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCardScreen(
          onCardAdded: (cardInfo) {
            setState(() {
              // Deselect all current payment methods
              paymentMethods = paymentMethods
                  .map(
                    (method) =>
                        PaymentMethod(method.name, method.iconPath, false),
                  )
                  .toList();

              // Add the new card and make it selected
              paymentMethods.add(
                PaymentMethod(
                  cardInfo['type'] ?? 'Unknown',
                  'assets/${cardInfo['type']?.toLowerCase()}.png',
                  true, // This should be a boolean, not a string
                ),
              );
            });
            _showSuccessMessage('${cardInfo['type']} card added successfully!');
          },
        ),
      ),
    );
  }

  void _handlePaymentMethodTap(PaymentMethod method) {
    if (method.name == 'Visa' && !_hasVisaCard()) {
      _navigateToAddCard();
    } else {
      setState(() {
        paymentMethods = paymentMethods
            .map(
              (pm) =>
                  PaymentMethod(pm.name, pm.iconPath, pm.name == method.name),
            )
            .toList();
      });
    }
  }

  bool _hasVisaCard() {
    return paymentMethods.any(
      (method) => method.name == 'Visa' && method.iconPath.isNotEmpty,
    );
  }

  void _showRemoveCardDialog() {
    final selectedMethod = paymentMethods.where((method) => method.isSelected);

    if (selectedMethod.isEmpty) {
      _showErrorMessage('No payment method selected');
      return;
    }

    final methodToRemove = selectedMethod.first;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2C3E50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Remove Payment Method',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to remove ${methodToRemove.name} from your wallet?',
            style: TextStyle(color: Colors.grey[400]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  paymentMethods.removeWhere((method) => method.isSelected);
                  // If there are remaining methods, select the first one
                  if (paymentMethods.isNotEmpty) {
                    paymentMethods[0] = PaymentMethod(
                      paymentMethods[0].name,
                      paymentMethods[0].iconPath,
                      true,
                    );
                  }
                });
                Navigator.pop(context);
                _showSuccessMessage(
                  '${methodToRemove.name} removed successfully',
                );
              },
              child: Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleContinue(String rideDuration) async {
    final amountText = widget.rideAmount;
    final driverId = widget.driverId;
    final stripeDriverId = widget.stripeDriverId;

    if (amountText == null || driverId == null || stripeDriverId == null) {
      _showErrorMessage('Payment details are missing');
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null) {
      _showErrorMessage('Invalid amount');
      return;
    }

    try {
      setState(() => _isProcessingPayment = true);
      final response = await _homeController.createPayment(
        CreatePaymentRequestModel(
          rideId: widget.rideId,
          rideDuration: rideDuration,
          amount: _convertToMinorUnit(amount),
          driverId: driverId,
          stripeDriverId: stripeDriverId,
        ),
      );

      final paymentUrl = response.url;
      if (paymentUrl == null || paymentUrl.isEmpty) {
        _showErrorMessage('Payment link is unavailable');
        return;
      }
      if (!mounted) return;

      // Wait for the webview to report completion (expected to return bool)
      final completed = await Get.to<bool>(
        () => PaymentWebViewScreen(
          paymentUrl: paymentUrl,
          sessionId: response.sessionId,
          selectedDriver: widget.selectedDriver,
        ),
      );

      if (completed == true && mounted) {
        Get.offAll(() => const FindingYourDriverScreen());
      }
    } catch (e) {
      _showErrorMessage(e.toString().replaceFirst('Exception:', '').trim());
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  int _convertToMinorUnit(double amount) {
    return (amount * 100).round();
  }
}
