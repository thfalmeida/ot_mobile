// lib/models/motorista.dart

class Motorista {
  int id;
  String nome;
  String? telefone;

  Motorista({
    required this.id,
    required this.nome,
    this.telefone,
  });

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
