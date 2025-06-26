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

    final regras = LogicaIndicacao.getIndicacoes(
      esferico: _prescricaoTemp!.esferico,
      cilindrico: _prescricaoTemp!.cilindrico,
      tipoArmacao: _prescricaoTemp!.tipoArmacao,
      tipoLente: _prescricaoTemp!.tipoLente,
    );

    return regras.expand((regra) {
      return regra.precos.entries.map((entry) {
        final precoBase = entry.value;
        final precoComAcrescimo = regra.status == 'nao_recomendado'
            ? precoBase
            : precoBase * _acrescimoMultiplier;

        final precoFinalComDesconto =
            precoComAcrescimo * (1 - _descontoAplicado);

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
    if (_usuarioLogado == null || _usuarioLogado!.isEmpty) {
      print('Erro: usuário não logado!');
      return;
    }

    _itensFinais.clear();
    _itensFinais.add(OrcamentoItem(
      categoria: "Lente e Tratamentos",
      descricao: opcaoFinal.descricao,
      preco: opcaoFinal.precoComDesconto,
      precoOriginalItem: opcaoFinal.precoOriginal,
      percentagemDescontoAplicada: _descontoAplicado,
      tipoArmacao: _prescricaoTemp?.tipoArmacao.name ?? '',
      esferico: _prescricaoTemp?.esferico ?? 0.0,
      cilindrico: _prescricaoTemp?.cilindrico ?? 0.0,
      tipoLente: _prescricaoTemp?.tipoLente.name ?? '',
    ));

    final docRef = FirebaseFirestore.instance
        .collection('usuarios_orcamentos')
        .doc(_usuarioLogado);

    await docRef.collection('orcamentos').add({
      'itens': _itensFinais.map((item) => {
            'categoria': item.categoria,
            'descricao': item.descricao,
            'preco': arredondar2(item.preco),
            'precoOriginalItem': arredondar2(item.precoOriginalItem),
            'percentagemDescontoAplicada':
                arredondar2(item.percentagemDescontoAplicada),
            'tipoArmacao': item.tipoArmacao,
            'esferico': item.esferico,
            'cilindrico': item.cilindrico,
            'tipoLente': item.tipoLente,
          }).toList(),
      'acUtilizado': _acrescimoMultiplier,
      'data': FieldValue.serverTimestamp(),
      'total': arredondar2(total),
      'descontoTotal': arredondar2(_descontoAplicado),
      'tipoLenteResumo': _prescricaoTemp?.tipoLente.name ?? '',
      'esferico': _prescricaoTemp?.esferico,
      'cilindrico': _prescricaoTemp?.cilindrico,
      'tipoArmacaoResumo': _prescricaoTemp?.tipoArmacao.name,
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
}

double arredondar2(double valor) =>
    double.parse(valor.toStringAsFixed(2));
