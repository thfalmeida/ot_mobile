import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ot_mobile/api_service/apiRest.dart';

import 'package:ot_mobile/models/carro.dart';

import 'package:ot_mobile/models/cliente.dart';
import 'package:ot_mobile/models/model.dart';
import 'package:ot_mobile/pages/cliente/clienteCard.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  ClientesPageState createState() => ClientesPageState();
}

class ClientesPageState extends State<ClientesPage> {
  late bool isLoading;
  List<dynamic> clientes = [];

  @override
  void initState() {
    super.initState();
    fetchClientes();
  }

  void setLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  Future<void> fetchClientes() async {
    print("Buscando clientes");
    setLoading(true);
    try {
      clientes = await ApiService.list(Models.cliente);
    } catch (e) {
      print('Erro: $e');
    } finally {
      print("Fim");
      setLoading(false);
    }
  }

  Future<void> deleteCarro(int id) async {
    print("Listando clientes");
    setLoading(true);

    try {
      await ApiService.deleteCarro(Models.cliente, id);
    } catch (e) {
      print('Erro: $e');
    } finally {
      fetchClientes();
    }
  }

  Future<void> saveCarro(Cliente cliente) async {
    setLoading(true);

    print("Salvando cliente");
    try {
      await ApiService.saveCliente(Models.cliente, cliente);
    } catch (e) {
      print("Erro: $e");
    } finally {
      fetchClientes();
    }
  }

  Future<void> updateCarro(Carro carro) async {
    print("Entrando na atualização de carro");
    setLoading(true);
    try {
      print("Atualizando carro");
      await ApiService.updateCarro(Models.carro, carro);
      print("Carro atualizado");
    } catch (e) {
      print("Erro: $e");
    } finally {
      fetchClientes();
    }
  }

  void showNewCarDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    Cliente cliente = Cliente(id: -1);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cadastrar cliente"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nome do cliente'),
                  initialValue: "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome para o cliente';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    cliente.nome = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Endereço'),
                  initialValue: "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o endereço do cliente';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    cliente.endereco = value!;
                  },
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  saveCarro(cliente);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Clientes')),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.blue,
              ))
            : RefreshIndicator(
                onRefresh: fetchClientes,
                child: ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = clientes[index];
                    return ClienteCard(
                        cliente: cliente,
                        onDelete: () => deleteCarro(cliente.id),
                        onSave: () => updateCarro(cliente));
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            {
              showNewCarDialog(context);
            }
          },
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ));
  }
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
