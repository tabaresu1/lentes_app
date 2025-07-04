import '../espessura_lente.dart'; // Para CampoVisaoPercentagem

class Formatadores {
  /// Formata materiais de lentes multifocais para exibição amigável
  static String materialLenteToString(MaterialLenteMultifocal material) {
    switch (material) {
      case MaterialLenteMultifocal.l156:
        return "Índice 1.56";
      case MaterialLenteMultifocal.poli:
        return "Policarbonato";
      case MaterialLenteMultifocal.l160:
        return "Índice 1.60";
      case MaterialLenteMultifocal.l167:
        return "Índice 1.67";
      case MaterialLenteMultifocal.l174:
        return "Índice 1.74";
      default:
        return material.toString().split('.').last;
    }
  }

  /// Formata tipos de tratamentos para nomes comerciais
  static String tratamentoToString(TipoTratamentoMultifocal tratamento) {
    switch (tratamento) {
      case TipoTratamentoMultifocal.incolor2Camadas:
        return "Anti-Reflexo Básico";
      case TipoTratamentoMultifocal.ar7Camadas:
        return "Anti-Reflexo Premium";
      case TipoTratamentoMultifocal.blue15Camadas:
        return "Blue Light 15 Camadas";
      case TipoTratamentoMultifocal.blue25Camadas:
        return "Blue Light 25 Camadas";
      case TipoTratamentoMultifocal.photo:
        return "Fotosensível";
      case TipoTratamentoMultifocal.transition:
        return "Transitions";
      default:
        return tratamento.toString().split('.').last;
    }
  }

  /// Formata porcentagens de campo visual para exibição uniforme
  static String campoVisaoToString(CampoVisaoPercentagem campo) {
    switch (campo) {
      case CampoVisaoPercentagem.p40:
        return "40% (Padrão)";
      case CampoVisaoPercentagem.p50:
        return "50% (Amplo)";
      case CampoVisaoPercentagem.p67:
        return "67% (Premium)";
      case CampoVisaoPercentagem.p80:
        return "80% (Elite)";
      case CampoVisaoPercentagem.p87:
        return "87% (Master)";
      case CampoVisaoPercentagem.p98:
        return "98% (Max Vision)";
      default:
        return "${campo.toString().split('.').last.replaceAll('p', '')}%";
    }
  }

  /// Formata preços para exibição (opcional)
  static String formatarPreco(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Formata tipo de armação para exibição (opcional)
  static String formatarArmacao(TipoArmacao armacao) {
    switch (armacao) {
      case TipoArmacao.acetato:
        return "Acetato";
      case TipoArmacao.metal:
        return "Metal";
      case TipoArmacao.nylon:
        return "Nylon";
      case TipoArmacao.balgriff:
        return "Balgriff";
      default:
        return armacao.toString().split('.').last;
    }
  }
}