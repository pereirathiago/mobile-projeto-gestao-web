import 'package:flutter/material.dart';
import 'package:my_app/pages/editar_tarefa_page.dart';
import 'cadastrar_tarefa_page.dart';
import 'package:intl/intl.dart';
import 'login_page.dart';

class ListaTarefasPage extends StatefulWidget {
  const ListaTarefasPage({super.key});

  @override
  State<ListaTarefasPage> createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {
  final List<Map<String, dynamic>> tarefas = [];

  void adicionarTarefa(String titulo, String descricao, DateTime? data) {
    setState(() {
      tarefas.add({
        'titulo': titulo,
        'descricao': descricao,
        'data': data,
        'concluido': false,
      });
    });
  }

  void removerTarefa(int index) {
    setState(() {
      tarefas.removeAt(index);
    });
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
            onPressed: () {
              // Volta para a tela de login e remove todas as rotas anteriores (para não voltar com o botão voltar)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          final formato = DateFormat('dd/MM/yyyy');

          String dataFormatada;
          if (tarefa['data'] != null) {
            dataFormatada =
                tarefa['data'].day == DateTime.now().day
                    ? 'Hoje'
                    : formato.format(tarefa['data']);
          } else {
            dataFormatada = 'Sem data';
          }
          return ListTile(
            title: Text(
              tarefa['titulo'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(dataFormatada),
            leading: Checkbox(
              value: tarefa['concluido'],
              onChanged: (value) {
                setState(() {
                  tarefa['concluido'] = value;
                });
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
                              tituloInicial: tarefa['titulo'],
                              descricaoInicial: tarefa['descricao'],
                              dataInicial: tarefa['data'],
                            ),
                      ),
                    );

                    if (resultado is Map<String, dynamic>) {
                      setState(() {
                        tarefas[index] = {
                          ...tarefas[index],
                          'titulo': resultado['titulo'],
                          'descricao': resultado['descricao'],
                          'data': resultado['data'],
                        };
                      });
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
            adicionarTarefa(
              result['titulo'],
              result['descricao'],
              result['data'],
            );
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
