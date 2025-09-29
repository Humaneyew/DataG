import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

enum AppCardVariant { elevated, outlined, gradient }

class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.variant = AppCardVariant.elevated,
    this.padding = const EdgeInsets.all(AppSpacing.xxl),
    this.background,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final Color? background;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;
    switch (widget.variant) {
      case AppCardVariant.elevated:
        decoration = BoxDecoration(
          borderRadius: AppRadii.large,
          gradient: widget.background != null
              ? null
              : const LinearGradient(
                  colors: [
                    Color(0x1AFFFFFF),
                    Color(0x05000000),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: widget.background,
          border: Border.all(color: Colors.white.withOpacity(0.06)),
          boxShadow: AppShadows.soft(),
        );
        break;
      case AppCardVariant.outlined:
        decoration = BoxDecoration(
          borderRadius: AppRadii.large,
          border: Border.all(color: Colors.white.withOpacity(0.12)),
          color: Colors.white.withOpacity(0.02),
        );
        break;
      case AppCardVariant.gradient:
        decoration = BoxDecoration(
          borderRadius: AppRadii.large,
          gradient: const LinearGradient(
            colors: [
              Color(0x334B73FF),
              Color(0x334BFFC5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        );
        break;
    }

    Widget content = Padding(
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.title,
                if (widget.subtitle != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  widget.subtitle!,
                ],
              ],
            ),
          ),
          if (widget.trailing != null) ...[
            const SizedBox(width: AppSpacing.xl),
            widget.trailing!,
          ],
        ],
      ),
    );

    if (widget.onTap != null) {
      content = GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap!.call();
        },
        child: AnimatedScale(
          duration: AppAnimations.medium,
          curve: AppAnimations.easing,
          scale: _pressed ? 0.98 : 1,
          child: content,
        ),
      );
    }

    return AnimatedContainer(
      duration: AppAnimations.medium,
      curve: AppAnimations.easing,
      decoration: decoration,
      child: content,
    );
  }
}
