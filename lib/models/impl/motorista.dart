// lib/models/motorista.dart

import 'package:ot_mobile/models/impl/model.dart';

class Motorista extends Model {
  @override
  int id;
  String? nome;
  String? telefone;

  Motorista({
    required this.id,
    this.nome,
    this.telefone,
  });

  String getNome() {
    return nome ?? "";
  }

  String getTelefone() {
    return telefone ?? "";
  }

  // Factory method to create a Motorista instance from a JSON map
  factory Motorista.fromJson(Map<String, dynamic> json) {
    return Motorista(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
    );
  }

  // Method to convert a Motorista instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
    };
  }
}
