import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCardScreen extends StatefulWidget {
  final Function(Map<String, String>)? onCardAdded;

  const AddCardScreen({Key? key, this.onCardAdded}) : super(key: key);

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _isLoading = false;
  String _cardType = 'Visa';

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_detectCardType);
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_detectCardType);
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _detectCardType() {
    String number = _cardNumberController.text.replaceAll(' ', '');
    String newCardType = 'Visa';

    if (number.startsWith('4')) {
      newCardType = 'Visa';
    } else if (number.startsWith('5') || number.startsWith('2')) {
      newCardType = 'Mastercard';
    } else if (number.startsWith('3')) {
      newCardType = 'Amex';
    }

    if (newCardType != _cardType) {
      setState(() {
        _cardType = newCardType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF34495E),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Wallet',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardTypeHeader(),
            SizedBox(height: 30),
            _buildCardForm(),
            SizedBox(height: 40),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTypeHeader() {
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
              _cardType,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _getCardTypeColor(),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          '$_cardType Card',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getCardTypeColor() {
    switch (_cardType) {
      case 'Visa':
        return Colors.blue[900]!;
      case 'Mastercard':
        return Colors.red[700]!;
      case 'Amex':
        return Colors.green[700]!;
      default:
        return Colors.blue[900]!;
    }
  }

  Widget _buildCardForm() {
    return Column(
      children: [
        _buildTextField(
          label: 'Card Number:',
          controller: _cardNumberController,
          placeholder: '0000 0000 0000 0000',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberFormatter(),
          ],
          validator: _validateCardNumber,
          prefixIcon: Icons.credit_card,
        ),
        SizedBox(height: 20),
        _buildTextField(
          label: 'Card Holder Name:',
          controller: _cardHolderController,
          placeholder: 'John Doe',
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          ],
          validator: _validateCardHolderName,
          prefixIcon: Icons.person,
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Expiry Date:',
                controller: _expiryController,
                placeholder: 'MM/YY',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryDateFormatter(),
                ],
                validator: _validateExpiryDate,
                prefixIcon: Icons.calendar_today,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: _buildTextField(
                label: 'CVV:',
                controller: _cvvController,
                placeholder: '123',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: _validateCVV,
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required TextInputType keyboardType,
    required List<TextInputFormatter> inputFormatters,
    required String? Function(String?) validator,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          obscureText: obscureText,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(prefixIcon, color: Colors.grey[400]),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card number';
    }
    String cleanValue = value.replaceAll(' ', '');
    if (cleanValue.length < 13 || cleanValue.length > 19) {
      return 'Please enter a valid card number';
    }
    return null;
  }

  String? _validateCardHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card holder name';
    }
    if (value.trim().length < 2) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expiry date';
    }
    if (value.length < 5) {
      return 'Please enter valid expiry date';
    }

    List<String> parts = value.split('/');
    if (parts.length != 2) return 'Invalid format';

    int month = int.tryParse(parts[0]) ?? 0;
    int year = int.tryParse(parts[1]) ?? 0;

    if (month < 1 || month > 12) {
      return 'Invalid month';
    }

    int currentYear = DateTime.now().year % 100;
    int currentMonth = DateTime.now().month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card has expired';
    }

    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter CVV';
    }
    if (value.length < 3 || value.length > 4) {
      return 'CVV must be 3-4 digits';
    }
    return null;
  }

  void _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      Map<String, String> cardInfo = {
        'type': _cardType,
        'number': _cardNumberController.text,
        'holder': _cardHolderController.text,
        'expiry': _expiryController.text,
        'cvv': _cvvController.text,
      };

      if (widget.onCardAdded != null) {
        widget.onCardAdded!(cardInfo);
      }

      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2C3E50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text('Success!', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Text(
            'Your $_cardType card has been added successfully to your wallet.',
            style: TextStyle(color: Colors.grey[400]),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to wallet
              },
              child: Text(
                'OK',
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
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length == 2 && oldValue.text.length == 1) {
      return TextEditingValue(
        text: '$text/',
        selection: TextSelection.collapsed(offset: 3),
      );
    }

    return newValue;
  }
}
