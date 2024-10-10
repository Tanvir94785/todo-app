import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // To format date and time

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  List<Map<String, dynamic>> _tasks =
      []; // List to store tasks with date and time
  TextEditingController _taskController =
      TextEditingController(); // Controller for task input

  DateTime? _selectedDate; // Variable to store selected date
  TimeOfDay? _selectedTime; // Variable to store selected time

  // Function to pick date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set initial date to current date
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime(2101), // Maximum date
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to pick time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Set initial time to current time
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Function to add a task with date and time
  void _addTask() {
    String task = _taskController.text;
    if (task.isNotEmpty && _selectedDate != null && _selectedTime != null) {
      setState(() {
        _tasks.add({
          'title': task,
          'date': _selectedDate,
          'time': _selectedTime,
          'isCompleted': false,
        });
      });
      _taskController.clear();
      _selectedDate = null;
      _selectedTime = null;
    }
  }

  // Function to toggle task completion
  void _toggleCompletion(int index) {
    setState(() {
      _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
    });
  }

  // Function to delete a task
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App with Date and Time"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Text input for task entry
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: "Enter a task",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Date selection button
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    _selectedDate == null
                        ? "Select Date"
                        : DateFormat.yMMMd().format(_selectedDate!),
                  ),
                ),
                SizedBox(width: 20),

                // Time selection button
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text(
                    _selectedTime == null
                        ? "Select Time"
                        : _selectedTime!.format(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Add Task Button
            ElevatedButton(
              onPressed: _addTask,
              child: Text("Add Task"),
            ),
            SizedBox(height: 20),

            // Task List Display
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                      child: Text(
                        "No tasks yet. Add some!",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Checkbox(
                              value: _tasks[index]['isCompleted'],
                              onChanged: (bool? value) {
                                _toggleCompletion(index);
                              },
                            ),
                            title: Text(
                              _tasks[index]['title'],
                              style: TextStyle(
                                decoration: _tasks[index]['isCompleted']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: _tasks[index]['isCompleted']
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              "${DateFormat.yMMMd().format(_tasks[index]['date'])} - ${_tasks[index]['time'].format(context)}",
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
