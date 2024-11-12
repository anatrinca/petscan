import 'package:flutter/material.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF213597),
      body: Stack( // Stack para posicionar o botão no canto inferior direito
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD1C4E9),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.pets,
                      color: Color(0xFFFFC107),
                      size: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'PETSCAN',
                  style: TextStyle(
                    color: Color(0xFFFFC107),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Cuidado inteligente, amor incondicional',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Positioned( // Posicionando o botão no canto inferior direito
            bottom: 30,
            right: 30,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Acesse a próxima tela
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107), // Cor do botão
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Espaçamento do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Borda arredondada
                ),
              ),
              child: const Text(
                "Próximo",
                style: TextStyle(
                  color: Colors.white, // Cor do texto
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}