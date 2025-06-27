// Seu import permanece igual
import 'package:flutter/material.dart';
import 'dart:ui';
import 'espessura_lente.dart';

enum CampoVisaoSimulacao {
  nenhum,
  monofocal,
  bifocal,
  multifocal,
  p40, p50, p67, p87, p98,
  todos
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
  CampoVisaoSimulacao _selecaoAtual = CampoVisaoSimulacao.nenhum;
  bool _isDescricaoVisivel = false;
  CampoVisaoPercentagem? _percentagemAtualEnum;

  // Descrições
  static const Map<CampoVisaoPercentagem, Map<String, String>> _distorcaoData = {
    CampoVisaoPercentagem.p40: {
      'titulo': 'Campo de Visão 40%',
      'descricao': 'Este campo de visão oferece uma área nítida mais limitada, com distorções perceptíveis nas laterais.',
      'pros': 'Custo mais acessível.',
      'contras': 'Distorções laterais mais acentuadas; Campo limitado.',
    },
    CampoVisaoPercentagem.p50: {
      'titulo': 'Campo de Visão 50%',
      'descricao': 'Com 50% de campo de visão, a área de transição e a nitidez são melhores que 40%.',
      'pros': 'Melhor custo-benefício.',
      'contras': 'Distorções ainda presentes.',
    },
    CampoVisaoPercentagem.p67: {
      'titulo': 'Campo de Visão 67%',
      'descricao': 'Campo intermediário com boa redução de distorções laterais.',
      'pros': 'Maior conforto visual.',
      'contras': 'Pode exigir breve adaptação.',
    },
    CampoVisaoPercentagem.p87: {
      'titulo': 'Campo de Visão 87%',
      'descricao': 'Quase sem distorções. Experiência visual premium.',
      'pros': 'Conforto visual superior.',
      'contras': 'Preço mais elevado.',
    },
    CampoVisaoPercentagem.p98: {
      'titulo': 'Campo de Visão 98%',
      'descricao': 'O melhor campo possível. Transição extremamente natural.',
      'pros': 'Melhor visão possível.',
      'contras': 'Maior custo.',
    },
  };

