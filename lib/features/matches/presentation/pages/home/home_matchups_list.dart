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
      children: List.generate(
        matchups.length,
        (index) {
          final matchup = matchups[index];
          return _AnimatedMatchupCard(
            index: index,
            homeTeam: matchup.homeTeam,
            awayTeam: matchup.awayTeam,
            matchCount: matchup.matchCount,
            onTap: () =>
                context.go('/analysis/${matchup.homeTeam}/${matchup.awayTeam}'),
          );
        },
      ),
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
                  child: _AnimatedMatchupCard(
                    index: start + i,
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
                  (_) => const Expanded(child: SizedBox()),
                ),
            ],
          ),
        );
      }),
    );
  }
}

/// Виджет карточки с анимацией появления
class _AnimatedMatchupCard extends StatefulWidget {
  final int index;
  final String homeTeam;
  final String awayTeam;
  final int matchCount;
  final VoidCallback onTap;

  const _AnimatedMatchupCard({
    required this.index,
    required this.homeTeam,
    required this.awayTeam,
    required this.matchCount,
    required this.onTap,
  });

  @override
  State<_AnimatedMatchupCard> createState() => _AnimatedMatchupCardState();
}

class _AnimatedMatchupCardState extends State<_AnimatedMatchupCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Задержка перед анимацией зависит от индекса
    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: MatchupCard(
          homeTeam: widget.homeTeam,
          awayTeam: widget.awayTeam,
          matchCount: widget.matchCount,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
