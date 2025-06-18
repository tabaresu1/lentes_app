import 'package:flutter/material.dart';

// Classe que representa o resultado de uma tentativa de aplicar um desconto
class ResultadoDesconto {
  final bool valido;
  final double percentagem; // De 0.0 a 1.0 (ex: 0.05 para 5%)
  final String mensagem;
  final bool codigoJaAplicado; // Novo campo para indicar se o código já foi aplicado

  ResultadoDesconto({
    required this.valido,
    this.percentagem = 0.0,
    required this.mensagem,
    this.codigoJaAplicado = false, // Padrão é false
  });
}

// Classe que gere todos os códigos de desconto
class DescontoService {
  // Mapa de códigos válidos e as suas percentagens
  static final Map<String, double> _codigosValidos = {
    'VISAO5': 0.05,    // 5%
    'OTICA7': 0.07,    // 7%
    'LENTE6': 0.06,    // 6%
    'CUIDAR8': 0.08,   // 8%
    'OCULOS10': 0.10,  // 10%
    'APP7': 0.07,      // 7%
    'NOVO6': 0.06,     // 6%
    'MAIS9': 0.09,     // 9%
    'LEVE5': 0.05,     // 5%
    'BRILHO10': 0.10,  // 10%
  };

  // Lista de códigos que existem mas não funcionam (ajustada)
  static const List<String> _codigosInvalidos = [
    'GERENTE15',   // Mantido conforme sua solicitação
    'NOVO5',       // Código inválido
    'CUPOM7',      // Código inválido
    'OCULOS8',     // Código inválido
    'LENTES10',    // Código inválido
    'OTICA6',      // Código inválido
    'APP9',        // Código inválido
    'MAIS5',       // Código inválido
    'ONLINE7',     // Código inválido
    'CUIDAR6',     // Código inválido
    'FLASH10',     // Código inválido
  ];

  // Função principal para aplicar um código
  static ResultadoDesconto aplicarCodigo(String codigo, double descontoAtual, Set<String> codigosJaAplicados) {
    final codigoUpper = codigo.toUpperCase();

    // Primeiro, verifica se o código já foi aplicado
    if (codigosJaAplicados.contains(codigoUpper)) {
      return ResultadoDesconto(
        valido: false,
        mensagem: 'Este código já foi aplicado!',
        codigoJaAplicado: true,
      );
    }

    if (_codigosValidos.containsKey(codigoUpper)) {
      final novoDesconto = _codigosValidos[codigoUpper]!;
      // Verifica se o novo desconto ultrapassa o limite de 25%
      if ((descontoAtual + novoDesconto) > 0.25) {
        return ResultadoDesconto(
          valido: false,
          mensagem: 'Limite de 25% de desconto atingido!',
        );
      }
      return ResultadoDesconto(
        valido: true,
        percentagem: novoDesconto,
        mensagem: 'Desconto de ${(novoDesconto * 100).toStringAsFixed(0)}% aplicado!',
      );
    }

    if (_codigosInvalidos.contains(codigoUpper)) {
      return ResultadoDesconto(
        valido: false,
        mensagem: 'Sistema não liberou este cupom.',
      );
    }

    // Se o código não for encontrado em nenhuma das listas
    return ResultadoDesconto(
      valido: false,
      mensagem: 'Código de desconto inválido.',
    );
  }
}
