import 'package:flutter/material.dart';
import 'package:pg_sql_app/Advertisement/advertisement.dart';
import 'package:pg_sql_app/Advertisement/advertisementOverviewScreen.dart';
import 'package:pg_sql_app/Login/auth.dart';

import 'package:provider/provider.dart';

class AdvertisementItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final advertisement = Provider.of<Advertisement>(context, listen: false);
    final authdata = Provider.of<AuthNotifier>(context, listen: false);
    print("sad");
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
                adv.toggleApplyStatus(!adv.isUserApplied);
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
            Navigator.of(context).pushNamed(
              AdvertisementOverviewScreen.routeName,
              arguments: advertisement.id,
            );
          },
          child: Hero(
            tag: advertisement.id,
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
