import 'package:flutter/material.dart';
import 'package:pg_sql_app/Advertisement/advertisementsGrid.dart';
import 'package:provider/provider.dart';

import '../AppDrawer/app_drawer.dart';
//

enum FilterOptions { Dogs, Cats, All }

class AdvertisementOverviewScreen extends StatefulWidget {
  static const routeName = '/advertisement-overview';

  @override
  State<AdvertisementOverviewScreen> createState() =>
      _AdvertisementOverviewScreenState();
}

class _AdvertisementOverviewScreenState
    extends State<AdvertisementOverviewScreen> {
  var _showFilter = "All";
  var _isInit = true;
  var _isLoading = false;

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Products>(context).fetchAndSetProducts().then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PetShop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only dogs'), value: FilterOptions.Dogs),
              PopupMenuItem(
                  child: Text('Only cats'), value: FilterOptions.Cats),
              PopupMenuItem(child: Text('Show all'), value: FilterOptions.All),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(
                () {
                  if (selectedValue == FilterOptions.Dogs) {
                    _showFilter = "Dogs";
                  } else if (selectedValue == FilterOptions.Cats) {
                    _showFilter = "Cats";
                  } else if (selectedValue == FilterOptions.All) {
                    _showFilter = "All";
                  } else {
                    _showFilter = "All";
                  }
                },
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const AdvertisementsGrid(),
    );
  }
}
