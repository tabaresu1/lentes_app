import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart'; // Para acessar o setAcrescimo

class TelaLoginAC extends StatefulWidget {
  // onLoginSuccess removido, pois a notificação é via Provider.
  const TelaLoginAC({Key? key}) : super(key: key);

  @override
  State<TelaLoginAC> createState() => _TelaLoginACState();
}

class _TelaLoginACState extends State<TelaLoginAC> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _acCodeController = TextEditingController();
  bool _isLoading = false;

  // Lista de usuários aceitos para padronização
  static const List<String> USUARIOS_ACEITOS = [
    'REI.VENDAS1',
    'REI.VENDAS2',
    'REI.VENDAS3',
    'POP.VENDAS1',
    'POP.VENDAS2',
    'POP.VENDAS3',
    // Adicione mais nomes de usuários aqui, em MAIÚSCULAS
  ]; 

  void _performLogin() async {
    // Esconder o teclado antes de prosseguir
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    final String username = _usernameController.text.trim().toUpperCase();
    final String acCode = _acCodeController.text.trim();

    // Validação do nome de usuário
    if (username.isEmpty) {
      if (!mounted) return; // Verifica se o widget ainda está montado
      _showSnackBar('Por favor, insira o nome de usuário.', Colors.red);
      setState(() { _isLoading = false; });
      return;
    }
    if (!USUARIOS_ACEITOS.contains(username)) { 
      if (!mounted) return; // Verifica se o widget ainda está montado
      _showSnackBar('Nome de usuário inválido.', Colors.red);
      setState(() { _isLoading = false; });
      return;
    }

    // Validação do Código AC (senha)
    if (acCode.isEmpty) {
      if (!mounted) return; // Verifica se o widget ainda está montado
      _showSnackBar('Por favor, insira o Código AC.', Colors.red);
      setState(() { _isLoading = false; });
      return;
    }
    
    // Chama o setAcrescimo do OrcamentoService para "validar" e aplicar o AC
    context.read<OrcamentoService>().setAcrescimo(acCode);

    await Future.delayed(const Duration(seconds: 1)); 

    // Verifica se o widget ainda está montado ANTES de interagir com o estado ou context
    if (!mounted) return; 

    final bool acCodeSuccessfullySet = context.read<OrcamentoService>().isAcCodeSetForCurrentSession;
    if (acCodeSuccessfullySet) {
      _showSnackBar('Login AC realizado com sucesso!', Colors.green);
      // Não é mais necessário um callback 'onLoginSuccess' para a tela pai diretamente.
      // A TelaMenu agora observará o OrcamentoService para mudar de tela.
    } else {
      _showSnackBar('Código AC inválido. Acréscimo não aplicado.', Colors.orange);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return; // Verifica se o widget ainda está montado antes de mostrar SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _acCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center( // Conteúdo da tela de login, sem Scaffold, para ser usado no IndexedStack
      child: SingleChildScrollView( // Permite rolar se o teclado aparecer
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Login - Código AC',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A2956),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Insira suas credenciais para acessar o orçamento.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 60),

            SizedBox(
              width: 300,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nome de Usuário',
                  labelStyle: const TextStyle(color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF0A2956), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: 300,
              child: TextField(
                controller: _acCodeController,
                decoration: InputDecoration(
                  labelText: 'Código AC (Senha)',
                  labelStyle: const TextStyle(color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF0A2956), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.black, fontSize: 18),
                textAlign: TextAlign.center,
                obscureText: true,
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _performLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A2956),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  elevation: 8,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Entrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
