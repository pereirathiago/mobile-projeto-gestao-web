import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/pages/cadastro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lista_tarefas_page.dart';
import 'package:my_app/constantes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'TODO',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bem-vindo(a) de volta!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Seu email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Sua senha',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 12,
                ),
              ),
              onPressed: () async {
                final email = emailController.text.trim();
                final senha = senhaController.text.trim();

                final emailValido = RegExp(
                  r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(email);

                if (email.isEmpty || senha.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos')),
                  );
                  return;
                }

                if (!emailValido) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email inválido')),
                  );
                  return;
                }

                // Tenta autenticar com a API
                final url = Uri.parse('$baseUrl/tarefas');

                try {
                  // Simples autenticação HTTP Basic
                  String basicAuth =
                      'Basic ' + base64Encode(utf8.encode('$email:$senha'));

                  final response = await http.get(
                    url,
                    headers: {'authorization': basicAuth},
                  );

                  if (response.statusCode == 200) {
                    // Salva credenciais
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('email', email);
                    await prefs.setString('senha', senha);

                    // Limpa os campos
                    emailController.clear();
                    senhaController.clear();

                    // Navega
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ListaTarefasPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login inválido: ${response.statusCode}'),
                      ),
                    );
                  }
                } catch (e) {
                  print('Erro na autenticação: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erro ao conectar com o servidor'),
                    ),
                  );
                }
              },

              child: const Text(
                'ENTRAR',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Ainda não tem uma conta?'),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CadastroPage()),
                );
              },
              child: const Text(
                'Cadastre-se aqui',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
