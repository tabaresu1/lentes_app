import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'orcamento_service.dart'; // Para acessar o setAcrescimo

class TelaLoginAC extends StatefulWidget {
  final ValueChanged<bool> onLoginSuccess; // Callback para notificar o sucesso do login

  const TelaLoginAC({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<TelaLoginAC> createState() => _TelaLoginACState();
}

class _TelaLoginACState extends State<TelaLoginAC> {
  final TextEditingController _usernameController = TextEditingController(); // NOVO: Controlador para o nome de usuário
  final TextEditingController _acCodeController = TextEditingController();
  bool _isLoading = false; // Estado para controlar o loading do botão

  // NOVO: Lista de usuários aceitos para padronização
  static const List<String> USUARIOS_ACEITOS = [
    'vendedor1',
    'vendedor2',
    'vendedor3',
    'vendedor4',
    'vendedor5',
    // Adicione mais nomes de usuários aqui, em maiúsculas
  ]; 

  void _performLogin() async {
    // Esconder o teclado antes de prosseguir
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true; // Ativa o loading
    });

    final String username = _usernameController.text.trim().toUpperCase(); // Pega o nome de usuário e converte para maiúsculas
    final String acCode = _acCodeController.text.trim();

    // Validação do nome de usuário
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira o nome de usuário.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() { _isLoading = false; });
      return;
    }
    // NOVO: Verifica se o nome de usuário está na lista de USUARIOS_ACEITOS
    if (!USUARIOS_ACEITOS.contains(username)) { 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nome de usuário inválido.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() { _isLoading = false; });
      return;
    }

    // Validação do Código AC (senha)
    if (acCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira o Código AC (senha).'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() { _isLoading = false; });
      return;
    }
    
    // Chama o setAcrescimo do OrcamentoService para "validar" e aplicar o AC
    // A validação real do AC (se ele é numérico e >= 100) já acontece no setAcrescimo.
    context.read<OrcamentoService>().setAcrescimo(acCode);

    // Simulação de delay para efeito visual de "login"
    await Future.delayed(const Duration(seconds: 1)); 

    // Notifica a tela pai que o login foi bem-sucedido APENAS se o AC foi validado pelo service
    // Se o AC inserido for inválido (setAcrescimo define _isAcCodeSetForCurrentSession como false)
    // a onLoginSuccess será chamada com false, e a TelaOrcamento pode reagir a isso.
    final bool acCodeSuccessfullySet = context.read<OrcamentoService>().isAcCodeSetForCurrentSession;
    widget.onLoginSuccess(acCodeSuccessfullySet); 

    setState(() {
      _isLoading = false; // Desativa o loading
    });
  }

  @override
  void dispose() {
    _usernameController.dispose(); // Descarte do controlador
    _acCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2956), // Cor de fundo da tela de login
      body: Center(
        child: SingleChildScrollView( // Permite rolar se o teclado aparecer
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo ou Título do App
              const Text(
                'Visão 360',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Guia de Lentes e Orçamento',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 60),

              // Campo de entrada do Nome de Usuário
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nome de Usuário',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white54, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16), // Espaçamento entre os campos

              // Campo de entrada do Código AC (agora como senha)
              SizedBox(
                width: 300, // Largura fixa para o campo
                child: TextField(
                  controller: _acCodeController,
                  decoration: InputDecoration(
                    labelText: 'Código AC (Senha)', // Texto do label alterado
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white54, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                  obscureText: true, // Esconde o texto para simular senha
                ),
              ),
              const SizedBox(height: 30),

              // Botão de Entrar
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _performLogin, // Desabilita o botão enquanto carrega
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 8,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white) // Indicador de loading
                      : const Text('Entrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}