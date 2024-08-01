abstract class Model {
  late int id;

  Map<String, dynamic> toJson();
}

enum Models { carro, cliente, motorista, representante, viagem }
