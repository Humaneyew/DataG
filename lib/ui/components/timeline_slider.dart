import 'package:flutter/material.dart';

import '../tokens.dart';

class TimelineSlider extends StatelessWidget {
  const TimelineSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.grid),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              min: 0,
              max: 2024,
              value: value,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('I', style: TextStyle(color: AppColors.textSecondary)),
              Text('V', style: TextStyle(color: AppColors.textSecondary)),
              Text('X', style: TextStyle(color: AppColors.textSecondary)),
              Text('XV', style: TextStyle(color: AppColors.textSecondary)),
              Text('XX', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderMuted),
              ),
              child: const Text(
                'CE',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
