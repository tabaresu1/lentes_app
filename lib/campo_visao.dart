import 'package:flutter/material.dart';
import 'dart:ui'; // Para o BackdropFilter (efeito de vidro)
import 'package:flutter_svg/flutter_svg.dart'; 
import 'espessura_lente.dart'; // Importa CampoVisaoPercentagem

// 1. Enum para as opções de simulação na Tela Campo de Visão
enum CampoVisaoSimulacao { 
  nenhum, 
  monofocal, 
  bifocal, 
  multifocal, // Agora serve como "abrir submenu"
  // Opções para cada porcentagem de campo de visão
  p40, p50, p67, p87, p98, // Adicionado p80
  todos // Para mostrar todos os campos de visão juntos
}

enum CampoVisaoPercentagem {

  p40, p50, p67, p87, p98

}
class TelaCampoVisao extends StatefulWidget {
  const TelaCampoVisao({super.key});

  @override
  State<TelaCampoVisao> createState() => _TelaCampoVisaoState();
}

class _TelaCampoVisaoState extends State<TelaCampoVisao> {
  // 2. Estado inicial
  CampoVisaoSimulacao _selecaoAtual = CampoVisaoSimulacao.nenhum;
  bool _isDescricaoVisivel = false;

  // Mapeamento de CampoVisaoPercentagem para o enum local de simulação
  CampoVisaoPercentagem? _percentagemAtualEnum; 

