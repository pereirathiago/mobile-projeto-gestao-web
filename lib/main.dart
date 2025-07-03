import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final senhaController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('MyApp', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 20),
            const Text('Bem-vindo(a) de volta!', style: TextStyle(fontSize: 20)),
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Esqueceu a senha?', style: TextStyle(color: Colors.deepPurple)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ListaTarefasPage()));
              },
              child: const Text('ENTRAR'),
            ),
            const SizedBox(height: 20),
            const Text('Ainda não tem uma conta?'),
            TextButton(
              onPressed: () {},
              child: const Text('Cadastre-se aqui', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        ),
      ),
    );
  }
}

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

  void editarTarefa(int index, String titulo, String descricao, DateTime? data) {
    setState(() {
      tarefas[index] = {
        ...tarefas[index],
        'titulo': titulo,
        'descricao': descricao,
        'data': data,
      };
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
      appBar: AppBar(title: const Text('Lista de Tarefas')),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          return ListTile(
            title: Text(tarefa['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              tarefa['data'] != null ?
              (tarefa['data']!.day == DateTime.now().day ? 'Hoje' : tarefa['data'].toString()) :
              'Sem data'
            ),
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
                IconButton(icon: const Icon(Icons.edit), onPressed: () {/* tela editar */}),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => removerTarefa(index)),
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
            adicionarTarefa(result['titulo'], result['descricao'], result['data']);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CadastrarTarefaPage extends StatefulWidget {
  const CadastrarTarefaPage({super.key});

  @override
  State<CadastrarTarefaPage> createState() => _CadastrarTarefaPageState();
}

class _CadastrarTarefaPageState extends State<CadastrarTarefaPage> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime? _dataSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Digite o título da tarefa'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DateTime>(
              value: _dataSelecionada,
              decoration: const InputDecoration(labelText: 'Selecionar Data'),
              items: [
                DateTime.now(),
                DateTime.now().add(const Duration(days: 1)),
                null
              ].map((date) {
                return DropdownMenuItem(
                  value: date,
                  child: Text(date == null ? 'Sem data' : date == DateTime.now() ? 'Hoje' : 'Amanhã'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _dataSelecionada = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Digite uma descrição'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: () {
                Navigator.pop(context, {
                  'titulo': _tituloController.text,
                  'descricao': _descricaoController.text,
                  'data': _dataSelecionada,
                });
              },
              child: const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }
}
