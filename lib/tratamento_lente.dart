import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

// --- ENUM ATUALIZADO COM NOVA OPÇÃO ---
enum TipoTratamento {
  camadas,
  nenhum,
  antirreflexo,
  fotossensivel,
  filtroAzul,
  comparativoEspessura // NOVO
}

// Helper class for the anti-reflection slider
class _ImageRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;
  _ImageRevealClipper({required this.revealPercent});

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * revealPercent, size.height);

  @override
  bool shouldReclip(_ImageRevealClipper oldClipper) => oldClipper.revealPercent != revealPercent;
}

class TelaTratamentoLente extends StatefulWidget {
  const TelaTratamentoLente({super.key});

  @override
  State<TelaTratamentoLente> createState() => _TelaTratamentoLenteState();
}

class _TelaTratamentoLenteState extends State<TelaTratamentoLente> {
  TipoTratamento _tratamentoSelecionado = TipoTratamento.nenhum;
  
  // Variáveis para tratamentos existentes
  double _sliderAntirreflexoValue = 0.0;
  double _posicaoLente = 0.25;
  double _sliderFiltroAzulValue = 0.0;

  // --- VARIÁVEIS DO COMPARATIVO DE ESPESSURA (NOVO) ---
  double _grauSelecionadoComparativo = -4.0;
  double _indiceEsquerda = 1.56;
  double _indiceDireita = 1.67;
  final Map<String, double> _opcoesLentes = {
    '1.56': 1.56,
    '1.59': 1.59,
    '1.61': 1.61,
    '1.67': 1.67,
    '1.74': 1.74,
  };
  double _expoenteExagero = 3.0;

  // --- MENU PRINCIPAL ATUALIZADO ---
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
            
