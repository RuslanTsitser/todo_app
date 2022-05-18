import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/domain/state/users/users_bloc.dart';
import 'package:todo_app/presentation/widgets/search_bar.dart';
import 'package:uuid/uuid.dart';

import '../../domain/model/export_model.dart';
import '../../domain/state/todo/todo_bloc.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late TodoBloc _todoBloc;
  late UsersBloc _usersBloc;
  @override
  void initState() {
    _todoBloc = BlocProvider.of<TodoBloc>(context);
    _todoBloc.add(TodoGetList());
    _usersBloc = BlocProvider.of<UsersBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo();
        },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          const SearchBar(),
          BlocBuilder<TodoBloc, TodoState>(
            bloc: _todoBloc,
            builder: (context, state) {
              if (state is TodoSuccess) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _todoTile(state.todoList[index]);
                    },
                    childCount: state.todoList.length,
                  ),
                );
              }
              if (state is TodoEmptyList) {
                return SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      const [
                        Center(
                          child: Text(
                            'Список задач пуст',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildListDelegate([
                  const Center(child: CircularProgressIndicator()),
                ]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _todoTile(Todo todo) {
    String performer = todo.performer?.name ?? 'Не делегировано';
    String status = todo.status.name;
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _todoBloc.add(TodoRemove(todo.id));
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Удалить',
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              if (_usersBloc.state is UsersSuccess) {
                var _state = _usersBloc.state as UsersSuccess;
                _delegateTask(_state.users, todo);
              }
            },
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Поделиться задачей',
          ),
        ],
      ),
      child: ListTile(
        // tileColor: todo.status == TodoStatus.completed
        //     ? Colors.lightGreen
        //     : todo.status == TodoStatus.inProgress
        //         ? Colors.yellowAccent
        //         : Colors.transparent,
        onTap: () {
          _changeStatus(todo);
        },
        onLongPress: () {
          _changeTitle(todo);
        },
        leading: const Icon(
          Icons.double_arrow_outlined,
          size: 40,
        ),
        title: Text(todo.title),
        subtitle: Row(
          children: [
            Text(performer),
            const SizedBox(width: 10),
            Text('Статус: $status'),
          ],
        ),
      ),
    );
  }

  void _changeTitle(Todo todo) {
    showDialog(
      context: context,
      builder: (context) {
        final _controller = TextEditingController();
        return AlertDialog(
          title: const Text('Изменить название'),
          content: TextField(
            controller: _controller,
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Закрыть')),
            TextButton(
              onPressed: () {
                _todoBloc.add(TodoChangeTitle(todo.id, _controller.text));
                Navigator.pop(context);
              },
              child: const Text('Добавить'),
            )
          ],
        );
      },
    );
  }

  void _delegateTask(List<User> users, Todo todo) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          height: 400,
          // color: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Список сотрудников',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          _todoBloc.add(
                            TodoSetPerformer(todo.id, users[index]),
                          );
                          Navigator.pop(context);
                        },
                        leading: Text(index.toString()),
                        title: Text(users[index].name),
                      );
                    },
                    itemCount: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _changeStatus(Todo todo) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Center(child: Text('Выберите статус')),
            children: [
              TextButton(
                onPressed: () {
                  _todoBloc.add(
                    TodoUpdateStatus(
                      todo.id,
                      TodoStatus.waiting,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Ожидание'),
              ),
              TextButton(
                onPressed: () {
                  _todoBloc.add(
                    TodoUpdateStatus(
                      todo.id,
                      TodoStatus.inProgress,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('В работе'),
              ),
              TextButton(
                onPressed: () {
                  _todoBloc.add(
                    TodoUpdateStatus(
                      todo.id,
                      TodoStatus.completed,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Выполнено'),
              ),
            ],
          );
        });
  }

  void _addTodo() {
    showDialog(
      context: context,
      builder: (context) {
        final _controller = TextEditingController();
        return AlertDialog(
          title: const Text('Добавить задание'),
          content: TextField(
            controller: _controller,
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Закрыть')),
            TextButton(
              onPressed: () {
                var id = const Uuid().v1();
                _todoBloc.add(TodoAdd(id, _controller.text));
                Navigator.pop(context);
              },
              child: const Text('Добавить'),
            )
          ],
        );
      },
    );
  }
}
