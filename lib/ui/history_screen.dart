import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:photomath_ripoff/data/database_provider.dart';
import 'package:photomath_ripoff/models/solution.dart';
import 'display_solution.dart';
import 'bordered_text.dart';


class HistoryScreen extends StatefulWidget {

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, Solution> _solutions;
  bool _delete;
  Set<int> _itemsToDelete;
  bool _hasItemsToDelete;
  bool _loading;

  final _loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  final _itemStyle = TeXViewStyle(
    padding: Solution.padding,
    margin: Solution.margin,
    border: Solution.border,
    borderRadius: Solution.borderRadius,
  );

  void _route(context, solution) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplaySolution(solution: solution,),
      ),
    );
  }

  void _deleteItems() async {
    setState(() {
      _loading = true;
    });
    for (int id in _itemsToDelete) {
      await DatabaseProvider().deleteSolution(id);
    }
    DatabaseProvider().getSolutionMap().then((value) => setState(() {
      _solutions = value;
      _hasItemsToDelete = false;
      _itemsToDelete.clear();
      _loading = false;
    }));
  }

  void _clearAll() async {
    setState(() {
      _loading = true;
    });
    await DatabaseProvider().clearAllSolutions();
    DatabaseProvider().getSolutionMap().then((value) => setState(() {
      _solutions = value;
      _hasItemsToDelete = false;
      _itemsToDelete.clear();
      _loading = false;
    }));
  }

  _edit(List<TeXViewGroupItem> children) {
    return TeXViewGroup.multipleSelection(
        children: children,
        normalItemStyle: _itemStyle,
        selectedItemStyle: TeXViewStyle(
          padding: Solution.padding,
          margin: Solution.margin,
          border: Solution.border,
          borderRadius: Solution.borderRadius,
          backgroundColor: Colors.blueGrey.shade300,
        ),
        onItemsSelection: (List<String> ids) {
          setState(() {
            _itemsToDelete.addAll(ids.map((e) => int.parse(e)));
            _hasItemsToDelete = ids.length != 0;
          });
        }
    );
  }

  _readOnly(List<TeXViewGroupItem> children) {
    return TeXViewGroup(
      children: children,
      onTap: (String id) => _route(context, _solutions[id]),
      normalItemStyle: _itemStyle,
      selectedItemStyle: _itemStyle,
    );
  }

  _displayHistory(List<TeXViewGroupItem> children) {
    if(_delete)
      return _edit(children);
    return _readOnly(children);
  }

  @override
  void initState() {
    super.initState();

    _solutions = {};
    _itemsToDelete = {};
    _hasItemsToDelete = false;
    _delete = false;
    _loading = true;

    DatabaseProvider().openSolutionDatabase().then((_) {
      DatabaseProvider().getSolutionMap().then((map) => setState(() {
        _solutions = map;
        _loading = false;
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        leading: _delete ? TextButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('This will delete all history'),
              content: Text('Are you sure?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Yes'),
                ),
              ],
            )
          ).then((value) => value ? _clearAll() : null),
          child: BorderedText(
            'Clear all',
            maxLines: 1,
            borderColor: Colors.blueGrey.shade600,
            color: Colors.red.shade400,
          ),
        ) : null,
        leadingWidth: _delete ? 68 : 56,
        actions: [
          if(_delete && _hasItemsToDelete)
            TextButton(
              onPressed: _deleteItems,
              child: BorderedText(
                'Delete',
                borderColor: Colors.blueGrey.shade600,
                color: Colors.red.shade400,
              ),
            ),
          TextButton(
            onPressed: () => setState(() {
              print(_itemsToDelete);
              if(_delete) {
                _itemsToDelete.clear();
                _hasItemsToDelete = false;
              }
              _delete =  !_delete;
            }),
            child: Text(
              _delete ? 'Done' : 'Edit',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? _loadingWidget
          : TeXView(
        style: TeXViewStyle(
          padding: TeXViewPadding.only(top: 10, left: 5, right: 5),
        ),
        child: _displayHistory([
          for(var item in _solutions.values.toList().reversed)
            item.view(),
        ]),
        loadingWidgetBuilder: (context) => _loadingWidget,
      ),
    );
  }
}