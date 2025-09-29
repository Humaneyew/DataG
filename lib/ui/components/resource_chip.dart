import 'package:flutter/material.dart';

import '../tokens.dart';

class ResourceChip extends StatefulWidget {
  const ResourceChip({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.selected = false,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final bool enabled;

  @override
  State<ResourceChip> createState() => _ResourceChipState();
}

class _ResourceChipState extends State<ResourceChip> {
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
    if (widget.selected) {
      states.add(WidgetState.selected);
    }

    final background = widget.selected
        ? AppStateLayers.accentSurface(states)
        : AppStateLayers.elevatedSurface(states);
    final borderSide = _focused
        ? AppBorders.focus
        : AppBorders.muted.copyWith(
            color: widget.enabled
                ? AppColors.borderMuted
                : AppColors.borderMuted.withValues(alpha: 0.4),
          );

    final iconColor = widget.selected
        ? AppColors.accentSecondary
        : AppColors.textSecondary;

    final labelStyle = AppTypography.chip.copyWith(
      color: widget.enabled
          ? AppColors.textPrimary
          : AppColors.textSecondary.withValues(alpha: 0.6),
    );

    return FocusableActionDetector(
      enabled: widget.enabled && widget.onPressed != null,
      mouseCursor: widget.enabled && widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onShowHoverHighlight: _updateHover,
      onShowFocusHighlight: _updateFocus,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.enabled ? widget.onPressed : null,
          borderRadius: AppRadius.pill,
          splashFactory: InkRipple.splashFactory,
          onHighlightChanged: _updatePressed,
          child: AnimatedContainer(
            duration: AppAnimations.micro,
            curve: AppAnimations.eased,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: AppRadius.pill,
              border: Border.fromBorderSide(borderSide),
              boxShadow: _hovered ? AppShadows.soft : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: iconColor,
                ),
                const SizedBox(width: AppSpacing.s),
                Text(
                  widget.label,
                  style: labelStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
