import 'package:flutter/material.dart';
import 'package:datag/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../components/app_top_bar.dart';
import '../components/locale_menu.dart';
import '../state/feedback_settings.dart';
import '../tokens.dart';

class StubScreen extends ConsumerWidget {
  const StubScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(feedbackSettingsProvider);
    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
        ),
        title: Text(title),
        actions: const [LocaleMenu()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.l),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: AppRadius.medium,
                border: Border.all(color: AppColors.borderMuted),
              ),
              child: Text(
                l.stubComingSoon(title),
                style: AppTypography.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _SettingsToggle(
              icon: LucideIcons.volume2,
              label: l.stubSoundToggle,
              value: settings.soundEnabled,
              onChanged: settings.setSoundEnabled,
            ),
            const SizedBox(height: AppSpacing.m),
            _SettingsToggle(
              icon: LucideIcons.vibrate,
              label: l.stubHapticsToggle,
              value: settings.hapticsEnabled,
              onChanged: settings.setHapticsEnabled,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  const _SettingsToggle({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      decoration: BoxDecoration(
        color: AppStateLayers.elevatedSurface(
          value
              ? {WidgetState.selected}
              : const <WidgetState>{},
        ),
        borderRadius: AppRadius.medium,
        border: Border.all(
          color: value ? AppColors.accentSecondary : AppColors.borderMuted,
          width: value ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Text(
              label,
              style: AppTypography.textTheme.titleSmall,
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.accentSecondary.withValues(alpha: 0.4),
            activeThumbColor: AppColors.accentSecondary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
