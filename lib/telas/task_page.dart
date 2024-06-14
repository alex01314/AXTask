import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'create_task_page.dart';
import 'edit_task_page.dart';
import 'task_detail_page.dart';

final DatabaseHelper _dbHelper = DatabaseHelper();

class TaskPage extends StatefulWidget {
  final int userId;

  TaskPage({required this.userId});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suas Tarefas'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: TaskList(
                userId: widget.userId,
                dbHelper: _dbHelper,
                onTaskChanged: () {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTaskPage(userId: widget.userId)),
          );

          if (result == true) {
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final int userId;
  final DatabaseHelper dbHelper;
  final Function()? onTaskChanged;

  TaskList({required this.userId, required this.dbHelper, this.onTaskChanged});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.getTasks(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar tarefas'));
        } else {
          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'imagens/semtarefas.jpg',
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(height: 20),
                  Text('Não há tarefas ainda!', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task['title']),
                  subtitle: Text(task['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskPage(task: task),
                            ),
                          ).then((result) {
                            if (result == true) {
                              if (onTaskChanged != null) onTaskChanged!();
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await dbHelper.deleteTask(task['id']);
                          if (onTaskChanged != null) onTaskChanged!();
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailPage(task: task),
                      ),
                    ).then((result) {
                      if (result == true) {
                        if (onTaskChanged != null) onTaskChanged!();
                      }
                    });
                  },
                );
              },
            );
          }
        }
      },
    );
  }
}
