import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request_url = "https://api.hgbrasil.com/finance?key=35b4f630";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber))),
        hintColor: Colors.amber,
        primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request_url);
  print(json.decode(response.body)["results"]["currencies"]["USD"]);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitCoinController = TextEditingController();
  double dolar;
  double euro;
  double bitCoin;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    bitCoinController.text = (real / bitCoin).toStringAsFixed(7);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    bitCoinController.text = (dolar * this.dolar / bitCoin).toStringAsFixed(7);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    bitCoinController.text = (euro * this.euro / bitCoin).toStringAsFixed(7);
  }

  void _bitCoinChanged(String text) {
    double bitCoin = double.parse(text);
    realController.text = (bitCoin * this.bitCoin).toStringAsFixed(2);
    dolarController.text = (bitCoin * this.bitCoin / dolar).toStringAsFixed(2);
    euroController.text = (bitCoin * this.bitCoin / euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text("Carregando Cotação...",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0)));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Erro ao buscar dados",
                          style: TextStyle(
                              color: Colors.redAccent, fontSize: 25.00)));
                } else {
                  print(snapshot.data);
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  bitCoin =
                      snapshot.data["results"]["currencies"]["BTC"]["buy"];
                  print(dolar / bitCoin);
                  dolarController.text = "1,00";
                  realController.text = (dolar).toStringAsFixed(2);
                  euroController.text = (dolar / euro).toStringAsFixed(2);
                  bitCoinController.text = (dolar / bitCoin).toStringAsFixed(7);

                  return SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.add_to_photos,
                          size: 150.0, color: Colors.amber),
                      builderTextField(
                          "Reais", "R\$", realController, _realChanged),
                      Divider(),
                      builderTextField(
                          "dolar", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      builderTextField(
                          "Euro", "€", euroController, _euroChanged),
                      Divider(),
                      builderTextField(
                          "BitCoin", "₿", bitCoinController, _bitCoinChanged),
                    ],
                  ));
                }
            }

            return null;
          },
        ));
  }
}

Widget builderTextField(
    String label, String prefix, TextEditingController ctrl, Function fn) {
  return TextField(
      controller: ctrl,
      onChanged: fn,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix,
      ),
      style: TextStyle(color: Colors.amber, fontSize: 25.0));
}
