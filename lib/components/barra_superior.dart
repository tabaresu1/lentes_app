import 'package:flutter/material.dart';

// 1. Enum PaginaMenu definido aqui como única fonte.
enum PaginaMenu {
  tratamentos, // Corresponde ao índice 0
  espessura,   // Corresponde ao índice 1
  campoVisao   // Corresponde ao índice 2
}

class BarraSuperior extends StatelessWidget {
  // ... (campos e construtor como na última versão) ...
  final PaginaMenu paginaAtual;
  final ValueChanged<int> aoSelecionar;

  const BarraSuperior({
    super.key,
    required this.paginaAtual,
    required this.aoSelecionar,
  });

  // Método auxiliar para construir os botões de página
  Widget _buildPageButton(BuildContext context, String texto, int index, PaginaMenu paginaAlvo) {
    // Não mostra o botão se ele corresponder à página atual
    if (paginaAtual == paginaAlvo) {
      return const SizedBox.shrink(); // Retorna um widget vazio se for a página atual
    }

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 200,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          // 3. onPressed agora chama widget.aoSelecionar com o índice correto.
          onPressed: () => aoSelecionar(index),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0, // <-- ADICIONE ESTA LINHA
      color: const Color(0xFF0A2956),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Botão Home
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black, size: 32),
            style: IconButton.styleFrom(
              backgroundColor: Colors.orangeAccent, // Amarelo
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            // 4. Botão Home leva para a rota raiz '/' (TelaMenu).
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
            },
            tooltip: 'Início',
          ),
          const SizedBox(width: 12),
          // Botões das outras páginas usando o método auxiliar
          _buildPageButton(context, 'Tratamentos', 0, PaginaMenu.tratamentos),
          _buildPageButton(context, 'Espessura', 1, PaginaMenu.espessura),
          _buildPageButton(context, 'Campo de visão', 2, PaginaMenu.campoVisao),
          // Adiciona um Expanded para empurrar os botões para a esquerda, se necessário,
          // ou para adicionar outros ícones à direita no futuro.
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}