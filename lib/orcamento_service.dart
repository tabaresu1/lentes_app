import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import 'espessura_lente.dart';
import '/logica_indicacao/regra_indicacao.dart';
import 'desconto_service.dart';

class PrescricaoTemporaria {
  final double esferico;
  final double cilindrico;
  final double? adicao; // <- Aqui está a adição como opcional
  final TipoLente tipoLente;
  final TipoArmacao tipoArmacao;
  final TipoAro tipoAro; // <- Adicionando o tipo de aro

  PrescricaoTemporaria({
    required this.esferico,
    required this.cilindrico,
    this.adicao, // <- Aqui também
    required this.tipoLente,
    required this.tipoArmacao,
    required this.tipoAro, // <- E aqui
  });
}


class OpcaoLenteCalculada {
  final String descricao;
  final double precoOriginal;
  final double precoComDesconto;
  final double precoBase;
  final String? status;
  final CampoVisaoPercentagem? campoVisao;

  OpcaoLenteCalculada({
    required this.descricao,
    required this.precoOriginal,
    required this.precoComDesconto,
    required this.precoBase,
    this.status,
    this.campoVisao,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpcaoLenteCalculada &&
          descricao == other.descricao &&
          precoOriginal == other.precoOriginal &&
          precoComDesconto == other.precoComDesconto &&
          status == other.status &&
          campoVisao == other.campoVisao;

  @override
  int get hashCode => Object.hash(
      descricao, precoOriginal, precoComDesconto, status, campoVisao);
}

class OrcamentoItem {
  final String categoria;
  final String descricao;
  final double preco;
  final double precoOriginalItem;
  final double percentagemDescontoAplicada;
  final String tipoArmacao;
  final String tipoAro; // Novo campo
  final double esferico;
  final double cilindrico;
  final String tipoLente;

  OrcamentoItem({
    required this.categoria,
    required this.descricao,
    required this.preco,
    required this.precoOriginalItem,
    required this.percentagemDescontoAplicada,
    required this.tipoArmacao,
    required this.tipoAro,
    required this.esferico,
    required this.cilindrico,
    required this.tipoLente,
  });
}

class OrcamentoService with ChangeNotifier {
  PrescricaoTemporaria? _prescricaoTemp;
  final List<OrcamentoItem> _itensFinais = [];

  double _acrescimoMultiplier = 1.0;
  final Set<String> _codigosDescontoAplicados = {};
  double _descontoAplicado = 0.0;
  bool _isAcCodeSetForCurrentSession = false;

  String? _usuarioLogado;

  List<OrcamentoItem> get itensFinais => _itensFinais;
  bool get temPrescricaoPendente => _prescricaoTemp != null;
  double get descontoAplicado => _descontoAplicado;
  Set<String> get codigosDescontoAplicados =>
      Set<String>.from(_codigosDescontoAplicados);
  bool get isAcCodeSetForCurrentSession => _isAcCodeSetForCurrentSession;
  String? get usuarioLogado => _usuarioLogado;
  PrescricaoTemporaria? get prescricaoTemp => _prescricaoTemp;

  double get total => _itensFinais.isEmpty
      ? 0.0
      : _itensFinais.map((e) => e.preco).reduce((a, b) => a + b);

  // Setter adicionado
  set descontoAplicado(double valor) {
    _descontoAplicado = valor;
    notifyListeners();
  }

  void setAcrescimo(String codigoAC) {
    if (codigoAC.isEmpty) {
      _acrescimoMultiplier = 1.0;
      _isAcCodeSetForCurrentSession = false;
      return;
    }
    final valor = double.tryParse(codigoAC);
    if (valor != null && valor >= 100) {
      _acrescimoMultiplier = valor / 100.0;
      _isAcCodeSetForCurrentSession = true;
    } else {
      _acrescimoMultiplier = 1.0;
      _isAcCodeSetForCurrentSession = false;
    }
    notifyListeners();
  }

  ResultadoDesconto aplicarDesconto({
    required String codigo,
    required double descontoPercentual,
    required double precoOriginal,
    required double precoBase,
  }) {
    if (codigo.trim().isEmpty || descontoPercentual <= 0.0) {
      return ResultadoDesconto(
        valido: false,
        mensagem: 'Preencha a senha e o percentual de desconto.',
      );
    }

    if (descontoPercentual < 0.0 || descontoPercentual > 100.0) {
      return ResultadoDesconto(
        valido: false,
        mensagem: 'O percentual deve ser entre 1 e 100.',
      );
    }

    final precoMinimoPermitido = precoBase * 0.75;
    final precoComDesconto =
        precoOriginal * (1 - (descontoPercentual / 100.0));

    if (precoComDesconto < precoMinimoPermitido) {
      return ResultadoDesconto(
        valido: false,
        mensagem: 'Desconto não liberado pelo sistema.',
      );
    }

    final resultado = DescontoService.aplicarCodigo(
      codigo,
      0.0,
      {},
      percentualDigitado: descontoPercentual,
    );

    if (resultado.valido) {
      _descontoAplicado = resultado.percentagem;
    }

    notifyListeners();
    return resultado;
  }

  void aplicarDescontoPercentual(double percentual) {
    _descontoAplicado = percentual / 100.0;
    notifyListeners();
  }

  void salvarPrescricao(PrescricaoTemporaria prescricao) {
    _prescricaoTemp = prescricao;
    _isAcCodeSetForCurrentSession = false;
    _descontoAplicado = 0.0;
    notifyListeners();
  }

  List<OpcaoLenteCalculada> gerarOpcoesDaTabela() {
  if (_prescricaoTemp == null) return [];

  // CALCULA O GRAU EFETIVO (ESFÉRICO + ADIÇÃO PARA MULTIFOCAL POSITIVO)
  double grauEfetivo = _prescricaoTemp!.esferico;
  if (_prescricaoTemp!.tipoLente == TipoLente.multifocal && 
      _prescricaoTemp!.esferico > 0 &&
      _prescricaoTemp!.adicao != null) {
    grauEfetivo += _prescricaoTemp!.adicao!;
  }

  final regras = LogicaIndicacao.getIndicacoes(
    esferico: grauEfetivo,
    cilindrico: _prescricaoTemp!.cilindrico,
    tipoArmacao: _prescricaoTemp!.tipoArmacao,
    tipoLente: _prescricaoTemp!.tipoLente,
    adicao: _prescricaoTemp!.adicao ?? 0,
  );

  return regras.expand((regra) {
    return regra.precos.entries.map((entry) {
      if(kDebugMode){
        print('Preço base: ${entry.value} | '
            'Adicional aro: ${_prescricaoTemp!.tipoAro.adicional} | '
            'Total: ${entry.value + _prescricaoTemp!.tipoAro.adicional}');
      }
      // ADICIONE O ADICIONAL DO ARO AQUI
      final precoBase = entry.value + _prescricaoTemp!.tipoAro.adicional;
      
      final precoComAcrescimo = regra.status == 'nao_recomendado'
          ? precoBase
          : precoBase * _acrescimoMultiplier;

      final precoFinalComDesconto = precoComAcrescimo * (1 - _descontoAplicado);

      return OpcaoLenteCalculada(
        descricao: "${regra.lente} ${regra.observacao} | ${entry.key}",
        precoOriginal: precoComAcrescimo,
        precoComDesconto: precoFinalComDesconto,
        precoBase: precoBase,
        status: regra.status,
        campoVisao: regra.campoVisao,
      );
    });
  }).toList();
}

  Future<void> finalizarOrcamento(OpcaoLenteCalculada opcaoFinal) async {
    _itensFinais.clear();
    _itensFinais.add(OrcamentoItem(
      categoria: "Lente e Tratamentos",
      descricao: opcaoFinal.descricao,
      preco: opcaoFinal.precoComDesconto,
      precoOriginalItem: opcaoFinal.precoOriginal,
      percentagemDescontoAplicada: _descontoAplicado,
      tipoArmacao: _prescricaoTemp?.tipoArmacao.name ?? '',
    tipoAro: _prescricaoTemp?.tipoAro.descricaoInterna ?? '', // Novo campo
      esferico: _prescricaoTemp?.esferico ?? 0.0,
      cilindrico: _prescricaoTemp?.cilindrico ?? 0.0,
      tipoLente: _prescricaoTemp?.tipoLente.name ?? '',
    ));

    // Salva localmente SEMPRE
    final box = Hive.box('orcamentos_offline');
    final orcamentoMap = {
      'itens': _itensFinais.map((item) => {
        'categoria': item.categoria,
        'descricao': item.descricao,
        'preco': arredondar2(item.preco),
        'precoOriginalItem': arredondar2(item.precoOriginalItem),
        'percentagemDescontoAplicada': arredondar2(item.percentagemDescontoAplicada),
        'tipoArmacao': item.tipoArmacao,
        'esferico': item.esferico,
        'cilindrico': item.cilindrico,
        'tipoLente': item.tipoLente,
      }).toList(),
      'acUtilizado': _acrescimoMultiplier,
      'data': DateTime.now().toIso8601String(),
      'total': arredondar2(total),
      'descontoTotal': arredondar2(_descontoAplicado),
      'tipoLenteResumo': _prescricaoTemp?.tipoLente.name ?? '',
      'esferico': _prescricaoTemp?.esferico,
      'cilindrico': _prescricaoTemp?.cilindrico,
      'tipoArmacaoResumo': _prescricaoTemp?.tipoArmacao.name,
      'sincronizado': false,
      'usuario': _usuarioLogado,
    };
    await box.add(orcamentoMap);

    // Tenta salvar no Firestore, mas não trava se falhar
    if (_usuarioLogado != null && _usuarioLogado!.isNotEmpty) {
      try {
        final docRef = FirebaseFirestore.instance
            .collection('usuarios_orcamentos')
            .doc(_usuarioLogado);

        await docRef.collection('orcamentos').add({
          ...orcamentoMap,
          'data': FieldValue.serverTimestamp(),
        });

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final docSnapshot = await transaction.get(docRef);
          final double valorOrcamento = opcaoFinal.precoComDesconto;

          if (docSnapshot.exists) {
            final data = docSnapshot.data()!;
            final totalAnterior = (data['total_orcamentos'] ?? 0) as int;
            final valorAnterior = (data['valor_total'] ?? 0.0) as num;

            transaction.update(docRef, {
              'total_orcamentos': totalAnterior + 1,
              'valor_total': arredondar2(valorAnterior + valorOrcamento),
            });
          } else {
            transaction.set(docRef, {
              'total_orcamentos': 1,
              'valor_total': arredondar2(valorOrcamento),
            });
          }
        });

        // Se salvar no Firestore, marque como sincronizado no Hive
        orcamentoMap['sincronizado'] = true;
        await box.putAt(box.values.length - 1, orcamentoMap);

      } catch (e) {
        // Se falhar, apenas mantenha como não sincronizado
        if (kDebugMode) print('Firestore indisponível, orçamento salvo offline.');
      }
    }

    _prescricaoTemp = null; // <- ESSENCIAL!
    _descontoAplicado = 0.0;
    _codigosDescontoAplicados.clear();
    notifyListeners(); // <- ESSENCIAL!
  }

