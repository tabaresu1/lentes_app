import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart';
import 'desconto_service.dart';
import 'espessura_lente.dart';
import 'pdf_generator.dart';

// Importe o modelo se necessário
// import 'modelos/opcao_lente_calculada.dart';

class TelaOrcamento extends StatefulWidget {
  const TelaOrcamento({super.key});

  @override
  State<TelaOrcamento> createState() => _TelaOrcamentoState();
}

class _TelaOrcamentoState extends State<TelaOrcamento> {
  final _descontoCodigoController = TextEditingController();
  final _descontoPercentualController = TextEditingController();
  OpcaoLenteCalculada? _opcaoSelecionada;
  String? _tratamentoSelecionado;
  bool _descontoResetado = false;
  bool _finalizado = false;

  @override
  void dispose() {
    _descontoCodigoController.dispose();
    _descontoPercentualController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_descontoResetado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<OrcamentoService>().resetarDesconto();
        }
      });
      _descontoResetado = true;
    }
    _opcaoSelecionada = null;
    _tratamentoSelecionado = null;
  }

  void _showDescontoFeedback(ResultadoDesconto resultado) {
    Color backgroundColor;
    if (resultado.valido) {
      backgroundColor = Colors.green;
    } else if (resultado.codigoJaAplicado) {
      backgroundColor = Colors.orange;
    } else {
      backgroundColor = Colors.red;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resultado.mensagem),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orcamentoService = context.watch<OrcamentoService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          orcamentoService.temPrescricaoPendente
              ? 'Selecione a Opção'
              : 'Orçamento Final',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A2956),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: orcamentoService.temPrescricaoPendente
              ? _buildTelaDeSelecao(orcamentoService)
              : _buildTelaDeResumo(orcamentoService),
        ),
      ),
    );
  }

  Widget _buildTelaDeSelecao(OrcamentoService orcamento) {
    final opcoes = orcamento.gerarOpcoesDaTabela();
    final opcoesMultifocais = opcoes
        .where((op) => op.descricao.toLowerCase().contains('multifocal') && op.status != 'nao_recomendado')
        .toList();
    final opcoesSimples = opcoes
        .where((op) => !op.descricao.toLowerCase().contains('multifocal') && op.status != 'nao_recomendado')
        .toList();

    // Tratamentos disponíveis nas multifocais
    final tratamentosMultifocais = opcoesMultifocais
        .map((op) => op.descricao.split('|').last.trim())
        .toSet()
        .toList();

    // Garante que o tratamento selecionado sempre exista na lista
    if (tratamentosMultifocais.isNotEmpty &&
        (_tratamentoSelecionado == null || !tratamentosMultifocais.contains(_tratamentoSelecionado))) {
      _tratamentoSelecionado = tratamentosMultifocais.first;
    }

    final descontoAplicado = orcamento.descontoAplicado * 100;
    final opcao = _opcaoSelecionada ?? (opcoes.isNotEmpty ? opcoes.first : null);
    if (opcao == null) return const SizedBox.shrink(); // Se não houver opções, não faz nada
    final precoOriginal = opcao.precoOriginal;
    final precoBase = opcao.precoBase;
    final precoComDesconto = precoOriginal * (1 - (orcamento.descontoAplicado));
    final corDesconto = precoComDesconto < precoBase ? Colors.red : Colors.blue;

    return Column(
      children: [
        // Campo para senha e percentual de desconto
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _descontoCodigoController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _descontoPercentualController,
                decoration: const InputDecoration(
                  labelText: '%',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_opcaoSelecionada == null) return;
                final percentual = double.tryParse(_descontoPercentualController.text) ?? 0.0;
                final precoMinimoPermitido = precoBase * 0.75;
                final precoComDescontoNovo = precoOriginal * (1 - (percentual / 100.0));
                if (precoComDescontoNovo < precoMinimoPermitido) {
                  _showDescontoFeedback(ResultadoDesconto(
                    valido: false,
                    mensagem: 'Sistema não liberou este desconto (limite de 25% abaixo do valor de tabela).',
                  ));
                  return;
                }
                final resultado = orcamento.aplicarDesconto(
                  codigo: _descontoCodigoController.text,
                  descontoPercentual: percentual,
                  precoOriginal: precoOriginal,
                  precoBase: precoBase,
                );
                _showDescontoFeedback(resultado);
                if (resultado.valido) {
                  _descontoCodigoController.clear();
                  _descontoPercentualController.clear();
                  setState(() {});
                }
              },
              child: const Text('Aplicar'),
            ),
          ],
        ),
        // Caixa de desconto já aplicado
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: descontoAplicado > 0 ? corDesconto : Colors.grey,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Desconto já aplicado:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${descontoAplicado.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: corDesconto,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // MULTIFOCAIS COM DROPDOWN DE TRATAMENTO
        if (opcoesMultifocais.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Text('Selecione o tratamento para orçar:', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DropdownButton<String>(
            value: _tratamentoSelecionado,
            items: tratamentosMultifocais.map((trat) => DropdownMenuItem(
              value: trat,
              child: Text(trat),
            )).toList(),
            onChanged: (value) {
              setState(() {
                _tratamentoSelecionado = value;
                _opcaoSelecionada = null;
              });
            },
          ),
          ...opcoesMultifocais
              .where((op) => op.descricao.split('|').last.trim() == (_tratamentoSelecionado ?? ''))
              .map((opcao) {
                final bool isAtencao = opcao.status == 'atencao';
                final bool temDesconto = opcao.precoOriginal != opcao.precoComDesconto;
                return Card(
                  color: opcao.status == 'nao_recomendado'
                      ? Colors.red.shade50
                      : opcao.status == 'atencao'
                          ? Colors.yellow.shade50
                          : Colors.green.shade50,
                  child: ListTile(
                    onTap: () => setState(() => _opcaoSelecionada = opcao),
                    leading: isAtencao
                        ? const Icon(Icons.warning_amber_rounded, color: Colors.orange)
                        : Radio<OpcaoLenteCalculada>(
                              value: opcao,
                              groupValue: _opcaoSelecionada,
                              onChanged: (value) => setState(() => _opcaoSelecionada = value),
                            ),
                    title: Text(opcao.descricao, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (temDesconto)
                          Text(
                            'R\$ ${opcao.precoOriginal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        Text(
                          'R\$ ${opcao.precoComDesconto.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: temDesconto ? Colors.green : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ],

        // SIMPLES
        if (opcoesSimples.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
            child: Text("Opções de Lentes Simples:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
          ),
          ...opcoesSimples.map((opcao) {
            final bool isAtencao = opcao.status == 'atencao';
            final bool temDesconto = opcao.precoOriginal != opcao.precoComDesconto;
            return Card(
              color: opcao.status == 'nao_recomendado'
                  ? Colors.red.shade50
                  : opcao.status == 'atencao'
                      ? Colors.yellow.shade50
                      : Colors.green.shade50,
              child: ListTile(
                onTap: () => setState(() => _opcaoSelecionada = opcao),
                leading: isAtencao
                    ? const Icon(Icons.warning_amber_rounded, color: Colors.orange)
                    : Radio<OpcaoLenteCalculada>(
                          value: opcao,
                          groupValue: _opcaoSelecionada,
                          onChanged: (value) => setState(() => _opcaoSelecionada = value),
                        ),
                title: Text(opcao.descricao, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (temDesconto)
                      Text(
                        'R\$ ${opcao.precoOriginal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    Text(
                      'R\$ ${opcao.precoComDesconto.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: temDesconto ? Colors.green : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],

        // NÃO RECOMENDADAS
        if (opcoes.where((op) => op.status == 'nao_recomendado').isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
            child: Text("Opções Não Recomendadas:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          ),
          ...opcoes.where((op) => op.status == 'nao_recomendado').map((opcao) => Card(
            color: Colors.red.shade50,
            child: ListTile(
              enabled: false,
              leading: const Icon(Icons.error_outline, color: Colors.red),
              title: Text(
                opcao.descricao,
                style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, decoration: TextDecoration.lineThrough),
              ),
              trailing: Text(
                'R\$ ${opcao.precoBase.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          )),
        ],
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            child: const Text('Confirmar e Adicionar ao Orçamento'),
            onPressed: _opcaoSelecionada == null
                ? null
                : () async {
                    await context.read<OrcamentoService>().finalizarOrcamento(_opcaoSelecionada!);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Orçamento finalizado e salvo!')),
                      );
                    }
                    setState(() {
                      _opcaoSelecionada = null;
                    });
                  },
          ),
        )
      ],
    );
  }

  Widget _buildTelaDeResumo(OrcamentoService orcamento) {
    final itens = orcamento.itensFinais;
    final total = orcamento.total;

    if (itens.isEmpty) {
      return const Center(child: Text('Orçamento vazio. Calcule uma indicação para começar.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itens.length,
          itemBuilder: (context, index) {
            final item = itens[index];
            return Card(
              child: ListTile(
                title: Text(item.categoria, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                subtitle: Text(item.descricao, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text('R\$ ${item.preco.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            );
          },
        ),
        const Divider(thickness: 2),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('R\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Limpar'),
                onPressed: () => context.read<OrcamentoService>().limparOrcamento(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Gerar e Partilhar'),
                onPressed: () async {
                  try {
                    await PdfGenerator.generateAndSharePdf(orcamento);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao gerar/partilhar PDF: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ),
          ],
        )
      ],
    );
  }
}
