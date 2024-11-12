import 'package:flutter/material.dart';
import 'chat_sintomas.dart';

class Descricao extends StatelessWidget {
  const Descricao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF213597),
        title: const Text(
          'PETSCAN',
          style: TextStyle(
            color: Color(0xFFFFC107),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Centraliza o título na AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pressione o botão abaixo para descrever os sintomas do seu pet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF213597),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navega para a tela chat_sintomas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatSintomasPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF213597),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Descreva aqui',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            const Icon(
              Icons.pets,
              color: Colors.black,
              size: 30,
            ),
            const SizedBox(height: 30),
            // Removido o texto e o botão relacionados à captura de imagem
          ],
        ),
      ),
    );
  }
}
