import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial()) {
    loadTodos();
  }

  void loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todos = prefs.getStringList('todos');
    List<String>? completed = prefs.getStringList('completed');
    if (todos != null && completed != null) {
      emit(TodoLoaded(todos: todos, completed: completed.map((e) => e == 'true').toList()));
    } else {
      emit(TodoLoaded(todos: [], completed: []));
    }
  }

  void addTodo(String todo) async {
    if (state is TodoLoaded) {
      final updatedTodos = List<String>.from((state as TodoLoaded).todos)..add(todo);
      final updatedCompleted = List<bool>.from((state as TodoLoaded).completed)..add(false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('todos', updatedTodos);
      await prefs.setStringList('completed', updatedCompleted.map((e) => e.toString()).toList());
      emit(TodoLoaded(todos: updatedTodos, completed: updatedCompleted));
    }
  }

  void removeTodoAt(int index) async {
    if (state is TodoLoaded) {
      final updatedTodos = List<String>.from((state as TodoLoaded).todos)..removeAt(index);
      final updatedCompleted = List<bool>.from((state as TodoLoaded).completed)..removeAt(index);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('todos', updatedTodos);
      await prefs.setStringList('completed', updatedCompleted.map((e) => e.toString()).toList());
      emit(TodoLoaded(todos: updatedTodos, completed: updatedCompleted));
    }
  }

  void toggleTodoCompletion(int index) async {
    if (state is TodoLoaded) {
      final updatedCompleted = List<bool>.from((state as TodoLoaded).completed);
      updatedCompleted[index] = !updatedCompleted[index];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completed', updatedCompleted.map((e) => e.toString()).toList());
      emit(TodoLoaded(todos: (state as TodoLoaded).todos, completed: updatedCompleted));
    }
  }
}
