// lib/models/carro.dart

import 'package:flutter/material.dart';
import 'package:ot_mobile/models/model.dart';

class Carro extends Model {
  int id;
  String? nome;
  String? placa;

  Carro({
    required this.id,
    this.nome,
    this.placa,
  });

  // Factory method to create a Carro instance from a JSON map
  factory Carro.fromJson(Map<String, dynamic> json) {
    return Carro(
      id: json['id'],
      nome: json['nome'],
      placa: json['placa'],
    );
  }

  // Method to convert a Carro instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'nome': nome,
      'placa': placa,
    };
  }
}

class CarroModel extends ChangeNotifier {
  List<Carro> _carros = [];
  bool _isLoading = false;

  List<Carro> get carros => _carros;
  bool get isLoading => _isLoading;

  set carros(List<Carro> carros) {
    _carros = carros;
    notifyListeners();
  }

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