  // === Menu Principal ===
  Widget _buildMenuVisao() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Campo de Visão', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0A2956))),
            const SizedBox(height: 8),
            const Text('Selecione uma lente para simular', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 40),
            _buildBotaoTipoLente(texto: 'Monofocal', tipo: CampoVisaoSimulacao.monofocal),
            const SizedBox(height: 16),
            _buildBotaoTipoLente(texto: 'Bifocal', tipo: CampoVisaoSimulacao.bifocal),
            const SizedBox(height: 16),
            _buildBotaoTipoLente(texto: 'Multifocal', tipo: CampoVisaoSimulacao.multifocal),
          ],
        ),
      ),
    );
  }

  // === Submenu Multifocal ===
  Widget _buildMultifocalSubMenu() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Multifocal - Selecione o Campo de Visão',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0A2956)),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              alignment: WrapAlignment.center,
              children: CampoVisaoPercentagem.values.map((percentagemEnum) {
                final String percentagemStr = percentagemEnum.toString().split('.').last.substring(1) + '%';
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2956),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(140, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => setState(() {
                    _selecaoAtual = _mapPercentagemEnumToSimulacao(percentagemEnum);
                    _percentagemAtualEnum = percentagemEnum;
                    _isDescricaoVisivel = false;
                  }),
                  child: Text(percentagemStr),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
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

  // === Helper Mapping ===
  CampoVisaoSimulacao _mapPercentagemEnumToSimulacao(CampoVisaoPercentagem percentagemEnum) {
    switch (percentagemEnum) {
      case CampoVisaoPercentagem.p40: return CampoVisaoSimulacao.p40;
      case CampoVisaoPercentagem.p50: return CampoVisaoSimulacao.p50;
      case CampoVisaoPercentagem.p67: return CampoVisaoSimulacao.p67;
      case CampoVisaoPercentagem.p87: return CampoVisaoSimulacao.p87;
      case CampoVisaoPercentagem.p98: return CampoVisaoSimulacao.p98;
    }
  }

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

  // === Exibição de Imagens ===
Widget _buildAreaSimulacao() {
  const tipoLenteImages = {
    CampoVisaoSimulacao.monofocal: 'assets/images/monofocal.jpg',
    CampoVisaoSimulacao.bifocal: 'assets/images/bifocal.jpg',
  };

  final campoVisaoImages = {
    CampoVisaoPercentagem.p40: 'assets/images/campo_visao_40.jpg',
    CampoVisaoPercentagem.p50: 'assets/images/campo_visao_50.jpg',
    CampoVisaoPercentagem.p67: 'assets/images/campo_visao_67.jpg',
    CampoVisaoPercentagem.p87: 'assets/images/campo_visao_87.jpg',
    CampoVisaoPercentagem.p98: 'assets/images/campo_visao_98.jpg',
  };

  const imagemComparativo = 'assets/images/campo_visao_todos_comparativo.png';

  // Unified right-aligned container for ALL images
  Widget buildRightAlignedImage(String imagePath, BoxFit fit) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Same width for all
        child: Image.asset(
          imagePath,
          fit: fit,
        ),
      ),
    );
  }

  switch (_selecaoAtual) {
    case CampoVisaoSimulacao.monofocal:
    case CampoVisaoSimulacao.bifocal:
      return buildRightAlignedImage(
        tipoLenteImages[_selecaoAtual]!,
        BoxFit.contain // Maintain contain for these
      );

    case CampoVisaoSimulacao.multifocal:
      return _buildMultifocalSubMenu();

    case CampoVisaoSimulacao.p40:
    case CampoVisaoSimulacao.p50:
    case CampoVisaoSimulacao.p67:
    case CampoVisaoSimulacao.p87:
    case CampoVisaoSimulacao.p98:
      return buildRightAlignedImage(
        campoVisaoImages[_percentagemAtualEnum]!,
        BoxFit.contain // Maintain contain for these
      );

    case CampoVisaoSimulacao.todos:
      return buildRightAlignedImage(
        imagemComparativo,
        BoxFit.contain
      );

    case CampoVisaoSimulacao.nenhum:
      return const SizedBox.shrink();
  }
}

  // === Botão Voltar ===
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
              if (_selecaoAtual.name.contains('p') || _selecaoAtual == CampoVisaoSimulacao.todos) {
                _selecaoAtual = CampoVisaoSimulacao.multifocal;
                _percentagemAtualEnum = null;
              } else {
                _selecaoAtual = CampoVisaoSimulacao.nenhum;
              }
              _isDescricaoVisivel = false;
            }),
            child: const Icon(Icons.arrow_back, size: 32),
          ),
        ),
      ),
    );
  }

  // === Overlay Descrição ===
  Widget _buildDescricaoOverlay() {
    return Visibility(
      visible: _isDescricaoVisivel,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isDescricaoVisivel = false),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildDescricaoDetalhada(),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoInfo() {
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
          child: const Icon(Icons.info, color: Color(0xFF0A2956)),
        ),
      ),
    );
  }

  Widget _buildDescricaoDetalhada() {
    String titulo = "";
    String descricao = "";
    List<String> pros = [];
    List<String> contras = [];

    if (_selecaoAtual == CampoVisaoSimulacao.monofocal) {
      titulo = "Lente Monofocal";
      descricao = "Corrige para uma única distância.";
      pros = ['Campo amplo', 'Sem distorções.'];
      contras = ['Corrige apenas para longe OU perto.'];
    } else if (_selecaoAtual == CampoVisaoSimulacao.bifocal) {
      titulo = "Lente Bifocal";
      descricao = "Duas zonas separadas: longe e perto.";
      pros = ['Visão nítida para longe e perto.'];
      contras = ['Linha divisória visível.', 'Sem correção para intermediário.'];
    } else if (_selecaoAtual == CampoVisaoSimulacao.todos) {
      titulo = "Comparativo dos Campos de Visão";
      descricao = "Observe as diferenças entre os campos de visão.";
      pros = ['Visualização clara das diferenças.'];
      contras = ['Variações podem ocorrer entre fabricantes.'];
    } else if (_percentagemAtualEnum != null) {
      final data = _distorcaoData[_percentagemAtualEnum]!;
      titulo = data['titulo']!;
      descricao = data['descricao']!;
      pros = data['pros']!.split(';');
      contras = data['contras']!.split(';');
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text(descricao, style: const TextStyle(fontSize: 16, color: Colors.white70)),
              const Divider(color: Colors.white54, height: 32),
              ...pros.map((e) => Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(e.trim(), style: const TextStyle(color: Colors.white))),
                    ],
                  )),
              const SizedBox(height: 12),
              ...contras.map((e) => Row(
                    children: [
                      const Icon(Icons.cancel, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(e.trim(), style: const TextStyle(color: Colors.white))),
                    ],
                  )),
            ],
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
