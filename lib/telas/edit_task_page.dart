import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../db/database_helper.dart';

class EditTaskPage extends StatefulWidget {
  final Map<String, dynamic> task;

  EditTaskPage({required this.task});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _priority;
  late DateTime _selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task['title']);
    _descriptionController = TextEditingController(text: widget.task['description']);
    _priority = widget.task['priority']; // Definindo a prioridade inicial
    _selectedDate = DateTime.parse(widget.task['dueDate']);
  }

  void _updateTask() async {
    await DatabaseHelper().updateTask({
      'id': widget.task['id'],
      'title': _titleController.text,
      'description': _descriptionController.text,
      'dueDate': _selectedDate.toString(),
      'priority': _priority, // Adicionando a prioridade
    });

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarefa'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Título',
            border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: const Color.fromARGB(255, 163, 163, 163).withOpacity(0.1),
              filled: true,)
            ),
            SizedBox(height: 10.0),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Descrição',
            border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: const Color.fromARGB(255, 163, 163, 163).withOpacity(0.1),
              filled: true,)
          ),
          SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: _priority,
                onChanged: (String? value) {
                  setState(() {
                    _priority = value!;
                  });
                },
                items: <String>['Baixa', 'Média', 'Alta'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Prioridade',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              TableCalendar(
                  focusedDay: _selectedDate,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _selectedDate = focusedDay;
                  },
                ),
              
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _updateTask,
                child: Text('Salvar Alterações', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
