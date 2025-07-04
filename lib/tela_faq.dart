import 'package:flutter/material.dart';

class TelaFAQ extends StatefulWidget {
  const TelaFAQ({super.key});

  @override
  State<TelaFAQ> createState() => _TelaFAQState();
}

class _TelaFAQState extends State<TelaFAQ> {
  // Conteúdo das FAQs focado no aplicativo
  final List<Map<String, String>> _faqs = [
    {
      'pergunta': 'Como faço para usar a calculadora de indicação?',
      'resposta': 'Na tela "Espessura", selecione "Calculadora de Indicação". Insira o Grau Esférico, Cilíndrico, Eixo, e Adição (se multifocal e esférico positivo). Escolha o Tipo de Lente e Material da Armação. Clique em "Salvar Escolha para Orçamento".',
    },
    {
      'pergunta': 'Onde insiro o Código AC?',
      'resposta': 'O Código AC é solicitado automaticamente ao entrar na tela de "Orçamento" pela primeira vez em uma nova sessão de cálculo. Você também pode alterá-lo a qualquer momento clicando no ícone de engrenagem (⚙️) no canto superior direito do menu principal.',
    },
    {
      'pergunta': 'Como aplico um desconto?',
      'resposta': 'Na tela de "Orçamento", após salvar a escolha da receita, você verá um campo para "Código de Desconto". Digite o código e clique em "Aplicar". O desconto será exibido logo abaixo.',
    },
    {
      'pergunta': 'O que significa o status "Atenção" ou "Não Recomendado" nas opções de lentes?',
      'resposta': 'O status "Não Recomendado" (vermelho) indica que a combinação de grau e armação não é ideal para aquela lente. "Atenção" (amarelo) sugere que a lente é uma opção, mas pode ter características (como adaptação ou estética) que merecem ser explicadas ao cliente.',
    },
    {
      'pergunta': 'Como gero e partilho o orçamento em PDF?',
      'resposta': 'Após selecionar a opção de lente desejada na tela de "Orçamento" e clicar em "Confirmar e Adicionar ao Orçamento", você será levado para a tela final do orçamento. Lá, clique no botão "Gerar e Partilhar" para criar o PDF e escolher como enviá-lo.',
    },
    {
      'pergunta': 'O aplicativo funciona offline?',
      'resposta': 'A funcionalidade offline está a ser implementada, mas no momento o aplicativo funciona apenas com conexão à internet. Os orçamentos criados offline serão sincronizados assim que a conexão for restabelecida.',
    },
    {
      'pergunta': 'Como as informações são exportadas para a planilha?',
      'resposta': 'Os orçamentos são automaticamente exportados para a planilha Google Sheets via Firebase Cloud Functions assim que são salvos no Firestore. Não é necessário um botão de exportação manual no aplicativo para isso.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // REMOVIDO: Scaffold e AppBar
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _faqs.map((faq) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              title: Text(
                faq['pergunta']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              childrenPadding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  faq['resposta']!,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
