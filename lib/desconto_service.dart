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
  static const String senhaValida = 'VENDA';
  static const String senhaInvalida = 'SEMVENDA';

  // Função principal para aplicar um código
  static ResultadoDesconto aplicarCodigo(
    String codigo,
    double descontoAtual,
    Set<String> codigosJaAplicados, {
    double? percentualDigitado,
  }) {
    final codigoUpper = codigo.toUpperCase();

    // Não permite campo de senha vazio
    if (codigoUpper.isEmpty) {
      return ResultadoDesconto(
        valido: false,
        mensagem: 'Digite a senha para aplicar o desconto.',
      );
    }


    if (codigoUpper == senhaValida) {
      final novoDesconto = (percentualDigitado ?? 0.0) / 100.0;
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

    if (codigoUpper == senhaInvalida) {
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
