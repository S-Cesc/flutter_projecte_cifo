import 'day_of_week.dart';

class DayOfWeekSets {
  final List<Set<DayOfWeek>> _weekdaysPartition;

  DayOfWeekSets({required int subsets})
      : _weekdaysPartition = List.filled(subsets, {}) {
    assert(subsets > 0);
  }

  int? operator [](DayOfWeek d) {
    for (int pos = 0; pos < _weekdaysPartition.length; pos++) {
      if (_weekdaysPartition[pos].contains(d)) return pos;
    }
    return null;
  }

  void operator []=(DayOfWeek d, int pos) {
    for (int i = 0; i < _weekdaysPartition.length; i++) {
      if (i == pos) {
        _weekdaysPartition[pos].add(d);
      } else {
        _weekdaysPartition[pos].remove(d);
      }
    }
  }

  bool isDayOfWeek(DayOfWeek d, int pos) => _weekdaysPartition[pos].contains(d);

  Set<DayOfWeek> get missingDays {
    Set<DayOfWeek> s = {
      DayOfWeek.monday,
      DayOfWeek.tuesday,
      DayOfWeek.wednesday,
      DayOfWeek.thursday,
      DayOfWeek.friday,
      DayOfWeek.saturday,
      DayOfWeek.sunday,
    };
    for (int pos = 0; pos < _weekdaysPartition.length; pos++) {
      s = s.difference(_weekdaysPartition[pos]);
    }
    return s;
  }
}
