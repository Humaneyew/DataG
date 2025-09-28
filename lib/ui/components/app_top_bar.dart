import 'package:flutter/material.dart';

import '../tokens.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
  });

  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.bgBase,
        border: Border(bottom: AppBorders.muted),
      ),
      child: Row(
        children: [
          leading ?? const SizedBox(width: AppComponentSpecs.minTouchTarget),
          const SizedBox(width: AppSpacing.grid),
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              child: title ?? const SizedBox.shrink(),
            ),
          ),
          const SizedBox(width: AppSpacing.grid),
          if (actions != null && actions!.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!
                  .expand(
                    (w) => [w, const SizedBox(width: 8)],
                  )
                  .toList()
                ..removeLast(),
            )
          else
            const SizedBox(width: AppComponentSpecs.minTouchTarget),
        ],
      ),
    );
  }
}
