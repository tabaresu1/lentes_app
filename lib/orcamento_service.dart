import 'package:flutter/foundation.dart';
import 'espessura_lente.dart'; // Importa os Enums
import 'logica_indicacao.dart'; // Importa o novo motor de regras
import 'desconto_service.dart'; // Importa o serviço de desconto

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
  final double precoOriginal; // Preço antes do desconto
  final double precoComDesconto; // Preço após a aplicação do desconto
  final String? status;

  OpcaoLenteCalculada({
    required this.descricao,
    required this.precoOriginal,
    required this.precoComDesconto,
    this.status,
  });
}

class OrcamentoItem {
  final String categoria;
  final String descricao;
  final double preco; // Preço final com desconto
  final double precoOriginalItem; // NOVO: Preço do item antes dos descontos
  final double percentagemDescontoAplicada; // NOVO: Percentagem de desconto aplicada ao item

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

  List<OrcamentoItem> get itensFinais => _itensFinais;
  bool get temPrescricaoPendente => _prescricaoTemp != null;
  double get descontoAplicado => _descontoAplicado; 
  Set<String> get codigosDescontoAplicados => Set.from(_codigosDescontoAplicados);

  double get total {
    if (_itensFinais.isEmpty) return 0.0;
    return _itensFinais.map((item) => item.preco).reduce((a, b) => a + b);
  }

  void setAcrescimo(String codigoAC) {
    if (codigoAC.isEmpty) {
      _acrescimoMultiplier = 1.0;
      return;
    }
    final valor = double.tryParse(codigoAC);
    if (valor != null && valor >= 100) {
      _acrescimoMultiplier = valor / 100.0;
    } else {
      _acrescimoMultiplier = 1.0; 
    }
    print("Multiplicador de Acréscimo definido para: $_acrescimoMultiplier");
    notifyListeners();
  }

  ResultadoDesconto aplicarDesconto(String codigo) {
    final resultado = DescontoService.aplicarCodigo(codigo, _descontoAplicado, _codigosDescontoAplicados);
    
    if (resultado.valido) {
      _descontoAplicado += resultado.percentagem; 
      _codigosDescontoAplicados.add(codigo.toUpperCase()); 
    } else {
      
    }
    notifyListeners(); 
    return resultado;
  }

  void salvarPrescricao(PrescricaoTemporaria prescricao) {
    _prescricaoTemp = prescricao;
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
          status: 'nao_recomendado'
        ));
      } else {
        regra.precos.forEach((tratamento, precoBase) {
          final precoAposAcrescimo = precoBase * _acrescimoMultiplier;
          final precoFinalComDesconto = precoAposAcrescimo * (1 - _descontoAplicado);

          opcoes.add(OpcaoLenteCalculada(
            descricao: "${regra.lente} ${regra.observacao} | $tratamento",
            precoOriginal: precoAposAcrescimo, 
            precoComDesconto: precoFinalComDesconto, 
            status: regra.status,
          ));
        });
      }
    }
    
    return opcoes;
  }

  void finalizarOrcamento(OpcaoLenteCalculada opcaoFinal) {
    _itensFinais.clear(); 
    _itensFinais.add(OrcamentoItem(
      categoria: "Lente e Tratamentos",
      descricao: opcaoFinal.descricao,
      preco: opcaoFinal.precoComDesconto, // Preço final com desconto
      precoOriginalItem: opcaoFinal.precoOriginal, // NOVO: Salva o preço original
      percentagemDescontoAplicada: _descontoAplicado, // NOVO: Salva a percentagem total de desconto aplicada
    ));
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
}
