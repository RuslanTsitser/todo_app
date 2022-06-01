import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/domain/state/auth/bloc/auth_bloc.dart';
import 'package:todo_app/internal/providers/providers.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/presentation/widgets/search_bar.dart';
import 'package:uuid/uuid.dart';

import '../../domain/model/export_model.dart';
import '../../domain/state/todo/bloc/todo_bloc.dart';
import '../../domain/state/users/bloc/users_bloc.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late TodoBloc _todoBloc;
  late UsersBloc _usersBloc;
  late AuthBloc _authBloc;
  late WidgetRef _ref;
  @override
  void initState() {
    if (!kTryRiverpod) {
      _todoBloc = BlocProvider.of<TodoBloc>(context);
      _todoBloc.add(TodoGetList());
      _usersBloc = BlocProvider.of<UsersBloc>(context);
      _authBloc = BlocProvider.of<AuthBloc>(context);
    }
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
          !kTryRiverpod
              ? SearchBar(
                  filterCallBacks: [
                    {
                      'Только выполненные': () {
                        _todoBloc.add(
                            TodoFilterOrSearch(status: TodoStatus.completed));
                      }
                    },
                    {
                      'Только в работе': () {
                        _todoBloc.add(
                            TodoFilterOrSearch(status: TodoStatus.inProgress));
                      }
                    },
                    {
                      'Только в ожидании': () {
                        _todoBloc.add(
                            TodoFilterOrSearch(status: TodoStatus.waiting));
                      }
                    },
                    {
                      'Сбросить фильтры': () {
                        _todoBloc.add(TodoFilterOrSearch());
                      }
                    },
                  ],
                  onLogout: () {
                    _authBloc.add(Logout());
                  },
                  onSearched: (value) {
                    _todoBloc.add(TodoFilterOrSearch(value: value));
                  },
                )
              : Consumer(
                  builder: (context, ref, child) => SearchBar(
                    filterCallBacks: [
                      {
                        'Только выполненные': () {
                          _ref
                              .watch(todoNotifierProvider.notifier)
                              .filterOrSearch(
                                status: TodoStatus.completed,
                              );
                        }
                      },
                      {
                        'Только в работе': () {
                          _ref
                              .watch(todoNotifierProvider.notifier)
                              .filterOrSearch(status: TodoStatus.inProgress);
                        }
                      },
                      {
                        'Только в ожидании': () {
                          _ref
                              .watch(todoNotifierProvider.notifier)
                              .filterOrSearch(status: TodoStatus.waiting);
                        }
                      },
                      {
                        'Сбросить фильтры': () {
                          _ref
                              .watch(todoNotifierProvider.notifier)
                              .filterOrSearch();
                        }
                      },
                    ],
                    onSearched: (value) {
                      _ref
                          .watch(todoNotifierProvider.notifier)
                          .filterOrSearch(value: value);
                    },
                    onLogout: () {
                      _ref.read(authNotifierProvider.notifier).logout();
                    },
                  ),
                ),
          !kTryRiverpod
              ? BlocBuilder<TodoBloc, TodoState>(
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
                )
              : Consumer(
                  builder: (context, ref, child) {
                    _ref = ref;

                    return _ref.watch(todoNotifierProvider).maybeMap(
                      success: (value) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _todoTile(value.todoList[index]);
                            },
                            childCount: value.todoList.length,
                          ),
                        );
                      },
                      orElse: () {
                        return SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      emptyList: (value) {
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
                      },
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
              !kTryRiverpod
                  ? _todoBloc.add(TodoRemove(todo.id))
                  : _ref
                      .read(todoNotifierProvider.notifier)
                      .removeTodo(todo.id);
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
              if (!kTryRiverpod) {
                if (_usersBloc.state is UsersSuccess) {
                  var _state = _usersBloc.state as UsersSuccess;
                  _delegateTask(_state.users, todo);
                }
              } else {
                _ref.watch(usersNotifierProvider).whenOrNull(
                  success: (users) {
                    _delegateTask(users, todo);
                  },
                );
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
                !kTryRiverpod
                    ? _todoBloc.add(TodoChangeTitle(todo.id, _controller.text))
                    : _ref
                        .read(todoNotifierProvider.notifier)
                        .changeTitle(todo.id, _controller.text);
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
                          !kTryRiverpod
                              ? _todoBloc.add(
                                  TodoSetPerformer(todo.id, users[index]),
                                )
                              : _ref
                                  .read(todoNotifierProvider.notifier)
                                  .setPerformer(todo.id, users[index]);
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
                  !kTryRiverpod
                      ? _todoBloc.add(
                          TodoUpdateStatus(
                            todo.id,
                            TodoStatus.waiting,
                          ),
                        )
                      : _ref.read(todoNotifierProvider.notifier).updateStatus(
                            todo.id,
                            TodoStatus.waiting,
                          );
                  Navigator.pop(context);
                },
                child: const Text('Ожидание'),
              ),
              TextButton(
                onPressed: () {
                  !kTryRiverpod
                      ? _todoBloc.add(
                          TodoUpdateStatus(
                            todo.id,
                            TodoStatus.inProgress,
                          ),
                        )
                      : _ref.read(todoNotifierProvider.notifier).updateStatus(
                            todo.id,
                            TodoStatus.inProgress,
                          );
                  Navigator.pop(context);
                },
                child: const Text('В работе'),
              ),
              TextButton(
                onPressed: () {
                  !kTryRiverpod
                      ? _todoBloc.add(
                          TodoUpdateStatus(
                            todo.id,
                            TodoStatus.completed,
                          ),
                        )
                      : _ref.read(todoNotifierProvider.notifier).updateStatus(
                            todo.id,
                            TodoStatus.completed,
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
                !kTryRiverpod
                    ? _todoBloc.add(TodoAdd(id, _controller.text))
                    : _ref
                        .read(todoNotifierProvider.notifier)
                        .addTodo(id, _controller.text);
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
