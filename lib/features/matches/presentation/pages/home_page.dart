import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/states/state_widget.dart';
import '../bloc/match_bloc.dart';
import '../../data/datasources/bet_parser_service.dart';
import '../../domain/entities/matchup.dart';
import 'home/home_app_bar.dart';
import 'home/home_load_data_fab.dart';
import 'home/home_matchups_content.dart';

/// Главная страница приложения
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(),
          _buildContent(context),
        ],
      ),
      floatingActionButton: HomeLoadDataFAB(
        onPressed: () => _handleLoadData(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(context.horizontalPadding),
        child: BlocBuilder<MatchBloc, MatchState>(
          builder: (context, state) {
            if (state is MatchLoading) {
              return const StateWidget.loading();
            }

            if (state is MatchError) {
              return StateWidget.error(
                message: state.message,
                onRetry: () => context.read<MatchBloc>().add(LoadMatches()),
              );
            }

            if (state is MatchLoaded) {
              final matches = state.matches;
              if (matches.isEmpty) {
                return const StateWidget.empty();
              }

              final matchups = _groupMatchesByMatchup(matches);
              return HomeMatchupsContent(
                matchups: matchups,
                totalMatches: matches.length,
              );
            }

            return const StateWidget.empty();
          },
        ),
      ),
    );
  }

  List<Matchup> _groupMatchesByMatchup(List matches) {
    final Map<String, int> matchupCounts = {};

    for (var match in matches) {
      final key = '${match.homeTeam}|${match.awayTeam}';
      matchupCounts[key] = (matchupCounts[key] ?? 0) + 1;
    }

    return matchupCounts.entries.map((entry) {
      final teams = entry.key.split('|');
      return Matchup(
        homeTeam: teams[0],
        awayTeam: teams[1],
        matchCount: entry.value,
      );
    }).toList()
      ..sort((a, b) => b.matchCount.compareTo(a.matchCount));
  }

  Future<void> _handleLoadData(BuildContext context) async {
    try {
      final betParser = BetParserService();
      final matches = await betParser.fetchMatches();

      if (context.mounted) {
        context.read<MatchBloc>().add(SaveMatches(matches));
        _showSuccessSnackBar(context, matches.length);
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, e.toString());
      }
    }
  }

  void _showSuccessSnackBar(BuildContext context, int matchesCount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Загружено $matchesCount матчей'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ошибка: $message'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
