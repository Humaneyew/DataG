import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'analytics/analytics_service.dart';
import 'analytics/dev_diagnostics.dart';
import 'ui/screens/categories_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/round_screen.dart';
import 'ui/screens/stub_screen.dart';
import 'ui/state/locale_controller.dart';
import 'ui/state/strings.dart';
import 'ui/theme/app_theme.dart';
import 'ui/theme/tokens.dart';

class DataGApp extends ConsumerStatefulWidget {
  const DataGApp({super.key});

  @override
  ConsumerState<DataGApp> createState() => _DataGAppState();
}

class _DataGAppState extends ConsumerState<DataGApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logAppOpen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => _buildPage(
            state,
            const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/stub',
          pageBuilder: (context, state) {
            final title = state.uri.queryParameters['title'] ?? strings.appTitle;
            return _buildPage(
              state,
              StubScreen(title: title),
            );
          },
        ),
        GoRoute(
          path: '/categories',
          pageBuilder: (context, state) => _buildPage(
            state,
            const CategoriesScreen(),
          ),
        ),
        GoRoute(
          path: '/round',
          pageBuilder: (context, state) => _buildPage(
            state,
            const RoundEntryScreen(),
          ),
        ),
        GoRoute(
          path: '/round/:categoryId',
          pageBuilder: (context, state) {
            final categoryId = state.pathParameters['categoryId'] ?? 'history';
            return _buildPage(
              state,
              RoundScreen(categoryId: categoryId),
            );
          },
        ),
      ],
    );

    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (_) => strings.appTitle,
      locale: locale,
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.dark,
      routerConfig: router,
      builder: (context, child) => DevToolsOverlay(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

CustomTransitionPage<void> _buildPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionsBuilder: (context, animation, secondaryAnimation, widget) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(curved),
          child: widget,
        ),
      );
    },
    transitionDuration: AppDurations.medium,
    child: child,
  );
}