  void limparOrcamento() {
    _itensFinais.clear();
    _prescricaoTemp = null;
    _descontoAplicado = 0.0;
    _codigosDescontoAplicados.clear();
    notifyListeners();
  }

  void setUsuarioLogado(String username) {
    _usuarioLogado = username;
    notifyListeners();
  }

  void resetarDesconto() {
    _descontoAplicado = 0.0;
    notifyListeners();
  }

  Future<void> calcularMediaOrcamento(String usuario) async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios_orcamentos')
        .doc(usuario)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      final total = (data['total_orcamentos'] ?? 0) as int;
      final valor = (data['valor_total'] ?? 0.0) as num;
      final media = total > 0 ? valor / total : 0.0;
      print('Valor médio: R\$ ${media.toStringAsFixed(2)}');
    }
  }

  Future<void> sincronizarOrcamentosPendentes() async {
    final box = Hive.box('orcamentos_offline');
    final orcamentos = box.values.toList();

    for (int i = 0; i < orcamentos.length; i++) {
      final orcamento = Map<String, dynamic>.from(orcamentos[i]);
      if (orcamento['sincronizado'] == true) continue;
      final usuario = orcamento['usuario'];
      if (usuario == null || usuario.isEmpty) continue;

      try {
        final docRef = FirebaseFirestore.instance
            .collection('usuarios_orcamentos')
            .doc(usuario);

        await docRef.collection('orcamentos').add({
          ...orcamento,
          'data': FieldValue.serverTimestamp(),
        });

        // Atualiza como sincronizado
        orcamento['sincronizado'] = true;
        await box.putAt(i, orcamento);
      } catch (e) {
        // Se falhar, tenta novamente depois
        if (kDebugMode) print('Falha ao sincronizar orçamento offline: $e');
      }
    }
  }
}

// Para salvar um orçamento offline:
Future<void> salvarOrcamentoOffline(Map<String, dynamic> orcamento) async {
  final box = Hive.box('orcamentos_offline');
  await box.add(orcamento);
}

// Para ler todos os orçamentos offline:
List<Map> listarOrcamentosOffline() {
  final box = Hive.box('orcamentos_offline');
  return box.values.cast<Map>().toList();
}

double arredondar2(double valor) =>
    double.parse(valor.toStringAsFixed(2));
