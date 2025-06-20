import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart';
import 'desconto_service.dart'; // Importa o ResultadoDesconto
import 'pdf_generator.dart'; // Importa o SEU gerador de PDF
import 'espessura_lente.dart'; // Importa CampoVisaoPercentagem

class TelaOrcamento extends StatefulWidget {
  const TelaOrcamento({Key? key}) : super(key: key);

  @override
  State<TelaOrcamento> createState() => _TelaOrcamentoState();
}

class _TelaOrcamentoState extends State<TelaOrcamento> {
  OpcaoLenteCalculada? _opcaoSelecionada;
  final TextEditingController _descontoCodigoController = TextEditingController();

  // Mapeamento para agrupar opções por CampoVisaoPercentagem
  Map<CampoVisaoPercentagem, List<OpcaoLenteCalculada>> _opcoesMultifocalAgrupadas = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Limpa a seleção sempre que a tela for reconstruída com novas opções
    _opcaoSelecionada = null;
    _agruparOpcoes();
  }

  @override
  void dispose() {
    _descontoCodigoController.dispose();
    super.dispose();
  }

  // Função para agrupar as opções de multifocal
  void _agruparOpcoes() {
    final orcamentoService = context.read<OrcamentoService>();
    final todasAsOpcoes = orcamentoService.gerarOpcoesDaTabela();
    
    // Limpa o mapa a cada nova geração
    _opcoesMultifocalAgrupadas = {}; 

    for (var opcao in todasAsOpcoes) {
      if (opcao.campoVisao != null) {
        // Se for multifocal com campo de visão, agrupa
        _opcoesMultifocalAgrupadas.putIfAbsent(opcao.campoVisao!, () => []).add(opcao);
      } else {
        // Se for lente simples ou não recomendado, trata separadamente
        // Para simplificar, as não recomendadas e simples podem ir para uma chave específica
        // Ou você pode ter uma lista separada para 'simples'
        // NOTA: Para um tratamento mais robusto, as opções simples e não recomendadas
        // poderiam ter seus próprios agrupamentos ou serem exibidas diretamente.
        // Por ora, as não recomendadas serão filtradas e exibidas no final.
        // As simples ainda serão geradas como opções normais, sem campoVisao,
        // mas aparecerão sem agrupamento no ExpansionTile se o _agruparOpcoes não as tratar.
        // O código atual irá colocá-las em um ExpansionTile 'default' se for adicionado.
        // Para este exemplo, apenas os campos de visão específicos de multifocal serão agrupados.
        // As opções sem campoVisao (simples) serão exibidas normalmente no final da lista,
        // mas não dentro de um ExpansionTile, o que está de acordo com o pedido de agrupar APENAS multifocais.
      }
    }
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
    _agruparOpcoes(); // Reagrupa as opções sempre que o widget é reconstruído (mudanças no estado)


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
    // Agora _opcoesMultifocalAgrupadas já está preenchida via _agruparOpcoes()
    // Separamos as opções "não recomendadas" e as "simples" para exibição diferenciada
    List<OpcaoLenteCalculada> naoRecomendadas = [];
    List<OpcaoLenteCalculada> simplesOpcoes = [];

    final todasAsOpcoesDoServico = orcamentoService.gerarOpcoesDaTabela();
    for (var opcao in todasAsOpcoesDoServico) {
      if (opcao.status == 'nao_recomendado') {
        naoRecomendadas.add(opcao);
      } else if (opcao.campoVisao == null) { // Lentes que não são multifocais ou não têm campo de visão
        simplesOpcoes.add(opcao);
      }
    }

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
                  _descontoCodigoController.clear(); // Limpa o campo após aplicar
                  _agruparOpcoes(); // Reagrupa as opções após aplicar desconto, caso os preços mudem
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
                )).toList(),
              ),
            ),
          ),
        const SizedBox(height: 16),
        // NOVO: Exibição agrupada por Campo de Visão para multifocais
        if (_opcoesMultifocalAgrupadas.isNotEmpty && _opcoesMultifocalAgrupadas.keys.any((key) => key != null))
          ..._opcoesMultifocalAgrupadas.entries.where((entry) => entry.key != null).map((entry) {
            final campoVisao = entry.key!; // Campo de Visão daquele grupo
            final opcoesDesseCampo = entry.value;

            final opcoesValidas = opcoesDesseCampo.where((o) => o.status != 'nao_recomendado').toList();
            
            if (opcoesValidas.isEmpty) return const SizedBox.shrink();

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ExpansionTile(
                title: Text(
                  'Campo de Visão ${_campoVisaoToString(campoVisao)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                children: opcoesValidas.map((opcao) {
                  final bool isAtencao = opcao.status == 'atencao';
                  final bool temDesconto = opcao.precoOriginal != opcao.precoComDesconto;
                  return ListTile(
                    onTap: () => setState(() => _opcaoSelecionada = opcao),
                    leading: isAtencao
                        ? const Icon(Icons.warning_amber_rounded, color: Colors.orange)
                        : Radio<OpcaoLenteCalculada>(
                              value: opcao,
                              groupValue: _opcaoSelecionada, // Agora compara por valor
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
                  );
                }).toList(),
              ),
            );
          }).toList(),
        
        // Seção para opções simples (não multifocais)
        if (simplesOpcoes.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
            child: Text("Opções de Lentes Simples:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
          ),
          ...simplesOpcoes.map((opcao) {
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
        ],

        // Seção para opções não recomendadas (exibidas no final, fora dos ExpansionTiles)
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

  // Helper para converter CampoVisaoPercentagem para string legível (duplicado do LogicaIndicacao, pode ser movido para um utilitário)
  String _campoVisaoToString(CampoVisaoPercentagem campo) {
    return campo.toString().split('.').last.substring(1) + '%';
  }
}
