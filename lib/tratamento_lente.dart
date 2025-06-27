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
  double _sliderAntirreflexoValue = 0.0; // Initial value for the anti-reflection slider
  double _posicaoLente = 0.25; // Initial position for the photochromic lens
  double _sliderFiltroAzulValue = 0.0; // Initial value for the blue light filter slider

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
                Image.asset('assets/images/blue1.jpg', fit: BoxFit.cover),
                ClipRect(
                  clipper: _ImageRevealClipper(revealPercent: _sliderFiltroAzulValue),
                  child: Image.asset('assets/images/blue2.jpg', fit: BoxFit.cover),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // Chips de seleção com tamanho responsivo
          Wrap(
            spacing: isTablet ? 20 : 8,
            runSpacing: 12,
            children: [
              _buildEnhancedChip(
                label: 'Filtro Azul',
                selected: _filtroAzul,
                onSelected: (v) => setState(() => _filtroAzul = v),
                color: Colors.blue[700]!,
                icon: Icons.lightbulb_outline,
              ),
              _buildEnhancedChip(
                label: 'Anti-Reflexo',
                selected: _antirreflexo,
                onSelected: (v) => setState(() => _antirreflexo = v),
                color: Colors.purple[700]!,
                icon: Icons.flash_on,
              ),
              _buildEnhancedChip(
                label: 'Anti-Risco',
                selected: _antiRisco,
                onSelected: (v) => setState(() => _antiRisco = v),
                color: Colors.green[700]!,
                icon: Icons.security,
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Representação 3D das camadas
          SizedBox(
            height: isTablet ? 350 : 280,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Fundo decorativo
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                  ),
                ),
                
                // Efeito de profundidade
                Positioned(
                  top: 40,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                  ),
                ),
                
                // Camadas de tratamento
                Positioned(
                  top: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Lente base (sempre visível)
                      _build3DLayer(
                        color: Colors.grey[300]!,
                        text: 'Lente Base',
                        index: 0,
                        isSelected: true,
                      ),
                      
                      // Anti-Risco
                      if (_antiRisco)
                        _build3DLayer(
                          color: Colors.green[400]!,
                          text: 'Anti-Risco',
                          index: 1,
                          isSelected: _antiRisco,
                        ),
                      
                      // Anti-Reflexo
                      if (_antirreflexo)
                        _build3DLayer(
                          color: Colors.purple[300]!,
                          text: 'Anti-Reflexo',
                          index: 2,
                          isSelected: _antirreflexo,
                        ),
                      
                      // Filtro Azul
                      if (_filtroAzul)
                        _build3DLayer(
                          color: Colors.blue[300]!,
                          text: 'Filtro Azul',
                          index: 3,
                          isSelected: _filtroAzul,
                        ),
                    ],
                  ),
                ),
                
                // Efeito de reflexo
                Positioned(
                  top: 90,
                  right: 60,
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.1),
                          ],
                          stops: const [0.2, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Chip aprimorado com ícone e efeitos
  Widget _buildEnhancedChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
    required Color color,
    required IconData icon,
  }) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: selected ? Colors.white : color),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black87,
          )),
        ],
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: selected ? color : Colors.grey[200],
      selectedColor: color,
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: selected ? color : Colors.grey[300]!, width: 1.5),
      ),
      elevation: 4,
      shadowColor: Colors.black26,
    );
  }

  // Camada 3D com efeitos de profundidade
  Widget _build3DLayer({
    required Color color,
    required String text,
    required int index,
    required bool isSelected,
  }) {
    final double size = 200 - index * 20;
    final double elevation = index * 6.0;
    final double borderRadius = size / 2;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(color, Colors.white, 0.3)!,
            Color.lerp(color, Colors.black, 0.1)!,
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: elevation,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: -2,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Center(
        child: AnimatedOpacity(
          opacity: isSelected ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}