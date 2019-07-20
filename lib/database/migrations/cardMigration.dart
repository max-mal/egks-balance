import '../init.dart';
import '../core/models/migration.dart';

class CardMigration extends Migration {
  String name = "card_table_create";

  void apply() async {
    var database = await db.open();

    database.execute(
        "CREATE TABLE `card` ( `number`	TEXT, `balance`	REAL, PRIMARY KEY(`number`));"
    );
  }
}

class CardHistoryMigration extends Migration {
  String name = "card_history_table_create";

  void apply() async {
    var database = await db.open();

    database.execute(
        "CREATE TABLE `card_history` (`id`	INTEGER, `cardNumber`	TEXT, `timestamp`	INTEGER, `balance`	REAL, PRIMARY KEY(`id`));"
    );
  }
}

