import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/constants.dart';
import 'todo_provider.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List with Riverpod',
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Let's do it",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/constellation.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: todoList.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks yet! Add your first task below.',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: todoList.length,
                          itemBuilder: (context, index) {
                            final todo = todoList[index];
                            return AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: Card(
                                key: ValueKey(todo.title),
                                color: kCardColors[index % kCardColors.length],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: ListTile(
                                  iconColor: Colors.white,
                                  textColor: Colors.white,
                                  title: Text(
                                    todo.title,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      decoration: todo.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  leading: Theme(
                                    data: Theme.of(context).copyWith(
                                      checkboxTheme: CheckboxThemeData(
                                        side: BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Checkbox(
                                      checkColor: kSecondaryColor,
                                      value: todo.isCompleted,
                                      onChanged: (_) {
                                        ref
                                            .read(todoListProvider.notifier)
                                            .toggleTodoStatus(index);
                                      },
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: kPrimaryColor,
                                          title: Text(
                                            'Delete Task',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          content: Text(
                                            'Are you sure you want to delete this task?',
                                            style: TextStyle(
                                                color: Colors.white60),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: kSecondaryColor),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                ref
                                                    .read(todoListProvider
                                                        .notifier)
                                                    .removeTodoAt(index);
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: kSecondaryColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: AddTodoField(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddTodoField extends ConsumerStatefulWidget {
  @override
  _AddTodoFieldState createState() => _AddTodoFieldState();
}

class _AddTodoFieldState extends ConsumerState<AddTodoField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Add a new task',
                hintStyle: TextStyle(color: Colors.white, fontSize: 14.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        IconButton(
          iconSize: 28.0,
          icon: Icon(
            Icons.add,
            color: kPrimaryColor,
          ),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              ref.read(todoListProvider.notifier).addTodo(_controller.text);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Task added successfully',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: kPrimaryColor,
                ),
              );
              _controller.clear();
            }
          },
        ),
      ],
    );
  }
}
