import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    required this.filterCallBacks,
    required this.onSearched,
    required this.onLogout,
  }) : super(key: key);
  final List<Map<String, VoidCallback>> filterCallBacks;
  final void Function(String) onSearched;
  final VoidCallback onLogout;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late bool _searchStarted;
  final _controller = TextEditingController();

  @override
  void initState() {
    _searchStarted = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      actions: [
        if (!_searchStarted)
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              _filter(widget.filterCallBacks);
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
                  widget.onSearched('');
                  setState(() {
                    _searchStarted = !_searchStarted;
                  });
                },
              ),
        if (!_searchStarted)
          IconButton(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
      ],
      // pinned: true,
      title: !_searchStarted
          ? const Text('Список задач')
          : _textField(widget.onSearched),
    );
  }

  Widget _textField(void Function(String value) onSearched) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _controller,
        onChanged: onSearched,
      ),
    );
  }

  void _filter(List<Map<String, VoidCallback>> filterCallBacks) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Выбрать фильтр'),
          children: filterCallBacks
              .map(
                (callBack) => TextButton(
                  onPressed: () {
                    callBack.values.first();
                    Navigator.pop(context);
                  },
                  child: Text(callBack.keys.first),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
