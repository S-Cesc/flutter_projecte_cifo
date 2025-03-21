/// Constant keys to use in JSON serialization/deserialization
class JsonKeys {

  //--------------------- Main objects keys ------------------------------------

  /// JSON key prefix for alarm objects
  static const alarmJsonKeyPrefix = "a";

  /// JSON key for alarm objects, using its id
  static String alarmJsonKey(int alarmId) => '$alarmJsonKeyPrefix$alarmId';

  /// JSON key for weeklyTimeTable
  static const weeklyTimeTableKey = 'wTimeTable';

  /// JSON key for meals for pills
  static const meals4PillsKey = 'm4p';

  //------------------------- Alarm keys ---------------------------------------

  /// JSON key for an alarm key pair (resolves into a unique int)
  static const pairKey = 'IdKey';

  /// JSON alarm lastShot key
  static const lastShotKey = 'lastShot';

  /// JSON alarm stopped key  
  static const stoppedKey = 'stopped';

  /// JSON alarm dealing with key
  static const dealingWithKey = 'dealingWith';

  /// JSON alarm is running key
  static const isRunningKey = 'isRunning';

  /// JSON alarm is snoozed key
  static const isSnoozedKey = 'isSnoozed';

  /// JSON alarm current replays key
  static const actualReplayKey = 'nReplay';

  //------------------------- Settings keys ------------------------------------

  /// JSON key for alarmDurationSeconds
  static const alarmDurationSecondsKey = 'aDuration';

  /// JSON key for alarmSnoozeSeconds
  static const alarmSnoozeSecondsKey = 'aSnooze';

  /// JSON key for alarmRepeatTimes
  static const alarmRepeatTimesKey = 'aRepeat';

  /// JSON key for minutesToDealWithAlarm
  static const minutesToDealWithAlarmKey = 'aDeal';

  /// JSON key for longBeforeMeal
  static const longBeforeMealKey = 'mLBefore';

  /// JSON key for beforeMeal
  static const beforeMealKey = 'mBefore';

  /// JSON key for afterMeal
  static const afterMealKey = 'mAfter';

  /// JSON key for longAfterMeal
  static const longAfterMealKey = 'mLAfter';

  /// JSON key for breakfastMinutes
  static const breakfastMinMinKey = 'bkfMinMin';

  /// JSON key for breakfastMinutes
  static const breakfastMaxMinKey = 'bkfMaxMin';

  /// JSON key for elevensesMinutes
  static const elevensesMinMinKey = 'elvnMinMin';

  /// JSON key for elevensesMinutes
  static const elevensesMaxMinKey = 'elvnMaxMin';

  /// JSON key for brunchMinutes
  static const brunchMinMinKey = 'brunchMinMin';

  /// JSON key for brunchMinutes
  static const brunchMaxMinKey = 'brunchMaxMin';

  /// JSON key for lunchMinutes
  static const lunchMinMinKey = 'lunchMinMin';

  /// JSON key for lunchMin
  static const lunchMaxMinKey = 'lunchMaxMin';

  /// JSON key for teaMinutes
  static const teaMinMinKey = 'teaMinMin';

  /// JSON key for teaMinutes
  static const teaMaxMinKey = 'teaMaxMin';

  /// JSON key for highTeaMinutes
  static const highTeaMinMinKey = 'hTeaMinMin';

  /// JSON key for highTeaMinutes
  static const highTeaMaxMinKey = 'hTeaMaxMin';

  /// JSON key for dinnerMinutes
  static const dinnerMinMinKey = 'dnrMinMin';

  /// JSON key for dinnerMinutes
  static const dinnerMaxMinKey = 'dnrMaxMin';

  /// JSON key for supperMin
  static const supperMinMinKey = 'supperMinMin';

  /// JSON key for supperMinutes
  static const supperMaxMinKey = 'supperMaxMin';

}