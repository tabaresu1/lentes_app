import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for FirebaseFirestore
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart';
import 'tela_menu.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- CRUCIAL: Enable Firestore Offline Persistence ---
  // This line enables offline data persistence for Firestore.
  // It should be called AFTER Firebase.initializeApp() and BEFORE any Firestore operations.
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    // You can also configure cache size, but default is usually fine to start
    // cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  // ----------------------------------------------------

  await Hive.initFlutter();
  await Hive.openBox('orcamentos_offline');

  runApp(
    ChangeNotifierProvider(
      create: (context) => OrcamentoService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        // Chama a sincronização quando ficar online
        final orcamentoService = context.read<OrcamentoService>();
        orcamentoService.sincronizarOrcamentosPendentes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visão 360',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TelaMenu(),
    );
  }
}
