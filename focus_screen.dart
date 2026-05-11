import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../providers/task_provider.dart';
import '../models/islamic_task.dart';
import 'focus_session_screen.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.carbonBlack,
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            final pendingTasks = taskProvider.pendingTasks;

            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),

                // Motivational quote
                SliverToBoxAdapter(
                  child: _buildQuoteCard(),
                ),

                // Quick focus section
                SliverToBoxAdapter(
                  child: _buildQuickFocusSection(context),
                ),

                // Tasks to focus on
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'اختر مهمة للتركيز',
                          style: AppTheme.headlineMedium,
                        ),
                        Text(
                          '${pendingTasks.length} مهمة',
                          style: AppTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),

                if (pendingTasks.isEmpty)
                  SliverToBoxAdapter(
                    child: _buildAllCompleted(context),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = pendingTasks[index];
                        return _buildFocusTaskCard(context, task, index);
                      },
                      childCount: pendingTasks.length,
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'وضع التركيز',
            style: AppTheme.displayMedium.copyWith(
              color: AppTheme.islamicGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ركز على عبادتك وابتعد عن المشتتات',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    final quotes = [
      {
        'text': 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
        'source': 'صحيح البخاري',
      },
      {
        'text': 'مَنْ يَتَّقِ اللَّهَ يَجْعَلْ لَهُ مَخْرَجًا',
        'source': 'سورة الطلاق: 2',
      },
      {
        'text': 'وَقُل رَّبِّ زِدْنِي عِلْمًا',
        'source': 'سورة طه: 114',
      },
    ];

    final randomQuote = quotes[DateTime.now().millisecond % quotes.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppTheme.islamicGold.withOpacity(0.15),
            AppTheme.deepEmerald.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.islamicGold.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.format_quote,
            color: AppTheme.islamicGold.withOpacity(0.5),
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            randomQuote['text']!,
            style: AppTheme.headlineLarge.copyWith(
              fontSize: 22,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '— ${randomQuote['source']}',
            style: AppTheme.caption.copyWith(
              color: AppTheme.islamicGold.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFocusSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تركيز سريع',
            style: AppTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDurationButton(context, '15 دقيقة', 15),
              const SizedBox(width: 12),
              _buildDurationButton(context, '25 دقيقة', 25),
              const SizedBox(width: 12),
              _buildDurationButton(context, '45 دقيقة', 45),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurationButton(BuildContext context, String label, int minutes) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FocusSessionScreen(
                initialDuration: Duration(minutes: minutes),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: AppTheme.emeraldGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.deepEmerald.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                '$minutes',
                style: AppTheme.headlineLarge.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              Text(
                'دقيقة',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFocusTaskCard(BuildContext context, IslamicTask task, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FocusSessionScreen(
              taskId: task.id,
              taskTitle: task.title,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.deepCharcoal,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.surfaceGrayLight.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.deepEmerald.withOpacity(0.3),
                    AppTheme.deepEmerald.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: AppTheme.deepEmerald,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${task.category.labelAr} • ${task.time}',
                    style: AppTheme.caption,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.islamicGold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${task.rewardPoints} نقطة',
                style: AppTheme.caption.copyWith(
                  color: AppTheme.islamicGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllCompleted(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              shape: BoxShape.circle,
              boxShadow: AppTheme.goldGlow,
            ),
            child: const Icon(
              Icons.celebration,
              color: AppTheme.carbonBlack,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'بارك الله فيك!',
            style: AppTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'أكملت جميع مهامك. استغل وقتك في تركيز إضافي أو استراحة',
            style: AppTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FocusSessionScreen(
                    initialDuration: Duration(minutes: 25),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'بدء تركيز حر',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.carbonBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
