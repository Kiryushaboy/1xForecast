// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/ui_constants.dart';

/// Универсальный виджет для отображения названия команды с иконкой
/// Используется вместо дублирующихся условных конструкций
class TeamLabel extends StatelessWidget {
  final String teamName;
  final bool iconFirst;

  const TeamLabel({
    super.key,
    required this.teamName,
    this.iconFirst = true,
  });

  @override
  Widget build(BuildContext context) {
    final words = teamName.split(' ');
    final textAlign = iconFirst ? TextAlign.left : TextAlign.right;

    final icon = Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(UiConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.sports_soccer,
          size: 28,
          color: Colors.white,
        ),
      ),
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
}
