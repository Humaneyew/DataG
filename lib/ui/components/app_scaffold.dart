import 'package:flutter/material.dart';

import '../theme/pattern_painter.dart';
import '../theme/tokens.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    super.key,
    this.topBar,
    required this.body,
    this.floatingActionButton,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
  });

  final PreferredSizeWidget? topBar;
  final Widget body;
  final Widget? floatingActionButton;
  final EdgeInsets padding;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  double _scrollOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: widget.floatingActionButton,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientEnd,
                  ],
                ),
              ),
              child: CustomPaint(
                painter: PatternPainter(offset: _scrollOffset),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  if (widget.topBar != null) widget.topBar!,
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollUpdateNotification) {
                          setState(() {
                            _scrollOffset =
                                notification.metrics.pixels.clamp(0, 120);
                          });
                        }
                        return false;
                      },
                      child: Padding(
                        padding: widget.padding,
                        child: widget.body,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
