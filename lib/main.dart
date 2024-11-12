import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'inicio.dart'; // importei o inicio
import 'login.dart'; // importei o login
import 'cadastro.dart'; // importado cadastro
import 'descricao.dart'; // importado descrição
import 'chat_sintomas.dart'; // Importando a tela chat_sintomas

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu App',
      initialRoute: '/inicio', // Primeira tela a aparecer
      routes: {
        '/inicio': (context) => const Inicio(), // Home screen
        '/login': (context) => LoginPage(), // Login screen
        '/cadastro': (context) => CadastroPage(), // Cadastro
        '/descricao': (context) => const Descricao(), // Descrição Page
        '/chat_sintomas': (context) =>
            ChatSintomasPage(), // Nova rota para chat_sintomas
      },
    );
  }
}
