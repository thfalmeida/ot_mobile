import 'package:flutter/material.dart';

import 'package:ot_mobile/api_service/apiRest.dart';

import 'package:ot_mobile/models/impl/model.dart';
import 'package:ot_mobile/models/impl/motorista.dart';
import 'package:ot_mobile/pages/motorista/motoristaCard.dart';

class MotoristasPage extends StatefulWidget {
  const MotoristasPage({super.key});

  @override
  MotoristasPageState createState() => MotoristasPageState();
}

class MotoristasPageState extends State<MotoristasPage> {
  late bool isLoading;
  List<dynamic> motoristas = [];

  @override
  void initState() {
    super.initState();
    fetchMotoristas();
  }

  void setLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  Future<void> fetchMotoristas() async {
    print("Buscando motoristas");
    setLoading(true);
    try {
      motoristas = await ApiService.list(Models.motorista);
    } catch (e) {
      print('Erro: $e');
    } finally {
      print("Fim");
      setLoading(false);
    }
  }

  Future<void> deleteMotorista(int id) async {
    print("Listando clientes");
    setLoading(true);

    try {
      await ApiService.delete(Models.motorista, id);
    } catch (e) {
      print('Erro: $e');
    } finally {
      fetchMotoristas();
    }
  }

  Future<void> saveMotorista(Motorista motorista) async {
    setLoading(true);

    print("Salvando motorista");
    try {
      await ApiService.save(Models.motorista, motorista);
    } catch (e) {
      print("Erro: $e");
    } finally {
      fetchMotoristas();
    }
  }

  Future<void> updateMotorista(Motorista motorista) async {
    print("Entrando na atualização de motorista");
    setLoading(true);
    try {
      print("Atualizando motorista");
      await ApiService.update(Models.motorista, motorista);
      print("motorista atualizado");
    } catch (e) {
      print("Erro: $e");
    } finally {
      fetchMotoristas();
    }
  }

  void showNewMotoristaDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    Motorista motorista = Motorista(id: -1);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cadastrar motorista"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nome do motorista'),
                  initialValue: "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome do motorista';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    motorista.nome = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Endereço'),
                  initialValue: "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o telefone do motorista';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    motorista.telefone = value!;
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
                  saveMotorista(motorista);
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
        appBar: AppBar(title: const Text('Motoristas')),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.blue,
              ))
            : RefreshIndicator(
                onRefresh: fetchMotoristas,
                child: ListView.builder(
                  itemCount: motoristas.length,
                  itemBuilder: (context, index) {
                    final motorista = motoristas[index];
                    return MotoristaCard(
                        motorista: motorista,
                        onDelete: () => deleteMotorista(motorista.id),
                        onSave: () => updateMotorista(motorista));
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            {
              showNewMotoristaDialog(context);
            }
          },
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ));
  }
}
