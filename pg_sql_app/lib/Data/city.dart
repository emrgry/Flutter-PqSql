class City {
  final int? id;
  final int? cityCode;
  final String name;

  City({this.id, this.cityCode, required this.name});

  // Convert a City object into a Map
  Map<String, dynamic> toJson() {
    return {'cityCode': cityCode, 'cityName': name, 'id': id};
  }

  // Create a City object from a Map
  static City fromJson(Map<String, dynamic> json) {
    return City(
        cityCode: json['cityCode'], name: json['cityName'], id: json['id']);
  }
}
