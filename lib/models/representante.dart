// lib/models/representante.dart

class Representante {
  int id;
  String? nome;
  String? email;
  String? telefone;
  String? isActive;

  Representante({
    required this.id,
    this.nome,
    this.email,
    this.telefone,
    this.isActive,
  });

  // Factory method to create a Representante instance from a JSON map
  factory Representante.fromJson(Map<String, dynamic> json) {
    return Representante(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      isActive: json['isActive'],
    );
  }

  // Method to convert a Representante instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'isActive': isActive,
    };
  }
}