  // Dados para as descrições de distorção
  static const Map<CampoVisaoPercentagem, Map<String, String>> _distorcaoData = {
    CampoVisaoPercentagem.p40: {
      'titulo': 'Campo de Visão 40%',
      'descricao': 'Este campo de visão oferece uma área nítida mais limitada, com distorções perceptíveis nas laterais. É uma opção mais básica, exigindo mais movimentação da cabeça para enxergar com clareza em todas as distâncias.',
      'pros': 'Custo mais acessível.',
      'contras': 'Distorções laterais mais acentuadas; Exige maior adaptação; Campo de visão limitado.',
    },
    CampoVisaoPercentagem.p50: {
      'titulo': 'Campo de Visão 50%',
      'descricao': 'Com 50% de campo de visão, a área de transição e a nitidez são um pouco melhores que a opção de 40%. As distorções laterais ainda estão presentes, mas a adaptação pode ser mais suave.',
      'pros': 'Melhor custo-benefício que opções mais básicas; Adaptação um pouco mais fácil.',
      'contras': 'Ainda possui distorções laterais; Transição menos fluida que campos maiores.',
    },
    CampoVisaoPercentagem.p67: {
      'titulo': 'Campo de Visao 67%',
      'descricao': 'Representa um campo de visão intermediário a avançado, com uma redução significativa das distorções laterais. Proporciona uma transição mais confortável entre as diferentes distâncias.',
      'pros': 'Melhor conforto visual e adaptação; Menor distorção lateral.',
      'contras': 'Pode exigir um breve período de adaptação para alguns usuários.',
    },

    CampoVisaoPercentagem.p87: {
      'titulo': 'Campo de Visão 87%',
      'descricao': 'Extremamente amplo e otimizado, o campo de visão de 87% oferece a máxima clareza e conforto. As distorções são quase imperceptíveis, proporcionando uma experiência visual premium.',
      'pros': 'Conforto visual superior; Praticamente sem distorções laterais; Adaptação muito rápida.',
      'contras': 'Preço mais elevado.',
    },
    CampoVisaoPercentagem.p98: {
      'titulo': 'Campo de Visão 98%',
      'descricao': 'O ápice da tecnologia em lentes multifocais, com um campo de visão que se aproxima da perfeição, eliminando quase por completo as distorções. Proporciona a transição mais suave e natural possível.',
      'pros': 'Melhor campo de visão possível; Transição totalmente natural; Adaptação instantânea para a maioria.',
      'contras': 'Custo mais elevado, representando a tecnologia de ponta.',
    },
  };


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
            // Botões para Monofocal, Bifocal, Multifocal (gerais)
            _buildBotaoTipoLente(texto: 'Monofocal', tipo: CampoVisaoSimulacao.monofocal),
            const SizedBox(height: 16),
            _buildBotaoTipoLente(texto: 'Bifocal', tipo: CampoVisaoSimulacao.bifocal),
            const SizedBox(height: 16),
            _buildBotaoTipoLente(texto: 'Multifocal', tipo: CampoVisaoSimulacao.multifocal), // Agora Multifocal é um "abrir submenu"
          ],
        ),
      ),
    );
  }

  // NOVO WIDGET: Sub-menu para seleção de porcentagens de campo de visão
  Widget _buildMultifocalSubMenu() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Multifocal - Selecione o Campo de Visão',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A2956),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Botões para cada porcentagem de campo de visão
            Wrap(
              spacing: 12.0, // Aumenta o espaçamento
              runSpacing: 12.0, // Aumenta o espaçamento
              alignment: WrapAlignment.center,
              children: CampoVisaoPercentagem.values.map((percentagemEnum) {
                final String percentagemStr = percentagemEnum.toString().split('.').last.substring(1) + '%';
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2956),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(140, 60), // Botões maiores
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => setState(() {
                    _selecaoAtual = _mapPercentagemEnumToSimulacao(percentagemEnum); // Mapeia o enum para a seleção
                    _percentagemAtualEnum = percentagemEnum; // Armazena a porcentagem real selecionada
                    _isDescricaoVisivel = false;
                  }),
                  child: Text(percentagemStr),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // Botão para "Comparar Todos os Campos de Visão"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2956),
                foregroundColor: Colors.white,
                minimumSize: const Size(300, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () => setState(() {
                _selecaoAtual = CampoVisaoSimulacao.todos;
                _isDescricaoVisivel = false;
              }),
              child: const Text('Comparar Todos os Campos de Visão'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper para mapear CampoVisaoPercentagem para CampoVisaoSimulacao
  CampoVisaoSimulacao _mapPercentagemEnumToSimulacao(CampoVisaoPercentagem percentagemEnum) {
    switch (percentagemEnum) {
      case CampoVisaoPercentagem.p40: return CampoVisaoSimulacao.p40;
      case CampoVisaoPercentagem.p50: return CampoVisaoSimulacao.p50;
      case CampoVisaoPercentagem.p67: return CampoVisaoSimulacao.p67;
      // case CampoVisaoPercentagem.p80: return CampoVisaoSimulacao.p80; // Adicionado p80
      case CampoVisaoPercentagem.p87: return CampoVisaoSimulacao.p87;
      case CampoVisaoPercentagem.p98: return CampoVisaoSimulacao.p98;
    }
    // Adicionado um return padrão para cobrir todos os casos.
    // Isso deve ser unreachable se todos os enums forem mapeados.
    return CampoVisaoSimulacao.nenhum; // Ou lance um erro, dependendo da sua estratégia
  }

  // Helper para criar os botões de tipo de lente
  Widget _buildBotaoTipoLente({required String texto, required CampoVisaoSimulacao tipo}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0A2956),
        foregroundColor: Colors.white,
        minimumSize: const Size(300, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      onPressed: () => setState(() {
        _selecaoAtual = tipo;
        _isDescricaoVisivel = false;
      }),
      child: Text(texto),
    );
  }


  // Novo widget para a descrição, mais detalhado
  Widget _buildDescricaoDetalhada() {
    String titulo = "", descricao = "";
    List<Widget> pros = [];
    List<Widget> contras = [];

    // Lógica para tipos gerais (Monofocal, Bifocal, Multifocal)
    if (_selecaoAtual == CampoVisaoSimulacao.monofocal) {
      titulo = "Lente Monofocal (Visão Simples)";
      descricao = "Ideal para corrigir a visão para uma única distância, oferecendo o campo de visão mais amplo e nítido.";
      pros = [const Text('Campo de visão amplo e sem distorções.', style: TextStyle(color: Colors.white))];
      contras = [const Text('Corrige apenas para longe OU perto.', style: TextStyle(color: Colors.white))];
    } else if (_selecaoAtual == CampoVisaoSimulacao.bifocal) {
      titulo = "Lente Bifocal";
      descricao = "Combina duas zonas de visão em uma única lente, uma para longe e outra para perto, separadas por uma linha visível.";
      pros = [const Text('Visão nítida para longe e perto.', style: TextStyle(color: Colors.white))];
      contras = [
        const Text('Linha divisória visível.', style: TextStyle(color: Colors.white)),
        const Text('Sem correção para distância intermediária.', style: TextStyle(color: Colors.white))
      ];
    } else if (_selecaoAtual == CampoVisaoSimulacao.multifocal) {
      // Quando _selecaoAtual é CampoVisaoSimulacao.multifocal, mostramos o sub-menu,
      // então esta descrição genérica não é mais exibida no overlay.
      return const SizedBox.shrink(); // Não há descrição detalhada para o item "Multifocal" geral
    } 
    // Lógica para descrições de porcentagens específicas
    else if (_percentagemAtualEnum != null && _distorcaoData.containsKey(_percentagemAtualEnum)) {
      final data = _distorcaoData[_percentagemAtualEnum]!;
      titulo = data['titulo']!;
      descricao = data['descricao']!;
      pros = data['pros']!.split(';').map((s) => Text(s.trim(), style: const TextStyle(color: Colors.white))).toList();
      contras = data['contras']!.split(';').map((s) => Text(s.trim(), style: const TextStyle(color: Colors.white))).toList();
    } else if (_selecaoAtual == CampoVisaoSimulacao.todos) {
      titulo = "Comparativo de Campos de Visão";
      descricao = "Observe como as zonas de distorção variam em diferentes porcentagens de campo de visão em lentes multifocais. Quanto maior a porcentagem, menor a distorção e mais natural a transição.";
      pros = [const Text('Compare as distorções para cada campo de visão.', style: TextStyle(color: Colors.white))];
      contras = [const Text('As distorções podem variar ligeiramente entre fabricantes.', style: TextStyle(color: Colors.white))];
    }else {
      return const SizedBox.shrink(); 
    }


    Widget buildInfoRow(IconData icon, Color color, List<Widget> items) {
      if (items.isEmpty) return const SizedBox.shrink();
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget que constrói a área de simulação
  Widget _buildAreaSimulacao() {
    // Imagens para Monofocal, Bifocal, Multifocal (genérico)
    const Map<CampoVisaoSimulacao, String> tipoLenteImages = {
      CampoVisaoSimulacao.monofocal: 'assets/images/monofocal.jpg', // Nova imagem completa
      CampoVisaoSimulacao.bifocal: 'assets/images/bifocal.jpg',   // Nova imagem completa
      // Multifocal (genérico) não terá uma imagem aqui, pois vai para o submenu
      // CampoVisaoSimulacao.multifocal: 'assets/images/multifocal_completo.jpg', // Removido ou usado para um visual genérico
    };
    
    // Mapeamento de imagens para cada porcentagem de campo de visão
    final Map<CampoVisaoPercentagem, String> campoVisaoImages = {
      CampoVisaoPercentagem.p40: 'assets/images/campo_visao_40.jpg',
      CampoVisaoPercentagem.p50: 'assets/images/campo_visao_50.jpg',
      CampoVisaoPercentagem.p67: 'assets/images/campo_visao_67.jpg',
      CampoVisaoPercentagem.p87: 'assets/images/campo_visao_87.jpg',
      CampoVisaoPercentagem.p98: 'assets/images/campo_visao_98.jpg',
    };
    
    const String imagemComparativoGeral = 'assets/images/campo_visao_todos_comparativo.jpg'; 

    switch (_selecaoAtual) {
      case CampoVisaoSimulacao.monofocal:
      case CampoVisaoSimulacao.bifocal:
        // Para Monofocal e Bifocal, carregue a imagem completa diretamente
        String? assetPath = tipoLenteImages[_selecaoAtual];
        if (assetPath == null) return const Center(child: Text('Imagem não encontrada.', style: TextStyle(color: Colors.red)));
        return Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(color: Colors.red),
        );

      case CampoVisaoSimulacao.multifocal: // Se Multifocal geral, mostra o submenu
        return _buildMultifocalSubMenu();

      // Casos para cada porcentagem individual
      case CampoVisaoSimulacao.p40:
      case CampoVisaoSimulacao.p50:
      case CampoVisaoSimulacao.p67:
      case CampoVisaoSimulacao.p87:
      case CampoVisaoSimulacao.p98:
        String? assetPath = campoVisaoImages[_percentagemAtualEnum];
        if (assetPath == null) return const Center(child: Text('Imagem não encontrada para este campo de visão.', style: TextStyle(color: Colors.black)));
        return Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(child: Text('Erro ao carregar imagem.', style: TextStyle(color: Colors.red))),
        );
      
      // Caso para "Todos os Campos de Visão Juntos"
      case CampoVisaoSimulacao.todos:
        return Image.asset(
          imagemComparativoGeral,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(child: Text('Erro ao carregar imagem comparativa.', style: TextStyle(color: Colors.red))),
        );

      case CampoVisaoSimulacao.nenhum:
        return const SizedBox.shrink();
    }
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
              // Lógica de voltar aprimorada:
              if (_selecaoAtual == CampoVisaoSimulacao.p40 || 
                  _selecaoAtual == CampoVisaoSimulacao.p50 ||
                  _selecaoAtual == CampoVisaoSimulacao.p67 ||
                  _selecaoAtual == CampoVisaoSimulacao.p87 ||
                  _selecaoAtual == CampoVisaoSimulacao.p98 ||
                  _selecaoAtual == CampoVisaoSimulacao.todos) {
                _selecaoAtual = CampoVisaoSimulacao.multifocal; // Volta para o submenu multifocal
                _percentagemAtualEnum = null; // Reseta a seleção de porcentagem
              } else if (_selecaoAtual == CampoVisaoSimulacao.monofocal ||
                         _selecaoAtual == CampoVisaoSimulacao.bifocal ||
                         _selecaoAtual == CampoVisaoSimulacao.multifocal) {
                _selecaoAtual = CampoVisaoSimulacao.nenhum; // Volta para o menu principal
              } else {
                _selecaoAtual = CampoVisaoSimulacao.nenhum; // Fallback
              }
              _isDescricaoVisivel = false; // Garante que a descrição seja fechada
            }),
            child: const Icon(Icons.arrow_back, size: 32),
          ),
        ),
      ),
    );
  }

  // Widget do botão flutuante para mostrar a descrição
  Widget _buildBotaoInfo() {
    // Esconde o botão de info se estiver no menu principal ou no submenu multifocal
    if (_selecaoAtual == CampoVisaoSimulacao.nenhum || _selecaoAtual == CampoVisaoSimulacao.multifocal) {
      return const SizedBox.shrink();
    }
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

  // O overlay que contém o painel de descrição
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
            bottom: _isDescricaoVisivel ? 0 : -MediaQuery.of(context).size.height,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: _selecaoAtual == CampoVisaoSimulacao.nenhum
            ? _buildMenuVisao()
            : Stack(
                key: ValueKey(_selecaoAtual), 
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0), 
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: _buildAreaSimulacao(),
                    ),
                  ),
                  _buildBotaoVoltar(),
                  _buildBotaoInfo(),
                  _buildDescricaoOverlay(), 
                ],
              ),
      ),
    );
  }
}
