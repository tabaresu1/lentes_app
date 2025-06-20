import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart';
import 'orcamento.dart';

// Enums e classe LentePainter permanecem os mesmos...
enum TelaEspessuraOpcao { menu, calculadora, comparativo }
enum TipoLente { simples, multifocal }
enum TipoArmacao { acetato, metal, nylon, balgriff }

// NOVOS ENUMS PARA LENTES MULTIFOCAIS
enum MaterialLenteMultifocal {
  l156, // Lente 1.56
  l160, // Lente 1.60
  l167, // Lente 1.67
  l174, // Lente 1.74
  poli, // Policarbonato
}

enum CampoVisaoPercentagem {
  p40, // 40%
  p50, // 50%
  p67, // 67%
  p80, // 80%
  p87, // 87%
  p98, // 98%
}

// Os tratamentos são os mesmos do simples, mas pode-se ter um enum separado se houver distinções futuras
enum TipoTratamentoMultifocal {
  incolor2Camadas, // INCOLOR 2 CAMADAS
  ar7Camadas,      // AR 7 CAMADAS
  blue15Camadas,   // BLUE 15 CAMADAS
  blue25Camadas,   // BLUE 25 CAMADAS
  photo,           // PHOTO
  transition,      // TRANSITION
}

class TelaEspessura extends StatefulWidget {
  const TelaEspessura({super.key});
  @override
  State<TelaEspessura> createState() => _TelaEspessuraState();
}

class _TelaEspessuraState extends State<TelaEspessura> {
  TelaEspessuraOpcao _opcaoSelecionada = TelaEspessuraOpcao.menu;
  double _grauSelecionadoComparativo = -4.0;
  double _indiceEsquerda = 1.50;
  double _indiceDireita = 1.67;
  final Map<String, double> _opcoesLentes = {
    '1.50': 1.50, '1.59': 1.59, '1.67': 1.67, '1.74': 1.74,
  };
  final _esfericoController = TextEditingController();
  final _cilindricoController = TextEditingController();
  final _eixoController = TextEditingController();
  TipoLente _tipoLenteSelecionada = TipoLente.simples;
  TipoArmacao _tipoArmacaoSelecionada = TipoArmacao.acetato;

  @override
  void dispose() {
    _esfericoController.dispose();
    _cilindricoController.dispose();
    _eixoController.dispose();
    super.dispose();
  }

  // --- FUNÇÃO ATUALIZADA PARA O NOVO FLUXO ---
  void _salvarEscolha() {
    FocusScope.of(context).unfocus();
    final esferico = double.tryParse(_esfericoController.text);
    if (esferico == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, insira um grau esférico válido.'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    final cilindrico = double.tryParse(_cilindricoController.text) ?? 0.0;
    
    final prescricao = PrescricaoTemporaria(
      esferico: esferico,
      cilindrico: cilindrico,
      tipoLente: _tipoLenteSelecionada,
      tipoArmacao: _tipoArmacaoSelecionada,
    );
    // Apenas salva os dados no serviço e mostra a confirmação. Não navega.
    context.read<OrcamentoService>().salvarPrescricao(prescricao);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Dados da receita salvos!'),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));
  }
  
  // --- WIDGETS DE MENU E NAVEGAÇÃO ---
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
              shape: const CircleBorder(), padding: const EdgeInsets.all(16),
              elevation: 8,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _opcaoSelecionada = TelaEspessuraOpcao.menu;
                _esfericoController.clear();
                _cilindricoController.clear();
                _eixoController.clear();
              });
            },
            child: const Icon(Icons.arrow_back, size: 32),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuEspessura() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Espessura da Lente', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0A2956))),
            const SizedBox(height: 8),
            const Text('Escolha uma ferramenta de simulação', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.calculate),
              label: const Text('Calculadora de Indicação'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2956), foregroundColor: Colors.white,
                minimumSize: const Size(300, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () => setState(() => _opcaoSelecionada = TelaEspessuraOpcao.calculadora),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.compare_arrows),
              label: const Text('Comparativo Visual'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2956),foregroundColor: Colors.white,
                minimumSize: const Size(300, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () => setState(() => _opcaoSelecionada = TelaEspessuraOpcao.comparativo),
            ),
          ],
        ),
      ),
    );
  }

  // --- COMPARATIVO VISUAL ---
  Widget _buildComparativo() {
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
                      Text('Grau Esférico: ${_grauSelecionadoComparativo.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, color: Colors.black54)),
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
    double fatorReducao = 1.50 / currentIndex;
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
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => onChanged(entry.value),
              child: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isSelected ? const Color(0xFF0A2956) : Colors.black54)),
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

  // --- CALCULADORA ---
  Widget _buildCalculadora() {
    return Container(
      color: Colors.grey[200],
      child: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    _buildToggleButtons("Tipo de Lente", _tipoLenteSelecionada, TipoLente.values, (TipoLente selection) => setState(() => _tipoLenteSelecionada = selection)),
                    const SizedBox(height: 16),
                    _buildToggleButtons("Material da Armação", _tipoArmacaoSelecionada, TipoArmacao.values, (TipoArmacao selection) => setState(() => _tipoArmacaoSelecionada = selection)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 450,
                      child: Column(
                        children: [
                          TextField(controller: _esfericoController, decoration: const InputDecoration(labelText: 'Grau Esférico', border: OutlineInputBorder()), keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.-]'))]),
                          const SizedBox(height: 16),
                          TextField(controller: _cilindricoController, decoration: const InputDecoration(labelText: 'Grau Cilíndrico', border: OutlineInputBorder(), prefixText: '- '), keyboardType: const TextInputType.numberWithOptions(decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))]),
                          const SizedBox(height: 16),
                          TextField(controller: _eixoController, decoration: const InputDecoration(labelText: 'Eixo', border: OutlineInputBorder()), keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _salvarEscolha,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                      ),
                      child: const Text('Salvar Escolha para Orçamento')
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBotaoVoltar(),
        ],
      ),
    );
  }

  Widget _buildToggleButtons<T>(String title, T selection, List<T> values, ValueChanged<T> onSelection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleButtons(
            isSelected: values.map((v) => v == selection).toList(),
            onPressed: (index) => onSelection(values[index]),
            borderRadius: BorderRadius.circular(8.0),
            selectedBorderColor: Colors.blue[700],
            selectedColor: Colors.white,
            fillColor: Colors.blue[200],
            color: Colors.blue[700],
            constraints: const BoxConstraints(minHeight: 40.0),
            children: values.map((v) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(v.toString().split('.').last.toUpperCase()),
            )).toList(), // O .toList() estava fora do parêntese do Padding.
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: _buildTelaAtual(),
      ),
    );
  }

  Widget _buildTelaAtual() {
    switch (_opcaoSelecionada) {
      case TelaEspessuraOpcao.calculadora: return _buildCalculadora();
      case TelaEspessuraOpcao.comparativo: return _buildComparativo();
      default: return _buildMenuEspessura();
    }
  }
}

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