            // Botões (incluindo o novo)
            ...TipoTratamento.values.where((t) => t != TipoTratamento.nenhum).map((tratamento) {
              String textoBotao = "";
              IconData? icone;
              
              switch (tratamento) {
                case TipoTratamento.antirreflexo:
                  textoBotao = "Antirreflexo";
                  icone = Icons.flash_on;
                  break;
                case TipoTratamento.fotossensivel:
                  textoBotao = "Fotossensível";
                  icone = Icons.wb_sunny;
                  break;
                case TipoTratamento.filtroAzul:
                  textoBotao = "Filtro de Luz Azul";
                  icone = Icons.lightbulb;
                  break;
                case TipoTratamento.camadas:
                  textoBotao = "Camadas";
                  icone = Icons.layers;
                  break;
                case TipoTratamento.comparativoEspessura: // NOVO
                  textoBotao = "Comparativo de Espessura";
                  icone = Icons.compare;
                  break;
                case TipoTratamento.nenhum:
                  break;
              }
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton.icon(
                  icon: Icon(icone, size: 24),
                  label: Text(textoBotao),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2956),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(300, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => setState(() => _tratamentoSelecionado = tratamento),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // --- BOTÃO VOLTAR (MANTIDO) ---
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

  // --- ÁREA DE SIMULAÇÃO ATUALIZADA ---
  Widget _buildAreaSimulacao() {
    switch (_tratamentoSelecionado) {
      case TipoTratamento.antirreflexo:
        return _buildAntirreflexo();
      case TipoTratamento.fotossensivel:
        return _buildFotossensivel();
      case TipoTratamento.filtroAzul:
        return _buildFiltroAzul();
      case TipoTratamento.camadas:
        return const CamadasLenteWidget();
      case TipoTratamento.comparativoEspessura: // NOVO
        return _buildComparativoEspessura();
      case TipoTratamento.nenhum:
        return const SizedBox.shrink();
    }
  }

  // --- WIDGETS EXISTENTES (MANTIDOS) ---
  Widget _buildAntirreflexo() {
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
      )
        );
  }

  Widget _buildFotossensivel() {
        return LayoutBuilder(builder: (context, constraints) {
          final darkeningStrength = (_posicaoLente - 0.5).clamp(0.0, 1.0) * 2 * 0.7;
      final Color currentLensTint = Color.lerp(Colors.transparent, Colors.black, darkeningStrength)!;

          return Stack(children: [
            Positioned.fill(child: Image.asset('assets/images/cenario_composto.jpg', fit: BoxFit.cover)),
            Positioned(
          left: _posicaoLente * (constraints.maxWidth - 150.0),
          top: (constraints.maxHeight - 150.0) / 2,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) => setState(() {
                  _posicaoLente += details.delta.dx / (constraints.maxWidth - 150.0);
                  _posicaoLente = _posicaoLente.clamp(0.0, 1.0);
                }),
                child: Stack(
                  children: [
                SvgPicture.asset('assets/images/lente_oculos.svg', width: 200, height: 200),
                    SvgPicture.asset(
                  'assets/images/lente_oculos_fs.svg',
                      width: 200,
                      height: 200,
                      colorFilter: ColorFilter.mode(currentLensTint, BlendMode.srcIn),
                    ),
                  ],
                ),
              ),
            ),
          ]);
        });
  }

  Widget _buildFiltroAzul() {
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
  }

  // --- NOVO WIDGET: COMPARATIVO DE ESPESSURA ---
  Widget _buildComparativoEspessura() {
    return Container(
      color: Colors.grey[200],
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Grau Esférico: ${_grauSelecionadoComparativo.toStringAsFixed(2)}', 
                          style: const TextStyle(fontSize: 18, color: Colors.black54)),
                      Slider(
                        value: _grauSelecionadoComparativo,
                        min: -10.0,
                        max: 10.0,
                        divisions: 80,
                        label: _grauSelecionadoComparativo.toStringAsFixed(2),
                        onChanged: (value) => setState(() => _grauSelecionadoComparativo = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildSideBySideLensView(_indiceEsquerda, (v) => setState(() => _indiceEsquerda = v))),
                        const VerticalDivider(width: 2, thickness: 2, color: Colors.black26),
                        Expanded(child: _buildSideBySideLensView(_indiceDireita, (v) => setState(() => _indiceDireita = v))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBotaoVoltar(),
        ],
      ),
    );
  }

  Widget _buildSideBySideLensView(double currentIndex, ValueChanged<double> onChanged) {
    double espessuraBorda = 0.1;
    double espessuraCentro = 0.1;
    double grauAbsolutoNormalizado = _grauSelecionadoComparativo.abs() / 10.0;
    
    if (_grauSelecionadoComparativo < 0) {
      espessuraBorda = 0.1 + (grauAbsolutoNormalizado * 0.9);
    } else {
      espessuraCentro = 0.1 + (grauAbsolutoNormalizado * 0.9);
    }

    double fatorReducao = pow(1.50 / currentIndex, _expoenteExagero).toDouble();
    espessuraBorda *= fatorReducao;
    espessuraCentro *= fatorReducao;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.center,
          children: _opcoesLentes.entries.map((entry) {
            final bool isSelected = entry.value == currentIndex;
            return OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected ? const Color(0xFF0A2956).withOpacity(0.1) : Colors.transparent,
                side: BorderSide(color: isSelected ? const Color(0xFF0A2956) : Colors.grey),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              onPressed: () => onChanged(entry.value),
              child: Text(entry.key, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 12, 
                    color: isSelected ? const Color(0xFF0A2956) : Colors.black54)),
            );
          }).toList(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: CustomPaint(
              size: Size.infinite, 
              painter: _LentePainter(
                espessuraBorda: espessuraBorda.clamp(0.05, 1.0),
                espessuraCentro: espessuraCentro.clamp(0.05, 1.0),
              ),
            ),
          ),
        ),
      ],
    );
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
                key: ValueKey(_tratamentoSelecionado),
                children: [_buildAreaSimulacao(), _buildBotaoVoltar()],
              ),
      ),
    );
  }
}

