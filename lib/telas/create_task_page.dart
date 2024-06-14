import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../db/database_helper.dart';

class CreateTaskPage extends StatelessWidget {
  final int userId;

  CreateTaskPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Tarefa'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: CreateTaskForm(userId: userId),
        ),
      ),
    );
  }
}

class CreateTaskForm extends StatefulWidget {
  final int userId;

  CreateTaskForm({required this.userId});

  @override
  _CreateTaskFormState createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late String _priority;
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _priority = 'Baixa'; // Definindo a prioridade inicial como 'baixa'
  }

  Future<void> _createTask() async {
    await DatabaseHelper().insertTask({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'dueDate': _selectedDate.toString(),
      'createdDate': DateTime.now().toString(),
      'priority': _priority,
      'user_id': widget.userId, // Associando a tarefa ao usuário
    });

    Navigator.pop(context, true); // Indica que a tarefa foi criada
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: const Color.fromARGB(255, 163, 163, 163).withOpacity(0.1),
              filled: true,
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: const Color.fromARGB(255, 163, 163, 163).withOpacity(0.1),
              filled: true,
            ),
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
            onPressed: _createTask,
            child: Text('Criar Tarefa', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
