import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const Color kShimmerBaseColor = Color(0xFF2F343C);
const Color kShimmerHighlightColor = Color(0xFF3B414A);
const Color kShimmerFillColor = Color(0xFF2F343C);

class ShimmerSkeleton extends StatelessWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerSkeleton({
    super.key,
    required this.child,
    this.baseColor = kShimmerBaseColor,
    this.highlightColor = kShimmerHighlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color color;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.color = kShimmerFillColor,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  final double size;
  final Color color;

  const ShimmerCircle({
    super.key,
    required this.size,
    this.color = kShimmerFillColor,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class ShimmerLine extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color color;

  const ShimmerLine({
    super.key,
    required this.width,
    this.height = 12,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.color = kShimmerFillColor,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
