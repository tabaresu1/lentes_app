import 'package:flutter/material.dart';
import 'dart:ui'; // Import necessário para ImageFilter.blur
import 'widgets/menu_button.dart';

enum TipoTratamento {
  nenhum,
  antirreflexo,
  fotossensivel,
  filtroAzul,
  polarizado,
}

class _ImageRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;
  _ImageRevealClipper({required this.revealPercent});
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * revealPercent, size.height);
  }
  @override
  bool shouldReclip(_ImageRevealClipper oldClipper) {
    return oldClipper.revealPercent != revealPercent;
  }
}

class _EmptySliderTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 0;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {}
}

class TelaTratamentoLente extends StatefulWidget {
  const TelaTratamentoLente({super.key});

  @override
  State<TelaTratamentoLente> createState() => _TelaTratamentoLenteState();
}

class _TelaTratamentoLenteState extends State<TelaTratamentoLente> {
  TipoTratamento _tratamentoSelecionado = TipoTratamento.nenhum;
  double _sliderAntirreflexoValue = 0.0;
  double _posicaoLente = 0.0; // Posição da lente para o fotossensível

  Widget _buildMenuTratamentos() {
    const Color corFundoBotaoTratamento = Color(0xFF0A2956);
    const Color corTextoBotaoTratamento = Colors.white;
    const double larguraBotaoTratamento = 300.0;
    const double alturaBotaoTratamento = 55.0;
    const TextStyle estiloTextoBotaoTratamento = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    const EdgeInsetsGeometry paddingBotaoTratamento = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: larguraBotaoTratamento,
              height: alturaBotaoTratamento,
              child: MenuButton(
                texto: 'Antirreflexo',
                onPressed: () {
                  setState(() {
                    _tratamentoSelecionado = TipoTratamento.antirreflexo;
                    _sliderAntirreflexoValue = 0.0; 
                  });
                },
                backgroundColor: corFundoBotaoTratamento,
                foregroundColor: corTextoBotaoTratamento,
                textStyle: estiloTextoBotaoTratamento,
                padding: paddingBotaoTratamento,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: larguraBotaoTratamento,
              height: alturaBotaoTratamento,
              child: MenuButton(
                texto: 'Fotossensível',
                onPressed: () {
                  setState(() {
                    _tratamentoSelecionado = TipoTratamento.fotossensivel;
                    _posicaoLente = 0.0; // Reseta a posição da lente
                  });
                },
                backgroundColor: corFundoBotaoTratamento,
                foregroundColor: corTextoBotaoTratamento,
                textStyle: estiloTextoBotaoTratamento,
                padding: paddingBotaoTratamento,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: larguraBotaoTratamento,
              height: alturaBotaoTratamento,
              child: MenuButton(
                texto: 'Filtro Luz Azul',
                onPressed: () => setState(() => _tratamentoSelecionado = TipoTratamento.filtroAzul),
                backgroundColor: corFundoBotaoTratamento,
                foregroundColor: corTextoBotaoTratamento,
                textStyle: estiloTextoBotaoTratamento,
                padding: paddingBotaoTratamento,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: larguraBotaoTratamento,
              height: alturaBotaoTratamento,
              child: MenuButton(
                texto: 'Polarizado',
                onPressed: () => setState(() => _tratamentoSelecionado = TipoTratamento.polarizado),
                backgroundColor: corFundoBotaoTratamento,
                foregroundColor: corTextoBotaoTratamento,
                textStyle: estiloTextoBotaoTratamento,
                padding: paddingBotaoTratamento,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotaoVoltar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 32.0, right: 16.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: SizedBox(
          width: 65,
          height: 65,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.4),
              padding: EdgeInsets.zero,
            ),
            onPressed: () => setState(() => _tratamentoSelecionado = TipoTratamento.nenhum),
            child: const Center(
              child: Icon(Icons.arrow_back, size: 32),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAreaSimulacao() {
    switch (_tratamentoSelecionado) {
            case TipoTratamento.antirreflexo:
        const String imagemBaseSemTratamento = 'assets/images/cena_com_reflexo.jpg';
        const String imagemReveladaComTratamento = 'assets/images/cena_sem_reflexo.jpg';
        const Color corDivisorDestaque = Colors.orangeAccent;

        return LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onHorizontalDragUpdate: (details) {
                final newSliderValue = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
                setState(() {
                  _sliderAntirreflexoValue = newSliderValue;
                });
              },
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  // **IMAGEM BASE (COBRINDO A TELA)**
                  Image.asset(
                    imagemBaseSemTratamento,
                    fit: BoxFit.cover, // Usamos BoxFit.cover para preencher a tela
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('Erro: Imagem base não encontrada!')),
                  ),
                  // **IMAGEM REVELADA (COBRINDO A TELA)**
                  ClipRect(
                    clipper: _ImageRevealClipper(revealPercent: _sliderAntirreflexoValue),
                    child: Image.asset(
                      imagemReveladaComTratamento,
                      fit: BoxFit.cover, // Usamos BoxFit.cover para preencher a tela
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Text('Erro: Imagem tratada não encontrada!')),
                    ),
                  ),
                  // Linha divisória visual
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment((_sliderAntirreflexoValue * 2.0) - 1.0, 0),
                      child: Container(
                        width: 4.0,
                        color: corDivisorDestaque.withOpacity(0.9),
                      ),
                    ),
                  ),
                  // SLIDER (posicionado na parte inferior do Stack)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 0.0,
                        activeTrackColor: Colors.transparent,
                        inactiveTrackColor: Colors.transparent,
                        thumbColor: Colors.transparent,
                        overlayColor: corDivisorDestaque.withAlpha(0x29),
                        trackShape: _EmptySliderTrackShape(),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
                      ),
                      child: Slider(
                        value: _sliderAntirreflexoValue,
                        onChanged: (newValue) {
                          setState(() {
                            _sliderAntirreflexoValue = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );

      case TipoTratamento.fotossensivel:
        const String imagemComposta = 'assets/images/cenario_composto.jpg';
        const double tamanhoLente = 150.0;
        const double opacidadeMaxima = 0.7;

        final double opacidadeLente = (_posicaoLente - 0.5).clamp(0.0, 1.0) * 2 * opacidadeMaxima;

        return LayoutBuilder(
          builder: (context, constraints) {
            final double posicaoHorizontalLente = _posicaoLente * (constraints.maxWidth - tamanhoLente);

            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    imagemComposta,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('Erro: Imagem composta não encontrada!')),
                  ),
                ),
                Positioned(
                  left: posicaoHorizontalLente,
                  top: (constraints.maxHeight - tamanhoLente) / 2,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _posicaoLente += details.delta.dx / (constraints.maxWidth - tamanhoLente);
                        _posicaoLente = _posicaoLente.clamp(0.0, 1.0);
                      });
                    },
                    child: Container(
                      width: tamanhoLente,
                      height: tamanhoLente,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(opacidadeLente),
                        border: Border.all(color: Colors.white.withOpacity(0.8), width: 4.0),
                        // MODIFICAÇÃO PRINCIPAL AQUI:
                        boxShadow: [
                          BoxShadow(
                            // A opacidade da sombra agora é controlada pela mesma variável
                            color: Colors.black.withOpacity(opacidadeLente * 0.7), // Sombra um pouco mais sutil que a lente
                            spreadRadius: 5,
                            blurRadius: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Text(
                    "Arraste a lente entre os ambientes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(blurRadius: 5.0, color: Colors.black.withOpacity(0.8))
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
        
      case TipoTratamento.filtroAzul:
        return const Center(child: Text("Simulação Filtro Luz Azul - Em breve!", style: TextStyle(fontSize: 18)));
      case TipoTratamento.polarizado:
        return const Center(child: Text("Simulação Polarizado - Em breve!", style: TextStyle(fontSize: 18)));
      case TipoTratamento.nenhum:
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(224, 224, 224, 1),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: _tratamentoSelecionado == TipoTratamento.nenhum
                    ? _buildMenuTratamentos()
                    : _buildAreaSimulacao(),
              ),
            ],
          ),
          if (_tratamentoSelecionado != TipoTratamento.nenhum)
            _buildBotaoVoltar(),
        ],
      ),
    );
  }
}