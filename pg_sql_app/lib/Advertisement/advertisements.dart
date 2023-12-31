import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pg_sql_app/Exception/http_exception.dart';
import 'dart:convert';
import 'package:pg_sql_app/Advertisement/advertisement.dart';

class Advertisements with ChangeNotifier {
  List<Advertisement> _items = [];
  // List<Advertisement> _items = List.generate(
  //     10,
  //     (index) => Advertisement(
  //           id: index,
  //           createdBy: index,
  //           animalId: index,
  //           createdDate: '2023-01-${index + 1}',
  //           updateDate: '2023-02-${index + 1}',
  //           title: 'Sample Title $index',
  //           description: 'This is a sample description for item $index.',
  //           imageUrl:
  //               'https://placekitten.com/200/300?image=$index', // Placeholder image for demonstration
  //           isActive: index.isEven,
  //           isUserApplied: index % 3 == 0,
  //         ));

  final _showFilter = "all";
  final String userId;

  Advertisements(this.userId, this._items);

  Future<List<Advertisement>> fetchAdvertisements() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/petShop/getAllPosts'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Advertisement.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load advertisements');
    }
  }

  List<Advertisement> get items {
    return [..._items];
    // _items = List.generate(
    //   10,
    //   (index) => Advertisement(
    //     id: index,
    //     createdBy: index,
    //     animalId: index,
    //     createdDate: '2023-01-${index + 1}',
    //     updateDate: '2023-02-${index + 1}',
    //     title: 'Sample Title $index',
    //     description: 'This is a sample description for item $index.',
    //     imageUrl:
    //         'https://placekitten.com/200/300?image=$index', // Placeholder image for demonstration
    //     isActive: index.isEven,
    //     isUserApplied: index % 3 == 0,
    //   ),
    // );
    // if (_showFilter == "Dog") {
    //   return _items.where((advItem) => advItem.animalId == "Dog").toList();
    // } else if (_showFilter == "Cat") {
    //   return _items.where((advItem) => advItem.animalId == "Cat").toList();
    // } else {
    //   return [..._items];
    // }
  }

  void updateAdvertisements(List<dynamic> newAdvertisements) {
    _items = newAdvertisements
        .map<Advertisement>((item) => Advertisement.fromJson(item))
        .toList();
    notifyListeners();
  }

  Advertisement findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addAdvertisement(Advertisement adv) async {
    final url = Uri.parse(
        'https://www.wdc.govt.nz/files/sharedassets/public/v/1/image-collection/animals/puppy.jpg?dimension=pageimage&w=480');
    try {
      final response = await http.post(
        url,
        body: adv.toJson(),
      );
      _items.add(adv);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> fetchAndSetAdvertisement([String filterByUser = 'all']) async {
    final url = Uri.parse('');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Advertisement> loadedProduct = [];
      extractedData.forEach((advId, advData) {
        loadedProduct.add(Advertisement.fromJson(advData));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Advertisement newAdv) async {
    final advIndex = _items.indexWhere((prod) => prod.id == id);
    if (advIndex >= 0) {
      final url = Uri.parse('');
      await http.patch(url, body: newAdv.toJson());
      _items[advIndex] = newAdv;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse("http://localhost:8080/petShop/deletePost?id=${id}");
    final existingAdvIndex = _items.indexWhere((element) => element.id == id);
    Advertisement? existingProduct = _items[existingAdvIndex];
    _items.removeAt(existingAdvIndex);
    notifyListeners();
    final response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(existingAdvIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  // void showAll() {
  //   _showFilter = "all";
  //   notifyListeners();
  // }
}
