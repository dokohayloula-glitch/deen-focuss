import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:confetti/confetti.dart';
import '../themes/app_theme.dart';
import '../providers/focus_provider.dart';
import '../providers/task_provider.dart';
import '../providers/stats_provider.dart';

class FocusSessionScreen extends StatefulWidget {
  final String? taskId;
  final String? taskTitle;
  final Duration? initialDuration;

  const FocusSessionScreen({
    super.key,
    this.taskId,
    this.taskTitle,
    this.initialDuration,
  });

  @override
  State<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends State<FocusSessionScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  final TextEditingController _commitmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Initialize focus session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final focusProvider = context.read<FocusProvider>();
      if (widget.taskId != null && widget.taskTitle != null) {
        focusProvider.startCommitment(widget.taskId!, widget.taskTitle!);
      } else {
        focusProvider.startCommitment('free_focus', 'تركيز حر');
        if (widget.initialDuration != null) {
          focusProvider.setDuration(widget.initialDuration!);
        }
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    _commitmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final focusProvider = context.read<FocusProvider>();
        if (focusProvider.isActive) {
          _showExitDialog(context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.carbonBlack,
        body: Consumer<FocusProvider>(
          builder: (context, focusProvider, child) {
            if (focusProvider.showConfetti) {
              _confettiController.play();
            }

            return Stack(
              children: [
                _buildBody(focusProvider),
                // Confetti overlay
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    particleDrag: 0.05,
                    emissionFrequency: 0.05,
                    numberOfParticles: 50,
                    gravity: 0.1,
                    colors: [
                      AppTheme.islamicGold,
                      AppTheme.deepEmerald,
                      Colors.white.withOpacity(0.8),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(FocusProvider focusProvider) {
    switch (focusProvider.session.state) {
      case FocusState.idle:
        return _buildIdleView();
      case FocusState.committed:
        return _buildCommitmentDialog(focusProvider);
      case FocusState.running:
      case FocusState.paused:
        return _buildActiveSession(focusProvider);
      case FocusState.completed:
        return _buildCompletedView(focusProvider);
      case FocusState.cancelled:
        return _buildCancelledView();
    }
  }

  Widget _buildIdleView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppTheme.islamicGold),
          const SizedBox(height: 16),
          Text('جاري التحميل...', style: AppTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildCommitmentDialog(FocusProvider focusProvider) {
    final quote = focusProvider.getRandomQuote();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Quote
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.deepCharcoal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.format_quote,
                    color: AppTheme.islamicGold.withOpacity(0.5),
                    size: 28,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    quote['text']!,
                    style: AppTheme.headlineLarge.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '— ${quote['source']}',
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.islamicGold.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Commitment text
            Text(
              'أتعهد بإتمام هذه العبادة اليوم',
              style: AppTheme.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'اختر مدة التركيز وابدأ رحلتك',
              style: AppTheme.bodySmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Duration selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDurationChip('15 د', const Duration(minutes: 15), focusProvider),
                const SizedBox(width: 8),
                _buildDurationChip('25 د', const Duration(minutes: 25), focusProvider),
                const SizedBox(width: 8),
                _buildDurationChip('45 د', const Duration(minutes: 45), focusProvider),
                const SizedBox(width: 8),
                _buildDurationChip('60 د', const Duration(minutes: 60), focusProvider),
              ],
            ),

            const SizedBox(height: 32),

            // Start button
            GestureDetector(
              onTap: () => focusProvider.startFocus(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: AppTheme.emeraldGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.deepEmerald.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'بدء التركيز',
                      style: AppTheme.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.alertRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(String label, Duration duration, FocusProvider provider) {
    final isSelected = provider.session.duration == duration;

    return GestureDetector(
      onTap: () => provider.setDuration(duration),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.deepEmerald : AppTheme.surfaceGray,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: AppTheme.deepEmerald, width: 2)
              : null,
        ),
        child: Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppTheme.secondaryText,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSession(FocusProvider focusProvider) {
    final progress = focusProvider.session.progress;
    final remaining = focusProvider.session.formattedRemaining;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Task title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              focusProvider.session.taskTitle,
              style: AppTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            focusProvider.session.state == FocusState.paused ? 'متوقف مؤقتاً' : 'وضع التركيز نشط',
            style: AppTheme.bodyMedium.copyWith(
              color: focusProvider.session.state == FocusState.paused
                  ? AppTheme.alertRed
                  : AppTheme.deepEmerald,
            ),
          ),

          const SizedBox(height: 48),

          // Timer circle
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: focusProvider.isRunning ? 1.0 + (_pulseController.value * 0.02) : 1.0,
                child: CircularPercentIndicator(
                  radius: 140,
                  lineWidth: 10,
                  percent: progress,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        remaining,
                        style: AppTheme.displayLarge.copyWith(
                          fontSize: 56,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'متبقي',
                        style: AppTheme.caption,
                      ),
                    ],
                  ),
                  progressColor: AppTheme.deepEmerald,
                  backgroundColor: AppTheme.surfaceGray,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: false,
                  rotateLinearGradient: true,
                ),
              );
            },
          ),

          const SizedBox(height: 48),

          // Motivational text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              focusProvider.getRandomQuote()['text']!,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.secondaryText,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(),

          // Control buttons
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Stop button
                _buildControlButton(
                  Icons.stop,
                  AppTheme.alertRed,
                  () => _showStopDialog(context, focusProvider),
                ),
                const SizedBox(width: 32),
                // Play/Pause button
                _buildControlButton(
                  focusProvider.isRunning ? Icons.pause : Icons.play_arrow,
                  AppTheme.deepEmerald,
                  () {
                    if (focusProvider.isRunning) {
                      focusProvider.pauseFocus();
                    } else {
                      focusProvider.resumeFocus();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }

  Widget _buildCompletedView(FocusProvider focusProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                shape: BoxShape.circle,
                boxShadow: AppTheme.goldGlow,
              ),
              child: const Icon(
                Icons.check,
                color: AppTheme.carbonBlack,
                size: 48,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'أحسنت!',
              style: AppTheme.displayMedium.copyWith(
                color: AppTheme.islamicGold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'أكملت جلسة تركيز مدتها ${focusProvider.session.duration.inMinutes} دقيقة',
              style: AppTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'جزاك الله خيراً على التزامك',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
            const SizedBox(height: 48),
            GestureDetector(
              onTap: () {
                // Complete the associated task if any
                if (widget.taskId != null && widget.taskId != 'free_focus') {
                  context.read<TaskProvider>().completeTask(widget.taskId!);
                  context.read<StatsProvider>().addTaskCompletion(50, focusProvider.session.duration.inMinutes);
                } else {
                  context.read<StatsProvider>().addFocusMinutes(focusProvider.session.duration.inMinutes);
                }
                focusProvider.reset();
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'متابعة',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.carbonBlack,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onTap: () {
                focusProvider.reset();
                Navigator.pop(context);
              },
              child: Text(
                'العودة للرئيسية',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelledView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cancel_outlined,
              size: 64,
              color: AppTheme.alertRed.withOpacity(0.6),
            ),
            const SizedBox(height: 24),
            Text(
              'تم إلغاء الجلسة',
              style: AppTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'لا بأس، حاول مرة أخرى عندما تكون مستعداً',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceGray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'العودة',
                  style: AppTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('إنهاء التركيز؟', style: AppTheme.headlineMedium),
        content: Text(
          'هل أنت متأكد من رغبتك في إنهاء جلسة التركيز؟',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('استمرار', style: TextStyle(color: AppTheme.deepEmerald)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<FocusProvider>().stopFocus();
            },
            child: Text('إنهاء', style: TextStyle(color: AppTheme.alertRed)),
          ),
        ],
      ),
    );
  }

  void _showStopDialog(BuildContext context, FocusProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('إيقاف التركيز؟', style: AppTheme.headlineMedium),
        content: Text(
          'سيتم إيقاف جلسة التركيز الحالية',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('استمرار', style: TextStyle(color: AppTheme.deepEmerald)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.stopFocus();
            },
            child: Text('إيقاف', style: TextStyle(color: AppTheme.alertRed)),
          ),
        ],
      ),
    );
  }
}
