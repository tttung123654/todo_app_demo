import 'package:flutter/material.dart';
import 'task.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Công Việc',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskList(), 
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = []; 
  String newTaskTitle = ''; 
  String newTaskDescription = ''; 
  DateTime? newTaskReminderTime; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Công Việc'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
             
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Thêm Công Việc Mới'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(labelText: 'Tiêu đề'),
                          onChanged: (value) {
                            setState(() {
                              
                              newTaskTitle = value;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Mô tả'),
                          onChanged: (value) {
                            setState(() {
                              
                              newTaskDescription = value;
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                           
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              final now = DateTime.now();
                              setState(() {
                                newTaskReminderTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            }
                          },
                          child: Text('Chọn thời gian hẹn giờ'),
                        ),
                        if (newTaskReminderTime != null)
                          Text('Thời gian hẹn giờ: ${newTaskReminderTime.toString()}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Đóng cửa sổ dialog khi nhấn Cancel
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Thêm công việc mới vào danh sách
                          setState(() {
                            tasks.add(Task(
                              title: newTaskTitle,
                              description: newTaskDescription,
                              deadline: DateTime.now(),
                              reminderTime: newTaskReminderTime,
                            ));
                          });
                          // Đóng cửa sổ dialog khi nhấn Save
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text('Không có công việc'),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      tasks[index].title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(tasks[index].description),
                        SizedBox(height: 4),
                        Text(
                          tasks[index].deadline != null
                              ? 'Deadline: ${tasks[index].deadline.toString()}'
                              : 'Không có thời hạn',
                          style: TextStyle(color: Colors.grey),
                        ),
                        if (tasks[index].reminderTime != null)
                          Text(
                            'Hẹn giờ: ${tasks[index].reminderTime.toString()}',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Mở hộp thoại để chỉnh sửa mô tả công việc
                            TextEditingController descriptionController =
                                TextEditingController(
                                    text: tasks[index].description);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Chỉnh sửa mô tả công việc'),
                                  content: TextField(
                                    controller: descriptionController,
                                    decoration:
                                        InputDecoration(labelText: 'Mô tả'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Đóng hộp thoại khi nhấn Cancel
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Cập nhật mô tả công việc
                                        setState(() {
                                          tasks[index].description =
                                              descriptionController.text;
                                        });
                                        // Đóng hộp thoại khi nhấn Save
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Xóa công việc khỏi danh sách
                            setState(() {
                              tasks.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
