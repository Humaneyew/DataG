import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../tokens.dart';

class CardTile extends StatefulWidget {
  const CardTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.height = 72,
    this.showChevron = true,
  });

  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final VoidCallback? onTap;
  final double height;
  final bool showChevron;

  bool get enabled => onTap != null;

  @override
  State<CardTile> createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  void _updateHover(bool hovered) {
    if (_hovered == hovered) return;
    setState(() => _hovered = hovered);
  }

  void _updateFocus(bool focused) {
    if (_focused == focused) return;
    setState(() => _focused = focused);
  }

  void _updatePressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final states = <WidgetState>{};
    if (!widget.enabled) {
      states.add(WidgetState.disabled);
    }
    if (_hovered) {
      states.add(WidgetState.hovered);
    }
    if (_focused) {
      states.add(WidgetState.focused);
    }
    if (_pressed) {
      states.add(WidgetState.pressed);
    }

    final background = AppStateLayers.elevatedSurface(states);
    final border = _focused
        ? AppBorders.focus
        : AppBorders.muted.copyWith(
            color: widget.enabled
                ? AppColors.borderMuted
                : AppColors.borderMuted.withValues(alpha: 0.5),
          );
    final shadow = _hovered ? AppShadows.soft : null;

    final titleStyle = AppTypography.textTheme.titleSmall!;
    final subtitleStyle = AppTypography.secondary;

    return FocusableActionDetector(
      enabled: widget.enabled,
      mouseCursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onShowHoverHighlight: _updateHover,
      onShowFocusHighlight: _updateFocus,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: _updatePressed,
          borderRadius: AppRadius.medium,
          splashFactory: InkRipple.splashFactory,
          child: AnimatedContainer(
            duration: AppAnimations.standard,
            curve: AppAnimations.eased,
            height: widget.height,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: AppRadius.medium,
              border: Border.fromBorderSide(border),
              boxShadow: shadow,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.leading,
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: widget.subtitle == null
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceEvenly,
                    children: [
                      DefaultTextStyle.merge(
                        style: titleStyle,
                        child: widget.title,
                      ),
                      if (widget.subtitle != null)
                        DefaultTextStyle.merge(
                          style: subtitleStyle,
                          child: widget.subtitle!,
                        ),
                    ],
                  ),
                ),
                if (widget.showChevron) ...[
                  const SizedBox(width: AppSpacing.m),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 20,
                    color: widget.enabled
                        ? AppColors.textSecondary
                        : AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
