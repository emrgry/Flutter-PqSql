import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pg_sql_app/Advertisement/advertisement.dart';
import 'package:pg_sql_app/Advertisement/advertisementOverviewScreen.dart';
import 'package:pg_sql_app/Login/auth.dart';
import 'package:http/http.dart' as http;
import 'package:pg_sql_app/Login/user_model.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class AdvertisementItem extends StatelessWidget {
  Future<void> fetchCitiesAndAnimals() async {
    // Fetch animals
    var animalResponse = await http
        .get(Uri.parse('http://localhost:8080/petShop/getAllAnimals'));

    // setState(() {
    //   animals =
    //       animalData.map<String>((item) => Animal.fromJson(item).name).toList();
    //   selectedAnimal = animals[0];
    // });
  }

  Future<User> fetchUser(String username) async {
    var userResponse = await http.get(Uri.parse(
        'http://localhost:8080/petShop/getUserByUserName?userName=${username}'));
    print(userResponse.body);
    User userData = User.fromJson(jsonDecode(userResponse.body));
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<AuthNotifier>(context, listen: false).user;
    String username =
        Provider.of<AuthNotifier>(context, listen: false).username;
    final advertisement = Provider.of<Advertisement>(context, listen: false);
    final authdata = Provider.of<AuthNotifier>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Advertisement>(
            builder: (ctx, adv, child) => IconButton(
              icon: Icon(adv.isUserApplied
                  ? Icons.add_box_outlined
                  : Icons.remove_circle_outline),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () async {
                print(adv.id);
                await http.delete(Uri.parse(
                    'http://localhost:8080/petShop/deletePost/${adv.id}'));
                // adv.toggleApplyStatus(!adv.isUserApplied);
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ),
          title: Text(
            advertisement.title,
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(advertisement.title),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio:
                            16 / 9, // Adjust the aspect ratio as needed
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            advertisement.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text('Description: ${advertisement.description}'),
                    Text('Created by: ${advertisement.createdBy?.username}'),
                    Text(
                        'Create date: ${DateFormat("dd/MM/yyyy").format(DateTime.parse(advertisement.createdDate))}'),

                    // Add other fields as needed
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text('Apply'),
                    onPressed: () async {
                      User usr = await fetchUser(username);
                      print(usr.id);
                      try {
                        final response = await http.post(
                          Uri.parse(
                              'http://localhost:8080/petShop/createApplication'),
                          headers: {"Content-Type": "application/json"},
                          body: json.encode({
                            "postId": advertisement.id,
                            "userId": usr.id,
                            "isActive": true
                          }),
                        );
                        Navigator.of(ctx).pop();
                      } catch (e) {}
                    },
                  ),
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            );
          },
          child: Hero(
            tag: advertisement.id ?? 0,
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/puppy.jpg'),
              image: NetworkImage(advertisement.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
