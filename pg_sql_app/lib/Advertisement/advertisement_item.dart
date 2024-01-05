import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pg_sql_app/Advertisement/advertisement.dart';
import 'package:pg_sql_app/Advertisement/advertisementOverviewScreen.dart';
import 'package:pg_sql_app/Login/auth.dart';
import 'package:http/http.dart' as http;
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

  @override
  Widget build(BuildContext context) {
    final advertisement = Provider.of<Advertisement>(context, listen: false);
    final authdata = Provider.of<AuthNotifier>(context, listen: false);
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
              onPressed: () {
                http.delete(Uri.parse(
                    'http://localhost:8080/petShop/deletePost?id=${adv.id}'));
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
                    onPressed: () {
                      // Handle apply action here
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
