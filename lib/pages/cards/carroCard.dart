import 'package:flutter/material.dart';

import 'package:ot_mobile/models/carro.dart';

class CarroCard extends StatelessWidget {
  final Carro carro;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  const CarroCard(
      {required this.carro,
      required this.onDelete,
      required this.onSave,
      Key? key})
      : super(key: key);

  Future deleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext contextt) {
          return AlertDialog(
            title: const Text('Deletar carro?'),
            content: const Text('Essa ação não poderá ser desfeita'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  onDelete();
                  Navigator.pop(context);
                },
                child: const Text('Deletar'),
              ),
            ],
          );
        });
  }

  void showEditDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar carro"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nome do Carro'),
                  initialValue: carro.nome,
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
                  initialValue: carro.placa,
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  onSave();
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

  Widget carroCard(BuildContext context, Carro carro) {
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
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
                          child: Text(carro.nome.toString()))),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            carro.id.toString(),
                            style: const TextStyle(color: Colors.grey),
                          )))
                ]),
                const Divider(color: Colors.grey),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(carro.placa.toString()))),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    deleteDialog(context);
                                  },
                                  child: const Text('Delete'),
                                ))),
                        SizedBox(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: const Text('Editar'),
                                  onPressed: () {
                                    showEditDialog(context);
                                  },
                                ))),
                      ]),
                ),
              ],
            ),
          )),
    );
  }
}
