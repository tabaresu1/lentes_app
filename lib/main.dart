import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tela_menu.dart';

void main() {
  // GARANTA QUE ESTAS DUAS LINHAS ESTEJAM ATIVAS
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    MaterialApp(
      title: 'Lentes App',
      home: const TelaMenu(),
      debugShowCheckedModeBanner: false,
      routes: {},
    ),
  );
}