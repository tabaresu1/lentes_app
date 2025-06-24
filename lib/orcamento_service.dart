import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'espessura_lente.dart';
import 'logica_indicacao.dart';
import 'desconto_service.dart';

class PrescricaoTemporaria {
  final double esferico;
  final double cilindrico;
  final TipoLente tipoLente;
  final TipoArmacao tipoArmacao;

  PrescricaoTemporaria({
    required this.esferico,
    required this.cilindrico,
    required this.tipoLente,
    required this.tipoArmacao,
  });
}

class OpcaoLenteCalculada {
  final String descricao;
  final double precoOriginal;
  final double precoComDesconto;
  final String? status;
  final CampoVisaoPercentagem? campoVisao;

  OpcaoLenteCalculada({
    required this.descricao,
    required this.precoOriginal,
    required this.precoComDesconto,
    this.status,
    this.campoVisao,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is OpcaoLenteCalculada &&
        other.descricao == descricao &&
        other.precoOriginal == precoOriginal &&
        other.precoComDesconto == precoComDesconto &&
        other.status == status &&
        other.campoVisao == campoVisao;
  }

  @override
  int get hashCode =>
      Object.hash(descricao, precoOriginal, precoComDesconto, status, campoVisao);
}

class OrcamentoItem {
  final String categoria;
  final String descricao;
  final double preco;
  final double precoOriginalItem;
  final double percentagemDescontoAplicada;

  OrcamentoItem({
    required this.categoria,
    required this.descricao,
    required this.preco,
    required this.precoOriginalItem,
    required this.percentagemDescontoAplicada,
  });
}

class OrcamentoService with ChangeNotifier {
  PrescricaoTemporaria? _prescricaoTemp;
  final List<OrcamentoItem> _itensFinais = [];

  double _acrescimoMultiplier = 1.0;
  final Set<String> _codigosDescontoAplicados = {};
  double _descontoAplicado = 0.0;
  bool _isAcCodeSetForCurrentSession = false;

  String? _usuarioLogado; // NOVO: Nome do usuário (REI.VENDAS1, etc.)

  List<OrcamentoItem> get itensFinais => _itensFinais;
  bool get temPrescricaoPendente => _prescricaoTemp != null;
  double get descontoAplicado => _descontoAplicado;
  Set<String> get codigosDescontoAplicados => Set.from(_codigosDescontoAplicados);
  bool get isAcCodeSetForCurrentSession => _isAcCodeSetForCurrentSession;
  String? get usuarioLogado => _usuarioLogado;

  double get total {
    if (_itensFinais.isEmpty) return 0.0;
    return _itensFinais.map((item) => item.preco).reduce((a, b) => a + b);
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

  ResultadoDesconto aplicarDesconto(String codigo) {
    final resultado = DescontoService.aplicarCodigo(
        codigo, _descontoAplicado, _codigosDescontoAplicados);
    if (resultado.valido) {
      _descontoAplicado += resultado.percentagem;
      _codigosDescontoAplicados.add(codigo.toUpperCase());
    }
    notifyListeners();
    return resultado;
  }

  void salvarPrescricao(PrescricaoTemporaria prescricao) {
    _prescricaoTemp = prescricao;
    _isAcCodeSetForCurrentSession = false;
    notifyListeners();
  }

  List<OpcaoLenteCalculada> gerarOpcoesDaTabela() {
    if (_prescricaoTemp == null) return [];

    final regras = LogicaIndicacao.getIndicacoes(
      esferico: _prescricaoTemp!.esferico,
      cilindrico: _prescricaoTemp!.cilindrico,
      tipoArmacao: _prescricaoTemp!.tipoArmacao,
      tipoLente: _prescricaoTemp!.tipoLente,
    );

    List<OpcaoLenteCalculada> opcoes = [];

    for (var regra in regras) {
      if (regra.status == 'nao_recomendado') {
        opcoes.add(OpcaoLenteCalculada(
          descricao: "${regra.lente} ${regra.observacao}",
          precoOriginal: 0,
          precoComDesconto: 0,
          status: 'nao_recomendado',
          campoVisao: regra.campoVisao,
        ));
      } else {
        regra.precos.forEach((tratamento, precoBase) {
          final precoAposAcrescimo = precoBase * _acrescimoMultiplier;
          final precoFinalComDesconto =
              precoAposAcrescimo * (1 - _descontoAplicado);

          opcoes.add(OpcaoLenteCalculada(
            descricao: "${regra.lente} ${regra.observacao} | $tratamento",
            precoOriginal: precoAposAcrescimo,
            precoComDesconto: precoFinalComDesconto,
            status: regra.status,
            campoVisao: regra.campoVisao,
          ));
        });
      }
    }

    return opcoes;
  }

  Future<void> finalizarOrcamento(OpcaoLenteCalculada opcaoFinal) async {
    _itensFinais.clear();
    _itensFinais.add(OrcamentoItem(
      categoria: "Lente e Tratamentos",
      descricao: opcaoFinal.descricao,
      preco: opcaoFinal.precoComDesconto,
      precoOriginalItem: opcaoFinal.precoOriginal,
      percentagemDescontoAplicada: _descontoAplicado,
    ));

    // GRAVAÇÃO NO FIRESTORE
    if (_usuarioLogado != null) {
      final docRef = FirebaseFirestore.instance
          .collection('usuarios_orcamentos')
          .doc(_usuarioLogado);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final double valorOrcamento = opcaoFinal.precoComDesconto;

        if (snapshot.exists) {
          final data = snapshot.data()!;
          final totalAnterior = (data['total_orcamentos'] ?? 0) as int;
          final valorAnterior = (data['valor_total'] ?? 0.0) as num;

          transaction.update(docRef, {
            'total_orcamentos': totalAnterior + 1,
            'valor_total': valorAnterior + valorOrcamento,
          });
        } else {
          transaction.set(docRef, {
            'total_orcamentos': 1,
            'valor_total': valorOrcamento,
          });
        }
      });
    }

    _prescricaoTemp = null;
    _descontoAplicado = 0.0;
    _codigosDescontoAplicados.clear();
    notifyListeners();
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
}
