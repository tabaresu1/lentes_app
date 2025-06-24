import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import 'orcamento_service.dart';
import 'tratamento_lente.dart';
import 'espessura_lente.dart';
import 'campo_visao.dart';
import 'orcamento.dart';
import 'tela_login_ac.dart';

class TelaMenu extends StatefulWidget {
  const TelaMenu({super.key});

  @override
  State<TelaMenu> createState() => _TelaMenuState();
}

class _TelaMenuState extends State<TelaMenu> {
  int _paginaAtual = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  final List<Widget> _paginasBase = [
    const TelaTratamentoLente(),
    const TelaEspessura(),
    const TelaCampoVisao(),
  ];

  // Função para salvar o clique no Firestore
  Future<void> salvarCliqueNoFirestore(int index) async {
    await FirebaseFirestore.instance.collection('cliques_menu').add({
      'botao_clicado': index,
      'timestamp': DateTime.now(),
    });
  }

  Future<void> _onPaginaSelecionada(int index) async {
    // Salva o clique no Firestore
    await salvarCliqueNoFirestore(index);

    if (index == 3) {
      final orcamentoService = context.read<OrcamentoService>();
      setState(() {
        _paginaAtual = index;
      });
    } else {
      setState(() {
        _paginaAtual = index;
      });
    }
  }

  void _mostrarDialogoAC(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Inserir/Atualizar Código AC'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Código AC',
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final String acCode = controller.text.trim();
                context.read<OrcamentoService>().setAcrescimo(acCode);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.read<OrcamentoService>().isAcCodeSetForCurrentSession
                          ? 'Código AC atualizado com sucesso!'
                          : 'Código AC inválido.',
                    ),
                    backgroundColor: context.read<OrcamentoService>().isAcCodeSetForCurrentSession
                        ? Colors.blue
                        : Colors.orange,
                  ),
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orcamentoService = context.watch<OrcamentoService>();

    Widget currentPageContent;
    if (_paginaAtual == 3) {
      if (!orcamentoService.isAcCodeSetForCurrentSession) {
        currentPageContent = const TelaLoginAC();
      } else {
        currentPageContent = const TelaOrcamento();
      }
    } else {
      currentPageContent = _paginasBase[_paginaAtual];
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Row(
            children: [
              // Menu lateral
              Container(
                width: 300,
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Visão 360',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2956),
                      ),
                    ),
                    const Text(
                      'Guia de Lentes',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildBotaoMenu(texto: 'Espessura', index: 1),
                          const SizedBox(height: 16),
                          _buildBotaoMenu(texto: 'Tratamentos', index: 0),
                          const SizedBox(height: 16),
                          _buildBotaoMenu(texto: 'Campo de Visão', index: 2),
                          const SizedBox(height: 16),
                          _buildBotaoMenu(texto: 'Orçamento', index: 3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Conteúdo à direita
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: currentPageContent,
                ),
              ),
            ],
          ),
          // Botão engrenagem
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.grey),
              onPressed: () => _mostrarDialogoAC(context),
              tooltip: 'Definir Acréscimo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoMenu({required String texto, required int index}) {
    final bool isSelected = _paginaAtual == index;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF0A2956) : Colors.white,
        foregroundColor: isSelected ? Colors.white : const Color(0xFF0A2956),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade400,
          ),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        elevation: isSelected ? 8 : 2,
      ),
      onPressed: () {
        _onPaginaSelecionada(index);
      },
      child: Text(texto),
    );
  }
}
