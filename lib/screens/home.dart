import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/task_model.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final todosList = Task.todoList();
  List<Task> tasksList = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    getData();
    // var list = getData(_foundToDo);
    // _foundToDo = list;
    super.initState();
  }

  Future<void> saveData() async {
    List<Map<String, dynamic>> tasksAsJson = [];
    List<String> tasksAsString = [];

    for (var element in tasksList) {
      tasksAsJson.add(element.toJson());
    }

    for (var element in tasksAsJson) {
      tasksAsString.add(jsonEncode(element));
    }
    final prefs = await SharedPreferences.getInstance();

    bool res = await prefs.setStringList("tasks", tasksAsString);
    print("save data======== $res $tasksAsString");
  }

  Future<void> getData() async {
    List<String> tasksAsString = [];
    List<Map<String, dynamic>> tasksAsJson = [];

    tasksList.clear();
    final prefs = await SharedPreferences.getInstance();

    tasksAsString = prefs.getStringList("tasks") ?? [];

    for (var element in tasksAsString) {
      tasksAsJson.add(jsonDecode(element));
    }

    setState(() {
      for (var element in tasksAsJson) {
        tasksList.add(Task.fromJson(element));
      }
    });
    print('get data======== (true) $tasksList ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await getData();
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                children: [
                  searchBox(),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 50,
                            bottom: 20,
                          ),
                          child: const Text(
                            'All ToDos',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        for (Task todoo in tasksList.reversed)
                          ToDoItem(
                            todo: todoo,
                            onToDoChanged: _handleToDoChange,
                            onDeleteItem: _deleteToDoItem,
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                          hintText: 'Add a new todo item',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: const Size(60, 60),
                      elevation: 10,
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _handleToDoChange(Task todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    saveData();
  }

  void _deleteToDoItem(String id) {
    setState(() {
      tasksList.removeWhere((item) => item.id == id);
    });
    saveData();
  }

  void _addToDoItem(String toDo) {
    setState(() {
      tasksList.add(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: toDo,
      ));
      saveData();
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<Task> results = [];
    if (enteredKeyword.isEmpty) {
      results = tasksList;
    } else {
      results = tasksList
          .where((item) =>
              item.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      tasksList = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.menu,
              color: tdBlack,
              size: 30,
            ),
            // SizedBox(
            //   height: 40,
            //   width: 40,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(20),
            //     child: Image.asset('assets/images/avatar.jpeg'),
            //   ),
            // ),
          ]),
    );
  }
}
