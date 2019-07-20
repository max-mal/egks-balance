import '../database/core/models/base.dart';
import '../classes/api.dart';
import 'package:intl/intl.dart';

class CardModel extends DatabaseModel{

  String table = 'card';
  String pk = 'number';

  String number = '';
  num balance = 0;
  String error;

  List<CardHistory> history = [];

  constructModel() {
    return new CardModel();
  }

  Map<String, dynamic> toMap() {
    return {
      'number': this.number,
      'balance': this.balance,
    };
  }

  loadFromMap(Map<String, dynamic> map){

    this.number = map['number'];
    this.balance = map['balance'];

    return this;
  }

  Future updateBalance() async {
    var balance = await ServerApi.getBalance(this.number);

    if (balance is String) {
      this.error = balance;
      print(balance);
    } else if (balance is bool) {
        this.error = 'Произошла ошибка';
        print(balance);
    } else {
        this.balance = balance.toDouble();
        this.error = null;
        print('Card baance: ' + balance.toString());
        this.store();
    }
  }

  Future getHistory() async {
    var history = await ServerApi.getHistory(this.number);
    this.history = history;

    return history;
  }

  Future monitor() async {
    return await ServerApi.monitor(this.number);
  }

}


class CardHistory extends DatabaseModel {
  int id;
  String cardNumber;
  int timestamp = 0;
  int balance = 0;

  getDate() {
    var date =  new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = new DateFormat('dd.MM.yyyy H:m:s');
    String formatted = formatter.format(date);
    return formatted;
  }

  String table = 'card_history';
  String pk = 'id';


  constructModel() {
    return new CardHistory();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'cardNumber': this.cardNumber,
      'timestamp': this.timestamp,
      'balance': this.balance,
    };
  }

  loadFromMap(Map<String, dynamic> map){

    this.cardNumber = map['cardNumber'];
    this.balance = map['balance'].toInt();
    this.id = map['id'];
    this.timestamp = map['timestamp'];

    return this;
  }
}