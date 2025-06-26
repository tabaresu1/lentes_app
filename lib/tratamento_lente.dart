import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Make sure this import is present

// Helper class for the anti-reflection slider
class _ImageRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;
  _ImageRevealClipper({required this.revealPercent});

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * revealPercent, size.height);

  @override
  bool shouldReclip(_ImageRevealClipper oldClipper) => oldClipper.revealPercent != revealPercent;
}

// Enum for different lens treatment types
enum TipoTratamento { camadas, nenhum, antirreflexo, fotossensivel, filtroAzul }

class TelaTratamentoLente extends StatefulWidget {
  const TelaTratamentoLente({super.key});

  @override
  State<TelaTratamentoLente> createState() => _TelaTratamentoLenteState();
}

class _TelaTratamentoLenteState extends State<TelaTratamentoLente> {
  TipoTratamento _tratamentoSelecionado = TipoTratamento.nenhum;
  double _sliderAntirreflexoValue = 0.5;
  double _posicaoLente = 0.25; // Initial position for the photochromic lens
  double _sliderFiltroAzulValue = 0.5;

  // Builds the menu for selecting lens treatments
  Widget _buildMenuTratamentos() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tratamentos de Lente',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0A2956))),
            const SizedBox(height: 8),
            const Text('Selecione um tratamento para ver a simulação',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 40),
            // Iterate through treatment types, excluding 'nenhum'
            ...TipoTratamento.values.where((t) => t != TipoTratamento.nenhum).map((tratamento) {
              String textoBotao = "";
              switch (tratamento) {
                case TipoTratamento.antirreflexo:
                  textoBotao = "Antirreflexo";
                  break;
                case TipoTratamento.fotossensivel:
                  textoBotao = "Fotossensível";
                  break;
                case TipoTratamento.filtroAzul:
                  textoBotao = "Filtro de Luz Azul";
                  break;
                case TipoTratamento.camadas:
                  textoBotao = "Camadas";
                  break;
                case TipoTratamento.nenhum: // Should not be reached due to .where clause
                  break;
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2956),
                    foregroundColor: Colors.white,
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

  // Builds the back button
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
            onPressed: () => setState(() => _tratamentoSelecionado = TipoTratamento.nenhum),
            child: const Icon(Icons.arrow_back, size: 32),
          ),
        ),
      ),
    );
  }

  // Builds the simulation area based on the selected treatment
  Widget _buildAreaSimulacao() {
    switch (_tratamentoSelecionado) {
      case TipoTratamento.antirreflexo:
        return LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            onHorizontalDragUpdate: (details) =>
                setState(() => _sliderAntirreflexoValue = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0)),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset('assets/images/cena_com_reflexo.jpg', fit: BoxFit.cover),
                ClipRect(
                  clipper: _ImageRevealClipper(revealPercent: _sliderAntirreflexoValue),
                  child: Image.asset('assets/images/cena_sem_reflexo.jpg', fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment((_sliderAntirreflexoValue * 2.0) - 1.0, 0),
                    child: Container(width: 4.0, color: Colors.orangeAccent.withOpacity(0.9)),
                  ),
                ),
              ],
            ),
          ),
        );

      case TipoTratamento.fotossensivel:
        return LayoutBuilder(builder: (context, constraints) {
          // 'darkeningStrength' controls how much the lenses darken
          // It goes from 0.0 (transparent tint) to 0.7 (max tint strength)
          // as _posicaoLente goes from 0.5 to 1.0.
          final darkeningStrength = (_posicaoLente - 0.5).clamp(0.0, 1.0) * 2 * 0.7;

          // Define the start and end colors for the lens tint
          final Color startTint = Colors.transparent;
          final Color endTint = Colors.black; // Example: dark grey/black tint

          // Interpolate the color based on the darkening strength
          final Color currentLensTint = Color.lerp(startTint, endTint, darkeningStrength)!;

          return Stack(children: [
            Positioned.fill(child: Image.asset('assets/images/cenario_composto.jpg', fit: BoxFit.cover)),
            Positioned(
              left: _posicaoLente * (constraints.maxWidth - 150.0), // Position based on slider
              top: (constraints.maxHeight - 150.0) / 2, // Vertically center the lens
              child: GestureDetector(
                onHorizontalDragUpdate: (details) => setState(() {
                  _posicaoLente += details.delta.dx / (constraints.maxWidth - 150.0);
                  _posicaoLente = _posicaoLente.clamp(0.0, 1.0);
                }),
                // This Stack will layer the static frame and the dynamic lenses
                child: Stack(
                  children: [
                    // 1. The full glasses SVG (frame + base lenses), without dynamic tinting
                    SvgPicture.asset(
                      'assets/images/lente_oculos.svg', // Path to your full glasses SVG
                      width: 200,
                      height: 200,
                      // No colorFilter here, so the frame stays its original color (black)
                    ),
                    // 2. The lenses-only SVG, with dynamic tinting applied
                    SvgPicture.asset(
                      'assets/images/lente_oculos_fs.svg', // Path to your lenses-only SVG
                      width: 200,
                      height: 200,
                      // Apply the dynamically calculated color filter
                      colorFilter: ColorFilter.mode(currentLensTint, BlendMode.srcIn),
                    ),
                  ],
                ),
              ),
            ),
          ]);
        });

      case TipoTratamento.filtroAzul:
        return LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            onHorizontalDragUpdate: (details) =>
                setState(() => _sliderFiltroAzulValue = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0)),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset('assets/images/tela_digital_normal.jpg', fit: BoxFit.cover),
                ClipRect(
                  clipper: _ImageRevealClipper(revealPercent: _sliderFiltroAzulValue),
                  child: Image.asset('assets/images/tela_digital_filtro_azul.jpg', fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment((_sliderFiltroAzulValue * 2.0) - 1.0, 0),
                    child: Container(width: 4, color: Colors.blueAccent.withOpacity(0.9)),
                  ),
                ),
              ],
            ),
          ),
        );

      case TipoTratamento.camadas:
        return const CamadasLenteWidget();

      case TipoTratamento.nenhum:
        return const SizedBox.shrink(); // Empty widget when no treatment is selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        // If no treatment is selected, show the menu; otherwise, show the simulation and back button
        child: _tratamentoSelecionado == TipoTratamento.nenhum
            ? _buildMenuTratamentos()
            : Stack(
                key: ValueKey(_tratamentoSelecionado), // Key for AnimatedSwitcher to recognize state changes
                children: [_buildAreaSimulacao(), _buildBotaoVoltar()],
              ),
      ),
    );
  }
}

