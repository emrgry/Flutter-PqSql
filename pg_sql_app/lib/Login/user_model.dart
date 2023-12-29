class User {
  final String username;
  final String password;
  final String name;
  final String surname;
  final String address;
  final int city;
  final int? animalId;

  User({
    required this.username,
    required this.password,
    required this.name,
    required this.surname,
    required this.address,
    required this.city,
    this.animalId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      name: json['name'],
      surname: json['surname'],
      address: json['address'],
      city: json['city'],
      animalId: json['animal_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'name': name,
        'surname': surname,
        'address': address,
        'city': city,
        'animal_id': animalId ?? "",
      };
}
