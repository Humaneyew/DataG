import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:datag/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'analytics/analytics_service.dart';
import 'analytics/dev_diagnostics.dart';
import 'features/modes/game_mode.dart';
import 'features/round/round_controller.dart';
import 'ui/screens/categories_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/round_screen.dart';
import 'ui/screens/summary_screen.dart';
import 'ui/screens/stub_screen.dart';
import 'ui/state/locale_controller.dart';
import 'ui/tokens.dart';

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
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesScreen(),
        ),
        GoRoute(
          path: '/round/:categoryId',
          builder: (context, state) {
            final categoryId = state.pathParameters['categoryId'] ?? 'history';
            final modeKey = state.uri.queryParameters['mode'];
            final mode = GameModeId.values.firstWhere(
              (mode) => mode.key == modeKey,
              orElse: () => GameModeId.classic10,
            );
            return RoundScreen(
              categoryId: categoryId,
              modeId: mode,
            );
          },
        ),
        GoRoute(
          path: '/summary',
          builder: (context, state) {
            final completion = state.extra as RoundCompletion?;
            return SummaryScreen(completion: completion);
          },
        ),
        GoRoute(
          path: '/stub',
          builder: (context, state) {
            final title = state.uri.queryParameters['title'] ?? 'Stub';
            return StubScreen(title: title);
          },
        ),
      ],
    );

    final locale = ref.watch(localeControllerProvider);

    final app = MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.dark,
      routerConfig: router,
    );

    return DevToolsOverlay(child: app);
  }
}
