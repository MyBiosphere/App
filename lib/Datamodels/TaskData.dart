class Task {
  final int id;
  final String name;
  final String desc;
  final bool done;
  final String plant;
  final String plantName;
  final int plantId;

  const Task({
    required this.id,
    required this.name,
    required this.desc,
    required this.done,
    required this.plant,
    required this.plantName,
    required this.plantId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      desc: json['description'],
      done: json['done'],
      plant: json['plant'],
      plantName: json['plant_name'],
      plantId: json['plant_id'],
    );
  }

  static Future<List<Task>> userTaskList(List snapshot) async {
    return snapshot.map((data) {
      return Task.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Tache $id :{name: $name, desc: $desc, done: $done, plant: $plant}';
  }
}