import 'package:flutter/material.dart';
import 'package:pg_sql_app/Advertisement/advertisement_item.dart';
import 'package:pg_sql_app/Advertisement/advertisements.dart';
import 'package:provider/provider.dart';

class AdvertisementsGrid extends StatelessWidget {
  const AdvertisementsGrid({super.key});
  @override
  Widget build(BuildContext context) {
    final advsData = Provider.of<Advertisements>(context);
    print(advsData.items);
    final advs = advsData.items;
    print(advs.length);
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: advs.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: advs[i],
        //create: (c) => products[i],
        child: AdvertisementItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
