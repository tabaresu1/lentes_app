import 'regra_indicacao.dart';
import '../espessura_lente.dart'; // Contém os enums necessários
import 'formatadores.dart'; // Importação dos formatadores

class LogicaMultifocal {
  static List<RegraIndicacao> calcular({
    required double esferico,
    required double esfericoAjustado,
    required double esfericoParaClassificacao,
    required TipoArmacao tipoArmacao,
    required TipoLente tipoLente,
    required String Function(MaterialLenteMultifocal) materialToString,
    required String Function(TipoTratamentoMultifocal) tratamentoToString,
    required String Function(CampoVisaoPercentagem) campoToString,
  }) {
    final List<RegraIndicacao> regras = [];

// --- LENTES MULTIFOCAIS (LÓGICA REPLICADA DA SIMPLES) ---
  if (tipoLente == TipoLente.multifocal) {
      // --- GRAUS NEGATIVOS (MULTIFOCAL) ---
      if (esfericoParaClassificacao < 0) {
        // Faixa de -0.25 a -3.00
        if (esfericoAjustado >= -3.0 && esfericoAjustado <= -0.25) {
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal) {
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 770.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2470.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 770.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2470.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          } else if (tipoArmacao == TipoArmacao.nylon) {
            // Apenas para Poli em Nylon nesta faixa
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2170.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1290.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2570.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2670.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          }
        }
        // Faixa de -3.25 a -4
        else if (esfericoAjustado >= -4.0 && esfericoAjustado <= -3.25) { // Inclui -4.0 e -3.25
          // ACETATO/METAL/NYLON
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal || tipoArmacao == TipoArmacao.nylon) {
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 3070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2770.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 3170.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 3170.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2770.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 3070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 2170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 3170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 3070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          }
        }
        // Faixa Acima de -4 (esferico < -4.0)
        else if (esfericoAjustado < -4.0) { // Agora abrange valores menores que -4.0 (ex: -4.25, -5.0)
          // ACETATO/METAL/NYLON
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal || tipoArmacao == TipoArmacao.nylon) {
            regras.addAll([
              // Lentes 1.56, POLI, 1.60 são não recomendadas aqui (fundo vermelho na tabela)
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'nao_recomendado', // Definido como não recomendado
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2270.0,
                },
                status: 'nao_recomendado', // Definido como não recomendado
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 3170.0,
                },
                status: 'nao_recomendado', // Definido como não recomendado
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              // Lente 1.67 é recomendada
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l167)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 3170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 2370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 3370.0,
                },
                status: 'recomendado', // Status padrão, mas Photo/Transition podem ter atenção
                campoVisao: CampoVisaoPercentagem.p80,
              ),
            ]);
          }
        }
      } 
      // --- GRAUS POSITIVOS (MULTIFOCAL) ---
      else if (esfericoParaClassificacao >= 0) {
        // Faixa de +0.25 a +3
        if (esfericoParaClassificacao <= 3.0) {
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal) {
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 770.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2470.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 770.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2070.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2470.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          } else if (tipoArmacao == TipoArmacao.nylon) {
            // Apenas para Poli em Nylon nesta faixa
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2170.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1290.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2570.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2670.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          }
        }
        // Faixa de +3.25 a +6
        else if (esfericoParaClassificacao <= 6.0) {
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal || tipoArmacao == TipoArmacao.nylon) {
            regras.addAll([
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p40)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2170.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p40,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p50)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2270.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p50,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p67)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p67,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p87)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2570.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p87,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p98)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1970.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2670.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p98,
              ),
            ]);
          }
        }
        // Faixa Acima de +6 (esferico > 6.0)
        else {
          // ACETATO/METAL/NYLON
          if (tipoArmacao == TipoArmacao.acetato || tipoArmacao == TipoArmacao.metal || tipoArmacao == TipoArmacao.nylon) {
            regras.addAll([
              // Lentes 1.56, POLI, 1.60 são não recomendadas aqui (fundo vermelho)
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l156)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 1870.0,
                },
                status: 'nao_recomendado',
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.poli)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 1470.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 1570.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 2270.0,
                },
                status: 'nao_recomendado',
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l160)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 1870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2670.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 2870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 3170.0,
                },
                status: 'nao_recomendado',
                campoVisao: CampoVisaoPercentagem.p80,
              ),
              // Lente 1.67 é recomendada
              RegraIndicacao(
                lente: "Multifocal ${Formatadores.materialLenteToString(MaterialLenteMultifocal.l167)}",
                observacao: "Campo ${Formatadores.campoVisaoToString(CampoVisaoPercentagem.p80)}",
                precos: {
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.incolor2Camadas): 2070.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.ar7Camadas): 2270.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue15Camadas): 2870.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.blue25Camadas): 3170.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.photo): 2370.0,
                  Formatadores.tratamentoToString(TipoTratamentoMultifocal.transition): 3370.0,
                },
                status: 'recomendado',
                campoVisao: CampoVisaoPercentagem.p80,
              ),
            ]);
          }
        }
      }
    }
    return regras;
  }
}