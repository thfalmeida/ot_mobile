// lib/pages/motorista.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/motorista.dart';

class MotoristaPage extends StatefulWidget {
  const MotoristaPage({super.key});

  @override
  MotoristaPageState createState() => MotoristaPageState();
}

class MotoristaPageState extends State<MotoristaPage> {
  List<dynamic> motoristas = [];

  @override
  void initState() {
    super.initState();
    fetchMotoristas();
  }

  Future<void> fetchMotoristas() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/driver/list'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      setState(() {
        motoristas =
            body.map((dynamic item) => Motorista.fromJson(item)).toList();
      });
    } else {
      throw Exception('Falha ao carregar motoristas');
    }
  }

  Widget cardBuilder(Motorista motorista) {
    return SizedBox(
      width: double.infinity,
      height: 90,
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
                          child: Text(motorista.nome))),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            motorista.id.toString(),
                            style: const TextStyle(color: Colors.grey),
                          )))
                ]),
                const Divider(color: Colors.grey),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(motorista.telefone.toString()))),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motorista'),
      ),
      body: ListView.builder(
        itemCount: motoristas.length,
        itemBuilder: (context, index) {
          return cardBuilder(motoristas[index]);
        },
      ),
    );
  }
}
