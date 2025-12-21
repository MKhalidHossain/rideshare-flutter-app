import 'package:flutter/material.dart';

class EstimatedTripInfo extends StatelessWidget {
  final double distanceKm;

  /// Fare config (all optional, with sensible defaults)
  final num? baseFare;
  final num? perKmRate;
  final num? minimumFare;

  /// Optional styling / labels
  final String timeLabel;
  final String priceLabel;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const EstimatedTripInfo({
    super.key,
    required this.distanceKm,
    this.baseFare,
    this.perKmRate,
    this.minimumFare,
    this.timeLabel = 'Estimated time',
    this.priceLabel = 'Estimated price',
    this.labelStyle,
    this.valueStyle,
    this.padding = const EdgeInsets.all(12),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  String _calculateEstimatedTime(double distanceKm) {
    // Assuming average speed of 30 km/h in city
    final double hours = distanceKm / 30;
    final int minutes = (hours * 60).round();

    if (minutes < 1) {
      return '1 min';
    } else if (minutes < 60) {
      return '$minutes min';
    } else {
      final int hrs = minutes ~/ 60;
      final int mins = minutes % 60;
      return '${hrs}h ${mins}min';
    }
  }

  String _calculateEstimatedPrice(
    double distanceKm, {
    num? baseFare,
    num? perKmRate,
    num? minimumFare,
  }) {
    // Base fare + per km rate with graceful defaults
    final double resolvedBaseFare = (baseFare ?? 5).toDouble();
    final double resolvedPerKmRate = (perKmRate ?? 2.5).toDouble();
    double price = resolvedBaseFare + (distanceKm * resolvedPerKmRate);

    // Respect minimum fare when provided
    if (minimumFare != null) {
      price = price < minimumFare ? minimumFare.toDouble() : price;
    }

    return price.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final String time = _calculateEstimatedTime(distanceKm);
    final String price = _calculateEstimatedPrice(
      distanceKm,
      baseFare: baseFare,
      perKmRate: perKmRate,
      minimumFare: minimumFare,
    );

    final TextStyle effectiveLabelStyle =
        labelStyle ?? Theme.of(context).textTheme.bodyMedium!;
    final TextStyle effectiveValueStyle = valueStyle ??
        Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold);

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(timeLabel, style: effectiveLabelStyle),
              const SizedBox(height: 4),
              Text(time, style: effectiveValueStyle),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(priceLabel, style: effectiveLabelStyle),
              const SizedBox(height: 4),
              Text('\$$price', style: effectiveValueStyle),
            ],
          ),
        ],
      ),
    );
  }
}
