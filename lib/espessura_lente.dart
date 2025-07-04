import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart';
import 'orcamento.dart';
import 'dart:math'; // Adicione este import no topo do arquivo (já está no seu código)

enum TelaEspessuraOpcao { menu, calculadora }
enum TipoLente { simples, multifocal }
enum TipoArmacao { acetato, metal, nylon, balgriff }
enum TipoAro {
  aroUso(1, 0.0),      // Código 1 - Sem adicional
  promocional(2, 50.0), // Código 2 - +R$50
  marcaPropria(3, 300.0); // Código 3 - +R$300

  final int codigo;  // Número que será exibido
  final double adicional;
  
  const TipoAro(this.codigo, this.adicional);

  // Método para buscar pelo código
  static TipoAro? fromCodigo(int codigo) {
    try {
      return values.firstWhere((e) => e.codigo == codigo);
    } catch (e) {
      return null;
    }
  }

  // Descrição para uso interno (não será exibida ao cliente)
  String get descricaoInterna {
    return switch(this) {
      aroUso => 'Aro Uso (Padrão)',
      promocional => 'Promocional (+R\$50)',
      marcaPropria => 'Marca Própria (+R\$300)',
    };
  }
}
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
    '1.56': 1.56,
    '1.59': 1.59,
    '1.61': 1.61,
    '1.67': 1.67,
    '1.74': 1.74,
  };
  final _esfericoController = TextEditingController();
  final _cilindricoController = TextEditingController();
  final _adicaoController = TextEditingController();
  TipoLente _tipoLenteSelecionada = TipoLente.simples;
  TipoArmacao _tipoArmacaoSelecionada = TipoArmacao.acetato;
  TipoAro _aroSelecionado = TipoAro.aroUso;

void _selecionarAro(TipoAro aro) {
    setState(() {
      _aroSelecionado = aro;
    });
  }

  @override
  void dispose() {
    _esfericoController.dispose();
    _cilindricoController.dispose();
    _adicaoController.dispose();
    super.dispose();
  }

  // --- FUNÇÃO ATUALIZADA PARA O NOVO FLUXO ---
  void _salvarEscolha() {
  FocusScope.of(context).unfocus();
  final esferico = double.tryParse(_esfericoController.text.replaceAll(',', '.'));
  if (esferico == null) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Por favor, insira um grau esférico válido.'),
      backgroundColor: Colors.red,
    ));
    return;
  }
  final cilindrico = double.tryParse(_cilindricoController.text.replaceAll(',', '.')) ?? 0.0;
  final adicao = _tipoLenteSelecionada == TipoLente.multifocal
      ? double.tryParse(_adicaoController.text.replaceAll(',', '.'))
      : null;

  final prescricao = PrescricaoTemporaria(
    esferico: esferico,
    cilindrico: cilindrico,
    adicao: adicao,
    tipoLente: _tipoLenteSelecionada,
    tipoArmacao: _tipoArmacaoSelecionada,
      tipoAro: _aroSelecionado,
  );

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
              shape: const CircleBorder(), 
              padding: const EdgeInsets.all(16),
              elevation: 8,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _opcaoSelecionada = TelaEspessuraOpcao.menu;
                _esfericoController.clear();
                _cilindricoController.clear();
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
            const Text('Espessura da Lente', 
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0A2956))),
            const SizedBox(height: 8),
            const Text('Escolha uma ferramenta de simulação', 
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.calculate),
              label: const Text('Calculadora de Indicação'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2956), 
                foregroundColor: Colors.white,
                minimumSize: const Size(300, 55), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () => setState(() => _opcaoSelecionada = TelaEspessuraOpcao.calculadora),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculadora() {
    return Container(
      color: Colors.grey[200],
      child: Stack(
        children: [
          SafeArea(
            child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: 450,
                    minHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildToggleButtons(
                      "Tipo de Lente",
                      _tipoLenteSelecionada,
                      TipoLente.values,
                      (TipoLente selection) => setState(() => _tipoLenteSelecionada = selection),
                    ),
                      const SizedBox(height: 24),
                      _buildSeletorAro(),
                    const SizedBox(height: 24),
                    _buildToggleButtons(
                      "Material da Armação",
                      _tipoArmacaoSelecionada,
                      TipoArmacao.values,
                      (TipoArmacao selection) => setState(() => _tipoArmacaoSelecionada = selection),
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        TextField(
                          controller: _esfericoController,
                          decoration: const InputDecoration(
                            labelText: 'Grau Esférico',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.-]'))],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _cilindricoController,
                          decoration: const InputDecoration(
                            labelText: 'Grau Cilíndrico',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            prefixText: '- ',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                        ),
                        if (_tipoLenteSelecionada == TipoLente.multifocal)
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              TextField(
                                controller: _adicaoController,
                                decoration: const InputDecoration(
                                  labelText: 'Adição',
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _salvarEscolha,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Salvar Escolha para Orçamento'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: _buildBotaoVoltar(),
        ),
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
            )).toList(),
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
      case TelaEspessuraOpcao.calculadora: 
        return _buildCalculadora();
      default: 
        return _buildMenuEspessura();
    }
  }

Widget _buildSeletorAro() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Tipo de Aro', 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: TipoAro.values.map((aro) {
          return ElevatedButton(
            onPressed: () => setState(() => _aroSelecionado = aro),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                _aroSelecionado == aro ? Colors.blue[700] : Colors.grey[300],
              ),
              minimumSize: MaterialStateProperty.all(const Size(60, 60)),
              shape: MaterialStateProperty.all(const CircleBorder()),
            ),
            child: Text(
              '${aro.codigo}',
              style: TextStyle(
                fontSize: 18,
                color: _aroSelecionado == aro ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
  }

}

