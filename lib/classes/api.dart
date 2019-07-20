import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/card.dart';

final String apiUrl = 'egks.my-pc.pw';

bool isInternet = false;

void checkConnectivity() async {

  isInternet = false;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isInternet = true;
    }
  } catch (exception) {
    isInternet = false;
  }

}

class ServerApi {

  static Future call(String method, Map<String, String> queryParameters) async {

    if (!isInternet) {
      await checkConnectivity();
    }

    if (!isInternet) {
      return null;
    }

    Uri url = Uri.https(apiUrl, method, queryParameters);

    final response = await http.get(url).timeout(const Duration(seconds: 10));;

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      var data = json.decode(response.body);
      print(data);

      return data;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  static Future getBalance(String cardNumber)  async {

    try {
      final response = await call('/', {'card': cardNumber});

      if (response['status'] == 'Ok' && response['error'] == false) {
        return response['money'];
      } else {
        if (response['message'] is String && response['message'].length > 0) {
          return response['message'];
        }
        return "Неверная карта, или карта не актина";
      }

    } catch(exception) {
      return false;
    }

  }

  static Future monitor(String cardNumber)  async {
    return await call('/monitor', {'card': cardNumber });
  }

  static Future getHistory(String cardNumber)  async {

    try {
      final response = await call('/monitor', {'card': cardNumber, 'history': '1'});
      print(response);
      List<CardHistory> list = [];

      var lastBalance = null;
      for (var record in response) {
        CardHistory model = new CardHistory();

        model.id = record['id'];
        model.cardNumber = record['card_number'];
        model.balance = record['balance'];
        model.timestamp = record['timestamp'];

        if (lastBalance == null) {
          lastBalance = model.balance;
          list.add(model);
        }

        if (model.balance != lastBalance) {
          list.add(model);
          lastBalance = model.balance;
          model.store();
        }

      }

      print(list);

      Iterable inReverse = list.reversed;
      list = inReverse.toList();

      return list;

    } catch(exception) {
      return null;
    }

  }
}