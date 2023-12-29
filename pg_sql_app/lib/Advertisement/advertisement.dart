import 'dart:convert';
import 'package:flutter/foundation.dart';

class Advertisement with ChangeNotifier {
  final int? id;
  final int? userId;
  final int animalId;
  final String createdDate;
  final String? updateDate;
  final String title;
  final String description;
  final String imageUrl;
  final bool isActive;
  bool isUserApplied = false;

  Advertisement(
      {this.id,
      this.userId,
      required this.animalId,
      required this.createdDate,
      this.updateDate,
      required this.title,
      required this.description,
      this.imageUrl =
          'https://www.stfrancisanimalwelfare.co.uk/wp-content/uploads/placeholder-logo-2.png',
      required this.isActive,
      this.isUserApplied = false});

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'],
      userId: json['userId'],
      animalId: json['animalId'],
      createdDate: json['createdDate'],
      updateDate: json['updateDate'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id ?? -1,
        'userId': userId ?? -1,
        'animalId': animalId,
        'createdDate': createdDate,
        'updateDate': updateDate ?? "",
        'title': title,
        'description': description,
        'imageUrl': imageUrl ?? "",
        'isActive': isActive,
      };

  void toggleApplyStatus(bool apply) {
    isUserApplied = apply;
    notifyListeners();
  }
}
