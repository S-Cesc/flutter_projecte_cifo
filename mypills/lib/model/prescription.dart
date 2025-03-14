// ignore_for_file: public_member_api_docs

// project
import 'enum/frequency.dart';
import 'enum/pill_meal_time.dart';


//TODO - Prescriptions:
// - A prescription could be a pair <key, data>
// - Prescriptions stored on database, and loaded on demand
// - A method to get the PrescriptionFrequency data by key
// - Alarm would have the PrescriptionFrequencies cached
// - as an iterable of <PrescriptionKey, PrescriptionFrequency>


class Prescription {
  //-----------------class state members and constructors ----------------------

  // TODO: include key for prescription (numeric?)
  // TODO: include prescription frequency (half part of data)

  final String name;
  final PillMealTime pillMealTime;
  Frequency? frequency;
  int? dosage;
  List<int>? daylyDosage; // presses diàries (que admeten variació)
  List<List<int>>?
  daylyVariableDosage; // variació setmanal en les presses diàries
  List<int>? weeklyDosage; // variació setmanal

  Prescription.empty(this.name, this.pillMealTime);

  //-----------------------class rest of members--------------------------------

  bool get isEmpty => (frequency == null);

  void definePrescription(
    Frequency frequency, {
    int? dosage,
    List<int>? daylyDosage,
    List<List<int>>? daylyVariableDosage,
    List<int>? weeklyDosage,
  }) {
    assert(!(dosage != null && daylyDosage != null));
    assert(!(dosage != null && daylyVariableDosage != null));
    assert(!(dosage != null && weeklyDosage != null));
    assert(!(daylyDosage != null && daylyVariableDosage != null));
    assert(!(daylyDosage != null && weeklyDosage != null));
    assert(!(daylyVariableDosage != null && weeklyDosage != null));
    this.frequency = frequency;
    this.dosage = dosage;
    this.daylyDosage = daylyDosage;
    this.daylyVariableDosage = daylyVariableDosage;
    this.weeklyDosage = weeklyDosage;
  }
}
