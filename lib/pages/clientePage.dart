import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ot_mobile/models/cliente.dart';

class ClientesPage extends StatefulWidget {
  @override
  _ClientesPageState createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<dynamic> clientes = [];

  @override
  void initState() {
    super.initState();
    fetchClientes();
  }

  Future<void> fetchClientes() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/client/list'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      setState(() {
        clientes = body.map((dynamic item) => Cliente.fromJson(item)).toList();
      });
    } else {
      throw Exception('Falha ao carregar clientes');
    }
  }

  Widget cardBuilder(Cliente cliente) {
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
                          child: Text(cliente.nome.toString()))),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            cliente.id.toString(),
                            style: const TextStyle(color: Colors.grey),
                          )))
                ]),
                const Divider(color: Colors.grey),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(cliente.endereco.toString()))),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          return cardBuilder(clientes[index]);
        },
      ),
    );
  }
}
