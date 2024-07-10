part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoaded extends TodoState {
  final List<String> todos;
  final List<bool> completed;

  TodoLoaded({required this.todos, required this.completed});
}
