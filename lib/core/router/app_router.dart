import 'package:go_router/go_router.dart';
import '../../features/matches/presentation/pages/home_page.dart';
import '../../features/analysis/presentation/pages/matchup_analysis_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/analysis/:homeTeam/:awayTeam',
        name: 'analysis',
        builder: (context, state) {
          final homeTeam = state.pathParameters['homeTeam']!;
          final awayTeam = state.pathParameters['awayTeam']!;
          return MatchupAnalysisPage(
            homeTeam: homeTeam,
            awayTeam: awayTeam,
          );
        },
      ),
    ],
  );
}
