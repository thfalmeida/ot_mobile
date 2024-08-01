import 'package:flutter/material.dart';

import 'package:ot_mobile/api_service/apiRest.dart';
import 'package:ot_mobile/models/impl/cliente.dart';

import 'package:ot_mobile/models/impl/model.dart';
import 'package:ot_mobile/models/impl/representante.dart';
import 'package:ot_mobile/pages/representante/representanteCard.dart';

class RepresentantesPage extends StatefulWidget {
  const RepresentantesPage({super.key});

  @override
  RepresentantePageState createState() => RepresentantePageState();
}

class RepresentantePageState extends State<RepresentantesPage> {
  late bool isLoading;
  List<Representante> representantes = [];

  List<Cliente> clientes = [];

  @override
  void initState() {
    super.initState();
    fetchRepresentante();
  }

  void setLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  Future<void> fetchRepresentante() async {
    print("Buscando representante");
    setLoading(true);
    try {
      final responses = await await Future.wait([
        ApiService.list(Models.cliente),
        ApiService.list(Models.representante)
      ]);
      clientes = responses[0] as List<Cliente>;
      representantes = responses[1] as List<Representante>;
    } catch (e) {
      print('Erro: $e');
    } finally {
      print("Fim");
      setLoading(false);
    }
  }

  Future<void> deleteRepresentante(int id) async {
    print("Listando representantes");
    setLoading(true);

    try {
      await ApiService.delete(Models.representante, id);
    } catch (e) {
      print('Erro: $e');
    } finally {
      fetchRepresentante();
    }
  }

  Future<void> saveRepresentante(Representante representante) async {
    setLoading(true);

    print("Salvando representante");
    try {
      await ApiService.save(Models.representante, representante);
    } catch (e) {
      print("Erro: $e");
    } finally {
      fetchRepresentante();
    }
  }

  Future<void> updateRepresentante(Representante representante) async {
    print("Entrando na atualização de representante");
    setLoading(true);
    try {
      print("Atualizando representante");
      await ApiService.update(Models.representante, representante);
      print("representante atualizado");
    } catch (e) {
      print("Erro: $e");
    } finally {
      fetchRepresentante();
    }
  }

  void showNewRepresentanteDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    Cliente dropdownValue = clientes.first;
    Representante representante = Representante(id: -1);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cadastrar representante"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Nome do representantes'),
                  initialValue: "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome do representante';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    representante.nome = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  initialValue: "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o telefone do representante';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    representante.telefone = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  initialValue: "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o e-mail do representante';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    representante.email = value!;
                  },
                ),
                const SizedBox(height: 20),
                DropdownMenu<Cliente>(
                  expandedInsets: const EdgeInsets.all(0),
                  label: const Text("Cliente"),
                  initialSelection: clientes.first,
                  onSelected: (Cliente? clientSelected) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = clientes
                          .where((e) => e == clientSelected)
                          .first; //value.!;
                      representante.empresa_id = dropdownValue.id;
                      print(representante.empresa_id);
                    });
                  },
                  dropdownMenuEntries:
                      clientes.map<DropdownMenuEntry<Cliente>>((Cliente value) {
                    return DropdownMenuEntry<Cliente>(
                        value: value, label: value.getNome());
                  }).toList(),
                ),
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
                  saveRepresentante(representante);
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
        appBar: AppBar(title: const Text('Representantes')),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.blue,
              ))
            : RefreshIndicator(
                onRefresh: fetchRepresentante,
                child: ListView.builder(
                  itemCount: representantes.length,
                  itemBuilder: (context, index) {
                    final representante = representantes[index];
                    return RepresentanteCard(
                        representante: representante,
                        onDelete: () => deleteRepresentante(representante.id),
                        onSave: () => updateRepresentante(representante));
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            {
              showNewRepresentanteDialog(context);
            }
          },
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ));
  }
}
