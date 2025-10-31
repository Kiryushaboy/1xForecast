import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/match_bloc.dart';
import '../../data/datasources/bet_parser_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1xForecast - FIFA FC24 4x4'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MatchBloc>().add(LoadMatches());
            },
          ),
        ],
      ),
      body: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state is MatchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MatchError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Ошибка: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MatchBloc>().add(LoadMatches());
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is MatchLoaded) {
            final matches = state.matches;

            if (matches.isEmpty) {
              return const Center(
                child: Text('Нет данных. Загрузите матчи.'),
              );
            }

            // Group matches by matchup
            final matchups = <String, List>{};
            for (var match in matches) {
              final key = '${match.homeTeam} vs ${match.awayTeam}';
              matchups.putIfAbsent(
                  key, () => [match.homeTeam, match.awayTeam, 0]);
              matchups[key]![2]++;
            }

            return ListView.builder(
              itemCount: matchups.length,
              itemBuilder: (context, index) {
                final entry = matchups.entries.elementAt(index);
                final homeTeam = entry.value[0] as String;
                final awayTeam = entry.value[1] as String;
                final matchCount = entry.value[2] as int;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('$matchCount'),
                    ),
                    title: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('$matchCount матчей в истории'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.go('/analysis/$homeTeam/$awayTeam');
                    },
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text('Загрузите данные для начала работы'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            final betParser = BetParserService();
            final matches = await betParser.fetchMatches();

            if (context.mounted) {
              context.read<MatchBloc>().add(SaveMatches(matches));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Загружено ${matches.length} матчей')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка: $e')),
              );
            }
          }
        },
        icon: const Icon(Icons.download),
        label: const Text('Загрузить данные'),
      ),
    );
  }
}
