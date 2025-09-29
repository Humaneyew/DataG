import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'l10n/generated/app_localizations.dart';
import 'ui/screens/categories_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/round_stub_screen.dart';
import 'ui/state/locale_controller.dart';
import 'ui/theme/app_theme.dart';
import 'ui/theme/tokens.dart';

class DataGApp extends ConsumerWidget {
  const DataGApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => _buildTransition(
            state,
            HomeScreen(categoryId: state.uri.queryParameters['category']),
          ),
        ),
        GoRoute(
          path: '/categories',
          pageBuilder: (context, state) => _buildTransition(
            state,
            const CategoriesScreen(),
          ),
        ),
        GoRoute(
          path: '/round',
          pageBuilder: (context, state) => _buildTransition(
            state,
            RoundStubScreen(categoryId: state.uri.queryParameters['category']),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

CustomTransitionPage<void> _buildTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppAnimations.short,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: AppAnimations.easing);
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(fade);
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}
