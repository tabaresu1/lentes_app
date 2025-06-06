import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor; // Cor do texto
  // REMOVER: final double width; // Não vamos mais forçar uma largura fixa aqui
  // REMOVER: final double height; // A altura será mais baseada no padding e fonte
  final double borderRadius;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding; // Adicionar parâmetro de padding

  const MenuButton({
    super.key,
    required this.texto,
    required this.onPressed,
    this.backgroundColor = Colors.white, // Branco (padrão da TelaMenu)
    this.foregroundColor = Colors.black,           // Preto (padrão da TelaMenu)
    this.borderRadius = 32.0,
    this.textStyle = const TextStyle(
      fontSize: 28, // Manteremos um bom tamanho de fonte base
      fontWeight: FontWeight.bold,
    ),
    // Definir um padding padrão que dê uma boa altura e espaço interno
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
  });

  @override
  Widget build(BuildContext context) {
    // REMOVER: O SizedBox externo que fixava a largura e altura
    // O ElevatedButton agora vai se dimensionar com base no seu padding e no conteúdo (texto)
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        textStyle: textStyle,
        padding: padding, // Usar o padding para controlar o tamanho interno e, consequentemente, a altura
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.4),
        // minimumSize: Size(width, height), // Removido para não forçar tamanho mínimo fixo
      ),
      onPressed: onPressed,
      child: Text(texto, textAlign: TextAlign.center),
    );
  }
}