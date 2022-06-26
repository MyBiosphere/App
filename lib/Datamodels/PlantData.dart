class Plant {
  final int id;
  final String name;
  final String desc;
  final String room;
  final String status;
  final String watering;
  final String sunshine;
  final String repot;
  final String bloom;
  final String user;

  const Plant({
    required this.id,
    required this.name,
    required this.desc,
    required this.room,
    required this.status,
    required this.watering,
    required this.sunshine,
    required this.repot,
    required this.bloom,
    required this.user,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      desc: json['description'],
      room: json['room'],
      status: json['status'],
      watering: json['watering'],
      sunshine: json['sunshine'],
      repot: json['repot'],
      bloom: json['blooming_time'],
      user: json['user'],
    );
  }

  static Future<List<Plant>> userPlantList(List snapshot) async {
    return snapshot.map((data) {
      return Plant.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Plante $id :{name: $name, desc: $desc, room: $room, bloom: $bloom}';
  }
}