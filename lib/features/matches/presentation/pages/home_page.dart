import 'package:flutter/gestures.dart';
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
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _scrollToSearch() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
          scrollbars: false,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            HomeAppBar(onSearchTap: _scrollToSearch),
            _buildSearchBar(context),
            _buildContent(context),
          ],
        ),
      ),
      floatingActionButton: HomeLoadDataFAB(
        onPressed: () => _handleLoadData(context),
        isLoading: _isLoading,
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          int resultsCount = 0;
          if (state is MatchLoaded) {
            final matchups = _groupMatchesByMatchup(state.matches);
            final filtered = _filterMatchups(matchups);
            resultsCount = filtered.length;
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(
              context.horizontalPadding,
              16,
              context.horizontalPadding,
              20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок поиска с счётчиком
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Поиск противостояний',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        Row(
                          children: [
                            Text(
                              'Найдено:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: context.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1E88E5),
                                    Color(0xFF1565C0)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1E88E5)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                '$resultsCount',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Поле поиска
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1E88E5).withOpacity(0.08),
                        const Color(0xFF1565C0).withOpacity(0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E88E5).withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: (context.isDark ? Colors.black : Colors.black)
                            .withOpacity(context.isDark ? 0.2 : 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Введите название команды...',
                      hintStyle: TextStyle(
                        color: context.textSecondary.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.search_rounded,
                          color: const Color(0xFF1E88E5),
                          size: 26,
                        ),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: context.textSecondary,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF1E88E5),
                          width: 2.5,
                        ),
                      ),
                      filled: true,
                      fillColor: context.surfaceColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(context.horizontalPadding),
        child: BlocBuilder<MatchBloc, MatchState>(
          builder: (context, state) {
            if (state is MatchLoading || _isLoading) {
              return _buildLoadingIndicator(context);
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
              final filteredMatchups = _filterMatchups(matchups);

              if (filteredMatchups.isEmpty && _searchQuery.isNotEmpty) {
                return _buildNoResults();
              }

              return HomeMatchupsContent(
                matchups: filteredMatchups,
                totalMatches: matches.length,
              );
            }

            return const StateWidget.empty();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Загрузка данных...',
              style: TextStyle(
                fontSize: 16,
                color: context.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Генерируем статистику матчей',
              style: TextStyle(
                fontSize: 14,
                color: context.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: context.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Ничего не найдено',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить запрос',
              style: TextStyle(
                fontSize: 14,
                color: context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Matchup> _filterMatchups(List<Matchup> matchups) {
    if (_searchQuery.isEmpty) return matchups;

    // Разбиваем запрос на слова
    final searchWords = _searchQuery.trim().split(RegExp(r'\s+'));

    // Если одно слово - ищем в любой команде
    if (searchWords.length == 1) {
      return matchups.where((matchup) {
        final homeTeam = matchup.homeTeam.toLowerCase();
        final awayTeam = matchup.awayTeam.toLowerCase();
        return homeTeam.contains(searchWords[0]) ||
            awayTeam.contains(searchWords[0]);
      }).toList();
    }

    // Если несколько слов - сначала ищем точные пары команд
    final exactMatches = <Matchup>[];
    final partialMatches = <Matchup>[];

    for (final matchup in matchups) {
      final homeTeam = matchup.homeTeam.toLowerCase();
      final awayTeam = matchup.awayTeam.toLowerCase();
      final bothTeams = '$homeTeam $awayTeam';

      // Проверяем, что все слова присутствуют в паре команд
      final allWordsFound =
          searchWords.every((word) => bothTeams.contains(word));

      if (allWordsFound) {
        // Это точная пара - обе команды содержат слова из запроса
        exactMatches.add(matchup);
      } else {
        // Проверяем частичное совпадение (хотя бы одно слово в одной команде)
        final hasPartialMatch = searchWords
            .any((word) => homeTeam.contains(word) || awayTeam.contains(word));

        if (hasPartialMatch) {
          partialMatches.add(matchup);
        }
      }
    }

    // Возвращаем сначала точные совпадения, потом частичные
    // Если есть точные - показываем только их
    if (exactMatches.isNotEmpty && exactMatches.length <= 5) {
      return exactMatches;
    }

    // Иначе показываем все результаты
    return [...exactMatches, ...partialMatches];
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
    setState(() {
      _isLoading = true;
    });

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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
