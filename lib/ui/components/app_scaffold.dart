import 'package:flutter/material.dart';

import '../theme/pattern_painter.dart';
import '../theme/tokens.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    super.key,
    this.topBar,
    required this.body,
    this.scrollController,
    this.padding,
  });

  final Widget? topBar;
  final Widget body;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  double _scrollOffset = 0;

  ScrollController? get _controller => widget.scrollController;

  @override
  void initState() {
    super.initState();
    _controller?.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant AppScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_handleScroll);
      _controller?.addListener(_handleScroll);
      _scrollOffset = 0;
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    final controller = _controller;
    if (controller == null) return;
    setState(() {
      _scrollOffset = controller.offset;
    });
  }

  bool _onNotification(ScrollNotification notification) {
    setState(() {
      _scrollOffset = notification.metrics.pixels;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final padding = widget.padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding);
    final resolvedPadding = padding.resolve(Directionality.of(context));
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.backgroundStart, AppColors.backgroundEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: PatternPainter(offset: Offset(0, -_scrollOffset * 0.12)),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.2), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: resolvedPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.topBar != null) widget.topBar!,
                  if (widget.topBar != null) const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: _controller != null
                        ? widget.body
                        : NotificationListener<ScrollNotification>(
                            onNotification: _onNotification,
                            child: widget.body,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
