import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../models/prayer_time.dart';

class PrayerCountdownCard extends StatelessWidget {
  final PrayerTime? nextPrayer;
  final String formattedCountdown;

  const PrayerCountdownCard({
    super.key,
    this.nextPrayer,
    required this.formattedCountdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.islamicGold.withOpacity(0.2),
            AppTheme.islamicGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.islamicGold.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                color: AppTheme.islamicGold,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'الصلاة القادمة',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.islamicGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (nextPrayer != null)
            Text(
              nextPrayer!.nameAr,
              style: AppTheme.headlineLarge.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            formattedCountdown,
            style: AppTheme.displayLarge.copyWith(
              fontSize: 48,
              color: AppTheme.islamicGold,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          if (nextPrayer != null)
            Text(
              'وقت الصلاة: ${nextPrayer!.formattedTime}',
              style: AppTheme.caption,
            ),
        ],
      ),
    );
  }
}
