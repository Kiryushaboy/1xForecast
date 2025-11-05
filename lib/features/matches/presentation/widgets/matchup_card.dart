// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/services/bet_analysis_service.dart';
import '../bloc/match_bloc.dart';
import 'bet_recommendation_widget.dart';
import 'team_label.dart';

class MatchupCard extends BaseCard {
  final String homeTeam;
  final String awayTeam;
  final int matchCount;

  const MatchupCard({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.matchCount,
    required super.onTap,
  });

  @override
  Widget buildContent(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: UiConstants.animationDurationSlow,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, UiConstants.spacingXLarge * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TeamLabel(teamName: homeTeam),
              _buildVsBadge(),
              TeamLabel(teamName: awayTeam, iconFirst: false),
            ],
          ),
          _buildRecommendation(context),
        ],
      ),
    );
  }

  Widget _buildRecommendation(BuildContext context) {
    final state = context.watch<MatchBloc>().state;

    if (state is! MatchLoaded) {
      return const SizedBox.shrink();
    }

    // Получаем матчи для этого противостояния
    final matches = state.matches
        .where(
            (match) => match.homeTeam == homeTeam && match.awayTeam == awayTeam)
        .toList();

    if (matches.isEmpty) {
      return const SizedBox.shrink();
    }

    final analysisService = BetAnalysisService();
    final recommendation = analysisService.analyzeBestBet(
      matches,
      awayTeam, // team1 - гости
      homeTeam, // team2 - хозяева
    );

    return BetRecommendationWidget(recommendation: recommendation);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: UiConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppTheme.getCard(context),
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusXLarge),
        border: Border.all(
          color: AppTheme.isDarkMode(context)
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (AppTheme.isDarkMode(context) ? Colors.black : Colors.black)
                .withOpacity(AppTheme.isDarkMode(context) ? 0.15 : 0.06),
            blurRadius: UiConstants.elevationXHigh,
            offset: const Offset(0, UiConstants.elevationLow),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConstants.cardPaddingMedium,
            vertical: UiConstants.cardPaddingMedium + 4,
          ),
          child: buildContent(context),
        ),
      ),
    );
  }

  Widget _buildVsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'VS',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
