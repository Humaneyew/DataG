import 'package:datag/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/player_resources.dart';
import '../theme/tokens.dart';

class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resources = ref.watch(playerResourcesProvider);
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.xxl,
        AppSpacing.xxl,
        AppSpacing.lg,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: AppRadii.large,
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: AppShadows.soft(color: Colors.black87),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.appTitle, style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Season XIII',
                    style: AppTypography.caption.copyWith(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.64),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Flexible(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _ResourceCapsule(
                      emoji: '❤️',
                      label: l.resourcesLives,
                      value: resources.lives,
                      onTap: () => ref
                          .read(playerResourcesProvider.notifier)
                          .gain(lives: 1),
                    ),
                    _ResourceCapsule(
                      emoji: '⚡',
                      label: l.resourcesEnergy,
                      value: resources.energy,
                      onTap: () => ref
                          .read(playerResourcesProvider.notifier)
                          .gain(energy: 1),
                    ),
                    _ResourceCapsule(
                      emoji: '💎',
                      label: l.resourcesGems,
                      value: resources.gems,
                      onTap: () => ref
                          .read(playerResourcesProvider.notifier)
                          .spend(gems: 10),
                    ),
                    _ResourceCapsule(
                      emoji: '🏆',
                      label: l.resourcesLevel,
                      value: resources.level,
                      onTap: () => ref
                          .read(playerResourcesProvider.notifier)
                          .levelUp(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResourceCapsule extends StatefulWidget {
  const _ResourceCapsule({
    required this.emoji,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final int value;
  final VoidCallback onTap;

  @override
  State<_ResourceCapsule> createState() => _ResourceCapsuleState();
}

class _ResourceCapsuleState extends State<_ResourceCapsule> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.caption.copyWith(
      color: Colors.white.withOpacity(0.8),
      letterSpacing: 0.4,
    );

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: AppAnimations.short,
        curve: AppAnimations.easing,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadii.pill,
            border: Border.all(color: Colors.white.withOpacity(0.14)),
            color: Colors.white.withOpacity(0.05),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.label.toUpperCase(), style: textStyle),
                    AnimatedSwitcher(
                      duration: AppAnimations.medium,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        widget.value.toString(),
                        key: ValueKey<int>(widget.value),
                        style: AppTypography.h3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
