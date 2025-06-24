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
  Set<String> get codigosDescontoAplicados => Set.from(_codigosDescontoAplicados);
  bool get isAcCodeSetForCurrentSession => _isAcCodeSetForCurrentSession;
  String? get usuarioLogado => _usuarioLogado;
  PrescricaoTemporaria? get prescricaoTemp => _prescricaoTemp;

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
    print('Usuário logado: $_usuarioLogado');
    try {
      if (_usuarioLogado == null || _usuarioLogado!.isEmpty) {
        print('Erro: usuário não logado!');
        return;
      }

      // 1. Crie o item normalmente
      _itensFinais.clear();
      _itensFinais.add(OrcamentoItem(
        categoria: "Lente e Tratamentos",
        descricao: opcaoFinal.descricao,
        preco: opcaoFinal.precoComDesconto,
        precoOriginalItem: opcaoFinal.precoOriginal,
        percentagemDescontoAplicada: _descontoAplicado,
        tipoArmacao: _prescricaoTemp?.tipoArmacao.toString().split('.').last ?? '',
        esferico: _prescricaoTemp?.esferico ?? 0.0,
        cilindrico: _prescricaoTemp?.cilindrico ?? 0.0,
        tipoLente: _prescricaoTemp?.tipoLente.toString().split('.').last ?? '', // <-- Adicionado aqui
      ));

      // 2. Depois, salve no Firestore (adicione o campo acUtilizado normalmente)
      final docRef = FirebaseFirestore.instance
          .collection('usuarios_orcamentos')
          .doc(_usuarioLogado);

      print('Salvando orçamento para usuário: $_usuarioLogado');

      // Salva o orçamento detalhado em uma subcoleção "orcamentos"
      await docRef.collection('orcamentos').add({
        'itens': _itensFinais.map((item) => {
          'categoria': item.categoria,
          'descricao': item.descricao,
          'preco': arredondar2(item.preco),
          'precoOriginalItem': arredondar2(item.precoOriginalItem),
          'percentagemDescontoAplicada': arredondar2(item.percentagemDescontoAplicada),
          'tipoArmacao': item.tipoArmacao,
          'esferico': item.esferico,
          'cilindrico': item.cilindrico,
          'tipoLente': _prescricaoTemp?.tipoLente.toString().split('.').last ?? '', // <-- Adicionado aqui
        }).toList(),
        'acUtilizado': _acrescimoMultiplier,
        'data': FieldValue.serverTimestamp(),
        'total': arredondar2(total),
        'descontoTotal': arredondar2(_descontoAplicado),
        'tipoLenteResumo': _prescricaoTemp?.tipoLente.toString().split('.').last ?? '', // <-- E aqui, se quiser
        // Os campos abaixo são redundantes se já estão em 'itens', mas mantenha se quiser facilitar buscas
        'esferico': _prescricaoTemp?.esferico != null ? arredondar2(_prescricaoTemp!.esferico) : null,
        'cilindrico': _prescricaoTemp?.cilindrico != null ? arredondar2(_prescricaoTemp!.cilindrico) : null,
        'tipoArmacaoResumo': _prescricaoTemp?.tipoArmacao.name, // Renomeado para evitar conflito
      });

      // Atualiza os totais agregados do usuário
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
            'valor_total': valorOrcamento,
          });
        }
      });

      _prescricaoTemp = null;
      _descontoAplicado = 0.0;
      _codigosDescontoAplicados.clear();
      notifyListeners();
      print('Orçamento salvo com sucesso!');
    } catch (e, s) {
      print('Erro ao salvar orçamento: $e');
      print(s);
    }
  }

  void limparOrcamento() {
    _itensFinais.clear();
    _prescricaoTemp = null;
    _descontoAplicado = 0.0;
    _codigosDescontoAplicados.clear();
    notifyListeners();
  }

  void setUsuarioLogado(String username) {
    print('setUsuarioLogado: $username');
    _usuarioLogado = username;
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

double arredondar2(double valor) => double.parse(valor.toStringAsFixed(2));
