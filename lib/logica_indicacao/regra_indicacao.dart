import 'logica_simples.dart';
import 'logica_multifocal.dart';
import '../espessura_lente.dart';
import 'formatadores.dart';

class RegraIndicacao {
  final String lente;
  final String observacao;
  final Map<String, double> precos;
  final String? status; // 'recomendado', 'atencao' ou 'nao_recomendado'
  final CampoVisaoPercentagem? campoVisao;

  RegraIndicacao({
    required this.lente,
    this.observacao = "",
    required this.precos,
    this.status,
    this.campoVisao,
  });

  // Método toString opcional para debug
  @override
  String toString() {
    return 'RegraIndicacao(lente: $lente, observacao: $observacao, '
           'precos: $precos, status: $status, campoVisao: $campoVisao)';
  }
}

class LogicaIndicacao {
  static List<RegraIndicacao> getIndicacoes({
    required double esferico,
    required double cilindrico,
    required TipoArmacao tipoArmacao,
    required TipoLente tipoLente,
    required double adicao,
  }) {
    final esfericoAbs = esferico.abs();
    final esfericoAjustado = esfericoAbs + (cilindrico.abs() / 2);
    final esfericoParaClassificacao = esferico + (cilindrico / 2);

    return tipoLente == TipoLente.simples
        ? _calcularLentesSimples(
            esferico,
            cilindrico,
            esfericoParaClassificacao,
            tipoArmacao,
          )
        : _calcularLentesMultifocais(
            esferico,
            esfericoAjustado,
            esfericoParaClassificacao,
            tipoArmacao,
          );
  }

  static List<RegraIndicacao> _calcularLentesSimples(
    double esferico,
    double cilindrico,
    double esfericoParaClassificacao,
    TipoArmacao tipoArmacao,
  ) {
    return LogicaSimples.calcular(
      esferico: esferico,
      cilindrico: cilindrico,
      esfericoParaClassificacao: esfericoParaClassificacao,
      tipoArmacao: tipoArmacao,
    );
  }

  static List<RegraIndicacao> _calcularLentesMultifocais(
    double esferico,
    double esfericoAjustado,
    double esfericoParaClassificacao,
    TipoArmacao tipoArmacao,
  ) {
    return LogicaMultifocal.calcular(
      esferico: esferico,
      esfericoAjustado: esfericoAjustado,
      esfericoParaClassificacao: esfericoParaClassificacao,
      tipoArmacao: tipoArmacao,
      tipoLente: TipoLente.multifocal,
      materialToString: Formatadores.materialLenteToString,
      tratamentoToString: Formatadores.tratamentoToString,
      campoToString: Formatadores.campoVisaoToString,
    );
  }
}