import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'ui/screens/categories_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/round_screen.dart';
import 'ui/screens/summary_screen.dart';
import 'ui/screens/stub_screen.dart';
import 'ui/tokens.dart';
import 'ui/state/round_controller.dart';
import 'ui/state/locale_controller.dart';

void main() {
  runApp(const ProviderScope(child: DataGApp()));
}

class DataGApp extends ConsumerWidget {
  const DataGApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            return RoundScreen(categoryId: categoryId);
          },
        ),
        GoRoute(
          path: '/summary',
          builder: (context, state) {
            final summary = state.extra as RoundSummary?;
            return SummaryScreen(summary: summary);
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

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgBase,
        colorScheme: const ColorScheme.dark(
          surface: AppColors.bgElevated,
          background: AppColors.bgBase,
          primary: AppColors.accentPrimary,
          secondary: AppColors.accentSecondary,
          error: AppColors.error,
          onBackground: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimary),
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
