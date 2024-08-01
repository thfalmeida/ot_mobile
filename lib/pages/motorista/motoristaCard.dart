import 'package:flutter/material.dart';

import 'package:ot_mobile/models/impl/motorista.dart';

class MotoristaCard extends StatelessWidget {
  final Motorista motorista;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  const MotoristaCard(
      {required this.motorista,
      required this.onDelete,
      required this.onSave,
      Key? key})
      : super(key: key);

  Future deleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext contextt) {
          return AlertDialog(
            title: const Text('Deletar motorista?'),
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
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar motorista"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nome do motorista'),
                  initialValue: motorista.nome,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do motorista';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    motorista.nome = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  initialValue: motorista.telefone,
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
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
                          child: Text(motorista.nome.toString()))),
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
