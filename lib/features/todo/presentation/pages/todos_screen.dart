import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do/features/todo/presentation/cubit/todo_cubit.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('List of todos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                labelText: 'Add your task here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<TodoCubit>().addTodo(value);
                  _todoController.clear();
                }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoCubit, TodoState>(
              builder: (context, state) {
                if (state is TodoInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TodoLoaded) {
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          textColor:  state.completed[index] ? Colors.grey : null,
                          tileColor: Colors.white,
                          contentPadding: const EdgeInsets.all(8.0),
                          shape:  RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          leading: Checkbox(
                            value: state.completed[index],
                            onChanged: (value) {
                              context.read<TodoCubit>().toggleTodoCompletion(index);
                            },
                          ),
                          title: Text(
                            state.todos[index],
                            style: TextStyle(
                              decoration: state.completed[index]
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context.read<TodoCubit>().removeTodoAt(index);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}