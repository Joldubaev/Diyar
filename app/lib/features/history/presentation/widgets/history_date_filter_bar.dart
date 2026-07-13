import 'package:flutter/material.dart';

/// Пресеты фильтра истории по дате.
enum HistoryDateFilterPreset { all, today, week, month, custom }

/// Выбранный фильтр: пресет + фактический диапазон (null — без фильтра).
class HistoryDateFilterValue {
  final HistoryDateFilterPreset preset;
  final DateTimeRange? range;

  const HistoryDateFilterValue._(this.preset, this.range);

  const HistoryDateFilterValue.all() : this._(HistoryDateFilterPreset.all, null);

  factory HistoryDateFilterValue.preset(HistoryDateFilterPreset preset, DateTime now) {
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return switch (preset) {
      HistoryDateFilterPreset.all => const HistoryDateFilterValue.all(),
      HistoryDateFilterPreset.today =>
        HistoryDateFilterValue._(preset, DateTimeRange(start: todayStart, end: todayEnd)),
      HistoryDateFilterPreset.week => HistoryDateFilterValue._(
          preset,
          DateTimeRange(start: todayStart.subtract(const Duration(days: 6)), end: todayEnd),
        ),
      HistoryDateFilterPreset.month => HistoryDateFilterValue._(
          preset,
          DateTimeRange(start: todayStart.subtract(const Duration(days: 29)), end: todayEnd),
        ),
      HistoryDateFilterPreset.custom =>
        throw ArgumentError('custom создаётся через HistoryDateFilterValue.custom'),
    };
  }

  factory HistoryDateFilterValue.custom(DateTimeRange picked) {
    // Конец диапазона включительно — до конца выбранного дня.
    final end = DateTime(picked.end.year, picked.end.month, picked.end.day, 23, 59, 59);
    return HistoryDateFilterValue._(
      HistoryDateFilterPreset.custom,
      DateTimeRange(start: picked.start, end: end),
    );
  }
}

/// Горизонтальная панель чипов фильтра по дате:
/// «Все / Сегодня / 7 дней / 30 дней / Период…».
/// Используется на всех экранах истории для единого UX.
class HistoryDateFilterBar extends StatelessWidget {
  final HistoryDateFilterValue value;
  final ValueChanged<HistoryDateFilterValue> onChanged;

  const HistoryDateFilterBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      initialDateRange: value.preset == HistoryDateFilterPreset.custom ? value.range : null,
    );
    if (picked == null) return;
    onChanged(HistoryDateFilterValue.custom(picked));
  }

  String _customLabel() {
    final range = value.range;
    if (value.preset != HistoryDateFilterPreset.custom || range == null) return 'Период';
    String two(int n) => n.toString().padLeft(2, '0');
    String d(DateTime x) => '${two(x.day)}.${two(x.month)}';
    return '${d(range.start)} – ${d(range.end)}';
  }

  @override
  Widget build(BuildContext context) {
    final presets = [
      (HistoryDateFilterPreset.all, 'Все'),
      (HistoryDateFilterPreset.today, 'Сегодня'),
      (HistoryDateFilterPreset.week, '7 дней'),
      (HistoryDateFilterPreset.month, '30 дней'),
    ];

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        children: [
          for (final (preset, label) in presets)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(label),
                selected: value.preset == preset,
                onSelected: (_) =>
                    onChanged(HistoryDateFilterValue.preset(preset, DateTime.now())),
              ),
            ),
          ChoiceChip(
            avatar: value.preset == HistoryDateFilterPreset.custom
                ? null
                : const Icon(Icons.date_range, size: 16),
            label: Text(_customLabel()),
            selected: value.preset == HistoryDateFilterPreset.custom,
            onSelected: (_) => _pickCustomRange(context),
          ),
        ],
      ),
    );
  }
}
