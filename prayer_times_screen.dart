import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../providers/prayer_provider.dart';
import '../models/prayer_time.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.carbonBlack,
      body: SafeArea(
        child: Consumer<PrayerProvider>(
          builder: (context, prayerProvider, child) {
            final prayerTimes = prayerProvider.prayerTimes;
            final nextPrayer = prayerProvider.nextPrayer;

            return CustomScrollView(
              slivers: [
                // App bar
                SliverAppBar(
                  expandedHeight: 220,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppTheme.carbonBlack,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.islamicGold.withOpacity(0.2),
                            AppTheme.carbonBlack,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Islamic geometric decoration
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                gradient: AppTheme.goldGradient,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.mosque,
                                color: AppTheme.carbonBlack,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'أوقات الصلاة',
                              style: AppTheme.headlineLarge.copyWith(fontSize: 24),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              prayerProvider.gregorianDate,
                              style: AppTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              prayerProvider.hijriDate,
                              style: AppTheme.caption.copyWith(
                                color: AppTheme.islamicGold.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Next prayer countdown
                if (nextPrayer != null)
                  SliverToBoxAdapter(
                    child: _buildNextPrayerCard(nextPrayer, prayerProvider),
                  ),

                // Prayer times list
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Text(
                      'مواقيت اليوم',
                      style: AppTheme.headlineMedium,
                    ),
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final prayer = prayerTimes[index];
                      return _buildPrayerCard(prayer, index);
                    },
                    childCount: prayerTimes.length,
                  ),
                ),

                // Qibla direction
                SliverToBoxAdapter(
                  child: _buildQiblaCard(),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNextPrayerCard(PrayerTime nextPrayer, PrayerProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
          color: AppTheme.islamicGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'الصلاة القادمة',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.islamicGold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nextPrayer.nameAr,
            style: AppTheme.displayMedium.copyWith(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            provider.formattedCountdown,
            style: AppTheme.displayLarge.copyWith(
              fontSize: 40,
              color: AppTheme.islamicGold,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'وقت الصلاة: ${nextPrayer.formattedTime}',
            style: AppTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(PrayerTime prayer, int index) {
    final isNext = prayer.isNext;
    final isPast = prayer.time.isBefore(DateTime.now());

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNext ? AppTheme.deepCharcoal : AppTheme.surfaceGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: isNext
            ? Border.all(color: AppTheme.islamicGold.withOpacity(0.4), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isNext
                  ? AppTheme.islamicGold.withOpacity(0.2)
                  : isPast
                      ? AppTheme.deepEmerald.withOpacity(0.1)
                      : AppTheme.surfaceGray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getPrayerIcon(prayer.nameEn),
              color: isNext
                  ? AppTheme.islamicGold
                  : isPast
                      ? AppTheme.deepEmerald.withOpacity(0.6)
                      : AppTheme.secondaryText,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer.nameAr,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isPast ? AppTheme.secondaryText : AppTheme.primaryText,
                  ),
                ),
                if (isNext)
                  Text(
                    'الصلاة القادمة',
                    style: AppTheme.caption.copyWith(color: AppTheme.islamicGold),
                  ),
              ],
            ),
          ),
          Text(
            prayer.formattedTime,
            style: AppTheme.headlineLarge.copyWith(
              fontSize: 22,
              color: isPast ? AppTheme.secondaryText : AppTheme.primaryText,
            ),
          ),
          if (isNext) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.islamicGold,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.islamicGold.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQiblaCard() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.islamicGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.explore,
                  color: AppTheme.islamicGold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اتجاه القبلة',
                      style: AppTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'تقريبي من موقعك الحالي',
                      style: AppTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.islamicGold.withOpacity(0.2),
                    AppTheme.islamicGold.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.islamicGold.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.rotate(
                      angle: 0.78, // Approximate Qibla direction from default location
                      child: Icon(
                        Icons.navigation,
                        color: AppTheme.islamicGold,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'شمال شرق',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.islamicGold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPrayerIcon(String nameEn) {
    switch (nameEn.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight;
      case 'sunrise':
        return Icons.wb_sunny_outlined;
      case 'dhuhr':
        return Icons.sunny;
      case 'asr':
        return Icons.wb_cloudy_outlined;
      case 'maghrib':
        return Icons.nights_stay_outlined;
      case 'isha':
        return Icons.dark_mode_outlined;
      default:
        return Icons.access_time;
    }
  }
}
