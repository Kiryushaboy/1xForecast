// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/team_logo.dart';

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
}
