// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_extensions.dart';

/// AppBar для главной страницы
class HomeAppBar extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const HomeAppBar({super.key, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppTheme.getAppBarHeight(context);
    // Увеличиваем высоту свернутого AppBar чтобы текст помещался
    const collapsedHeight = kToolbarHeight + 32.0;

    return SliverAppBar(
      expandedHeight: appBarHeight,
      collapsedHeight: collapsedHeight,
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Вычисляем насколько свернут AppBar (0.0 = полностью развернут, 1.0 = полностью свернут)
                  final double scrollRatio =
                      ((appBarHeight - constraints.maxHeight) /
                              (appBarHeight - collapsedHeight))
                          .clamp(0.0, 1.0);

                  return FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: EdgeInsets.only(
                      left: context.isMobile
                          ? UiConstants.spacingLarge
                          : UiConstants.spacingXXLarge,
                      bottom: UiConstants.spacingLarge + 4,
                    ),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1xForecast',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: context.isMobile ? 24 : 28,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Кибер FIFA FC24 4x4 (Чемпионат Англии)',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: context.isMobile ? 12 : 14,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    background: Stack(
                      children: [
                        // Декоративный элемент - футбольный мяч в правом верхнем углу
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Opacity(
                            opacity: 0.12 * (1.0 - scrollRatio),
                            child: const Icon(
                              Icons.sports_soccer,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Подпись автора
                        Positioned(
                          bottom: UiConstants.spacingLarge + 36,
                          left: context.isMobile ? 220 : 310,
                          child: Opacity(
                            opacity: 0.3,
                            child: Text(
                              '@Kiryushaboy',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: context.isMobile ? 22 : 26,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      actions: const [],
    );
  }
}
