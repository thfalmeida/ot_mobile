import 'package:http/http.dart' as http;
import 'package:ot_mobile/models/carro.dart';
import 'dart:convert';
import '../config.dart';

class ApiService {
  static Future<List<Carro>> listaCarro() async {
    Uri url = Uri.parse('${Config.baseUrl}${Config.carUrl}list');
    final response = await http.get(url);
    print(url.toString());

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Carro> carros =
          jsonResponse.map((carro) => Carro.fromJson(carro)).toList();
      carros.sort((a, b) => a.id.compareTo(b.id));
      return carros;
    } else {
      print('${response.statusCode} ${response.body}');
      throw Exception('Falha ao carregar carros');
    }
  }

  static Future<void> saveCarro(Carro carro) async {
    Uri url = Uri.parse('${Config.baseUrl}${Config.carUrl}new');
    print(url.toString());

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(carro));
    print('${url.toString()} | ${response.body}');

    if (response.statusCode == 200) {
      Carro carro = Carro.fromJson(jsonDecode(response.body));
      print(carro);
    } else {
      print('${response.statusCode} ${response.body}');
      throw Exception('Falha ao carregar carros');
    }
  }

  static Future<void> updateCarro(Carro carro) async {
    Uri url = Uri.parse('${Config.baseUrl}${Config.carUrl}${carro.id}');

    final response = await http.put(url,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(carro));

    print('${url.toString()} | ${response.body}');

    if (response.statusCode != 200) {
      print('${response.statusCode} ${response.body}');
      throw Exception('Falha ao carregar carros');
    }
  }

  static Future<int> deleteCarro(int id) async {
    String url = Config.baseUrl + Config.carUrl + id.toString();

    final response = await http.delete(Uri.parse(url));

    print("${response.statusCode} | ${response.body}");
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception('Falha ao carregar carros');
    }
  }
}
