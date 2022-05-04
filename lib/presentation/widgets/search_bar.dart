import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/model/export_model.dart';
import 'package:todo_app/domain/state/todo/todo_bloc.dart';

import '../../domain/state/auth/auth_bloc.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late bool _searchStarted;
  late TodoBloc _todoBloc;
  final _controller = TextEditingController();

  @override
  void initState() {
    _searchStarted = false;
    _todoBloc = BlocProvider.of<TodoBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: [
        if (!_searchStarted)
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              _filter();
            },
          ),
        !_searchStarted
            ? IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _searchStarted = !_searchStarted;
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  _controller.clear();
                  setState(() {
                    _searchStarted = !_searchStarted;
                  });
                },
              ),
        if (!_searchStarted)
          IconButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(Logout());
            },
            icon: const Icon(Icons.logout),
          ),
      ],
      // pinned: true,
      title: !_searchStarted ? const Text('Список задач') : _textField(),
    );
  }

  Widget _textField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          _todoBloc.add(TodoSearch(value));
        },
      ),
    );
  }

  void _filter() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Выбрать фильтр'),
          children: [
            TextButton(
              onPressed: () {
                _todoBloc.add(TodoFilter(TodoStatus.completed));
                Navigator.pop(context);
              },
              child: const Text('Только выполненные'),
            ),
            TextButton(
              onPressed: () {
                _todoBloc.add(TodoFilter(TodoStatus.inProgress));
                Navigator.pop(context);
              },
              child: const Text('Только в работе'),
            ),
            TextButton(
              onPressed: () {
                _todoBloc.add(TodoFilter(TodoStatus.waiting));
                Navigator.pop(context);
              },
              child: const Text('Только в ожидании'),
            ),
            TextButton(
              onPressed: () {
                _todoBloc.add(TodoFilterReset());
                Navigator.pop(context);
              },
              child: const Text('Сбросить фильтры'),
            ),
          ],
        );
      },
    );
  }
}
