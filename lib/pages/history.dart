import 'package:flutter/material.dart';
import '../models/card.dart';


class HistoryPageState extends State<HistoryPage> {

  final List<CardModel> cards = [];
  CardModel card;

  List<CardHistory> history = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.number)
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: history.length,
          itemBuilder: (context,i){
            return DateBalanceLayout(this.history[i], i%2 == 0? Colors.grey: null);
          },
        ),
      ),
    );
  }

  void _getHistory() async
  {
    try {
      await card.getHistory();

      print('Hist');
    } catch (exception) {
      print("Err while fetching history");
    }

      this.history = [];
      var data = await new CardHistory().where('cardNumber = ?', [card.number]).order("timestamp DESC").find();
      print(data);
      setState(() {
        for (var record in data) {
          this.history.add(record);
        }
      });

  }

  void initState() {
    super.initState();
    _getHistory();
  }

  static Route getRoute(CardModel card){
    return MaterialPageRoute(builder: (context){
      return HistoryPage(card);
    });
  }

  HistoryPageState(CardModel card) {
    this.card = card;
  }
}


class HistoryPage extends StatefulWidget {
  CardModel card;
  HistoryPageState createState() => HistoryPageState(card);

  HistoryPage(CardModel card) {
    this.card = card;
  }
}




class DateBalanceLayout extends StatelessWidget {

  CardHistory record;
  Color color;

  DateBalanceLayout(CardHistory record, Color color) {
    this.record = record;
    this.color = color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(record.getDate(),
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Text( record.balance.toString() + ' руб.'),
          ],
        ),
      ),
    );
  }
}