// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/ui_constants.dart';
import '../../../../../../core/theme/app_theme.dart';
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
      expandedHeight: 130,
      collapsedHeight: kToolbarHeight + 16,
      pinned: true,
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
                  // Кнопка назад - выровнена по названиям команд
                  Positioned(
                    left: 8,
                    bottom: UiConstants.spacingLarge + 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () => context.go('/'),
                    ),
                  ),
                  // FlexibleSpace с заголовком
                  FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(
                      left: 60,
                      right: UiConstants.spacingLarge,
                      bottom: UiConstants.spacingLarge + 4,
                    ),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                TeamNameHelper.abbreviate(homeTeam),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'vs',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                TeamNameHelper.abbreviate(awayTeam),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Детальный анализ матча',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    background: const Stack(
                      children: [
                        // Декоративный элемент - футбольный мяч
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Opacity(
                            opacity: 0.08,
                            child: Icon(
                              Icons.sports_soccer,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Надпись FIFA FC24. 4x4
                        Positioned(
                          top: 20,
                          right: 135,
                          child: Opacity(
                            opacity: 0.12,
                            child: Text(
                              'FIFA FC24. 4x4',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
