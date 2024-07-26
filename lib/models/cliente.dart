// lib/models/cliente.dart

class Cliente {
  int id;
  String? nome;
  String? endereco;

  Cliente({
    required this.id,
    this.nome,
    this.endereco,
  });

  // Factory method to create a Cliente instance from a JSON map
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
    );
  }

  // Method to convert a Cliente instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
    };
  }
}
