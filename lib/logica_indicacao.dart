import 'espessura_lente.dart'; // Importa os Enums, incluindo os novos para multifocal

// Representa uma única regra/linha da sua tabela de indicação
class RegraIndicacao {
  final String lente;
  final String observacao;
  final Map<String, double> precos;
  final String? status; // 'atencao' ou 'nao_recomendado'
  final CampoVisaoPercentagem? campoVisao; // Para agrupar multifocais

  RegraIndicacao({
    required this.lente,
    this.observacao = "",
    required this.precos,
    this.status,
    this.campoVisao,
  });
}

// Classe que contém a lógica para encontrar a indicação correta
class LogicaIndicacao {
  // Helpers para converter Enums para String legível
  static String _campoVisaoToString(CampoVisaoPercentagem campo) {
    // Ex: CampoVisaoPercentagem.p40 -> "40%"
    return campo.toString().split('.').last.substring(1) + '%';
  }

  static String _materialLenteToString(MaterialLenteMultifocal material) {
    // Mapeamento explícito para nomes de lentes (índices e Poli)
    switch (material) {
      case MaterialLenteMultifocal.poli: return 'Poli';
      case MaterialLenteMultifocal.l156: return '1.56';
      case MaterialLenteMultifocal.l160: return '1.60';
      case MaterialLenteMultifocal.l167: return '1.67';
      case MaterialLenteMultifocal.l174: return '1.74';
    }
  }

  static String _tratamentoToString(TipoTratamentoMultifocal tratamento) {
    switch (tratamento) {
      case TipoTratamentoMultifocal.incolor2Camadas: return 'Incolor 2 Camadas';
      case TipoTratamentoMultifocal.ar7Camadas: return 'AR 7 Camadas';
      case TipoTratamentoMultifocal.blue15Camadas: return 'Blue 15';
      case TipoTratamentoMultifocal.blue25Camadas: return 'Blue 25';
      case TipoTratamentoMultifocal.photo: return 'Photo';
      case TipoTratamentoMultifocal.transition: return 'Transition';
    }
  }

