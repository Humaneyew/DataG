import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../tokens.dart';

class CategoryListShimmer extends StatelessWidget {
  const CategoryListShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemBuilder: (context, index) => const _CategoryCardPlaceholder(),
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
      itemCount: itemCount,
    );
  }
}

class RoundQuestionShimmer extends StatelessWidget {
  const RoundQuestionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _ShimmerBar(height: 20, widthFactor: 0.6),
          SizedBox(height: AppSpacing.l),
          _ShimmerCard(height: 120),
          SizedBox(height: AppSpacing.l),
          _ShimmerBar(height: 48, widthFactor: 0.4),
          SizedBox(height: AppSpacing.l),
          _ShimmerCard(height: 160),
        ],
      ),
    );
  }
}

class _CategoryCardPlaceholder extends StatelessWidget {
  const _CategoryCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return _ShimmerCard(
      height: 72,
      radius: AppRadius.medium,
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({
    required this.height,
    this.radius = AppRadius.medium,
  });

  final double height;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgElevated.withOpacity(0.7),
      highlightColor: AppColors.bgElevated.withOpacity(0.4),
      period: const Duration(milliseconds: 1300),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: radius,
        ),
      ),
    );
  }
}

class _ShimmerBar extends StatelessWidget {
  const _ShimmerBar({
    required this.height,
    this.widthFactor,
  });

  final double height;
  final double? widthFactor;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final targetWidth = widthFactor == null ? width : width * widthFactor!;
    return SizedBox(
      width: targetWidth,
      child: _ShimmerCard(
        height: height,
        radius: AppRadius.pill,
      ),
    );
  }
}
