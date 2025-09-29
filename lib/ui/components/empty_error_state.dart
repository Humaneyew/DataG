import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../tokens.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon = LucideIcons.archiveX,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return _StateScaffold(
      icon: icon,
      title: title,
      message: message,
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.icon = LucideIcons.alertTriangle,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StateScaffold(
          icon: icon,
          title: title,
          message: message,
        ),
        if (onRetry != null) ...[
          const SizedBox(height: AppSpacing.l),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ],
    );
  }
}

class _StateScaffold extends StatelessWidget {
  const _StateScaffold({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.l),
          Text(
            title,
            style: AppTypography.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            message,
            style: AppTypography.secondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
