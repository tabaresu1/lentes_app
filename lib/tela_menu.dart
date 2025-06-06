import 'package:flutter/material.dart';
import 'paginas_conteudo.dart';
import 'widgets/menu_button.dart'; // Caminho para o MenuButton reutilizável

class TelaMenu extends StatelessWidget {
  const TelaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    const double espacoEntreBotoes = 24.0;
    // Definir um fator de largura para os botões
    const double fatorLarguraBotao = 0.8; // Botões ocuparão 80% da largura disponível

    return Scaffold(
      backgroundColor: const Color(0xFF0A2956), // Azul escuro de fundo
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: fatorLarguraBotao,
                child: MenuButton( // O MenuButton agora se ajustará à largura dada pelo FractionallySizedBox
                  texto: 'Tratamentos',
                  // As cores e outros estilos podem ser passados aqui se precisar
                  // diferenciar dos padrões do MenuButton.
                  // Ex: backgroundColor: Colors.algumaCor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaginasComBarraSuperior(paginaInicial: 0),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: espacoEntreBotoes),
              FractionallySizedBox(
                widthFactor: fatorLarguraBotao,
                child: MenuButton(
                  texto: 'Espessura',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaginasComBarraSuperior(paginaInicial: 1),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: espacoEntreBotoes),
              FractionallySizedBox(
                widthFactor: fatorLarguraBotao,
                child: MenuButton(
                  texto: 'Campo de visão',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaginasComBarraSuperior(paginaInicial: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}