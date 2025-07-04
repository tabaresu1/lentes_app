import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Importa o reprodutor do YouTube

// Modelo para um Tópico de treinamento
class ModuloTopico {
  final String id;
  final String tituloTopico;
  final String conteudo;
  final String? videoUrl; // Campo para o URL do vídeo

  ModuloTopico({required this.id, required this.tituloTopico, required this.conteudo, this.videoUrl});

  factory ModuloTopico.fromJson(Map<String, dynamic> json) {
    return ModuloTopico(
      id: json['id'] as String,
      tituloTopico: json['titulo_topico'] as String,
      conteudo: json['conteudo'] as String,
      videoUrl: json['video_url'] as String?, // Lendo o URL do JSON
    );
  }
}

// Modelo para um Módulo de treinamento (sem alterações)
class ModuloTreinamento {
  final String id;
  final String titulo;
  final String descricaoCurta;
  final List<ModuloTopico> topicos;

  ModuloTreinamento({
    required this.id,
    required this.titulo,
    required this.descricaoCurta,
    required this.topicos,
  });

  factory ModuloTreinamento.fromJson(Map<String, dynamic> json) {
    var topicosList = json['topicos'] as List;
    List<ModuloTopico> topicos = topicosList.map((i) => ModuloTopico.fromJson(i as Map<String, dynamic>)).toList();

    return ModuloTreinamento(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descricaoCurta: json['descricao_curta'] as String,
      topicos: topicos,
    );
  }
}

class TelaModulosTreinamento extends StatefulWidget {
  const TelaModulosTreinamento({super.key});

  @override
  State<TelaModulosTreinamento> createState() => _TelaModulosTreinamentoState();
}

class _TelaModulosTreinamentoState extends State<TelaModulosTreinamento> {
  List<ModuloTreinamento> _modulos = [];
  bool _isLoading = true;
  String? _selectedModuleId;
  String? _selectedTopicId;

  // Controlador do YouTube Player
  YoutubePlayerController? _ytController;
  String? _currentVideoId; // Para rastrear o ID do vídeo atualmente carregado

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  // Gerencia o ciclo de vida do controlador quando o widget é atualizado
  @override
  void didUpdateWidget(covariant TelaModulosTreinamento oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se o tópico selecionado mudou, ou se um tópico foi selecionado/desselecionado
    if (_selectedTopicId != null) {
      final selectedModule = _modulos.firstWhere((m) => m.id == _selectedModuleId);
      final selectedTopic = selectedModule.topicos.firstWhere((t) => t.id == _selectedTopicId);

      final newVideoId = YoutubePlayer.convertUrlToId(selectedTopic.videoUrl ?? '');

      // Se o ID do vídeo mudou ou se o controlador não existe, inicializa um novo
      if (newVideoId != _currentVideoId) {
        _ytController?.dispose(); // Descarta o controlador antigo
        _ytController = null; // Zera o controlador

        if (newVideoId != null) {
          _ytController = YoutubePlayerController(
            initialVideoId: newVideoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              loop: false,
              forceHD: false,
              enableCaption: false,
              controlsVisibleAtStart: true,
            ),
          )..addListener(() {
              // Opcional: Lógica para lidar com o estado do player
            });
          _currentVideoId = newVideoId;
        } else {
          _currentVideoId = null;
        }
      }
    } else {
      // Se nenhum tópico está selecionado, descarta o controlador
      _ytController?.dispose();
      _ytController = null;
      _currentVideoId = null;
    }
  }

  // Carrega os módulos do arquivo JSON
  Future<void> _loadModules() async {
    try {
      final String response = await rootBundle.loadString('assets/data/modulos_treinamento.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        _modulos = data.map((json) => ModuloTreinamento.fromJson(json as Map<String, dynamic>)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        debugPrint('Erro ao carregar módulos de treinamento: $e');
      });
    }
  }

  // Retorna a tela atual com base na seleção
  Widget _buildCurrentScreen() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_modulos.isEmpty) {
      return const Center(child: Text('Nenhum módulo de treinamento encontrado.'));
    }

    // Gerencia qual tela interna exibir (lista de módulos, lista de tópicos, conteúdo do tópico)
    if (_selectedModuleId != null && _selectedTopicId != null) {
      final selectedModule = _modulos.firstWhere((m) => m.id == _selectedModuleId);
      final selectedTopic = selectedModule.topicos.firstWhere((t) => t.id == _selectedTopicId);
      return _buildTopicContent(selectedTopic);
    } else if (_selectedModuleId != null) {
      final selectedModule = _modulos.firstWhere((m) => m.id == _selectedModuleId);
      return _buildModuleTopicsList(selectedModule);
    } else {
      return _buildModulesList();
    }
  }

  // Constrói a lista de módulos (AGORA SEM APPBAR)
  Widget _buildModulesList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _modulos.map((module) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(module.titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text(module.descricaoCurta),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                setState(() {
                  _selectedModuleId = module.id;
                  _selectedTopicId = null; // Garante que nenhum tópico esteja selecionado ao entrar no módulo
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // Constrói a lista de tópicos de um módulo (AGORA COM APPBAR INTERNA)
  Widget _buildModuleTopicsList(ModuloTreinamento module) {
    return Scaffold( // Scaffold para ter um AppBar interna
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(module.titulo, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0A2956),
        leading: IconButton( // Botão de voltar para a lista de módulos
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _selectedModuleId = null; // Volta para a lista de módulos
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: module.topicos.map((topic) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(topic.tituloTopico, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  setState(() {
                    _selectedTopicId = topic.id;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Constrói o conteúdo de um tópico (AGORA COM APPBAR INTERNA)
  Widget _buildTopicContent(ModuloTopico topic) {
    // O controlador _ytController agora é gerenciado em didUpdateWidget
    return Scaffold( // Scaffold para ter um AppBar interna
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(topic.tituloTopico, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0A2956),
        leading: IconButton( // Botão de voltar para a lista de tópicos
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _selectedTopicId = null; // Volta para a lista de tópicos
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_ytController != null) // Exibe o reprodutor de vídeo se houver
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: YoutubePlayer(
                  controller: _ytController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.blueAccent,
                  progressColors: const ProgressBarColors(
                    playedColor: Colors.blue,
                    handleColor: Colors.blueAccent,
                  ),
                  onReady: () {
                    // Opcional: Lógica quando o player está pronto
                  },
                ),
              ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  topic.conteudo,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ytController?.dispose(); // Importante: descartar o controlador do YouTube
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCurrentScreen();
  }
}
