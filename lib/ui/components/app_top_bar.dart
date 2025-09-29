import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/player_resources.dart';
import '../state/strings.dart';
import '../theme/tokens.dart';

class AppTopBar extends ConsumerWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onMenuTap,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onMenuTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resources = ref.watch(playerResourcesProvider);
    final strings = ref.watch(stringsProvider);
    final subtitleText = subtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (onMenuTap != null)
              _TopBarIconButton(
                icon: Icons.menu_rounded,
                onTap: onMenuTap!,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.h1),
                  if (subtitleText != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(subtitleText, style: AppTypography.body),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _ResourceCapsule(
              icon: Icons.favorite,
              label: strings.resourcesLives,
              value: resources.lives,
              color: AppColors.error.withOpacity(0.12),
              foregroundColor: AppColors.error,
            ),
            _ResourceCapsule(
              icon: Icons.flash_on,
              label: strings.resourcesEnergy,
              value: resources.energy,
              color: AppColors.warning.withOpacity(0.12),
              foregroundColor: AppColors.warning,
            ),
            _ResourceCapsule(
              icon: Icons.diamond,
              label: strings.resourcesGems,
              value: resources.gems,
              color: AppColors.primary.withOpacity(0.12),
              foregroundColor: AppColors.primary,
            ),
            _ResourceCapsule(
              icon: Icons.emoji_events,
              label: strings.resourcesLevel,
              value: resources.level,
              color: AppColors.success.withOpacity(0.12),
              foregroundColor: AppColors.success,
              trailing: _AnimatedCounter(
                value: resources.xp,
                label: 'XP',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResourceCapsule extends StatelessWidget {
  const _ResourceCapsule({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.foregroundColor,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color color;
  final Color foregroundColor;
  final Widget? trailing;

  void _handleTap() {
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: color,
          border: Border.all(color: foregroundColor.withOpacity(0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: foregroundColor),
            const SizedBox(width: AppSpacing.xs),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(color: foregroundColor.withOpacity(0.9)),
                ),
                _AnimatedCounter(value: value),
              ],
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _AnimatedCounter extends StatelessWidget {
  const _AnimatedCounter({required this.value, this.label});

  final int value;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final text = label == null ? '$value' : '$value ${label!}';
    return AnimatedSwitcher(
      duration: AppDurations.medium,
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child: Text(
        text,
        key: ValueKey<int>(value),
        style: AppTypography.numeric(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _TopBarIconButton extends StatelessWidget {
  const _TopBarIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(right: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(AppRadii.medium),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Icon(icon, size: 22, color: AppColors.textSecondary),
      ),
    );
  }
}
