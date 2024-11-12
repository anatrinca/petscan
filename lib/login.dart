import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  void login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: txtEmail.text,
        password: txtPassword.text,
      );

      // Navega para a tela inicial após o login
      Navigator.pushReplacementNamed(context, '/descricao');
    } on FirebaseAuthException catch (ex) {
      var snackBar = SnackBar(
        content: Text(ex.message!),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF213597), // Mesma cor de fundo
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo do PETSCAN
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
                'Já tem cadastro? Faça seu login aqui:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),

              // Formulário de Login
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Campo de Email
                    TextField(
                      controller: txtEmail,
                      decoration: InputDecoration(
                        labelText: 'EMAIL',
                        hintText: 'Insira seu e-mail',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Campo de Senha
                    TextField(
                      controller: txtPassword,
                      obscureText: true, // Para ocultar a senha
                      decoration: InputDecoration(
                        labelText: 'PASSWORD',
                        hintText: '******',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Botão de Login
                    ElevatedButton(
                      onPressed: () =>
                          login(context), // Chama o método de login
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple, // Cor do botão
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        textStyle:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      child: const Text("Cadastre-se"),
                      onPressed: () {
                        Navigator.pushNamed(context, '/cadastro');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
