// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

// Importe o seu arquivo main.dart para que o teste saiba qual app iniciar.
// Certifique-se de que o nome do seu projeto aqui esteja correto.
import 'package:visao_360/main.dart'; 

void main() {
  testWidgets('App starts without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Este teste simplesmente constrói o seu widget principal (MyApp)
    // e verifica se nenhum erro acontece durante a renderização inicial.
    await tester.pumpWidget(const MyApp());

    // Este é um teste muito básico. Ele não verifica nenhuma funcionalidade específica.
    // Ele apenas garante que o app não quebra ao ser iniciado.
    // Você pode adicionar testes mais específicos aqui no futuro, se desejar.
  });
}
