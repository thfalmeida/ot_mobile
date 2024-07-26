import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ot_mobile/models/viagem.dart';

class ViagensPage extends StatefulWidget {
  @override
  _ViagensPageState createState() => _ViagensPageState();
}

class _ViagensPageState extends State<ViagensPage> {
  List<dynamic> viagens = [];

  @override
  void initState() {
    super.initState();
    fetchViagens();
  }

  Future<void> fetchViagens() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/trip/info/list'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      setState(() {
        viagens = body.map((dynamic item) => Viagem.fromJson(item)).toList();
      });
    } else {
      throw Exception('Falha ao carregar viagens');
    }
  }

  Widget cardBuilder(Viagem viagem) {
    return SizedBox(
      width: double.infinity,
      height: 160,
      child: Card(
          margin: const EdgeInsets.only(left: 32, right: 32, top: 10),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(viagem.cliente.toString()))),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            viagem.data.toString(),
                            style: const TextStyle(color: Colors.grey),
                          )))
                ]),
                const Divider(color: Colors.grey),
                const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Motorista"))),
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("Carro"))),
                    ]),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("  ${viagem.motorista}"))),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("${viagem.carro.toString()}  "))),
                ]),
                const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [Text("")]),
                const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Km inicial"))),
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("Km final"))),
                    ]),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("   ${viagem.kmInicial.toString()}"))),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("${viagem.kmFinal.toString()}  "))),
                ]),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viagens'),
      ),
      body: ListView.builder(
        itemCount: viagens.length,
        itemBuilder: (context, index) {
          return cardBuilder(viagens[index]);
        },
      ),
    );
  }
}
