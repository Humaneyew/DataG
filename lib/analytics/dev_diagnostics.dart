import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevDiagnosticsEntry {
  const DevDiagnosticsEntry({
    required this.timestamp,
    required this.label,
    required this.details,
  });

  final DateTime timestamp;
  final String label;
  final String details;
}

class DevDiagnosticsNotifier extends StateNotifier<List<DevDiagnosticsEntry>> {
  DevDiagnosticsNotifier() : super(const []);

  static const int _maxEntries = 50;

  void log({required String label, required String details}) {
    if (!kDebugMode) return;
    final entry = DevDiagnosticsEntry(
      timestamp: DateTime.now(),
      label: label,
      details: details,
    );
    debugPrint('[DevDiagnostics] $label — $details');
    final updated = [...state, entry];
    if (updated.length > _maxEntries) {
      updated.removeRange(0, updated.length - _maxEntries);
    }
    state = List.unmodifiable(updated);
  }

  void clear() {
    state = const [];
  }
}

class DevDiagnosticsService {
  DevDiagnosticsService(this._ref);

  final Ref _ref;

  void logAnswer({
    required String questionId,
    required int delta,
    required Duration timeSpent,
    required int hintsUsed,
  }) {
    if (!kDebugMode) return;
    final seconds = timeSpent.inMilliseconds / 1000;
    _ref.read(devDiagnosticsProvider.notifier).log(
          label: 'Answer $questionId',
          details:
              'delta=$delta, time=${seconds.toStringAsFixed(2)}s, hints=$hintsUsed',
        );
  }

  void logHint({
    required String questionId,
    required String hintType,
  }) {
    if (!kDebugMode) return;
    _ref.read(devDiagnosticsProvider.notifier).log(
          label: 'Hint $questionId',
          details: hintType,
        );
  }

  void clear() {
    if (!kDebugMode) return;
    _ref.read(devDiagnosticsProvider.notifier).clear();
  }
}

final devDiagnosticsProvider =
    StateNotifierProvider<DevDiagnosticsNotifier, List<DevDiagnosticsEntry>>(
  (ref) => DevDiagnosticsNotifier(),
);

final devDiagnosticsServiceProvider = Provider<DevDiagnosticsService>((ref) {
  return DevDiagnosticsService(ref);
});

final devToolsEnabledProvider = StateProvider<bool>((ref) => false);

class DevToolsOverlay extends ConsumerWidget {
  const DevToolsOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) {
      return child;
    }
    final enabled = ref.watch(devToolsEnabledProvider);
    final entries = ref.watch(devDiagnosticsProvider);
    return Stack(
      children: [
        child,
        if (enabled && entries.isNotEmpty)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _DevPanel(entries: entries),
            ),
          ),
      ],
    );
  }
}

class _DevPanel extends ConsumerWidget {
  const _DevPanel({required this.entries});

  final List<DevDiagnosticsEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.black.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320, maxHeight: 280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    'Dev tools',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () =>
                        ref.read(devDiagnosticsProvider.notifier).clear(),
                    icon: const Icon(Icons.delete_forever, color: Colors.white70),
                    tooltip: 'Clear',
                  ),
                  IconButton(
                    onPressed: () =>
                        ref.read(devToolsEnabledProvider.notifier).state = false,
                    icon: const Icon(Icons.close, color: Colors.white70),
                    tooltip: 'Hide',
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white24),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[entries.length - index - 1];
                  final time = TimeOfDay.fromDateTime(entry.timestamp);
                  final label = entry.label;
                  final details = entry.details;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${time.format(context)} — $label',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                          const SizedBox(height: 2),
                          Text(details, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showDevToolsMenu(BuildContext context) async {
  if (!kDebugMode) {
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.black,
    builder: (context) {
      return const _DevToolsSheet();
    },
  );
}

class _DevToolsSheet extends ConsumerWidget {
  const _DevToolsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(devToolsEnabledProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Developer tools',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              value: enabled,
              onChanged: (value) {
                ref.read(devToolsEnabledProvider.notifier).state = value;
                Navigator.of(context).pop();
              },
              title: const Text('Dev tools', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
