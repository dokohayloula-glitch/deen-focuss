import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../providers/settings_provider.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.carbonBlack,
      body: SafeArea(
        child: Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),

                // Profile section
                SliverToBoxAdapter(
                  child: _buildProfileCard(settingsProvider),
                ),

                // Notifications
                SliverToBoxAdapter(
                  child: _buildSettingsGroup(
                    'الإشعارات',
                    [
                      _buildSwitchTile(
                        'تفعيل الإشعارات',
                        Icons.notifications_outlined,
                        settingsProvider.notificationsEnabled,
                        (value) => settingsProvider.setNotificationsEnabled(value),
                      ),
                      if (settingsProvider.notificationsEnabled) ...[
                        _buildSwitchTile(
                          'تذكيرات الصلاة',
                          Icons.mosque_outlined,
                          settingsProvider.prayerNotifications,
                          (value) => settingsProvider.setPrayerNotifications(value),
                        ),
                        _buildSwitchTile(
                          'تذكيرات المهام',
                          Icons.task_alt_outlined,
                          settingsProvider.taskNotifications,
                          (value) => settingsProvider.setTaskNotifications(value),
                        ),
                        _buildSwitchTile(
                          'تذكيرات التركيز',
                          Icons.self_improvement_outlined,
                          settingsProvider.focusReminders,
                          (value) => settingsProvider.setFocusReminders(value),
                        ),
                      ],
                    ],
                  ),
                ),

                // Reminder times
                SliverToBoxAdapter(
                  child: _buildSettingsGroup(
                    'أوقات التذكير',
                    [
                      _buildTimePickerTile(
                        context,
                        'تذكير الصباح',
                        Icons.wb_sunny_outlined,
                        settingsProvider.morningReminderTime,
                        (time) => settingsProvider.setMorningReminderTime(time),
                      ),
                      _buildTimePickerTile(
                        context,
                        'تذكير المساء',
                        Icons.nights_stay_outlined,
                        settingsProvider.eveningReminderTime,
                        (time) => settingsProvider.setEveningReminderTime(time),
                      ),
                    ],
                  ),
                ),

                // General
                SliverToBoxAdapter(
                  child: _buildSettingsGroup(
                    'عام',
                    [
                      _buildNavigationTile(
                        'تغيير الاسم',
                        Icons.person_outline,
                        () => _showNameDialog(context, settingsProvider),
                      ),
                      _buildNavigationTile(
                        'موقع الصلاة',
                        Icons.location_on_outlined,
                        () => _showLocationDialog(context),
                      ),
                    ],
                  ),
                ),

                // Data management
                SliverToBoxAdapter(
                  child: _buildSettingsGroup(
                    'إدارة البيانات',
                    [
                      _buildDangerTile(
                        'إعادة تعيين جميع البيانات',
                        Icons.delete_outline,
                        () => _showResetDialog(context),
                      ),
                    ],
                  ),
                ),

                // App info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.star_border,
                          color: AppTheme.islamicGold.withOpacity(0.3),
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Deen Focus',
                          style: AppTheme.headlineMedium.copyWith(
                            color: AppTheme.tertiaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'الإصدار 1.0.0',
                          style: AppTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
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
            'الإعدادات',
            style: AppTheme.displayMedium.copyWith(
              color: AppTheme.islamicGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'خصص تجربتك في التطبيق',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(SettingsProvider settingsProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.carbonBlack.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: AppTheme.carbonBlack,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  settingsProvider.userName,
                  style: AppTheme.headlineLarge.copyWith(
                    color: AppTheme.carbonBlack,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'مستخدم Deen Focus',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.carbonBlack.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_back_ios,
            color: AppTheme.carbonBlack.withOpacity(0.5),
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: AppTheme.caption.copyWith(
                color: AppTheme.islamicGold.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.deepCharcoal,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.secondaryText),
      title: Text(title, style: AppTheme.bodyMedium),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.islamicGold,
        activeTrackColor: AppTheme.islamicGold.withOpacity(0.3),
        inactiveThumbColor: AppTheme.surfaceGray,
        inactiveTrackColor: AppTheme.surfaceGray.withOpacity(0.3),
      ),
    );
  }

  Widget _buildTimePickerTile(
    BuildContext context,
    String title,
    IconData icon,
    TimeOfDay time,
    ValueChanged<TimeOfDay> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.secondaryText),
      title: Text(title, style: AppTheme.bodyMedium),
      trailing: Text(
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
        style: AppTheme.bodyMedium.copyWith(
          color: AppTheme.islamicGold,
        ),
      ),
      onTap: () async {
        final newTime = await showTimePicker(
          context: context,
          initialTime: time,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: AppTheme.deepCharcoal,
                  hourMinuteTextColor: AppTheme.primaryText,
                  dialHandColor: AppTheme.islamicGold,
                  dialBackgroundColor: AppTheme.surfaceGray,
                  dialTextColor: AppTheme.primaryText,
                  entryModeIconColor: AppTheme.islamicGold,
                ),
              ),
              child: child!,
            );
          },
        );
        if (newTime != null) {
          onChanged(newTime);
        }
      },
    );
  }

  Widget _buildNavigationTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.secondaryText),
      title: Text(title, style: AppTheme.bodyMedium),
      trailing: const Icon(
        Icons.arrow_back_ios,
        color: AppTheme.secondaryText,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDangerTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.alertRed),
      title: Text(
        title,
        style: AppTheme.bodyMedium.copyWith(color: AppTheme.alertRed),
      ),
      onTap: onTap,
    );
  }

  void _showNameDialog(BuildContext context, SettingsProvider provider) {
    final controller = TextEditingController(text: provider.userName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('تغيير الاسم', style: AppTheme.headlineMedium),
        content: TextField(
          controller: controller,
          style: AppTheme.bodyLarge,
          textAlign: TextAlign.right,
          decoration: AppTheme.inputDecoration.copyWith(
            hintText: 'أدخل اسمك',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: AppTheme.secondaryText)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.setUserName(controller.text);
              }
              Navigator.pop(context);
            },
            child: Text('حفظ', style: TextStyle(color: AppTheme.islamicGold)),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('موقع الصلاة', style: AppTheme.headlineMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              size: 48,
              color: AppTheme.islamicGold.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'يتم استخدام موقعك لحساب أوقات الصلاة بدقة',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.secondaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'الموقع الحالي: مكة المكرمة (افتراضي)',
              style: AppTheme.caption,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: AppTheme.secondaryText)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement location picker
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'سيتم إضافة خريطة لاختيار الموقع في الإصدار القادم',
                    style: AppTheme.bodyMedium,
                  ),
                  backgroundColor: AppTheme.deepCharcoal,
                ),
              );
            },
            child: Text('تحديث الموقع', style: TextStyle(color: AppTheme.islamicGold)),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: AppTheme.alertRed),
            const SizedBox(width: 8),
            Text('تأكيد إعادة التعيين', style: AppTheme.headlineMedium),
          ],
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف جميع بياناتك؟ لا يمكن التراجع عن هذا الإجراء.',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: AppTheme.secondaryText)),
          ),
          TextButton(
            onPressed: () async {
              await context.read<StorageService>().resetAllData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم إعادة تعيين البيانات بنجاح',
                    style: AppTheme.bodyMedium,
                  ),
                  backgroundColor: AppTheme.deepEmerald,
                ),
              );
            },
            child: Text('تأكيد', style: TextStyle(color: AppTheme.alertRed)),
          ),
        ],
      ),
    );
  }
}