// Widget for simulating lens layers
class CamadasLenteWidget extends StatefulWidget {
  const CamadasLenteWidget({super.key});

  @override
  State<CamadasLenteWidget> createState() => _CamadasLenteWidgetState();
}

class _CamadasLenteWidgetState extends State<CamadasLenteWidget> {
  bool _filtroAzul = false;
  bool _antirreflexo = false;
  bool _antiRisco = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8, // Horizontal space between chips
          children: [
            FilterChip(
              label: const Text('Filtro Azul'),
              selected: _filtroAzul,
              onSelected: (v) => setState(() => _filtroAzul = v),
              selectedColor: Colors.brown[200],
            ),
            FilterChip(
              label: const Text('Anti-Reflexo'),
              selected: _antirreflexo,
              onSelected: (v) => setState(() => _antirreflexo = v),
              selectedColor: Colors.green[200],
            ),
            FilterChip(
              label: const Text('Anti-Risco'),
              selected: _antiRisco,
              onSelected: (v) => setState(() => _antiRisco = v),
              selectedColor: Colors.lightBlue[100],
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 250, // Fixed height for the layer stack
          child: Stack(
            alignment: Alignment.bottomCenter, // Layers stack from the bottom
            children: [
              // Base lens layer
              _buildLayer(color: Colors.grey[300]!, text: 'Lente Simples', offset: 0),
              // Conditionally display other layers based on chip selection
              if (_antiRisco) _buildLayer(color: Colors.lightBlue[100]!, text: 'Anti-Risco', offset: 1),
              if (_antirreflexo) _buildLayer(color: Colors.green[200]!, text: 'Anti-Reflexo', offset: 2),
              if (_filtroAzul) _buildLayer(color: Colors.brown[200]!, text: 'Filtro Azul', offset: 3),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to build individual lens layers
  Widget _buildLayer({required Color color, required String text, required int offset}) {
    return Positioned(
      bottom: offset * 25.0, // Position layers above each other
      child: Container(
        width: 180 - offset * 10.0, // Make layers slightly smaller as they go up
        height: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30 - offset * 3.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}

// This class is not directly used in the provided code but was present in the original snippet.
class _LayerInfo {
  final Color color;
  final String? text;
  final int offset;
  _LayerInfo({required this.color, this.text, required this.offset});
}