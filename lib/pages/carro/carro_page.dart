import 'package:flutter/material.dart';
import 'package:ot_mobile/api_service/apiRest.dart';

import 'package:ot_mobile/models/impl/carro.dart';
import 'package:ot_mobile/models/impl/model.dart';
import 'package:ot_mobile/pages/carro/carro_card.dart';

class CarrosPage extends StatefulWidget {
  const CarrosPage({super.key});

  @override
  CarrosPageState createState() => CarrosPageState();
}

class CarrosPageState extends State<CarrosPage> {
  late bool isLoading;
  List<dynamic> carros = [];

  @override
  void initState() {
    super.initState();
    fetchCarros();
  }

  Future<void> fetchCarros() async {
    print("Buscando carros");
    isLoading = true;
    try {
      carros = await ApiService.list(Models.carro);
    } catch (e) {
      print('Erro: $e');
    } finally {
      print("Fim");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteCarro(int id) async {
    print("Listando carros");
    setState(() {
      isLoading = true;
    });

    try {
      await ApiService.delete(Models.carro, id);
    } catch (e) {
      print('Erro: $e');
    } finally {
      isLoading = false;
      fetchCarros();
    }
  }

  Future<void> saveCarro(Carro carro) async {
    setState(() {
      isLoading = true;
    });
    print("Salvando carro");
    try {
      await ApiService.save(Models.carro, carro);
    } catch (e) {
      print("Erro: $e");
    } finally {
      fetchCarros();
    }
  }

  Future<void> updateCarro(Carro carro) async {
    print("Entrando na atualização de carro");
    setState(() {
      isLoading = true;
    });
    try {
      print("Atualizando carro");
      await ApiService.update(Models.carro, carro);
      print("Carro atualizado");
    } catch (e) {
      print("Erro: $e");
    } finally {
      fetchCarros();
    }
  }

  void showNewCarDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    Carro carro = Carro(id: -1);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cadastrar carro"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nome do Carro'),
                  initialValue: "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome para o carro';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    carro.nome = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Placa'),
                  initialValue: "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a placa do veículo';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    carro.placa = value!;
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
                  await saveCarro(carro);
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
        appBar: AppBar(title: Text('Carros')),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.blue,
              ))
            : RefreshIndicator(
                onRefresh: fetchCarros,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: carros.length,
                  itemBuilder: (context, index) {
                    final carro = carros[index];
                    return CarroCard(
                        carro: carro,
                        onDelete: () => deleteCarro(carro.id),
                        onSave: () => updateCarro(carro));
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
