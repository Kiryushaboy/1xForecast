import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ColorUtils {
  static Color getProbabilityColor(double percentage) {
    if (percentage >= AppConstants.highProbabilityThreshold) {
      return Colors.green;
    } else if (percentage >= AppConstants.mediumProbabilityThreshold) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  static Color getSuccessColor(bool isSuccess) {
    return isSuccess ? Colors.green : Colors.grey;
  }
}

class DateUtils {
  static int calculateSeasonNumber(DateTime date, {int daysPerSeason = 90}) {
    final now = DateTime.now();
    final daysDiff = now.difference(date).inDays;
    return (daysDiff / daysPerSeason).floor() + 1;
  }

  static String formatShortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
