// Dart
import 'dart:typed_data';
import 'dart:collection';
// Project files
import 'meal_pillmealtime_pair.dart';

// TODO: This list could be used to avoid a Alarm full scan
// Full scan allows a very fast acces to an alarm
// this structure can be used as a set to know which are the existing alarms
// and mantainig the structure is an alternative to the full scan
// when we need to retrieve all the active alarms (edit operations)
// Full scan could be relegated to be a backup for this structure

//==============================================================================

// The usual prescription uses 1-1-1-1 notation
// Using that the requeriment is limited to an AlarmKeyList to exist
// with the correct number of items
// The binding just will match items by index, independent from its contents
// Althought the index in the AlarmKeyList will be meanfully
// Note the first three ones are ordered,
// but the last one meaning could be "between meals" more often that "at night"

// Uses:
// - Settings: define the usual routine (and alternative ones)
// - Prescription: requires the usual routine to be defined
// - Active alarms: built from prescriptions

//==============================================================================


/// A class to implement a tiny list of MealPillmealtimePair
/// It is included in [PrescriptionFrequency]
/// (in the case used, up to 4 elements, but it can stand for more)
/// It represent prescription time by index
class AlarmKeyList extends ListBase<MealPillmealtimePair> {
  //
  final Uint8List _value;

  /// length get
  @override
  int get length => _value.length;

  /// length set
  @override
  set length(int newLength) {
    throw UnsupportedError('Cannot modify the length of an unmodifiable list');
  }

  AlarmKeyList._(List<int> values) : _value = Uint8List.fromList(values);

  /// Ctor
  AlarmKeyList(List<MealPillmealtimePair> values)
    : this._(values.map((x) => x.id).toList(growable: false));

  /// Ctor
  AlarmKeyList.fromJsonList(List<dynamic> values)
    : this._(values.map((x) => x as int).toList(growable: false));

  /// Ctor
  factory AlarmKeyList.parse(String str) {
    str = str.trim();
    if (str[0] == '[' && str[str.length - 1] == ']') {
      final tmp = str.substring(1, str.length - 1).split(',');
      return AlarmKeyList._(
        tmp.map((x) => int.parse(x)).toList(growable: false),
      );
    } else {
      throw ArgumentError("Expected a list of integers");
    }
  }

  /// operator []
  @override
  MealPillmealtimePair operator [](int index) {
    return MealPillmealtimePair(_value[index]);
  }

  /// operator []=
  @override
  void operator []=(int index, MealPillmealtimePair value) {
    _value[index] = value.id;
  }
}
