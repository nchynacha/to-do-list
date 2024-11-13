import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo.dart';

// สร้าง provider สำหรับรายการ To-Do
final todoListProvider =
    StateNotifierProvider<TodoListNotifier, List<Todo>>((ref) {
  return TodoListNotifier();
});

class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]);

  void addTodo(String title) {
    state = [...state, Todo(title: title)];
  }

  void toggleTodoStatus(int index) {
    state[index].isCompleted = !state[index].isCompleted;
    state = [...state]; // อัปเดตสถานะ
  }

  void removeTodoAt(int index) {
    state = [...state]..removeAt(index);
  }
}
