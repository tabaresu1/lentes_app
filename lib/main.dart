import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'orcamento_service.dart';
import 'tela_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  salvarTesteNoFirestore(); // <-- Adicione esta linha para testar

  runApp(
    ChangeNotifierProvider(
      create: (context) => OrcamentoService(),
      child: const MyApp(),
    ),
  );
}

void salvarTesteNoFirestore() {
  FirebaseFirestore.instance.collection('testes').add({
    'mensagem': 'Hello Firestore!',
    'timestamp': DateTime.now(),
  });
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
