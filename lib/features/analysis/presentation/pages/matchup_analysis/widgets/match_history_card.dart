// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../matches/domain/entities/match.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/constants/ui_constants.dart';
import '../../../../../../core/widgets/team_logo.dart';

/// Виджет для отображения одного матча из истории
class MatchHistoryCard extends StatelessWidget {
  final Match match;

  const MatchHistoryCard({
    super.key,
    required this.match,
  });

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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstants.cardPaddingMedium,
          vertical: UiConstants.cardPaddingMedium + 4,
        ),
        child: Column(
          children: [
            // Команды и счёт
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamLabel(context, match.homeTeam, true),
                _buildScoreBadge(
                    context, match.homeScore, match.awayScore, match.date),
                _buildTeamLabel(context, match.awayTeam, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamLabel(
      BuildContext context, String teamName, bool iconFirst) {
    final words = teamName.split(' ');
    final textAlign = iconFirst ? TextAlign.left : TextAlign.right;

    final icon = TeamLogo(
      teamName: teamName,
      size: 72,
    );

    final text = Expanded(
      child: Text(
        words.join('\n'),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppTheme.getTextPrimary(context),
          height: 1.3,
        ),
        textAlign: textAlign,
        softWrap: true,
      ),
    );

    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: iconFirst
            ? [icon, const SizedBox(width: 10), text]
            : [text, const SizedBox(width: 10), icon],
      ),
    );
  }

  Widget _buildScoreBadge(
      BuildContext context, int homeScore, int awayScore, DateTime date) {
    final dateFormat = DateFormat('dd.MM.yy');
    final formattedDate = dateFormat.format(date);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            '$homeScore:$awayScore',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formattedDate,
          style: const TextStyle(
            color: AppTheme.primaryDark,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
