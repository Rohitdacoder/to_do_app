import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/util/dialog_box.dart';
import 'package:to_do_app/util/todo_title.dart';

  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
  // refernce the hive box
    final mybox = Hive.box('mybox');
    ToDoDataBase db = ToDoDataBase();

    @override
    void initState()
    {
      if(mybox.get("TODOLIST") == null)
        {
          db.createInitialData();
        }
      else {
        db.loadData();
      }
      super.initState();
    }

    // text controller
    final controller = TextEditingController();



    // checkboxed was tapped
    void checkBoxChanged(bool? value, int index)
    {
        setState(() {
          db.todolist[index][1] = !db.todolist[index][1];
        });
        db.updateDataBase();
    }

    // save new task
    void saveNewTask()
    {
        setState(() {
          db.todolist.add([controller.text, false]);
          controller.clear();
        });
        Navigator.of(context).pop();
        db.updateDataBase();
    }

    // Create a new task
    void createNewTask()
    {
      showDialog(
          context: context,
          builder: (context) {
            return DialogBox(
              controller: controller,
              onSave: saveNewTask,
              onCancel: () => Navigator.of(context).pop(),
            );
          }
      );
    }

    // Delete Task
    void deleteTask(int index)
    {
      setState(() {
        db.todolist.removeAt(index);
      });
      db.updateDataBase();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.yellow[200],
        appBar: AppBar(
          title: Text('TO DO'),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: createNewTask,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: db.todolist.length,
          itemBuilder: (context, index)
            {
              return TodoTitle(
                  taskName: db.todolist[index][0],
                  onChanged: (value) => checkBoxChanged(value,index),
                  taskCompleted: db.todolist[index][1],
                  deleteFunction: (context) => deleteTask(index),
              );
            }
        ),
      );
    }
  }