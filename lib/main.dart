import 'package:flutter/material.dart';
import 'package:ot_mobile/models/impl/carro.dart';
import 'package:ot_mobile/pages/representante/representantePage.dart';
import 'pages/motorista/motoristaPage.dart';
import 'pages/carro/carro_page.dart';
import 'package:provider/provider.dart';
import 'pages/cliente/cliente_page.dart';
import 'pages/viagemPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarroModel(),
      child: const MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Motorista'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MotoristasPage()));
              },
            ),
            ListTile(
              title: const Text('Carros'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CarrosPage()));
              },
            ),
            ListTile(
              title: const Text('Clientes'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ClientesPage()));
              },
            ),
            ListTile(
              title: const Text('Representante'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RepresentantesPage()));
              },
            ),
            ListTile(
              title: const Text('Viagens'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViagensPage()));
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Bem-vindo ao Meu App!'),
      ),
    );
  }
}
