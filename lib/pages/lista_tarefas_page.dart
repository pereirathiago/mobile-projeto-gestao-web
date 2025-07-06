import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/pages/editar_tarefa_page.dart';
import 'cadastrar_tarefa_page.dart';
import 'login_page.dart';
import 'package:my_app/constantes.dart';

class ListaTarefasPage extends StatefulWidget {
  const ListaTarefasPage({super.key});

  @override
  State<ListaTarefasPage> createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {
  List<Map<String, dynamic>> tarefas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarTarefas();
  }

  Future<void> _buscarTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final senha = prefs.getString('senha');

    if (email == null || senha == null) {
      // Retorna à tela de login se não houver credenciais
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
      return;
    }

    final client = BasicAuthClient(email, senha);
    final url = Uri.parse('$baseUrl/tarefas');

    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final List dados = jsonDecode(response.body);
        setState(() {
          tarefas =
              dados.map<Map<String, dynamic>>((item) {
                return {
                  'id': item['id'],
                  'descricao': item['descricao'],
                  'concluida': item['concluida'] ?? false,
                };
              }).toList();

          carregando = false;
        });
      } else {
        throw Exception('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar tarefas: $e');
      setState(() {
        carregando = false;
      });
    }
  }

  Future<void> adicionarTarefa(String descricao, bool concluida) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final senha = prefs.getString('senha');

    if (email == null || senha == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
      return;
    }

    final client = BasicAuthClient(email, senha);
    final url = Uri.parse('$baseUrl/tarefas');

    final body = jsonEncode({'descricao': descricao, 'concluida': concluida});

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final novaTarefa = jsonDecode(response.body);
        setState(() {
          tarefas.add({
            'id': novaTarefa['id'],
            'descricao': novaTarefa['descricao'],
            'concluida': novaTarefa['concluida'],
          });
        });
      } else {
        print('Erro ao criar tarefa: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição POST: $e');
    }
  }

  Future<void> removerTarefa(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final senha = prefs.getString('senha');

    if (email == null || senha == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
      return;
    }

    final tarefaId = tarefas[index]['id'];
    final client = BasicAuthClient(email, senha);
    final url = Uri.parse('$baseUrl/tarefas/$tarefaId');

    try {
      final response = await client.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          tarefas.removeAt(index);
        });
      } else {
        print('Erro ao deletar tarefa: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição DELETE: $e');
    }
  }

  Future<void> atualizarStatusConclusaoTarefa(int index, bool concluida) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final senha = prefs.getString('senha');

    if (email == null || senha == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
      return;
    }

    final tarefa = tarefas[index];
    final tarefaId = tarefa['id'];

    final client = BasicAuthClient(email, senha);
    final url = Uri.parse('$baseUrl/tarefas/$tarefaId');

    final body = jsonEncode({
      'descricao': tarefa['descricao'],
      'concluida': concluida,
    });

    try {
      final response = await client.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          tarefas[index]['concluida'] = concluida;
        });
      } else {
        print('Erro ao atualizar tarefa: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição PUT: $e');
    }
  }

  Future<void> editarTarefa(int id, String descricao, bool concluida) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final senha = prefs.getString('senha');

    if (email == null || senha == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
      return;
    }

    final client = BasicAuthClient(email, senha);
    final url = Uri.parse('$baseUrl/tarefas/$id');

    final body = jsonEncode({'descricao': descricao, 'concluida': concluida});

    try {
      final response = await client.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          final index = tarefas.indexWhere((t) => t['id'] == id);
          if (index != -1) {
            tarefas[index] = {
              'id': id,
              'descricao': descricao,
              'concluida': concluida,
            };
          }
        });
      } else {
        print('Erro ao editar tarefa: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao editar tarefa: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('email');
              await prefs.remove('senha');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body:
          carregando
              ? const Center(child: CircularProgressIndicator())
              : tarefas.isEmpty
              ? const Center(child: Text('Nenhuma tarefa encontrada.'))
              : ListView.builder(
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  final tarefa = tarefas[index];

                  return ListTile(
                    title: Text(
                      tarefa['descricao'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('ID: ${tarefa['id']}'),
                    leading: Checkbox(
                      value: tarefa['concluida'],
                      onChanged: (value) {
                        if (value != null) {
                          atualizarStatusConclusaoTarefa(index, value);
                        }
                      },
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final tarefa = tarefas[index];

                            final resultado = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => EditarTarefaPage(
                                      id: tarefa['id'],
                                      descricaoInicial: tarefa['descricao'],
                                      concluidaInicial: tarefa['concluida'],
                                    ),
                              ),
                            );

                            if (resultado is Map<String, dynamic>) {
                              await editarTarefa(
                                resultado['id'],
                                resultado['descricao'],
                                resultado['concluida'],
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removerTarefa(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastrarTarefaPage()),
          );

          if (result is Map<String, dynamic>) {
            adicionarTarefa(result['descricao'], false);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
