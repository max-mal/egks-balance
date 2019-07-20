import 'package:flutter/material.dart';

import '../models/card.dart';
import '../pages/history.dart';
import '../pages/payment.dart';

class CardLayout extends StatelessWidget {

  List<CardModel> cards = [];
  dynamic setState;
  dynamic _cardRefreshPressed;

  CardLayout(cards, setState, cardRefresh) {
    this.cards = cards;
    this.setState = setState;
    this._cardRefreshPressed = cardRefresh;
  }

  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, i){
          var card = cards[i];

          return Container(
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
                  child: Text(card.number),
                  padding: const EdgeInsets.only(
                      top: 10
                  ),
                ),
                Container(
                  child: Text( (card.error != null) ? card.error.replaceAll("\\n", "\n\n") : (card.balance.toString() + ' руб.'), textAlign: TextAlign.center,),
                  padding: const EdgeInsets.only(
                      top: 10
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: null,
                      ),
                      onPressed: (){
                        _cardRefreshPressed(card);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.info,
                        color: null,
                      ),
                      onPressed: (){
                        print('Info');

                        Navigator.push(
                          context,
                            HistoryPageState.getRoute(card)
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.payment,
                        color: null,
                      ),
                      onPressed: (){
                        print('Payment');

                        Navigator.push(
                            context,
                            PaymentPageState.getRoute(card.number)
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: null,
                      ),
                      onPressed: (){
                        setState(() {
                          card.remove();
                          cards.remove(card);
                        });
                      },
                    )
                  ],
                )

              ],
            ),

          );
        });
  }
}