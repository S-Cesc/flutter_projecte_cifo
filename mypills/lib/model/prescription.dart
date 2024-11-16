// project
import 'enums.dart';
import 'pill_meal_time.dart';

//=======================================================================


class Prescription {

  //-----------------class state members and constructors ----------------------

  final String name;
  final PillMealTime pillMealTime;
  PrescriptionFrequency? frequency;
  int? dosage;
  List<int>? daylyDosage; // presses diàries (que admeten variació)
  List<List<int>>?
      daylyVariableDosage; // variació setmanal en les presses diàries
  List<int>? weeklyDosage; // variació setmanal

  Prescription.empty(this.name, this.pillMealTime);

  //-----------------------class rest of members--------------------------------

  bool get isEmpty => (frequency == null);

  void definePrescription(PrescriptionFrequency frequency,
      {int? dosage,
      List<int>? daylyDosage,
      List<List<int>>? daylyVariableDosage,
      List<int>? weeklyDosage}) {
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
