import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class CadastroPage extends StatelessWidget {
  CadastroPage({super.key});

  // Controladores para os campos de entrada
  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();
  var txtName = TextEditingController();

  // Função para registrar o usuário no Firebase
  void register(BuildContext context) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: txtEmail.text, password: txtPassword.text);

      // Atualiza o nome do usuário
      await credential.user!.updateDisplayName(txtName.text);

      // Navega para a tela inicial após o cadastro
      Navigator.pushReplacementNamed(context, '/descricao');
    } on FirebaseAuthException catch (ex) {
      var snackBar = SnackBar(
          content: Text(ex.message!), backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF213597), // Cor de fundo
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
                'Ainda não possui cadastro? Faça seu login aqui:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),

              // Formulário de Cadastro
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Campo de Nome
                    TextField(
                      controller: txtName,
                      decoration: InputDecoration(
                        labelText: 'NOME',
                        hintText: 'Insira seu nome',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

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

                    // Botão de Cadastro
                    ElevatedButton(
                      onPressed: () => register(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple, // Cor do botão
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Cadastre-se'),
                    ),
                    const SizedBox(height: 20),

                    // Botão para voltar ao Login
                    TextButton(
                      onPressed: () {
                        // Retorna para a tela de login
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Voltar ao login",
                        style: TextStyle(color: Colors.purple),
                      ),
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