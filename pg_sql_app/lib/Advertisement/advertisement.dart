import 'dart:convert';
import 'package:flutter/foundation.dart';

class Advertisement with ChangeNotifier {
  final String id;
  final String userId;
  final String animalId;
  final String createdDate;
  final String updateDate;
  final String title;
  final String description;
  final String imageUrl;
  final bool isActive;
  bool isUserApplied = false;

  Advertisement(
      {required this.id,
      required this.userId,
      required this.animalId,
      required this.createdDate,
      required this.updateDate,
      required this.title,
      required this.description,
      required this.imageUrl,
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
        'id': id,
        'userId': userId,
        'animalId': animalId,
        'createdDate': createdDate,
        'updateDate': updateDate,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'isActive': isActive,
      };

  void toggleApplyStatus(bool apply) {
    isUserApplied = apply;
    notifyListeners();
  }
}
