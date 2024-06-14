import 'package:flutter/material.dart';
import 'edit_task_page.dart';
import '../db/database_helper.dart';
import 'package:intl/intl.dart';


class TaskDetailPage extends StatelessWidget {
  final Map<String, dynamic> task;

  TaskDetailPage({required this.task});

  void _deleteTask(BuildContext context) async {
    await DatabaseHelper().deleteTask(task['id']);
    Navigator.pop(context, true); // Retornar para a lista de tarefas após exclusão com um resultado indicando que houve uma mudança
  }

  @override
  Widget build(BuildContext context) {
    // Converter as datas de texto para DateTime
    DateTime createdDate = DateTime.parse(task['createdDate']);
    DateTime dueDate = DateTime.parse(task['dueDate']);

    // Formatar as datas no formato desejado
    String formattedCreatedDate = DateFormat('dd/MM/yyyy').format(createdDate);
    String formattedDueDate = DateFormat('dd/MM/yyyy').format(dueDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(task['title']),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${task['description']}'),
            Text('Prioridade: ${task['priority']}'),
            Text('Data de Criação: $formattedCreatedDate'),
            Text('Data de Vencimento: $formattedDueDate'),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Navegar para a página de edição e aguardar o retorno
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditTaskPage(task: task)),
                    );

                    // Se houve uma mudança na edição, retornar com um resultado indicando mudança
                    if (result == true) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('Editar', style: TextStyle( color: Colors.black)),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () => _deleteTask(context),
                  child: Text('Excluir', style: TextStyle( color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
