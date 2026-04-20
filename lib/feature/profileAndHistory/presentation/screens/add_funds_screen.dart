import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/core/widgets/normal_custom_button.dart';

class AddFundsScreen extends StatefulWidget {
  final double currentBalance;
  final Function(double)? onFundsAdded;

  const AddFundsScreen({
    Key? key,
    required this.currentBalance,
    this.onFundsAdded,
  }) : super(key: key);

  @override
  _AddFundsScreenState createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  int selectedAmount = 50;
  final _customAmountController = TextEditingController();
  String selectedPaymentMethod = 'Visa';
  bool _isLoading = false;

  final List<Map<String, dynamic>> predefinedAmounts = [
    {'amount': 50, 'type': 'Rider Cash', 'popular': true},
    {'amount': 100, 'type': 'Rider Cash', 'popular': false},
    {'amount': 200, 'type': 'Rider Cash', 'popular': false},
  ];

  final List<String> paymentMethods = ['Visa', 'Mastercard', 'PayPal'];

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF34495E),
      // appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  //

  // Need to show figma when Api Integration

  //

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(
                  color: Colors.white,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                'Add Funds'.text20white(),

                SizedBox(width: 50),
              ],
            ),
            SizedBox(height: 20),
            _buildCurrentBalanceCard(),
            SizedBox(height: 20),
            _buildWarningMessage(),
            SizedBox(height: 30),
            _buildAmountSelection(),
            SizedBox(height: 30),
            _buildPaymentMethodSection(),
            SizedBox(height: 20),
            _buildCustomAmountSection(),
            SizedBox(height: 30),
            _buildFundMethodSelector(),
            SizedBox(height: 40),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        //Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[600]!),
      ),
      child: Column(
        children: [
          Text(
            'Current Balance',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            '\$${widget.currentBalance.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningMessage() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        //color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.red, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Choose add funds without payment method',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Amount Selection',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15),
        ...predefinedAmounts.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> amountData = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: _buildAmountOption(
              amountData['amount'],
              amountData['type'],
              index,
              isPopular: amountData['popular'],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAmountOption(
    int amount,
    String type,
    int index, {
    bool isPopular = false,
  }) {
    bool isSelected =
        selectedAmount == amount && _customAmountController.text.isEmpty;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAmount = amount;
          _customAmountController.clear();
        });
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.withOpacity(0.1) : Color(0xFF2C3E50),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey[600]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<int>(
              value: amount,
              groupValue: _customAmountController.text.isEmpty
                  ? selectedAmount
                  : null,
              onChanged: (value) {
                setState(() {
                  selectedAmount = value!;
                  _customAmountController.clear();
                });
              },
              activeColor: Colors.red,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '\$$amount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isPopular) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Popular',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    type,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.red, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 25,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              selectedPaymentMethod,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: _getPaymentMethodColor(),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          selectedPaymentMethod,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: _showPaymentMethodSelector,
          child: Text('Change', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Color _getPaymentMethodColor() {
    switch (selectedPaymentMethod) {
      case 'Visa':
        return Colors.blue[900]!;
      case 'Mastercard':
        return Colors.red[700]!;
      case 'PayPal':
        return Colors.blue;
      default:
        return Colors.blue[900]!;
    }
  }

  Widget _buildCustomAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Write Custom Amount:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _customAmountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter amount (\$1 - \$10,000)',
            hintStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(Icons.attach_money, color: Colors.grey[400]),
            filled: true,
            fillColor: Color(0xFF2C3E50),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
          onChanged: (value) {
            setState(() {
              selectedAmount = int.tryParse(value) ?? 0;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFundMethodSelector() {
    return GestureDetector(
      onTap: _showPaymentMethodSelector,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFF2C3E50),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[600]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Fund Method',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffBFC1C5),
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: "Cancel".text16Black(),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: NormalCustomButton(
            text: 'Confirm',
            textColor: Colors.white,
            fontSize: 16,
            onPressed: () {},
            height: 51,
          ),
        ),
      ],
    );
  }

  void _showPaymentMethodSelector() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Payment Method',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              ...paymentMethods.map(
                (method) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        method,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: _getPaymentMethodColorForMethod(method),
                        ),
                      ),
                    ),
                  ),
                  title: Text(method, style: TextStyle(color: Colors.white)),
                  trailing: selectedPaymentMethod == method
                      ? Icon(Icons.check_circle, color: Colors.red)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = method;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getPaymentMethodColorForMethod(String method) {
    switch (method) {
      case 'Visa':
        return Colors.blue[900]!;
      case 'Mastercard':
        return Colors.red[700]!;
      case 'PayPal':
        return Colors.blue;
      default:
        return Colors.blue[900]!;
    }
  }

  void _confirmAddFunds() async {
    int finalAmount = _customAmountController.text.isNotEmpty
        ? int.tryParse(_customAmountController.text) ?? 0
        : selectedAmount;

    if (finalAmount <= 0) {
      _showErrorMessage('Please select or enter a valid amount');
      return;
    }

    if (finalAmount > 10000) {
      _showErrorMessage('Maximum amount allowed is \$10,000');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    _showConfirmationDialog(finalAmount.toDouble());
  }

  void _showConfirmationDialog(double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2C3E50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Confirm Transaction',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConfirmationRow(
                'Amount:',
                '\$${amount.toStringAsFixed(2)}',
              ),
              _buildConfirmationRow('Payment Method:', selectedPaymentMethod),
              _buildConfirmationRow('Destination:', 'Rider Cash'),
              _buildConfirmationRow(
                'New Balance:',
                '\$${(widget.currentBalance + amount).toStringAsFixed(2)}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to wallet

                if (widget.onFundsAdded != null) {
                  widget.onFundsAdded!(amount);
                }

                _showSuccessMessage(amount);
              },
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(double amount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Success! \$${amount.toStringAsFixed(2)} added to your wallet.',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
