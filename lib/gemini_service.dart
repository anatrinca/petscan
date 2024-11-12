import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=COLOQUE SUA CHAVE DO GEMINI AQUI!';

  Future<Map<String, dynamic>> enviarSintomas(
      String sintomas, String imagemBase64) async {
    // Criando um prompt mais específico e cuidadoso
    String prompt = """
    Com base na imagem e nos sintomas descritos: "$sintomas"

    Por favor, forneça uma análise educacional geral, NÃO como diagnóstico médico, mas como informações básicas que podem ajudar tutores a entenderem melhor a situação. 

    Responda no seguinte formato:

    OBSERVAÇÕES GERAIS:
    [Liste observações gerais sobre os sintomas descritos]

    POSSÍVEIS SITUAÇÕES COMUNS:
    [Liste algumas situações comuns que podem apresentar sintomas similares]

    CUIDADOS BÁSICOS SUGERIDOS:
    [Liste cuidados básicos gerais]

    IMPORTANTE:
    [Inclua uma mensagem sobre a importância de consultar um veterinário para diagnóstico adequado]
    """;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
              if (imagemBase64.isNotEmpty)
                {
                  "inlineData": {"mimeType": "image/jpeg", "data": imagemBase64}
                }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.4,
          "topK": 32,
          "topP": 1,
          "maxOutputTokens": 2048,
        }
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Erro ao enviar para Gemini: ${response.statusCode} - ${response.body}');
    }
  }
}
