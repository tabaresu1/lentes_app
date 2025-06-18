import 'package:flutter/material.dart';
import 'dart:ui'; // Para o BackdropFilter (efeito de vidro)

// 1. Enum permanece o mesmo
enum TipoCampoVisao { nenhum, monofocal, bifocal, multifocal }

class TelaCampoVisao extends StatefulWidget {
  const TelaCampoVisao({super.key});

  @override
  State<TelaCampoVisao> createState() => _TelaCampoVisaoState();
}

class _TelaCampoVisaoState extends State<TelaCampoVisao> {
  // 2. Estado inicial
  TipoCampoVisao _selecaoAtual = TipoCampoVisao.nenhum;
  // NOVO ESTADO: controla a visibilidade do painel de descrição
  bool _isDescricaoVisivel = false;

  // Widget que constrói o menu inicial com um visual melhorado
  Widget _buildMenuVisao() {
    return Container(
      color: Colors.grey[200], // Cor de fundo para o menu
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Campo de Visão',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A2956),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecione uma lente para simular',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            // Botão para Monofocal
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2956),
                foregroundColor: Colors.white,
                minimumSize: const Size(300, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () => setState(() {
                _selecaoAtual = TipoCampoVisao.monofocal;
                _isDescricaoVisivel = false; // Reseta a visibilidade
              }),
              child: const Text('Monofocal'),
            ),
            const SizedBox(height: 16),
            // Botão para Bifocal
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2956),
                foregroundColor: Colors.white,
                minimumSize: const Size(300, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () => setState(() {
                _selecaoAtual = TipoCampoVisao.bifocal;
                _isDescricaoVisivel = false; // Reseta a visibilidade
              }),
              child: const Text('Bifocal'),
            ),
            const SizedBox(height: 16),
            // Botão para Multifocal
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2956),
                foregroundColor: Colors.white,
                minimumSize: const Size(300, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () => setState(() {
                _selecaoAtual = TipoCampoVisao.multifocal;
                _isDescricaoVisivel = false; // Reseta a visibilidade
              }),
              child: const Text('Multifocal'),
            ),
          ],
        ),
      ),
    );
  }

  // Novo widget para a descrição, mais detalhado
  Widget _buildDescricaoDetalhada() {
    String titulo = "", descricao = "";
    List<Widget> pros = [];
    List<Widget> contras = [];

    switch (_selecaoAtual) {
      case TipoCampoVisao.monofocal:
        titulo = "Lente Monofocal (Visão Simples)";
        descricao = "Ideal para corrigir a visão para uma única distância, oferecendo o campo de visão mais amplo e nítido.";
        pros = [const Text('Campo de visão amplo e sem distorções.', style: TextStyle(color: Colors.white))];
        contras = [const Text('Corrige apenas para longe OU perto.', style: TextStyle(color: Colors.white))];
        break;
      case TipoCampoVisao.bifocal:
        titulo = "Lente Bifocal";
        descricao = "Combina duas zonas de visão em uma única lente, uma para longe e outra para perto, separadas por uma linha visível.";
        pros = [const Text('Visão nítida para longe e perto.', style: TextStyle(color: Colors.white))];
        contras = [
          const Text('Linha divisória visível.', style: TextStyle(color: Colors.white)),
          const Text('Sem correção para distância intermediária.', style: TextStyle(color: Colors.white))
        ];
        break;
      case TipoCampoVisao.multifocal:
        titulo = "Lente Multifocal (Progressiva)";
        descricao = "A solução mais completa, oferece uma transição suave entre as visões de perto, intermediário e longe, sem linhas.";
        pros = [
          const Text('Visão nítida para todas as distâncias.', style: TextStyle(color: Colors.white)),
          const Text('Estética sem linhas visíveis.', style: TextStyle(color: Colors.white))
        ];
        contras = [
          const Text('Exige período de adaptação.', style: TextStyle(color: Colors.white)),
          const Text('Zonas de distorção nas laterais.', style: TextStyle(color: Colors.white))
        ];
        break;
      default:
        return const SizedBox.shrink();
    }

    Widget buildInfoRow(IconData icon, Color color, List<Widget> items) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(child: item),
            ],
          ),
        )).toList(),
      );
    }
    
    // Usando ClipRRect e BackdropFilter para o efeito de vidro fosco
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text(descricao, style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.4)),
              const Divider(color: Colors.white54, height: 32),
              if (pros.isNotEmpty) buildInfoRow(Icons.check_circle, Colors.greenAccent, pros),
              if (contras.isNotEmpty) const SizedBox(height: 12),
              if (contras.isNotEmpty) buildInfoRow(Icons.cancel, Colors.redAccent, contras),
              const SizedBox(height: 20), // Espaço extra na parte inferior
            ],
          ),
        ),
      ),
    );
  }

  // Widget que constrói a tela de simulação (agora sem a descrição)
  Widget _buildAreaSimulacao() {
    const String imagemDeFundo = 'assets/images/cena_ambiente.jpg';
    // MUDANÇA 1: Monofocal overlay foi adicionado de volta ao mapa.
    const Map<TipoCampoVisao, String> overlays = {
      TipoCampoVisao.monofocal: 'assets/images/monofocal_overlay.png',
      TipoCampoVisao.bifocal: 'assets/images/bifocal_overlay.png',
      TipoCampoVisao.multifocal: 'assets/images/multifocal_overlay.png',
    };

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagemDeFundo,
          // MUDANÇA 2: BoxFit.cover foi alterado para BoxFit.contain.
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Container(color: Colors.red),
        ),
        // A condição 'if' que excluía o monofocal foi removida.
        Image.asset(
          overlays[_selecaoAtual]!,
          // MUDANÇA 2: BoxFit.cover foi alterado para BoxFit.contain.
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  // NOVO WIDGET: Botão flutuante para mostrar a descrição
  Widget _buildBotaoInfo() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: FloatingActionButton(
          onPressed: () => setState(() => _isDescricaoVisivel = true),
          backgroundColor: Colors.white.withOpacity(0.9),
          child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF0A2956)),
        ),
      ),
    );
  }

  // NOVO WIDGET: O overlay que contém o painel de descrição
  Widget _buildDescricaoOverlay() {
    return Visibility(
      visible: _isDescricaoVisivel,
      child: Stack(
        children: [
          // Fundo escurecido que fecha o painel ao ser tocado
          GestureDetector(
            onTap: () => setState(() => _isDescricaoVisivel = false),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          // Painel que desliza de baixo para cima
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isDescricaoVisivel ? 0 : -MediaQuery.of(context).size.height, // Anima de fora da tela
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {}, // Bloqueia toques no painel para não fechar
              child: _buildDescricaoDetalhada(),
            ),
          )
        ],
      ),
    );
  }

  // Widget do botão de voltar
  Widget _buildBotaoVoltar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.9),
              foregroundColor: Colors.black,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              elevation: 8,
            ),
            onPressed: () => setState(() {
              _selecaoAtual = TipoCampoVisao.nenhum;
              _isDescricaoVisivel = false; // Garante que a descrição seja fechada
            }),
            child: const Icon(Icons.arrow_back, size: 32),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _selecaoAtual == TipoCampoVisao.nenhum
            ? _buildMenuVisao()
            // Estrutura atualizada para a tela de simulação
            : Stack(
                key: ValueKey(_selecaoAtual), // Chave para o AnimatedSwitcher funcionar
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0), // Padding que cria a "moldura"
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: _buildAreaSimulacao(),
                    ),
                  ),
                  _buildBotaoVoltar(),
                  _buildBotaoInfo(), // O botão de informação
                  _buildDescricaoOverlay(), // O painel de descrição (visível ou não)
                ],
              ),
      ),
    );
  }
}
