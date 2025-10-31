import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../domain/entities/matchup.dart';
import '../../widgets/matchup_card.dart';

/// Список/сетка противостояний
class HomeMatchupsList extends StatelessWidget {
  final List<Matchup> matchups;

  const HomeMatchupsList({
    super.key,
    required this.matchups,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return _buildMobileList(context);
    }

    return _buildGrid(
      context,
      context.gridColumns,
      context.isTablet ? UiConstants.spacingMedium : UiConstants.spacingLarge,
    );
  }

  Widget _buildMobileList(BuildContext context) {
    return Column(
      children: matchups
          .map((m) => MatchupCard(
                homeTeam: m.homeTeam,
                awayTeam: m.awayTeam,
                matchCount: m.matchCount,
                onTap: () =>
                    context.go('/analysis/${m.homeTeam}/${m.awayTeam}'),
              ))
          .toList(),
    );
  }

  Widget _buildGrid(BuildContext context, int columns, double spacing) {
    return Column(
      children: List.generate((matchups.length / columns).ceil(), (rowIndex) {
        final start = rowIndex * columns;
        final end = (start + columns).clamp(0, matchups.length);
        final rowItems = matchups.sublist(start, end);

        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            children: [
              for (var i = 0; i < rowItems.length; i++) ...[
                Expanded(
                  child: MatchupCard(
                    homeTeam: rowItems[i].homeTeam,
                    awayTeam: rowItems[i].awayTeam,
                    matchCount: rowItems[i].matchCount,
                    onTap: () => context.go(
                      '/analysis/${rowItems[i].homeTeam}/${rowItems[i].awayTeam}',
                    ),
                  ),
                ),
                if (i < rowItems.length - 1) SizedBox(width: spacing),
              ],
              if (rowItems.length < columns)
                ...List.generate(
                  columns - rowItems.length,
                  (_) => Expanded(child: SizedBox()),
                ),
            ],
          ),
        );
      }),
    );
  }
}
