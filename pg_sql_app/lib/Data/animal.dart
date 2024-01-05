class Animal {
  final String name;
  final int? id;

  Animal({this.id, required this.name});

  // Convert a City object into a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }

  // Create a City object from a Map
  static Animal fromJson(Map<String, dynamic> json) {
    return Animal(
      name: json['name'] ?? "",
      id: json['id'],
    );
  }
}
