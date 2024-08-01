import 'package:http/http.dart' as http;
import 'package:ot_mobile/models/impl/carro.dart';
import 'package:ot_mobile/models/impl/cliente.dart';
import 'package:ot_mobile/models/impl/model.dart';
import 'package:ot_mobile/models/impl/motorista.dart';
import 'package:ot_mobile/models/impl/representante.dart';
import 'dart:convert';
import '../config.dart';

class ApiService {
  static Future<List<Model>> list(Models models) async {
    String urlString = buildUri(models);
    print(urlString);
    Uri url = Uri.parse('${urlString}list');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      List<Model> list = buildModelFromJson(jsonResponse, models);
      list.sort((a, b) => a.id.compareTo(b.id));
      return list;
    } else {
      print('${response.statusCode} ${response.body}');
      throw Exception('Falha ao carregar dados');
    }
  }

  static Future<void> save(Models models, Model model) async {
    // Uri url = Uri.parse('${Config.baseUrl}${Config.carUrl}new');
    print("Salvando: ");
    Uri url = Uri.parse('${buildUri(models)}new');

    print(url.toString());
    String body = jsonEncode(model);

    print("Body: $body");

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print('${url.toString()} | ${response.body}');

    if (response.statusCode == 200) {
      Model model = jsonDecode(response.body);
      print(model);
    } else {
      print('${response.statusCode} ${response.body}');
      throw Exception('Falha ao carregar carros');
    }
  }

  static Future<void> update(Models models, Model model) async {
    Uri url = Uri.parse('${buildUri(models)}${model.id}');
    print(url);
    String body = jsonEncode(model);
    print('Body: $body');
    final response = await http.put(url,
        headers: {"Content-Type": "application/json"}, body: body);

    print('${url.toString()} | ${response.body}');

    if (response.statusCode != 200) {
      print('${response.statusCode} ${response.body}');
      throw Exception('Falha ao salvar model');
    }
  }

  static Future<int> delete(Models models, int id) async {
    Uri url = Uri.parse('${buildUri(models)}${id}');

    print("Deletando: " + url.toString());

    final response = await http.delete(url);

    print("${response.statusCode} | ${response.body}");
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception('Falha ao carregar carros');
    }
  }

  static String buildUri(Models models) {
    print("Agente url: " + Config.agentUrl);
    switch (models) {
      case (Models.carro):
        return '${Config.baseUrl}${Config.carUrl}';
      case Models.cliente:
        return '${Config.baseUrl}${Config.clientUrl}';
      case Models.motorista:
        return '${Config.baseUrl}${Config.driverUrl}';
      case Models.representante:
        return '${Config.baseUrl}${Config.agentUrl}';
      case Models.viagem:
        return '${Config.baseUrl}${Config.carUrl}';
    }
  }

  static List<Model> buildModelFromJson(List<dynamic> lista, Models model) {
    switch (model) {
      case (Models.carro):
        return lista.map((e) => Carro.fromJson(e)).toList();
      case Models.cliente:
        return lista.map((e) => Cliente.fromJson(e)).toList();
      case Models.motorista:
        return lista.map((e) => Motorista.fromJson(e)).toList();
      case Models.representante:
        return lista.map((e) => Representante.fromJson(e)).toList();
      case Models.viagem:
        return lista.map((e) => Carro.fromJson(e)).toList();
    }
  }
}
