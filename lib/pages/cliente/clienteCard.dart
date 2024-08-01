import 'package:flutter/material.dart';

import 'package:ot_mobile/models/cliente.dart';

class ClienteCard extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  const ClienteCard(
      {required this.cliente,
      required this.onDelete,
      required this.onSave,
      Key? key})
      : super(key: key);

  Future deleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext contextt) {
          return AlertDialog(
            title: const Text('Deletar cliente?'),
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
          title: const Text("Editar cliente"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nome do cliente'),
                  initialValue: cliente.nome,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome do cliente';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    cliente.nome = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Endereço'),
                  initialValue: cliente.endereco,
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
