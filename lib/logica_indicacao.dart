import 'espessura_lente.dart'; // Importa os Enums

// Representa uma única regra/linha da sua tabela de indicação
class RegraIndicacao {
  final String lente;
  final String observacao;
  final Map<String, double> precos;
  final String? status; // 'atencao' ou 'nao_recomendado'

  RegraIndicacao({
    required this.lente,
    this.observacao = "",
    required this.precos,
    this.status,
  });
}

// Classe que contém a lógica para encontrar a indicação correta
class LogicaIndicacao {
  
  static List<RegraIndicacao> getIndicacoes({
    required double esferico,
    required double cilindrico,
    required TipoArmacao tipoArmacao,
    required TipoLente tipoLente,
  }) {
    if (tipoLente != TipoLente.simples) return [];

    final cilAbs = cilindrico.abs();

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
             RegraIndicacao(lente: "1.67", observacao: "Especial", precos: {"Incolor 2 Camadas": 970, "AR 7 Camadas": 1170, "Blue 15": 1570, "Blue 25": 1870}),
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
    // --- GRAUS POSITIVOS ---
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
            RegraIndicacao(lente: "1.74", observacao: "SURFAÇADA", precos: {"Incolor 2 Camadas": 2370, "AR 7 Camadas": 2570, "Blue 15": 2870, "Blue 25": 3170}, status: "atencao"),
          ];
        }
      }
    }
    return [];
  }
}
