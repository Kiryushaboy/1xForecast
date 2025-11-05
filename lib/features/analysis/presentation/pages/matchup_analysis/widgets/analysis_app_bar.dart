// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/ui_constants.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/services/team_logo_service.dart';
import '../utils/team_name_helper.dart';

/// AppBar для страницы анализа матча
class AnalysisAppBar extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;

  const AnalysisAppBar({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 110,
      collapsedHeight: 110,
      pinned: true,
      floating: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
              ),
              child: Stack(
                children: [
                  // Background декорации
                  Positioned.fill(
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Логотип команды хозяев (левый)
                            Opacity(
                              opacity: 0.12,
                              child: _buildTeamLogoBackground(homeTeam),
                            ),
                            // Надпись FIFA FC24. 4x4
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 60),
                                child: Opacity(
                                  opacity: 0.15,
                                  child: Text(
                                    'FIFA FC24. 4x4',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Логотип команды гостей (правый)
                            Opacity(
                              opacity: 0.12,
                              child: _buildTeamLogoBackground(awayTeam),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Контент поверх фона
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UiConstants.spacingLarge,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Строка с командами и VS
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: UiConstants.spacingLarge + 4),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 26,
                                  child: Row(
                                    children: [
                                      // Левая команда (хозяева)
                                      Expanded(
                                        child: Text(
                                          TeamNameHelper.abbreviate(homeTeam),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                            height: 1.2,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      // VS по центру с отступами
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 55),
                                        child: Text(
                                          'VS',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ),
                                      // Правая команда (гости)
                                      Expanded(
                                        child: Text(
                                          TeamNameHelper.abbreviate(awayTeam),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                            height: 1.2,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Подзаголовок
                                Text(
                                  'Анализ матча',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamLogoBackground(String teamName) {
    final logoUrl = TeamLogoService.getTeamLogoUrl(teamName);

    if (logoUrl.isEmpty) {
      // Fallback на иконку мяча если нет логотипа
      return const Icon(
        Icons.sports_soccer,
        size: 100,
        color: Colors.white,
      );
    }

    return SizedBox(
      width: 100,
      height: 100,
      child: Image.network(
        logoUrl,
        width: 100,
        height: 100,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        cacheWidth: 200, // Загружаем в 2x разрешении
        cacheHeight: 200,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.sports_soccer,
            size: 100,
            color: Colors.white,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Icon(
            Icons.sports_soccer,
            size: 100,
            color: Colors.white,
          );
        },
      ),
    );
  }
}
