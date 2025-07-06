import 'package:flutter/material.dart';

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
    final hoje = DateTime.now();
    final hojeSemHora = DateTime(hoje.year, hoje.month, hoje.day);
    final amanhaSemHora = hojeSemHora.add(const Duration(days: 1));

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Digite o título da tarefa',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DateTime?>(
              value: _dataSelecionada,
              decoration: const InputDecoration(labelText: 'Selecionar Data'),
              items:
                  [hojeSemHora, amanhaSemHora, null].map((date) {
                    return DropdownMenuItem<DateTime?>(
                      value: date,
                      child: Text(
                        date == null
                            ? 'Sem data'
                            : date == hojeSemHora
                            ? 'Hoje'
                            : 'Amanhã',
                      ),
                    );
                  }).toList(),
              onChanged: (value) => setState(() => _dataSelecionada = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Digite uma descrição',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: () {
                Navigator.pop(context, {
                  'titulo': _tituloController.text,
                  'descricao': _descricaoController.text,
                  'data': _dataSelecionada,
                });
              },
              child: const Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
