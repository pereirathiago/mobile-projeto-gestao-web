import 'package:flutter/material.dart';

class EditarTarefaPage extends StatefulWidget {
  final int id;
  final String descricaoInicial;
  final bool concluidaInicial;

  const EditarTarefaPage({
    super.key,
    required this.id,
    required this.descricaoInicial,
    required this.concluidaInicial,
  });

  @override
  State<EditarTarefaPage> createState() => _EditarTarefaPageState();
}

class _EditarTarefaPageState extends State<EditarTarefaPage> {
  late TextEditingController _descricaoController;
  late bool _concluida;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: widget.descricaoInicial);
    _concluida = widget.concluidaInicial;
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            CheckboxListTile(
              title: const Text('Concluída'),
              value: _concluida,
              onChanged: (value) {
                setState(() {
                  _concluida = value ?? false;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: () {
                Navigator.pop(context, {
                  'id': widget.id,
                  'descricao': _descricaoController.text,
                  'concluida': _concluida,
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
