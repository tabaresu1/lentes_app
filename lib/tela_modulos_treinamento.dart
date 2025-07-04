import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ModuloTopico {
  final String id;
  final String tituloTopico;
  final String conteudo;
  final String? videoUrl;

  ModuloTopico({required this.id, required this.tituloTopico, required this.conteudo, this.videoUrl});

  factory ModuloTopico.fromJson(Map<String, dynamic> json) {
    return ModuloTopico(
      id: json['id'],
      tituloTopico: json['titulo_topico'],
      conteudo: json['conteudo'],
      videoUrl: json['video_url'],
    );
  }
}

class ModuloTreinamento {
  final String id;
  final String titulo;
  final String descricaoCurta;
  final String categoria;
  final List<ModuloTopico> topicos;

  ModuloTreinamento({
    required this.id,
    required this.titulo,
    required this.descricaoCurta,
    required this.categoria,
    required this.topicos,
  });

  factory ModuloTreinamento.fromJson(Map<String, dynamic> json) {
    var topicosList = json['topicos'] as List;
    List<ModuloTopico> topicos = topicosList.map((i) => ModuloTopico.fromJson(i)).toList();

    return ModuloTreinamento(
      id: json['id'],
      titulo: json['titulo'],
      descricaoCurta: json['descricao_curta'],
      categoria: json['categoria'],
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
  String? _selectedCategoria;
  String? _selectedModuleId;
  String? _selectedTopicId;
  YoutubePlayerController? _ytController;
  String? _currentVideoId;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  @override
  void didUpdateWidget(covariant TelaModulosTreinamento oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedTopicId != null) {
      final selectedModule = _modulos.firstWhere((m) => m.id == _selectedModuleId);
      final selectedTopic = selectedModule.topicos.firstWhere((t) => t.id == _selectedTopicId);
      final newVideoId = YoutubePlayer.convertUrlToId(selectedTopic.videoUrl ?? '');
      if (newVideoId != _currentVideoId) {
        _ytController?.dispose();
        _ytController = null;
        if (newVideoId != null) {
          _ytController = YoutubePlayerController(
            initialVideoId: newVideoId,
            flags: const YoutubePlayerFlags(autoPlay: false),
          );
          _currentVideoId = newVideoId;
        } else {
          _currentVideoId = null;
        }
      }
    } else {
      _ytController?.dispose();
      _ytController = null;
      _currentVideoId = null;
    }
  }

  Future<void> _loadModules() async {
    try {
      final String response = await rootBundle.loadString('assets/data/modulos_treinamento.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        _modulos = data.map((json) => ModuloTreinamento.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        debugPrint('Erro ao carregar módulos: $e');
      });
    }
  }

  Widget _buildCategoriaMenu() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treinamentos'),
        backgroundColor: const Color(0xFF0A2956),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Selecione a categoria:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            _buildCategoriaCard('App', Colors.blue, () => setState(() => _selectedCategoria = 'app')),
            const SizedBox(height: 16),
            _buildCategoriaCard('Vendedores', Colors.green, () => setState(() => _selectedCategoria = 'vendedores')),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriaCard(String titulo, Color cor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cor, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.play_circle_fill, color: cor, size: 36),
            const SizedBox(width: 16),
            Expanded(child: Text(titulo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cor))),
          ],
        ),
      ),
    );
  }

  Widget _buildModulesList() {
    final modulosFiltrados = _modulos.where((m) => m.categoria == _selectedCategoria).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulos'),
        backgroundColor: const Color(0xFF0A2956),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => setState(() => _selectedCategoria = null),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: modulosFiltrados.map((module) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(module.titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text(module.descricaoCurta),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => setState(() => _selectedModuleId = module.id),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildModuleTopicsList(ModuloTreinamento module) {
    return Scaffold(
      appBar: AppBar(
        title: Text(module.titulo, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0A2956),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => setState(() => _selectedModuleId = null),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: module.topicos.map((topic) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(topic.tituloTopico, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => setState(() => _selectedTopicId = topic.id),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopicContent(ModuloTopico topic) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.tituloTopico, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0A2956),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => setState(() => _selectedTopicId = null),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_ytController != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: YoutubePlayer(
                  controller: _ytController!,
                  showVideoProgressIndicator: true,
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

  Widget _buildCurrentScreen() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_selectedCategoria == null) return _buildCategoriaMenu();
    if (_selectedModuleId == null) return _buildModulesList();
    final selectedModule = _modulos.firstWhere((m) => m.id == _selectedModuleId);
    if (_selectedTopicId == null) return _buildModuleTopicsList(selectedModule);
    final selectedTopic = selectedModule.topicos.firstWhere((t) => t.id == _selectedTopicId);
    return _buildTopicContent(selectedTopic);
  }

  @override
  void dispose() {
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildCurrentScreen();
}
