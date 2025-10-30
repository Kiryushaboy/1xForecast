import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/match_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(allMatchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('1xForecast - FIFA FC24 4x4'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(allMatchesProvider),
          ),
        ],
      ),
      body: matchesAsync.when(
        data: (matches) {
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(allMatchesProvider),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Load test data
          final betParser = ref.read(betParserServiceProvider);
          final notifier = ref.read(matchesNotifierProvider.notifier);

          try {
            final matches = await betParser.fetchMatches();
            await notifier.saveMatches(matches);

            if (context.mounted) {
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
