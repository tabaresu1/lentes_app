import 'package:flutter/material.dart';

// As classes auxiliares para o slider do antirreflexo
class _ImageRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;
  _ImageRevealClipper({required this.revealPercent});
  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * revealPercent, size.height);
  @override
  bool shouldReclip(_ImageRevealClipper oldClipper) => oldClipper.revealPercent != revealPercent;
}

enum TipoTratamento { nenhum, antirreflexo, fotossensivel, filtroAzul }

class TelaTratamentoLente extends StatefulWidget {
  const TelaTratamentoLente({super.key});

  @override
  State<TelaTratamentoLente> createState() => _TelaTratamentoLenteState();
}

class _TelaTratamentoLenteState extends State<TelaTratamentoLente> {
  TipoTratamento _tratamentoSelecionado = TipoTratamento.nenhum;
  double _sliderAntirreflexoValue = 0.5;
  double _posicaoLente = 0.25;
  double _sliderFiltroAzulValue = 0.5;

  Widget _buildMenuTratamentos() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tratamentos de Lente', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0A2956))),
            const SizedBox(height: 8),
            const Text('Selecione um tratamento para ver a simulação', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 40),
            ...TipoTratamento.values.where((t) => t != TipoTratamento.nenhum).map((tratamento) {
              String textoBotao = "";
              switch(tratamento) {
                case TipoTratamento.antirreflexo: textoBotao = "Antirreflexo"; break;
                case TipoTratamento.fotossensivel: textoBotao = "Fotossensível"; break;
                case TipoTratamento.filtroAzul: textoBotao = "Filtro de Luz Azul"; break;
                case TipoTratamento.nenhum: break;
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2956), foregroundColor: Colors.white,
                    minimumSize: const Size(300, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => setState(() => _tratamentoSelecionado = tratamento),
                  child: Text(textoBotao),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBotaoVoltar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.9), foregroundColor: Colors.black,
              shape: const CircleBorder(), padding: const EdgeInsets.all(16), elevation: 8,
            ),
            onPressed: () => setState(() => _tratamentoSelecionado = TipoTratamento.nenhum),
            child: const Icon(Icons.arrow_back, size: 32),
          ),
        ),
      ),
    );
  }

  // A função e o botão para adicionar ao orçamento foram removidos.
  
  Widget _buildAreaSimulacao() {
    switch (_tratamentoSelecionado) {
      case TipoTratamento.antirreflexo:
        return LayoutBuilder(builder: (context, constraints) => GestureDetector(
          onHorizontalDragUpdate: (details) => setState(() => _sliderAntirreflexoValue = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0)),
          child: Stack(fit: StackFit.expand, children: <Widget>[
            Image.asset('assets/images/cena_com_reflexo.jpg', fit: BoxFit.cover),
            ClipRect(clipper: _ImageRevealClipper(revealPercent: _sliderAntirreflexoValue), child: Image.asset('assets/images/cena_sem_reflexo.jpg', fit: BoxFit.cover)),
            Positioned.fill(child: Align(alignment: Alignment((_sliderAntirreflexoValue * 2.0) - 1.0, 0), child: Container(width: 4.0, color: Colors.orangeAccent.withOpacity(0.9)))),
          ]),
        ));

      case TipoTratamento.fotossensivel:
        return LayoutBuilder(builder: (context, constraints) {
          final opacidadeLente = (_posicaoLente - 0.5).clamp(0.0, 1.0) * 2 * 0.7;
          return Stack(children: [
            Positioned.fill(child: Image.asset('assets/images/cenario_composto.jpg', fit: BoxFit.cover)),
            Positioned(
              left: _posicaoLente * (constraints.maxWidth - 150.0), top: (constraints.maxHeight - 150.0) / 2,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) => setState(() {
                  _posicaoLente += details.delta.dx / (constraints.maxWidth - 150.0);
                  _posicaoLente = _posicaoLente.clamp(0.0, 1.0);
                }),
                child: Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(opacidadeLente), border: Border.all(color: Colors.white.withOpacity(0.8), width: 4.0))),
              ),
            ),
          ]);
        });
      
      case TipoTratamento.filtroAzul:
        return LayoutBuilder(builder: (context, constraints) => GestureDetector(
          onHorizontalDragUpdate: (details) => setState(() => _sliderFiltroAzulValue = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0)),
          child: Stack(fit: StackFit.expand, children: <Widget>[
            Image.asset('assets/images/tela_digital_normal.jpg', fit: BoxFit.cover),
            ClipRect(clipper: _ImageRevealClipper(revealPercent: _sliderFiltroAzulValue), child: Image.asset('assets/images/tela_digital_filtro_azul.jpg', fit: BoxFit.cover)),
            Positioned.fill(child: Align(alignment: Alignment((_sliderFiltroAzulValue * 2.0) - 1.0, 0), child: Container(width: 4.0, color: Colors.blueAccent.withOpacity(0.9)))),
          ]),
        ));

      case TipoTratamento.nenhum:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: _tratamentoSelecionado == TipoTratamento.nenhum
            ? _buildMenuTratamentos()
            : Stack(
                key: ValueKey(_tratamentoSelecionado),
                children: [_buildAreaSimulacao(), _buildBotaoVoltar()],
              ),
      ),
    );
  }
}
