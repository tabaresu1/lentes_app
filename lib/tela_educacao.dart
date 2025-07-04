import 'package:flutter/material.dart';
import 'tela_faq.dart'; // Importa a nova tela de FAQ
import 'tela_modulos_treinamento.dart'; // Importa a nova tela de módulos

// Enum para as opções do menu de Educação
enum EducacaoOpcao { menu, faq, modulos }

class TelaEducacao extends StatefulWidget {
  const TelaEducacao({super.key});

  @override
  State<TelaEducacao> createState() => _TelaEducacaoState();
}

class _TelaEducacaoState extends State<TelaEducacao> {
  EducacaoOpcao _opcaoAtual = EducacaoOpcao.menu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          _opcaoAtual == EducacaoOpcao.menu ? 'Educação e Treinamento' : _getAppBarTitle(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A2956),
        leading: _opcaoAtual != EducacaoOpcao.menu
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => setState(() => _opcaoAtual = EducacaoOpcao.menu),
              )
            : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _buildCurrentEducacaoScreen(),
      ),
    );
  }

  // Retorna o título da AppBar com base na opção selecionada
  String _getAppBarTitle() {
    switch (_opcaoAtual) {
      case EducacaoOpcao.faq:
        return 'Perguntas Frequentes (FAQ)';
      case EducacaoOpcao.modulos:
        return 'Módulos de Treinamento';
      default:
        return 'Educação e Treinamento';
    }
  }

  // Constrói a tela atual com base na seleção
  Widget _buildCurrentEducacaoScreen() {
    switch (_opcaoAtual) {
      case EducacaoOpcao.menu:
        return _buildEducacaoMenu();
      case EducacaoOpcao.faq:
        return const TelaFAQ();
      case EducacaoOpcao.modulos:
        return const TelaModulosTreinamento();
    }
  }

  // Menu principal da seção Educação
  Widget _buildEducacaoMenu() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Bem-vindo à Área de Educação!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0A2956)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.help_outline),
            label: const Text('Perguntas Frequentes (FAQ)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A2956),
              foregroundColor: Colors.white,
              minimumSize: const Size(300, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onPressed: () => setState(() => _opcaoAtual = EducacaoOpcao.faq),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.book),
            label: const Text('Módulos de Treinamento'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A2956),
              foregroundColor: Colors.white,
              minimumSize: const Size(300, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onPressed: () => setState(() => _opcaoAtual = EducacaoOpcao.modulos),
          ),
        ],
      ),
    );
  }
}
