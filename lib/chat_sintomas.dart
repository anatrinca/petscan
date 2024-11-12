import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'gemini_service.dart'; // Importar o serviço

class ChatSintomasPage extends StatefulWidget {
  const ChatSintomasPage({super.key});

  @override
  _ChatSintomasPageState createState() => _ChatSintomasPageState();
}

class _ChatSintomasPageState extends State<ChatSintomasPage> {
  TextEditingController _sintomasController = TextEditingController();
  File? _imagemPet;
  Uint8List? _webImagemPet;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Função para selecionar imagem da galeria
  Future<void> _selecionarImagem() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        _webImagemPet = await pickedFile.readAsBytes();
      } else {
        _imagemPet = File(pickedFile.path);
      }
      setState(() {});
    }
  }

  // Função para tirar foto
  Future<void> _tirarFoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        _webImagemPet = await pickedFile.readAsBytes();
      } else {
        _imagemPet = File(pickedFile.path);
      }
      setState(() {});
    }
  }

  // Função para enviar sintomas e imagem para o Gemini e abrir o popup
// Função para enviar sintomas e imagem para o Gemini e abrir o popup
  Future<void> _enviarSintomas() async {
    if (_sintomasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Descreva os sintomas do seu pet.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Codificar imagem em Base64 se necessário
      String imagemBase64 = "";
      if (_imagemPet != null) {
        List<int> imageBytes = await _imagemPet!.readAsBytes();
        imagemBase64 = base64Encode(imageBytes);
      } else if (_webImagemPet != null) {
        imagemBase64 = base64Encode(_webImagemPet!);
      }

      // Chama o serviço Gemini
      GeminiService geminiService = GeminiService();
      Map<String, dynamic> respostaGemini = await geminiService.enviarSintomas(
        _sintomasController.text,
        imagemBase64,
      );

      // Mostrar o resultado do Gemini em um popup
      if (!mounted) return;
      _showPopup(respostaGemini);

      // Enviar para Firestore
      await FirebaseFirestore.instance.collection('historico_pesquisas').add({
        'sintomas': _sintomasController.text,
        'respostaGemini': respostaGemini.toString(),
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar sintomas: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Função para exibir o popup com a resposta do Gemini
  void _showPopup(Map<String, dynamic> respostaGemini) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Extrair o texto da resposta do Gemini
        String respostaTexto = respostaGemini['candidates']?[0]?['content']
                ?['parts']?[0]?['text'] ??
            'Não foi possível obter a resposta';

        // Separar as seções da resposta
        Map<String, String> secoes = {};

        // Lista de todas as seções que queremos extrair
        List<String> secoesDesejadas = [
          'OBSERVAÇÕES GERAIS',
          'POSSÍVEIS SITUAÇÕES COMUNS',
          'CUIDADOS BÁSICOS SUGERIDOS',
          'IMPORTANTE'
        ];

        // Extrair cada seção
        for (int i = 0; i < secoesDesejadas.length; i++) {
          String secaoAtual = secoesDesejadas[i];
          String secaoProxima =
              i < secoesDesejadas.length - 1 ? secoesDesejadas[i + 1] : '';

          int inicioSecao = respostaTexto.indexOf('$secaoAtual:');
          int fimSecao = secaoProxima.isNotEmpty
              ? respostaTexto.indexOf('$secaoProxima:')
              : respostaTexto.length;

          if (inicioSecao != -1) {
            String conteudoSecao = respostaTexto
                .substring(inicioSecao + secaoAtual.length + 1, fimSecao)
                .trim();
            secoes[secaoAtual] = conteudoSecao;
          }
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Análise dos Sintomas',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF213597),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...secoesDesejadas.map((secao) {
                    if (secoes.containsKey(secao)) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            secao,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF213597),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            secoes[secao]!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }
                    return Container();
                  }).toList(),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF213597),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Fechar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat de Sintomas'),
        backgroundColor: const Color(0xFF213597),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (kIsWeb && _webImagemPet != null)
                  Image.memory(_webImagemPet!)
                else if (_imagemPet != null)
                  Image.file(_imagemPet!)
                else
                  const Text(
                    'Nenhuma imagem selecionada.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                const SizedBox(height: 10),
                TextField(
                  controller: _sintomasController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Digite os sintomas aqui...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera),
                      label: const Text('Tirar Foto'),
                      onPressed: _tirarFoto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF213597),
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Selecionar da Galeria'),
                      onPressed: _selecionarImagem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF213597),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _enviarSintomas,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                    ),
                    child: const Text(
                      'Enviar Sintomas',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
