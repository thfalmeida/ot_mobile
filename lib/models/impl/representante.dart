// lib/models/representante.dart

import 'package:ot_mobile/models/impl/model.dart';

class Representante extends Model {
  int id;
  String? nome;
  String? email;
  String? telefone;
  int? empresa_id;
  String? nomeEmpresa;
  String? isActive;

  Representante({
    required this.id,
    this.nome,
    this.email,
    this.telefone,
    this.empresa_id,
    this.nomeEmpresa,
    this.isActive,
  });

  String getNome() {
    return nome ?? "";
  }

  String getEmail() {
    return email ?? "";
  }

  String getTelefone() {
    return telefone ?? "";
  }

  String getNomeEmpresa() {
    return nomeEmpresa ?? "";
  }

  // Factory method to create a Representante instance from a JSON map
  factory Representante.fromJson(Map<String, dynamic> json) {
    return Representante(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      empresa_id: json['empresa_id'],
      isActive: json['isActive'],
    );
  }

  // Method to convert a Representante instance to a JSON map
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': getNome(),
      'email': getEmail(),
      'telefone': getTelefone(),
      'empresa_id': empresa_id,
      'isActive': isActive,
      'nomeEmpresa': getNomeEmpresa()
    };
  }
}
