import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PaymentPageState extends State<PaymentPage> {

  String number;
  WebViewController _controller;

  Future _insertCardNumber () async {
    await this._controller.evaluateJavascript("""
          \$(document).ready(function(){ 
            setTimeout(function(){ 
              
              inputElement = \$('[name="inputprop__0"]')[0]

              inputElement.value = '""" + this.number + """';
              inputElement.dispatchEvent(new Event('input', {
                view: window,
                bubbles: true,
                cancelable: true
              }))
            }, 1000);
            
          })
          var node = document.createElement('style');
          node.innerHTML =` """ + css + """ `;
          document.body.appendChild(node);
          """);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Пополнить карту'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.payment), onPressed: () async{
            await _insertCardNumber();
          })
        ],
      ),
      body: WebView(
        initialUrl: 'https://shop.payberry.ru/pay/4253',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          this._controller = webViewController;
        },
        onPageFinished: (String str) {
          _insertCardNumber();
        },
      ),
    );
  }


  static Route getRoute(String number){
    return MaterialPageRoute(builder: (context){
      return PaymentPage(number);
    });
  }

  PaymentPageState(String number) {
    this.number = number;
  }

}

class PaymentPage extends StatefulWidget {

  String number;

  PaymentPageState createState() => PaymentPageState(this.number);

  PaymentPage(String number) {
    this.number = number;
  }
}


var css = """

section.wrapper > .row > .col-xs-8 {
    width: 100% !important;
    display: block !important;
}




header#header {
    display: none;
}

footer#footer {
    display: none;
}

.internet-recharge-header * {
    display: block !important;
}

section#maincontainer {
    min-width: 0 !important;
    max-width: 100vw;
    width: auto;
    overflow: auto;
}

body {
    min-width: 0;
}

#paymentForm #requests {
    position: static;
}

#paymentForm #prePayBtn {
    left: 44px;
}

#prePayDiv .btn-container {
    left: 0;
    position: static;
    display: flex;
}

div#prePayDiv {
    position: static;
}

.col-xs-12.btn-container {}

""";