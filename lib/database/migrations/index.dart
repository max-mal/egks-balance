import 'cardMigration.dart';
import 'preferencesMigration.dart';

var migrations = [
  PreferencesMigration(),
  CardMigration(),
  CardHistoryMigration()
];