import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/core/widgets/wide_custom_button.dart';
import '../widgets/payment_method_card.dart';
import 'add_card_screen.dart';
import 'add_funds_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double balance = 225.0;
  List<PaymentMethod> paymentMethods = [
    PaymentMethod('PayPal', 'assets/paypal.png', true),
    PaymentMethod('Visa', 'assets/visa.png', false),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //  backgroundColor: Color(0xFF34495E),
      // appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // PreferredSizeWidget _buildAppBar() {
  //   return AppBar(
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     leading: BackButton(color: Colors.white),
  //     title: Text(
  //       'Wallet',
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: 18,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //     centerTitle: true,
  //     actions: [
  //       IconButton(
  //         icon: Icon(Icons.more_vert, color: Colors.white),
  //         onPressed: () => _showOptionsMenu(),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: Colors.white),
                Text(
                  'Wallet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () => _showOptionsMenu(),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildBalanceSection(),
            SizedBox(height: 40),
            _buildPaymentMethodsSection(),
            Spacer(),
            WideCustomButton(
              text: '+  Add Payment Method',
              onPressed: () => _showRemoveCardDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox(height: 40),
          Text(
            '\$${balance.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Rider Cash',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: size.width * 0.5,
            child: ElevatedButton(
              onPressed: () {
                Get.to(
                  AddFundsScreen(
                    currentBalance: balance,
                    onFundsAdded: (amount) {
                      setState(() {
                        balance += amount;
                      });
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white12,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: BorderSide(color: Colors.grey[600]!),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 25),
                  SizedBox(width: 8),
                  'Add Money'.text18White500(),
                  // Text(
                  //   'Add Money',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                ],
              ),
            ),
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20),
        ...paymentMethods.map(
          (method) => PaymentMethodCard(
            method: method,
            onTap: () => _handlePaymentMethodTap(method),
          ),
        ),
        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          child: TextButton(
            onPressed: () => _navigateToAddCard(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.red),
              ),
            ),
            child: Text(
              '+ Add new card/method',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // void _navigateToAddFunds() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => AddFundsScreen(
  //         currentBalance: balance,
  //         onFundsAdded: (amount) {
  //           setState(() {
  //             balance += amount;
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

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

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF2C3E50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.history, color: Colors.white),
                title: Text(
                  'Transaction History',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showSuccessMessage(
                    'Transaction history feature coming soon!',
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text(
                  'Wallet Settings',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showSuccessMessage('Wallet settings feature coming soon!');
                },
              ),
              ListTile(
                leading: Icon(Icons.help, color: Colors.white),
                title: Text(
                  'Help & Support',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showSuccessMessage('Help & support feature coming soon!');
                },
              ),
            ],
          ),
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
}
