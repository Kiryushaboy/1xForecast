import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../bloc/match_bloc.dart';

/// AppBar для главной страницы
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppTheme.getAppBarHeight(context);

    return SliverAppBar(
      expandedHeight: appBarHeight,
      pinned: true,
      backgroundColor: context.surfaceColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: UiConstants.spacingLarge,
          bottom: UiConstants.spacingLarge,
        ),
        title: Text(
          '1xForecast',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: context.isMobile
                ? UiConstants.fontSizeXLarge
                : UiConstants.fontSizeXXLarge + 2,
            color: Colors.white,
            letterSpacing: UiConstants.letterSpacingWide,
          ),
        ),
        background: _HomeAppBarBackground(),
      ),
      actions: [
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) => IconButton(
            icon: Icon(
              mode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: Colors.white,
            ),
            tooltip: mode == ThemeMode.dark ? 'Светлая тема' : 'Тёмная тема',
            onPressed: context.read<ThemeCubit>().toggleTheme,
          ),
        ),
        IconButton(
          icon: Icon(Icons.refresh_rounded, color: Colors.white),
          tooltip: 'Обновить',
          onPressed: () => context.read<MatchBloc>().add(LoadMatches()),
        ),
        SizedBox(width: UiConstants.spacingXSmall),
      ],
    );
  }
}

class _HomeAppBarBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(UiConstants.borderRadiusHuge),
          bottomRight: Radius.circular(UiConstants.borderRadiusHuge),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(UiConstants.spacingLarge),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius:
                    BorderRadius.circular(UiConstants.borderRadiusXLarge),
              ),
              child: Icon(
                Icons.sports_soccer,
                size: context.isMobile ? 40 : UiConstants.iconSizeXXLarge,
                color: Colors.white,
              ),
            ),
            SizedBox(height: UiConstants.spacingMedium),
            Text(
              'FIFA FC24 4x4',
              style: TextStyle(
                color: Colors.white.withOpacity(UiConstants.opacityVeryHigh),
                fontSize: context.isMobile
                    ? UiConstants.fontSizeMedium
                    : UiConstants.fontSizeRegular,
                letterSpacing: UiConstants.letterSpacingExtraWide,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
