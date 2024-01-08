class Task {
  String id;
  String title;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  // static List<Task> todoList() {
  //   return [
  //     Task(id: '01', title: 'Morning Excercise', isDone: true),
  //     Task(id: '02', title: 'Buy Groceries', isDone: true),
  //     Task(id: '03', title: 'Check Emails'),
  //     Task(id: '04', title: 'Team Meeting'),
  //     Task(id: '05', title: 'Work on mobile apps for 2 hour'),
  //     Task(id: '06', title: 'Dinner with Jenny'),
  //   ];
  // }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      // 'description': description,
      // 'datetime': datetime,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        isDone: json['isDone'] as bool,
        // description:
        //     json['description'] != null ? json['description'] as String : null,
        // datetime: json['datetime'] as String,
      );
}
