class Animal {
  final String name;

  Animal({required this.name});

  // Convert a City object into a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  // Create a City object from a Map
  static Animal fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return Animal(name: "");
    }
    return Animal(
      name: json['name'] ?? "",
    );
  }
}
