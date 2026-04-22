import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'features/add_material/add_material_screen.dart';
import 'features/focus_session/session_screen.dart';
import 'features/home/home_screen.dart';
import 'features/library/library_screen.dart';
import 'features/material_detail/material_detail_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/stats/stats_screen.dart';

part 'main.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const FocusFlowApp(),
    ),
  );
}

class FocusFlowApp extends ConsumerWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'FocusFlow',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      routerConfig: router,
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scaffoldBackgroundColor =
      isDark ? AppColors.darkBackground : const Color(0xFFF8FAFD);
  final baseScheme = ColorScheme.fromSeed(
    brightness: brightness,
    seedColor: AppColors.primary,
    primary: AppColors.primary,
  );

  final colorScheme = baseScheme.copyWith(
    primary: AppColors.primary,
    surface: isDark ? AppColors.darkSurface : Colors.white,
    surfaceContainerHighest: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
  );

  return base.copyWith(
    textTheme: AppTextStyles.buildTextTheme(base.textTheme),
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    cardTheme: CardThemeData(
      elevation: 0,
      color: colorScheme.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.25),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.6),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 1.4,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
    ),
  );
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final isOnboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  return GoRouter(
    debugLogDiagnostics: kDebugMode,
    navigatorKey: _rootNavigatorKey,
    initialLocation: isOnboardingComplete ? '/' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/library/add',
        builder: (_, __) => const AddMaterialScreen(),
      ),
      GoRoute(
        path: '/library/:materialId',
        builder: (_, state) => MaterialDetailScreen(
          materialId: state.pathParameters['materialId']!,
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => _AppShell(
          location: state.uri.toString(),
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: '/library',
            builder: (_, __) => const LibraryScreen(),
          ),
          GoRoute(
            path: '/stats',
            builder: (_, __) => const StatsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/session',
        builder: (_, state) => FocusSessionScreen(
          materialId: state.uri.queryParameters['materialId'],
          chapterId: state.uri.queryParameters['chapterId'],
        ),
      ),
      GoRoute(
        path: '/session/complete',
        builder: (_, state) => SessionCompleteScreen(
          args: state.extra as SessionCompleteArgs?,
        ),
      ),
    ],
    redirect: (_, state) {
      final finished = prefs.getBool('onboarding_complete') ?? false;
      final atOnboarding = state.uri.path == '/onboarding';
      if (!finished && !atOnboarding) return '/onboarding';
      if (finished && atOnboarding) return '/';
      return null;
    },
  );
}

class _AppShell extends StatelessWidget {
  const _AppShell({
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = switch (location) {
      final path when path.startsWith('/library') => 1,
      final path when path.startsWith('/stats') => 3,
      _ => 0,
    };

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/library');
              break;
            case 2:
              context.push('/session');
              break;
            case 3:
              context.go('/stats');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.video_library_rounded), label: 'Library'),
          NavigationDestination(icon: Icon(Icons.play_circle_fill_rounded), label: 'Session'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: 'Stats'),
        ],
      ),
    );
  }
}
