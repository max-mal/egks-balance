import 'package:flutter/material.dart';
import '../main.dart';
import '../database/core/models/preferences.dart';


class SettingsPageState extends State<SettingsPage> {

  final balanceInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Настройки')
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            new SettingsField(
                TextField(
                  controller: balanceInputController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Баланс'
                  ),
                ), "Минимальный баланс для уведомлений"
            ),
            MaterialButton(
              color: Colors.green,
              child: Text('Сохранить', style: TextStyle(
                color: Colors.white
              )),
              onPressed: (){
                savePrefs();
              },
            ),
            MaterialButton(
              color: Colors.green,
              child: Text('Тест уведомления', style: TextStyle(
                  color: Colors.white
              )),
              onPressed: (){
                backgroundBalance();
              },
            )
          ],
        ),
      ),
    );
  }

  getPrefs() async
  {
      String balance = await Preferences.get('minBalance');

      setState(() {
        balanceInputController.text = balance;
      });


  }

  savePrefs() async {
    await Preferences.set('minBalance', balanceInputController.text);

    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Сохранено"),
        actions: <Widget>[
          FlatButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("OK"))
        ],
      );
    });
  }

  void initState() {
    super.initState();
    getPrefs();
  }

  static Route getRoute(){
    return MaterialPageRoute(builder: (context){
      return SettingsPage();
    });
  }

}

class SettingsField extends StatelessWidget {

  Widget field;
  String label;

  SettingsField(Widget field, String label) {
    this.field = field;
    this.label = label;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Text(this.label),
            this.field,
          ],
        ),
      ),
    );
  }
}


class SettingsPage extends StatefulWidget {
  SettingsPageState createState() => SettingsPageState();
}
