import 'package:flutter/material.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<TodoItem> _todoItems = [];

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoItems.add(TodoItem(task: task));
      });
    }
  }

  void _editTodoItemDateAndTime(int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _todoItems[index].dateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _todoItems[index].timeOfDay ?? TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _todoItems[index].dateTime = pickedDate;
          _todoItems[index].timeOfDay = pickedTime;
        });
      }
    }
  }

  Widget _buildTodoList() {
    return Container(
      color: Colors.grey[200],
      child: ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _editTodoItemDateAndTime(index);
            },
            child: _buildTodoItem(_todoItems[index], index),
          );
        },
      ),
    );
  }

  Widget _buildTodoItem(TodoItem todoItem, int index) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: ListTile(
        leading: Icon(Icons.check_box_outline_blank),
        title: Text(
          todoItem.task,
          style: TextStyle(fontSize: 18.0),
        ),
        subtitle: Text(
          todoItem.dateTime != null && todoItem.timeOfDay != null
              ? '${todoItem.dateTime!.toString().split(' ')[0]} ${todoItem.timeOfDay!.format(context)}'
              : 'Tap to set date and time',
          style: TextStyle(fontSize: 14.0),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              _todoItems.removeAt(index);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        elevation: 2.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.blue, Colors.purple],
            ),
          ),
        ),
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pushAddTodoScreen(context),
        tooltip: 'Add task',
        child: Icon(Icons.add),
        elevation: 4.0,
      ),
    );
  }

  void _pushAddTodoScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context);
            },
            decoration: InputDecoration(
              labelText: 'Enter something to do...',
              hintText: 'Buy smh',
              border: OutlineInputBorder(),
            ),
          ),
        );
      },
    );
  }
}

class TodoItem {
  String task;
  DateTime? dateTime;
  TimeOfDay? timeOfDay;

  TodoItem({
    required this.task,
    this.dateTime,
    this.timeOfDay,
  });
}
