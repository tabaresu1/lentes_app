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
  final CampoVisaoPercentagem? campoVisao; // Para agrupar multifocais na UI

  OpcaoLenteCalculada({
    required this.descricao,
    required this.precoOriginal,
    required this.precoComDesconto,
    this.status,
    this.campoVisao,
  });

  // Sobrescreve o operador == e o hashCode para comparação de valor
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
  int get hashCode => Object.hash(descricao, precoOriginal, precoComDesconto, status, campoVisao);
}

class OrcamentoItem {
  final String categoria;
  final String descricao;
  final double preco; // Preço final com desconto
  final double precoOriginalItem; // Preço do item antes dos descontos
  final double percentagemDescontoAplicada; // Percentagem de desconto aplicada ao item

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

  // NOVO: Flag para rastrear se o Código AC foi definido para a sessão atual
  bool _isAcCodeSetForCurrentSession = false;

  List<OrcamentoItem> get itensFinais => _itensFinais;
  bool get temPrescricaoPendente => _prescricaoTemp != null;
  double get descontoAplicado => _descontoAplicado; 
  Set<String> get codigosDescontoAplicados => Set.from(_codigosDescontoAplicados);
  // NOVO: Getter para a flag de sessão AC
  bool get isAcCodeSetForCurrentSession => _isAcCodeSetForCurrentSession;

  double get total {
    if (_itensFinais.isEmpty) return 0.0;
    return _itensFinais.map((item) => item.preco).reduce((a, b) => a + b);
  }

  // Função para definir o multiplicador a partir do código AC
  void setAcrescimo(String codigoAC) {
    if (codigoAC.isEmpty) {
      _acrescimoMultiplier = 1.0;
      _isAcCodeSetForCurrentSession = false; // Se o código for vazio, reseta a flag
      return;
    }
    final valor = double.tryParse(codigoAC);
    if (valor != null && valor >= 100) {
      _acrescimoMultiplier = valor / 100.0;
      _isAcCodeSetForCurrentSession = true; // Código AC válido foi inserido
    } else {
      _acrescimoMultiplier = 1.0; // Volta ao padrão se o código for inválido
      _isAcCodeSetForCurrentSession = false; // Código AC inválido
    }
    print("Multiplicador de Acréscimo definido para: $_acrescimoMultiplier. AC Set: $_isAcCodeSetForCurrentSession");
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
    // NÃO reseta _isAcCodeSetForCurrentSession aqui, pois estamos salvando uma prescrição na sessão atual
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
          final precoFinalComDesconto = precoAposAcrescimo * (1 - _descontoAplicado);

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

  void finalizarOrcamento(OpcaoLenteCalculada opcaoFinal) {
    _itensFinais.clear(); 
    _itensFinais.add(OrcamentoItem(
      categoria: "Lente e Tratamentos",
      descricao: opcaoFinal.descricao,
      preco: opcaoFinal.precoComDesconto,
      precoOriginalItem: opcaoFinal.precoOriginal,
      percentagemDescontoAplicada: _descontoAplicado,
    ));
    _prescricaoTemp = null;
    _descontoAplicado = 0.0; 
    _codigosDescontoAplicados.clear(); 
    _isAcCodeSetForCurrentSession = false; // NOVO: Reseta a flag para um novo orçamento
    notifyListeners();
  }
  
  void limparOrcamento() {
    _itensFinais.clear();
    _prescricaoTemp = null;
    _descontoAplicado = 0.0; 
    _codigosDescontoAplicados.clear(); 
    _isAcCodeSetForCurrentSession = false; // NOVO: Reseta a flag para um novo orçamento
    notifyListeners();
  }
}
