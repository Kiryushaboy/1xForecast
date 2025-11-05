import 'package:flutter/material.dart';
import '../services/team_logo_service.dart';
import '../theme/app_theme.dart';

/// Виджет для отображения логотипа команды
class TeamLogo extends StatelessWidget {
  final String teamName;
  final double size;

  const TeamLogo({
    super.key,
    required this.teamName,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    final logoUrl = TeamLogoService.getTeamLogoUrl(teamName);

    // Если нет логотипа, сразу показываем fallback
    if (logoUrl.isEmpty) {
      return _buildFallbackIcon(context);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.getCard(context),
        borderRadius: BorderRadius.circular(size * 0.15),
        // Убрали внешнюю тень - логотип теперь часть карточки
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.15),
        child: Padding(
          padding: EdgeInsets.all(size * 0.12),
          child: Image.network(
            logoUrl,
            width: size,
            height: size,
            fit: BoxFit.contain,
            filterQuality:
                FilterQuality.high, // Максимальное качество рендеринга
            cacheWidth: (size * 2).toInt(), // Загружаем в 2x разрешении (144px)
            cacheHeight:
                (size * 2).toInt(), // Оптимальное качество при масштабировании
            errorBuilder: (context, error, stackTrace) {
              // При ошибке показываем только иконку мяча внутри
              return Center(
                child: Icon(
                  Icons.sports_soccer,
                  size: size * 0.5,
                  color: AppTheme.primaryBlue,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              // Показываем индикатор загрузки
              return Center(
                child: SizedBox(
                  width: size * 0.3,
                  height: size * 0.3,
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryBlue,
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(size * 0.15),
        // Убрали тень и у fallback иконки
      ),
      child: Center(
        child: Icon(
          Icons.sports_soccer,
          size: size * 0.54,
          color: Colors.white,
        ),
      ),
    );
  }
}
