import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoricoPesquisasPage extends StatelessWidget {
  const HistoricoPesquisasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Histórico de Pesquisas',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFFFFC107),
          ),
        ),
        backgroundColor: const Color(0xFF213597),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('historico_pesquisas')
              .where('user_id', isEqualTo: 'ID_DO_USUARIO') // Atualize com o ID do usuário atual
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhuma pesquisa encontrada.',
                  style: TextStyle(fontSize: 18, color: Color(0xFF213597)),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      data['sintomas'] ?? 'Sintomas não especificados',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF213597),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      data['respostaGemini'] ?? 'Sem resposta do Gemini AI',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    trailing: Text(
                      (data['timestamp'] as Timestamp).toDate().toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.black38),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}