// --- CLASSE DO PAINTER (COPIADA DO ESPESSURA_LENTE) ---
class _LentePainter extends CustomPainter {
  final double espessuraBorda;
  final double espessuraCentro;
  _LentePainter({required this.espessuraBorda, required this.espessuraCentro});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [
          Colors.blue.shade300.withOpacity(0.4),
          Colors.blue.shade100.withOpacity(0.5),
          Colors.blue.shade300.withOpacity(0.4),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final double espessuraMinima = size.height * 0.02;
    final double alturaBorda = espessuraMinima + (size.height * 0.8 * espessuraBorda);
    final double alturaCentro = espessuraMinima + (size.height * 0.8 * espessuraCentro);
    
    final pTopoEsquerda = Offset(0, size.height / 2 - alturaBorda / 2);
    final pTopoDireita = Offset(size.width, size.height / 2 - alturaBorda / 2);
    final pControleTopo1 = Offset(size.width * 0.25, size.height / 2 - alturaCentro / 2);
    final pControleTopo2 = Offset(size.width * 0.75, size.height / 2 - alturaCentro / 2);

    final pBaixoDireita = Offset(size.width, size.height / 2 + alturaBorda / 2);
    final pBaixoEsquerda = Offset(0, size.height / 2 + alturaBorda / 2);
    final pControleBaixo1 = Offset(size.width * 0.75, size.height / 2 + alturaCentro / 2);
    final pControleBaixo2 = Offset(size.width * 0.25, size.height / 2 + alturaCentro / 2);

    path.moveTo(pTopoEsquerda.dx, pTopoEsquerda.dy);
    path.cubicTo(pControleTopo1.dx, pControleTopo1.dy, pControleTopo2.dx, pControleTopo2.dy, pTopoDireita.dx, pTopoDireita.dy);
    path.lineTo(pBaixoDireita.dx, pBaixoDireita.dy);
    path.cubicTo(pControleBaixo1.dx, pControleBaixo1.dy, pControleBaixo2.dx, pControleBaixo2.dy, pBaixoEsquerda.dx, pBaixoEsquerda.dy);
    path.close();

    final paintBorda = Paint()
      ..color = Colors.blue.shade700.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(path, paint);
    canvas.drawPath(path, paintBorda);
  }

  @override
  bool shouldRepaint(covariant _LentePainter oldDelegate) {
    return oldDelegate.espessuraBorda != espessuraBorda || oldDelegate.espessuraCentro != espessuraCentro;
  }
}

// --- WIDGET DE CAMADAS (MANTIDO) ---
class CamadasLenteWidget extends StatefulWidget {
  const CamadasLenteWidget({super.key});

  @override
  State<CamadasLenteWidget> createState() => _CamadasLenteWidgetState();
}

class _CamadasLenteWidgetState extends State<CamadasLenteWidget> {
  bool filtroAzul = false;
  bool antiReflexo = false;
  bool antiRisco = false;

  @override
  Widget build(BuildContext context) {
    final layers = [
      _LayerData(label: 'Lente Base', color: Colors.grey.shade400, isVisible: true, depth: 0, icon: Icons.remove_red_eye),
      _LayerData(label: 'Anti-Risco', color: Colors.green.shade600, isVisible: antiRisco, depth: 1, icon: Icons.security),
      _LayerData(label: 'Anti-Reflexo', color: Colors.purple.shade600, isVisible: antiReflexo, depth: 2, icon: Icons.flash_on),
      _LayerData(label: 'Filtro Azul', color: Colors.blue.shade600, isVisible: filtroAzul, depth: 3, icon: Icons.lightbulb_outline),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          Text('Camadas da Lente', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            children: [
              _buildToggleChip('Filtro Azul', filtroAzul, (v) => setState(() => filtroAzul = v), Colors.blue.shade700),
              _buildToggleChip('Anti-Reflexo', antiReflexo, (v) => setState(() => antiReflexo = v), Colors.purple.shade700),
              _buildToggleChip('Anti-Risco', antiRisco, (v) => setState(() => antiRisco = v), Colors.green.shade700),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 340,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: layers.map((layer) {
                final double yOffset = -layer.depth * 28.0;
                final double scale = 1 - layer.depth * 0.08;
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  top: 170 + yOffset,
                  child: Transform.scale(
                    scale: scale,
                    child: AnimatedOpacity(
                      opacity: layer.isVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: _LayerCard(data: layer),
                        ),
                      ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChip(String label, bool selected, ValueChanged<bool> onSelected, Color color) {
    return FilterChip(
      label: Text(label, style: TextStyle(color: selected ? Colors.white : color)),
      selected: selected,
      onSelected: onSelected,
      selectedColor: color,
      backgroundColor: color.withOpacity(0.2),
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _LayerData {
  final String label;
  final Color color;
  final bool isVisible;
  final int depth;
  final IconData icon;

  _LayerData({
    required this.label,
    required this.color,
    required this.isVisible,
    required this.depth,
    required this.icon,
  });
}

class _LayerCard extends StatelessWidget {
  final _LayerData data;
  const _LayerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 14,
      borderRadius: BorderRadius.circular(28),
      color: data.color,
      child: Container(
        width: 280,
        height: 190,
        padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
            colors: [data.color.withOpacity(0.95), data.color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Icon(data.icon, size: 52, color: Colors.white),
            const SizedBox(width: 26),
            Expanded(
              child: Text(data.label,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
        ),
      ),
    );
  }
}