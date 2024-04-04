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
  final List<String> _todoItems = [];

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoItems.add(task);
      });
    }
  }

  Widget _buildTodoList() {
    return Container(
      color: Colors.grey[200],
      child: ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index) {
          return _buildTodoItem(_todoItems[index], index);
        },
      ),
    );
  }

  Widget _buildTodoItem(String title, int index) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: ListTile(
        leading: Icon(Icons.check_box_outline_blank),
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0),
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
        onPressed: () => _pushAddTodoScreen(),
        tooltip: 'Add task',
        child: Icon(Icons.add),
        elevation: 4.0,
      ),
    );
  }

  void _pushAddTodoScreen() {
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