  static List<RegraIndicacao> getIndicacoes({
    required double esferico,
    required double cilindrico,
    required TipoArmacao tipoArmacao,
    required TipoLente tipoLente,
  }) {
    List<RegraIndicacao> regras = [];
    final cilAbs = cilindrico.abs();

    if (tipoLente == TipoLente.simples) {
      // --- LÓGICA EXISTENTE PARA LENTES SIMPLES (MANTIDA) ---
      // --- GRAUS NEGATIVOS ---
      if (esferico < 0) {
        // Faixa de -0.25 a -2.00
        if (esferico >= -2.0) {
          if (cilAbs <= 2.0) {
            if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal) return [RegraIndicacao(lente: "1.56", observacao: "(Camadas)", precos: {"Incolor 2 Camadas": 230, "AR 7 Camadas": 330, "Blue 15": 470, "Blue 25": 670, "Photo": 670, "Transition": 970})];
            return [RegraIndicacao(lente: "1.59", observacao: "(Poli)", precos: {"Incolor 2 Camadas": 470, "AR 7 Camadas": 570, "Blue 15": 770, "Blue 25": 970, "Photo": 1170})];
          } else if (cilAbs <= 4.0) { // Cilindrico Extendido
            if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal) return [RegraIndicacao(lente: "1.56", observacao: "Especial", precos: {"Incolor 2 Camadas": 570, "AR 7 Camadas": 770, "Blue 15": 870, "Blue 25": 970, "Photo": 670})];
            return [RegraIndicacao(lente: "Poli", observacao: "Especial", precos: {"Incolor 2 Camadas": 570, "AR 7 Camadas": 670, "Blue 15": 870, "Blue 25": 1070})];
          }
        }
        // Faixa de -2.25 a -4.00
        else if (esferico >= -4.0) {
          if (cilAbs <= 2.0) {
            if (tipoArmacao == TipoArmacao.acetato) return [RegraIndicacao(lente: "1.61", precos: {"Incolor 2 Camadas": 670, "AR 7 Camadas": 770, "Blue 15": 870, "Blue 25": 1070})];
            if (tipoArmacao == TipoArmacao.metal) return [RegraIndicacao(lente: "1.67", observacao: "(Espessura)", precos: {"Incolor 2 Camadas": 970, "AR 7 Camadas": 1070, "Blue 15": 1470, "Blue 25": 1670})];
            return [RegraIndicacao(lente: "Poli", precos: {"Incolor 2 Camadas": 470, "AR 7 Camadas": 570, "Blue 15": 770, "Blue 25": 970, "Photo": 1170})];
          }
          if (cilAbs <= 4.0) { // Cilindrico Extendido
            if (tipoArmacao == TipoArmacao.acetato) return [RegraIndicacao(lente: "1.61", observacao: "Especial", precos: {"Incolor 2 Camadas": 570, "AR 7 Camadas": 770, "Blue 15": 870, "Blue 25": 1070})];
            if (tipoArmacao == TipoArmacao.metal) return [RegraIndicacao(lente: "1.67", observacao: "Especial", precos: {"Incolor 2 Camadas": 970, "AR 7 Camadas": 1170, "Blue 15": 1570, "Blue 25": 1870})];
            return [RegraIndicacao(lente: "Poli", observacao: "Especial", precos: {"Incolor 2 Camadas": 570, "AR 7 Camadas": 670, "Blue 15": 870, "Blue 25": 1070})];
          }
        }
        // Faixa de -4.25 a -8.00
        else if (esferico >= -8.0) {
          if (tipoArmacao == TipoArmacao.balgriff) return [RegraIndicacao(lente: "Nenhuma", precos: {}, status: "nao_recomendado")];
          if (cilAbs <= 2.0) {
              return [
                RegraIndicacao(lente: "1.59", observacao: "(Poli)", precos: {"Incolor 2 Camadas": 470, "AR 7 Camadas": 570, "Blue 15": 770, "Blue 25": 970, "Photo": 1170}, status: "nao_recomendado"),
                RegraIndicacao(lente: "1.61", precos: {"Incolor 2 Camadas": 670, "AR 7 Camadas": 770, "Blue 15": 870, "Blue 25": 1070}, status: "nao_recomendado"),
                RegraIndicacao(lente: "1.67", precos: {"Incolor 2 Camadas": 970, "AR 7 Camadas": 1070, "Blue 15": 1470, "Blue 25": 1670}, status: "atencao"),
                RegraIndicacao(lente: "1.74", precos: {"Incolor 2 Camadas": 3470, "AR 7 Camadas": 1970}),
              ];
          }
          if (cilAbs <= 4.0) {
              return [
                RegraIndicacao(lente: "1.59", observacao: "(Poli Especial)", precos: {"Incolor 2 Camadas": 570, "AR 7 Camadas": 670, "Blue 15": 870, "Blue 25": 1070}),
                RegraIndicacao(lente: "1.67", observacao: "Especial", precos: {"Incolor 2 Camadas": 970, "AR 7 Camadas": 1170, "Blue 15": 1570, "Blue 25": 1870}, status: "atencao"),
                RegraIndicacao(lente: "1.74", observacao: "Especial", precos: {"Incolor 2 Camadas": 2070, "AR 7 Camadas": 2170}, status: "atencao"),
              ];
          }
        }
        // Acima de -8.00
        else {
          if (tipoArmacao == TipoArmacao.nylon || tipoArmacao == TipoArmacao.balgriff) return [RegraIndicacao(lente: "Nenhuma", precos: {}, status: "nao_recomendado")];
          if (cilAbs <= 2.0) {
              return [
                RegraIndicacao(lente: "1.59", observacao: "(Poli)", precos: {"Incolor 2 Camadas": 470, "AR 7 Camadas": 570, "Blue 15": 770, "Blue 25": 970, "Photo": 1170}, status: "nao_recomendado"),
                RegraIndicacao(lente: "1.61", precos: {"Incolor 2 Camadas": 670, "AR 7 Camadas": 770, "Blue 15": 870, "Blue 25": 1070}, status: "nao_recomendado"),
                RegraIndicacao(lente: "1.67", precos: {"Incolor 2 Camadas": 970, "AR 7 Camadas": 1070, "Blue 15": 1470, "Blue 25": 1670}, status: "atencao"),
                RegraIndicacao(lente: "1.74", precos: {"Incolor 2 Camadas": 3470, "AR 7 Camadas": 1970}),
              ];
          } else { // Cilindrico Extendido
              return [
                RegraIndicacao(lente: "1.59", observacao: "(Poli Especial)", precos: {"Incolor 2 Camadas": 570, "AR 7 Camadas": 670, "Blue 15": 870, "Blue 25": 1070}),
                RegraIndicacao(lente: "1.67", observacao: "Especial", precos: {"Incolor 2 Camadas": 970, "AR 7 Camadas": 1170, "Blue 15": 1570, "Blue 25": 1870}, status: "atencao"),
                RegraIndicacao(lente: "1.74", observacao: "Especial", precos: {"Incolor 2 Camadas": 2070, "AR 7 Camadas": 2170}, status: "atencao"),
              ];
          }
        }
      } 
      // --- GRAUS POSITIVOS (SIMPLES) ---
      else if (esferico >= 0) {
        if (esferico <= 2.25) {
            if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal) return [RegraIndicacao(lente: "1.56", observacao: "(Camadas)", precos: {"Incolor 2 Camadas": 230, "AR 7 Camadas": 330, "Blue 15": 470, "Blue 25": 670, "Photo": 670, "Transition": 970})];
            return [RegraIndicacao(lente: "1.59", observacao: "(Poli)", precos: {"Incolor 2 Camadas": 470, "AR 7 Camadas": 570, "Blue 15": 770, "Blue 25": 970, "Photo": 1170})];
        }
        if (esferico <= 5.0) {
          if(tipoArmacao == TipoArmacao.nylon || tipoArmacao == TipoArmacao.balgriff) return [RegraIndicacao(lente: "Poli", observacao: "SURFAÇADA", precos: {"Incolor 2 Camadas": 670, "AR 7 Camadas": 870, "Blue 15": 1270, "Blue 25": 1470, "Photo": 1370, "Transition": 2270})];
          return [RegraIndicacao(lente: "1.61", observacao: "SURFAÇADA", precos: {"Incolor 2 Camadas": 1070, "AR 7 Camadas": 1270, "Blue 15": 1370, "Blue 25": 1570, "Transition": 2870})];
        }
        if (esferico > 5.0) {
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal) {
            return [
              RegraIndicacao(lente: "1.59", observacao: "(Poli) SURFAÇADA", precos: {"Incolor 2 Camadas": 670, "AR 7 Camadas": 870, "Blue 15": 1270, "Blue 25": 1470, "Photo": 1370, "Transition": 2270}, status: "atencao"),
              RegraIndicacao(lente: "1.61", observacao: "SURFAÇADA", precos: {"Incolor 2 Camadas": 1070, "AR 7 Camadas": 1270, "Blue 15": 1370, "Blue 25": 1570, "Transition": 2870}, status: "atencao"),
              RegraIndicacao(lente: "1.67", observacao: "SURFAÇADA", precos: {"Incolor 2 Camadas": 1670, "AR 7 Camadas": 1970, "Blue 15": 2070, "Blue 25": 2270, "Transition": 3470}),
              RegraIndicacao(lente: "1.74", observacao: "SURFAÇADA", precos: {"Incolor 2 Camadas": 2370, "AR 7 Camadas": 2570, "Blue 15": 2870, "Blue 25": 3170, "Transition": 4070}),
            ];
          }
          else { // Nylon / Balgriff
            return [
              RegraIndicacao(lente: "1.59", observacao: "(Poli) SURFAÇADA", precos: {"Incolor 2 Camadas": 670, "AR 7 Camadas": 870, "Blue 15": 1270, "Blue 25": 1470, "Photo": 1370, "Transition": 2270}),
              RegraIndicacao(lente: "1.61", observacao: "SURFAÇADA", precos: {"Incolor 2 Camadas": 1070, "AR 7 Camadas": 1270, "Blue 15": 1370, "Blue 25": 1570, "Transition": 2870}, status: "atencao"),
              RegraIndicacao(lente: "1.67", observacao: "SURFAÇADA", precos: {"Incolor 2 Camadas": 1670, "AR 7 Camadas": 1970, "Blue 15": 2070, "Blue 25": 2270}, status: "atencao"),
              RegraIndicacao(lente: "1.74", observacao: "Especial", precos: {"Incolor 2 Camadas": 2370, "AR 7 Camadas": 2570, "Blue 15": 2870, "Blue 25": 3170}, status: "atencao"),
            ];
          }
        }
      }
    } 
    // --- LENTES MULTIFOCAIS (LÓGICA REPLICADA DA SIMPLES) ---
    else if (tipoLente == TipoLente.multifocal) {
      // --- GRAUS NEGATIVOS (MULTIFOCAL) ---
      if (esferico < 0) {
        // Faixa de -0.25 a -3.00
        if (esferico >= -3.0 && esferico <= -0.25) {
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal) {
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 770.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2470.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 770.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2470.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          } else if (tipoArmacao == TipoArmacao.nylon) {
            // Apenas para Poli em Nylon nesta faixa
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2170.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1290.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2570.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2670.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          }
        }
        // Faixa de -3.25 a -4
        else if (esferico >= -4.0 && esferico <= -3.25) { // Inclui -4.0 e -3.25
          // ACETATO/METAL/NYLON
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal || tipoArmacao == TipoArmacao.nylon) {
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 3070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2770.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 3170.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 3170.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2770.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 3070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 2170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 3170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 3070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          }
        }
        // Faixa Acima de -4 (esferico < -4.0)
        else if (esferico < -4.0) { // Agora abrange valores menores que -4.0 (ex: -4.25, -5.0)
          // ACETATO/METAL/NYLON
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal || tipoArmacao == TipoArmacao.nylon) {
            regras.addAll([
              // Lentes 1.56, POLI, 1.60 são não recomendadas aqui (fundo vermelho na tabela)
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'nao_recomendado', // Definido como não recomendado
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2270.0,
                },
                status: 'nao_recomendado', // Definido como não recomendado
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 3170.0,
                },
                status: 'nao_recomendado', // Definido como não recomendado
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              // Lente 1.67 é recomendada
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l167)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 3170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 2370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 3370.0,
                },
                status: 'recomendado', // Status padrão, mas Photo/Transition podem ter atenção
                campoVisao: CampoVisaoPercentagem.p80,
              ),
            ]);
          }
        }
      } 
      // --- GRAUS POSITIVOS (MULTIFOCAL) ---
      else if (esferico >= 0) {
        // Faixa de +0.25 a +3
        if (esferico >= 0.25 && esferico <= 3.0) {
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal) {
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 770.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2470.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 770.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2470.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          } else if (tipoArmacao == TipoArmacao.nylon) {
            // Apenas para Poli em Nylon nesta faixa
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2170.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1290.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2570.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2670.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          }
        }
        // Faixa de +3.25 a +6
        else if (esferico >= 3.25 && esferico <= 6.0) { // Inclui +3.25 e +6.0
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal || tipoArmacao == TipoArmacao.nylon) {
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2170.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2570.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1970.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2670.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          }
        }
        // Faixa Acima de +6 (esferico > 6.0)
        else if (esferico > 6.0) {
          // ACETATO/METAL/NYLON
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal || tipoArmacao == TipoArmacao.nylon) {
            regras.addAll([
              // Lentes 1.56, POLI, 1.60 são não recomendadas aqui (fundo vermelho)
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'nao_recomendado',
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 2270.0,
                },
                status: 'nao_recomendado',
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2670.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 3170.0,
                },
                status: 'nao_recomendado',
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              // Lente 1.67 é recomendada
              RegraIndicacao(
                lente: "Multifocal ${_materialLenteToString(MaterialLenteMultifocal.l167)}",
                observacao: "Campo ${_campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  _tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 2070.0,
                  _tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2270.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2870.0,
                  _tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 3170.0,
                  _tratamentoToString(TipoTratamentoMultifocal.photo): 2370.0,
                  _tratamentoToString(TipoTratamentoMultifocal.transition): 3370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p80,
              ),
            ]);
          }
        }
      }
    }

    // Lógica para aplicar o status 'atencao' globalmente a PHOTO e TRANSITION se a lente não for 'nao_recomendado'
    // Esta lógica agora será aplicada APÓS a determinação principal da lente para evitar sobrescrever 'nao_recomendado'
    List<RegraIndicacao> finalRegras = [];
    for (var regra in regras) {
      String? finalStatus = regra.status;
      
      // Se o status não for 'nao_recomendado'
      if (finalStatus != 'nao_recomendado') {
        // Verifica se é uma opção PHOTO ou TRANSITION
        if (regra.precos.containsKey(_tratamentoToString(TipoTratamentoMultifocal.photo)) ||
            regra.precos.containsKey(_tratamentoToString(TipoTratamentoMultifocal.transition))) {
          // Se ainda não tiver status ou for 'recomendado', marca como 'atencao'
          if (finalStatus == null || finalStatus == 'recomendado') {
          }
        }
      }
      
      finalRegras.add(RegraIndicacao(
        lente: regra.lente,
        observacao: regra.observacao,
        precos: regra.precos,
        status: finalStatus, // Usa o status calculado
        campoVisao: regra.campoVisao,
      ));
    }

    return finalRegras;
  }
}
