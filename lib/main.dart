import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart';
import 'tela_menu.dart';

void main() {
  runApp(
    // Envolve toda a aplicação com o Provider para que o OrcamentoService
    // fique acessível a todas as telas.
    ChangeNotifierProvider(
      create: (context) => OrcamentoService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visão 360',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TelaMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}
