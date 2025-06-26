import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart'; // Para acessar o setAcrescimo

class TelaLoginAC extends StatefulWidget {
  const TelaLoginAC({Key? key}) : super(key: key);

  @override
  State<TelaLoginAC> createState() => _TelaLoginACState();
}

class _TelaLoginACState extends State<TelaLoginAC> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _acCodeController = TextEditingController();
  bool _isLoading = false;

  static const List<String> USUARIOS_ACEITOS = [
    'REI.VENDAS1',
    'REI.VENDAS2',
    'REI.VENDAS3',
    'POP.VENDAS1',
    'POP.VENDAS2',
    'POP.VENDAS3',
  ];

  void _performLogin() async {
    setState(() => _isLoading = true);

    final username = _usernameController.text.trim().toUpperCase();
    final acCode = _acCodeController.text.trim();

    if (username.isEmpty) {
      _showSnackBar('Por favor, insira o nome de usuário.', Colors.red);
      setState(() => _isLoading = false);
      return;
    }

    if (!USUARIOS_ACEITOS.contains(username)) {
      _showSnackBar('Nome de usuário inválido.', Colors.red);
      setState(() => _isLoading = false);
      return;
    }

    if (acCode.isEmpty) {
      _showSnackBar('Por favor, insira senha.', Colors.red);
      setState(() => _isLoading = false);
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Salva o usuário logado no service!
    print('Chamando setUsuarioLogado com: $username');
    context.read<OrcamentoService>().setUsuarioLogado(username);

    context.read<OrcamentoService>().setAcrescimo(acCode);

    final bool acCodeSuccessfullySet = context.read<OrcamentoService>().isAcCodeSetForCurrentSession;

    if (acCodeSuccessfullySet) {
      _showSnackBar('Login realizado com sucesso!', Colors.green);
      // Navegue para a próxima tela, se necessário
    } else {
      _showSnackBar('Senha incorreta.', Colors.red);
    }

    setState(() => _isLoading = false);
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
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
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Login',
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
                  labelText: 'Senha',
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
