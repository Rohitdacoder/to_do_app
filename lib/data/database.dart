import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {

  List todolist = [];

  // refernce our box
  final mybox = Hive.box('mybox');

  void createInitialData() {
    todolist = [
      ["Make Tutorial", false],
      ["Do Exercise", false],
    ];
  }


// load the data from database
  void loadData() {
    todolist = mybox.get("TODOLIST");
  }

  // update the database
  void updateDataBase()
  {
      mybox.put("TODOLIST", todolist);
  }


}