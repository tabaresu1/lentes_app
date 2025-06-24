import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'orcamento_service.dart';

class PdfGenerator {
  static Future<void> generateAndSharePdf(OrcamentoService orcamento) async {
    final pdf = pw.Document();

    if (orcamento.itensFinais.isEmpty) {
      throw Exception('Não há itens no orçamento para gerar o PDF.');
    }

    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    // Calcula o valor original total (sem nenhum desconto)
    double totalOriginal = 0.0;
    if (orcamento.itensFinais.isNotEmpty) {
      totalOriginal = orcamento.itensFinais.first.precoOriginalItem;
    }

    // Calcula o valor total do desconto
    double valorTotalDesconto = totalOriginal - orcamento.total;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Orçamento - Visão 360', style: pw.TextStyle(font: boldFont, fontSize: 20)),
                    pw.Text(DateTime.now().toLocal().toString().substring(0, 16)),
                  ],
                ),
              ),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),

              // Exibe dados da prescrição e armação logo no início do PDF
              if (orcamento.prescricaoTemp != null) ...[
                pw.Text(
                  'Material da armação: ${orcamento.prescricaoTemp!.tipoArmacao.toString().split('.').last}',
                  style: pw.TextStyle(font: font, fontSize: 14),
                ),
                pw.Text(
                  'Grau esférico: ${orcamento.prescricaoTemp!.esferico.toStringAsFixed(2)}',
                  style: pw.TextStyle(font: font, fontSize: 14),
                ),
                pw.Text(
                  'Grau cilíndrico: ${orcamento.prescricaoTemp!.cilindrico.toStringAsFixed(2)}',
                  style: pw.TextStyle(font: font, fontSize: 14),
                ),
                pw.SizedBox(height: 10),
              ],

              pw.Text('Itens do Orçamento', style: pw.TextStyle(font: boldFont, fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(font: boldFont),
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                headers: ['Categoria', 'Descrição', 'Preço', 'Armação', 'Esférico', 'Cilíndrico'],
                data: orcamento.itensFinais.map((item) => [
                  item.categoria,
                  item.descricao,
                  'R\$ ${item.precoOriginalItem.toStringAsFixed(2)}',
                  item.tipoArmacao,
                  item.esferico.toStringAsFixed(2),
                  item.cilindrico.toStringAsFixed(2),
                ]).toList(),
              ),
              pw.SizedBox(height: 20),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: 250,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Divider(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Valor Orçado:', style: pw.TextStyle(font: font, fontSize: 16)),
                          pw.Text('R\$ ${totalOriginal.toStringAsFixed(2)}', style: pw.TextStyle(font: font, fontSize: 16)),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Desconto Aplicado:', style: pw.TextStyle(font: font, fontSize: 16)),
                          pw.Text(
                            '- R\$ ${valorTotalDesconto.toStringAsFixed(2)} (${(orcamento.itensFinais.isNotEmpty ? orcamento.itensFinais.first.percentagemDescontoAplicada * 100 : 0).toStringAsFixed(0)}%)',
                            style: pw.TextStyle(font: font, fontSize: 16, color: PdfColors.red),
                          ),
                        ],
                      ),
                      pw.Divider(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('TOTAL FINAL:', style: pw.TextStyle(font: boldFont, fontSize: 18)),
                          pw.Text('R\$ ${orcamento.total.toStringAsFixed(2)}', style: pw.TextStyle(font: boldFont, fontSize: 18, color: PdfColors.green)),
                        ],
                      ),
                    ]
                  )
                )
              ),
              pw.Spacer(),

              pw.Divider(),
              pw.Text('Obrigado pela preferência! Este orçamento é válido por 30 dias.'),
            ]
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File("${output.path}/orcamento_$timestamp.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(bytes: await file.readAsBytes(), filename: 'orcamento-visao360.pdf');
  }
}
