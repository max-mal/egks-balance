import 'package:flutter/material.dart';
import '../models/card.dart';

import '../layouts/cardLayout.dart';

import 'settings.dart';

class CardsPageState extends State<CardsPage> {

  final List<CardModel> cards = [];

  bool isChecking = false;
  String checkMessage;

  bool isUpdating = false;

  void _cardRefreshPressed(CardModel card) async {

    _showProgress('', 'Проверка баланса...');
    await card.updateBalance();
    Navigator.of(context).pop();
    setState(() {});
  }

  final cardInputController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    cardInputController.dispose();
    super.dispose();
  }


  void _showCardDialog() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("P : " + (isChecking? '1' : '0'));
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Введите номер карты"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: cardInputController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Введите номер карты'
                ),
              )
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Отмена"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Добавить'),
              onPressed: () async {
                print('Add card: ');
                print(cardInputController.text);

                var card = new CardModel();
                card.number = cardInputController.text;
                setState(() {
                  isChecking = true;
                });
                _showProgress('', "Добавление карты...");

                await card.updateBalance();

                Navigator.of(context).pop();

                print("AAAA");
                if (card.error == null) {

                  await card.store();

                  setState(() {
                    cards.add(card);
                    checkMessage = "Карта добавлена";
                    isChecking = false;
                  });

                  card.monitor();

                  Navigator.of(context).pop();
                } else {
                  print ("Error! Cant confirm card!");
                    setState(() {
                      checkMessage = card.error;
                      isChecking = false;
                    });

                  _showProgress(checkMessage, "Добавление карты...");

                }
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildCards() {
    return CardLayout(this.cards, this.setState, this._cardRefreshPressed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ЕГКС::баланс'),
        actions: <Widget>[
          IconButton(icon: Icon(
              Icons.settings
          ), onPressed: (){
            Navigator.push(
                context,
                SettingsPageState.getRoute(),
            );
          }),
          IconButton(icon: Icon(
              Icons.refresh
          ), onPressed: (){
            _updateCards();
          }),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
//              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                isUpdating? LinearProgressIndicator(): Column(),
                GestureDetector(
                    onTap: (){
                      _showCardDialog();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: new BoxDecoration(
                          border: Border.all(
                              color: Colors.green,
                              style: BorderStyle.solid
                          )
                      ),
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text('Добавить карту'),
                            padding: const EdgeInsets.only(
                                top: 10
                            ),
                          ),

                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              color: null,
                            ),
                            onPressed: (){
                              _showCardDialog();
                            },
                          )
                        ],
                      ),

                    )

                ),
                _buildCards(),
              ])
      ),


    );
  }

  void _showProgress(String message, String title) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: message!= '' ? new Text(message) : LinearProgressIndicator(),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            message!= '' ? new FlatButton(
              child: new Text("ОК"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ) : Text(''),
          ],
        );
      },
    );
  }

  void _getCards () async {

    var cards = await CardModel().all();
    print(cards);
    setState(() {
      for (var card in cards) {
        this.cards.add(card);
      }
    });

    _updateCards();
  }

  void _updateCards() async {
    setState(() {
      isUpdating = true;
    });
    for (var card in this.cards) {
      await card.updateBalance();
      setState(() {});
    }

    setState(() {
      isUpdating = false;
    });
  }
  void initState() {
    super.initState();
    _getCards();
  }
}
class CardsPage extends StatefulWidget {
  CardsPageState createState() => CardsPageState();
}


