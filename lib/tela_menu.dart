import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart';
import 'tratamento_lente.dart';
import 'espessura_lente.dart';
import 'campo_visao.dart';
import 'orcamento.dart';
// import 'tela_login_ac.dart'; // Removida a importação, pois não é mais a tela inicial aqui

class TelaMenu extends StatefulWidget {
  const TelaMenu({super.key});

  @override
  State<TelaMenu> createState() => _TelaMenuState();
}

class _TelaMenuState extends State<TelaMenu> {
  int _paginaAtual = 0;
  // Removida a variável _isLoggedIn, pois o login AC não é mais inicial no app.

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  final List<Widget> _paginas = [
    const TelaTratamentoLente(),
    const TelaEspessura(),
    const TelaCampoVisao(),
    const TelaOrcamento(),
  ];

  void _onPaginaSelecionada(int index) {
    setState(() {
      _paginaAtual = index;
    });
  }

  // Método _mostrarDialogoAC para ser usado pela engrenagem
  void _mostrarDialogoAC(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Inserir AC'),
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
                context.read<OrcamentoService>().setAcrescimo(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Código AC atualizado!'), // Mensagem ajustada
                    backgroundColor: Colors.blue,
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

  // Removido o callback _handleLoginSuccess, pois não é mais a tela inicial

  @override
  Widget build(BuildContext context) {
    // Não há mais verificação de login aqui. O app começa diretamente no menu.
    return Scaffold(
      // Mantido como false para que o teclado flutue sobre o conteúdo principal
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
                          _buildBotaoMenu(texto: 'Orçamento', index: 3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- ÁREA DE CONTEÚDO À DIREITA ---
              Expanded(
                child: IndexedStack(
                  index: _paginaAtual,
                  children: _paginas,
                ),
              ),
            ],
          ),
          // O botão de engrenagem continua aqui.
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
