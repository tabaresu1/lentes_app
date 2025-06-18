import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart';
import 'desconto_service.dart'; // Importa o ResultadoDesconto
import 'pdf_generator.dart'; // Importa o SEU gerador de PDF

class TelaOrcamento extends StatefulWidget {
  const TelaOrcamento({Key? key}) : super(key: key);

  @override
  State<TelaOrcamento> createState() => _TelaOrcamentoState();
}

class _TelaOrcamentoState extends State<TelaOrcamento> {
  OpcaoLenteCalculada? _opcaoSelecionada;
  final TextEditingController _descontoCodigoController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Limpa a seleção sempre que a tela for reconstruída com novas opções
    _opcaoSelecionada = null;
  }

  @override
  void dispose() {
    _descontoCodigoController.dispose();
    super.dispose();
  }

  // Função para exibir o SnackBar com a mensagem de desconto
  void _showDescontoFeedback(ResultadoDesconto resultado) {
    Color backgroundColor;
    if (resultado.valido) {
      backgroundColor = Colors.green; // Sucesso na aplicação do desconto
    } else if (resultado.codigoJaAplicado) {
      backgroundColor = Colors.orange; // Código já aplicado (aviso)
    } else {
      backgroundColor = Colors.red; // Código inválido (erro)
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
        title: Text(orcamentoService.temPrescricaoPendente ? 'Selecione a Opção' : 'Orçamento Final', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0A2956),
      ),
      // Adiciona SingleChildScrollView para evitar overflow do teclado
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

  // ETAPA 1: TELA DE SELEÇÃO DE OPÇÕES
  Widget _buildTelaDeSelecao(OrcamentoService orcamentoService) {
    final opcoes = orcamentoService.gerarOpcoesDaTabela();
    final recomendadas = opcoes.where((o) => o.status != 'nao_recomendado').toList();
    final naoRecomendadas = opcoes.where((o) => o.status == 'nao_recomendado').toList();

    return Column(
      children: [
        const Text(
          'Com base na receita, estas são as suas opções:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Campo para o código de desconto
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _descontoCodigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código de Desconto',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final resultado = orcamentoService.aplicarDesconto(_descontoCodigoController.text);
                  _showDescontoFeedback(resultado);
                  // O notifyListeners() em OrcamentoService já vai reconstruir a lista
                  _descontoCodigoController.clear(); // Limpa o campo após aplicar
                },
                child: const Text('Aplicar Desconto'),
              ),
            ],
          ),
        ),
        // Exibe os códigos de desconto já aplicados
        if (orcamentoService.codigosDescontoAplicados.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft, // Alinha os chips à esquerda
              child: Wrap(
                spacing: 8.0, // espaçamento horizontal
                runSpacing: 4.0, // espaçamento vertical
                children: orcamentoService.codigosDescontoAplicados.map((codigo) => Chip(
                  label: Text(codigo),
                  backgroundColor: Colors.blue.shade100, // Um pouco de cor para o chip
                  labelStyle: const TextStyle(color: Colors.blueGrey),
                  // Opcional: permitir remover um desconto aplicado (descomente o método em orcamento_service.dart também)
                  /*
                  onDeleted: () {
                    orcamentoService.removerDesconto(codigo);
                    _showDescontoFeedback(ResultadoDesconto(valido: true, mensagem: 'Desconto $codigo removido!', codigoJaAplicado: false));
                  },
                  deleteIcon: const Icon(Icons.cancel, size: 18),
                  */
                )).toList(),
              ),
            ),
          ),
        const SizedBox(height: 16),
        Column(
          children: [
            if (recomendadas.isEmpty && naoRecomendadas.isEmpty)
              const Center(child: Text("Nenhuma regra encontrada para esta prescrição."))
            else
              ...recomendadas.map((opcao) {
                final bool isAtencao = opcao.status == 'atencao';
                final bool temDesconto = opcao.precoOriginal != opcao.precoComDesconto;
                return Card(
                  color: _opcaoSelecionada == opcao ? Colors.blue.shade50 : (isAtencao ? Colors.yellow.shade50 : null),
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
              
            if (naoRecomendadas.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                child: Text("Opções Não Recomendadas:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ),
              ...naoRecomendadas.map((opcao) => Card(
                color: Colors.red.shade50,
                child: ListTile(
                  enabled: false,
                  leading: const Icon(Icons.error_outline, color: Colors.red),
                  title: Text(
                    opcao.descricao,
                    style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, decoration: TextDecoration.lineThrough),
                  ),
                ),
              )).toList(),
            ],
            const SizedBox(height: 20),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            child: const Text('Confirmar e Adicionar ao Orçamento'),
            onPressed: _opcaoSelecionada == null ? null : () {
              context.read<OrcamentoService>().finalizarOrcamento(_opcaoSelecionada!);
              _opcaoSelecionada = null;
            },
          ),
        )
      ],
    );
  }

  // ETAPA 2: TELA DE RESUMO FINAL
  Widget _buildTelaDeResumo(OrcamentoService orcamentoService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (orcamentoService.itensFinais.isEmpty)
              const Center(child: Text('Orçamento vazio. Calcule uma indicação para começar.'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orcamentoService.itensFinais.length,
                itemBuilder: (context, index) {
                  final item = orcamentoService.itensFinais[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.categoria, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      subtitle: Text(item.descricao, style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text('R\$ ${item.preco.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
          ],
        ),
        const Divider(thickness: 2),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('R\$ ${orcamentoService.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
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
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red), padding: const EdgeInsets.symmetric(vertical: 16)),
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
                    // Chama a sua própria função de geração de PDF
                    await PdfGenerator.generateAndSharePdf(orcamentoService);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao gerar/partilhar PDF: ${e.toString()}'),
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
