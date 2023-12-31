import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pg_sql_app/Data/animal.dart';
import 'package:pg_sql_app/Login/user_model.dart';

class Advertisement with ChangeNotifier {
  final int? id;
  final User? createdBy;
  final String? name;
  final String createdDate;
  final String? updateDate;
  final String title;
  final String description;
  final String imageUrl;
  final Animal? animal;
  final String? animalName;
  final bool isActive;
  bool isUserApplied = false;

  Advertisement(
      {this.id,
      this.createdBy,
      this.name,
      required this.createdDate,
      this.updateDate,
      required this.title,
      required this.description,
      this.imageUrl =
          'https://www.stfrancisanimalwelfare.co.uk/wp-content/uploads/placeholder-logo-2.png',
      required this.isActive,
      this.animal,
      this.animalName,
      this.isUserApplied = false});

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'],
      createdBy: User.fromJson(json['createdBy']),
      createdDate: json['createdDate'],
      updateDate: json['updateDate'] ?? "",
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'] ??
          'https://www.stfrancisanimalwelfare.co.uk/wp-content/uploads/placeholder-logo-2.png',
      isActive: json['isActive'],
      animal: Animal.fromJson(json['animal']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userName': name,
        'createdDate': createdDate,
        'updateDate': updateDate,
        'title': title,
        'description': description,
        'imageUrl': imageUrl ??
            "https://www.stfrancisanimalwelfare.co.uk/wp-content/uploads/placeholder-logo-2.png",
        'isActive': isActive,
        'animalName': animalName,
      };

  void toggleApplyStatus(bool apply) {
    isUserApplied = apply;
    notifyListeners();
  }
}
