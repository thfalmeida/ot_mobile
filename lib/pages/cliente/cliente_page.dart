import 'package:flutter/material.dart';

import 'package:ot_mobile/api_service/apiRest.dart';

import 'package:ot_mobile/models/impl/cliente.dart';
import 'package:ot_mobile/models/impl/model.dart';
import 'package:ot_mobile/pages/cliente/cliente_card.dart';

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

  Future<void> deleteCliente(int id) async {
    print("Listando clientes");
    setLoading(true);

    try {
      await ApiService.delete(Models.cliente, id);
    } catch (e) {
      print('Erro: $e');
    } finally {
      fetchClientes();
    }
  }

  Future<void> saveCliente(Cliente cliente) async {
    setLoading(true);

    print("Salvando cliente");
    try {
      await ApiService.save(Models.cliente, cliente);
    } catch (e) {
      print("Erro: $e");
    } finally {
      fetchClientes();
    }
  }

  Future<void> updateCliente(Cliente cliente) async {
    print("Entrando na atualização de carro");
    setLoading(true);
    try {
      print("Atualizando carro");
      await ApiService.update(Models.cliente, cliente);
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
                  saveCliente(cliente);
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
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = clientes[index];
                    return ClienteCard(
                        cliente: cliente,
                        onDelete: () => deleteCliente(cliente.id),
                        onSave: () => updateCliente(cliente));
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
