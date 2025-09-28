import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../analytics/dev_diagnostics.dart';
import '../tokens.dart';

class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    Widget titleWidget = title ?? const SizedBox.shrink();
    if (kDebugMode) {
      titleWidget = GestureDetector(
        onLongPress: () => showDevToolsMenu(context),
        behavior: HitTestBehavior.opaque,
        child: titleWidget,
      );
    }

    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.bgBase,
          border: Border(bottom: AppBorders.muted),
        ),
        child: Row(
          children: [
            leading ?? const SizedBox(width: AppComponentSpecs.minTouchTarget),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: DefaultTextStyle(
                style: AppTypography.textTheme.titleMedium ??
                    AppTypography.textTheme.titleSmall ??
                    AppTypography.textTheme.bodyLarge!,
                textAlign: TextAlign.center,
                child: titleWidget,
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            if (actions != null && actions!.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!
                    .expand((w) => [w, const SizedBox(width: AppSpacing.s)])
                    .toList()
                  ..removeLast(),
              )
            else
              const SizedBox(width: AppComponentSpecs.minTouchTarget),
          ],
        ),
      ),
    );
  }
}
