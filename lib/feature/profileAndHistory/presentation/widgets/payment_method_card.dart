import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: method.isSelected
                ? Colors.red.withValues(alpha: 0.1)
                : Colors.white12,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: method.isSelected ? Colors.red : Colors.grey[600]!,
              width: method.isSelected ? 2 : 1,
            ),
          ),
          child: Row(
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
                    method.name,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: method.name == 'PayPal'
                          ? Colors.blue
                          : Colors.blue[900],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                method.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: method.isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
              const Spacer(),
              if (method.isSelected)
                Icon(Icons.check_circle, color: Colors.red, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethod {
  final String name;
  final String iconPath;
  final bool isSelected;

  PaymentMethod(this.name, this.iconPath, this.isSelected);

  PaymentMethod copyWith({String? name, String? iconPath, bool? isSelected}) {
    return PaymentMethod(
      name ?? this.name,
      iconPath ?? this.iconPath,
      isSelected ?? this.isSelected,
    );
  }
}
