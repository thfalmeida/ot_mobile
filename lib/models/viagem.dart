// lib/models/viagem.dart

class Viagem {
  int id;
  int? data;
  int? kmInicial;
  int? kmFinal;
  String? motorista;
  String? carro;
  String? cliente;
  String? qntTransporte;
  String? observacao;
  int? numAjudante;

  Viagem(
      {required this.id,
      this.data,
      this.motorista,
      this.carro,
      this.cliente,
      this.numAjudante,
      this.observacao,
      this.qntTransporte,
      this.kmInicial,
      this.kmFinal});

  // Factory method to create a Viagem instance from a JSON map
  factory Viagem.fromJson(Map<String, dynamic> json) {
    return Viagem(
        id: json['id'],
        data: json['data'],
        motorista: json['motorista'],
        carro: json['carro'],
        cliente: json['cliente'],
        numAjudante: json['num_ajudante'],
        observacao: json['observacao'],
        qntTransporte: json['qnt_transporte'],
        kmInicial: json['km_inicial'],
        kmFinal: json['km_final']);
  }

  // Method to convert a Viagem instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'motorista': motorista,
      'carro': carro,
      'cliente': cliente,
      'num_ajudante': numAjudante,
      'observacao': observacao,
      'qnt_transporte': qntTransporte,
      'km_inicial': kmInicial,
      'km_final': kmFinal
    };
  }
}
