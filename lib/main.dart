import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';

import 'pages/cards.dart';
import 'models/card.dart';
import 'classes/notifications.dart';
import 'database/core/models/preferences.dart';



void backgroundBalance() async  {

  print("Checking balance of cards...");

  String pref = await Preferences.get('minBalance');
  int balance = 0;

  if (pref != null) {
    balance = int.parse(pref);
  }

  print(balance);

  if (balance == 0) {
    return;
  }

  await notificationManager.init();

  var cards = await CardModel().all();

  for (var card in cards) {
    await card.updateBalance();
    if (card.error == null && card.balance <= balance) {
      print("notification: balance: " + card.balance.toString());
      await notificationManager.send(int.parse(card.number), 'Карта: ' + card.number, card.balance.toString() + ' руб.', '');
    } else if (card.error != null) {
      if (!(card.error is String)) {
        card.error = card.error.toString();
      }
      print("notification: error: " + card.error);
      await notificationManager.send(int.parse(card.number), 'Карта: ' + card.number, card.error, '');
    }
  }

}


void main() async {

  final int helloAlarmID = 0;
  await AndroidAlarmManager.initialize();

  runApp(MyApp());

  await AndroidAlarmManager.periodic(const Duration(hours: 1), helloAlarmID, backgroundBalance);

  await notificationManager.init();

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'ЕГКС::баланс',
      theme: ThemeData(          // Add the 3 lines from here...
        primaryColor: Colors.green,
      ),
      home: CardsPage(),
    );
  }
}
