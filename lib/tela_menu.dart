import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart';
import 'tratamento_lente.dart';
import 'espessura_lente.dart';
import 'campo_visao.dart';
import 'orcamento.dart';
import 'tela_login_ac.dart'; // Importa a tela de login AC, agora como uma página
import 'tela_educacao.dart'; // Importa a nova tela de educação

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

  // NOVO: A lista _paginasBase agora inclui todas as telas que podem ser exibidas diretamente
  // pelo IndexedStack, incluindo TelaOrcamento e TelaEducacao.
  final List<Widget> _paginasBase = [
    const TelaTratamentoLente(),      // Index 0
    const TelaEspessura(),           // Index 1
    const TelaCampoVisao(),          // Index 2
    const TelaOrcamento(),           // Index 3 (para o slot de orçamento)
    const TelaEducacao(),            // Index 4 (para Educação)
  ];

  void _onPaginaSelecionada(int index) {
    // Se o índice selecionado for 3 (que é o do botão 'Orçamento')
    if (index == 3) {
      // OrcamentoService é observado no build, então não precisamos dele aqui para a decisão de tela.
      // Apenas definimos a página atual e o build irá reagir ao estado do OrcamentoService.
      setState(() {
        _paginaAtual = index; 
      });
    } else {
      // Para outras páginas (Tratamentos, Espessura, Campo de Visão, Educação)
    setState(() {
      _paginaAtual = index;
    });
    }
  }

  // Método _mostrarDialogoAC para ser usado pela engrenagem (agora como AlertDialog)
  void _mostrarDialogoAC(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Atualizar Usuário'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Senha',
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            obscureText: true,
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
    final orcamentoService = context.watch<OrcamentoService>(); // Observa o serviço para reagir a mudanças no AC

    // Conteúdo a ser exibido na área da direita
    Widget currentPageContent;
    if (_paginaAtual == 3) { // Se o índice selecionado é o do Orçamento
      if (!orcamentoService.isAcCodeSetForCurrentSession) {
        // Se o Código AC não está definido, mostra a tela de login AC
        currentPageContent = const TelaLoginAC();
      } else {
        // Se o Código AC está definido, mostra a TelaOrcamento
        currentPageContent = _paginasBase[_paginaAtual]; // Agora TelaOrcamento está em _paginasBase
      }
    } else {
      // Para as outras páginas (Tratamentos, Espessura, Campo de Visão, Educação)
      currentPageContent = _paginasBase[_paginaAtual];
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Row(
            children: [
              // --- COLUNA DA ESQUERDA COM O MENU ---
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
                          _buildBotaoMenu(texto: 'Orçamento', index: 3), // Orçamento é o índice 3
                          const SizedBox(height: 16),
                          _buildBotaoMenu(texto: 'Educação e Treinamento', index: 4), // Educação é o índice 4
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- ÁREA DE CONTEÚDO À DIREITA (Dinâmica) ---
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: currentPageContent,
                ),
              ),
            ],
          ),
          // Botão de engrenagem
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

  // Widget helper para construir os botões do menu
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
      onPressed: () => _onPaginaSelecionada(index),
      child: Text(texto),
    );
  }
}
