import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ADICIONE ESTE IMPORT
import 'components/barra_superior.dart' as barra_superior;
import 'tratamentoLente.dart';
import 'espessuraLente.dart';
import 'campoVisao.dart';

class PaginasComBarraSuperior extends StatefulWidget {
  final int paginaInicial;
  const PaginasComBarraSuperior({Key? key, this.paginaInicial = 0}) : super(key: key);

  @override
  State<PaginasComBarraSuperior> createState() => _PaginasComBarraSuperiorState();
}

class _PaginasComBarraSuperiorState extends State<PaginasComBarraSuperior> {
  late int paginaAtual;

  @override
  void initState() {
    super.initState();
    paginaAtual = widget.paginaInicial;
  }

  @override
  Widget build(BuildContext context) {
    // MUDANÇA PRINCIPAL: Reafirmamos o modo de tela cheia aqui
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Mantemos a estrutura de layout mais robusta que montamos
    return Material(
      child: Container(
        color: const Color.fromRGBO(224, 224, 224, 1),
        child: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            children: [
              barra_superior.BarraSuperior(
                paginaAtual: barra_superior.PaginaMenu.values[paginaAtual],
                aoSelecionar: (index) {
                  setState(() {
                    paginaAtual = index;
                  });
                },
              ),
              Expanded(
                child: IndexedStack(
                  index: paginaAtual,
                  children: const [
                    TelaTratamentoLente(),
                    TelaEspessuraLente(),
                    TelaCampoVisao(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}