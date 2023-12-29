import 'package:flutter/material.dart';
import 'package:pg_sql_app/Advertisement/add_advertisement.dart';
import 'package:pg_sql_app/Advertisement/advertisements.dart';
import 'package:pg_sql_app/Helpers/custom_route.dart';
import 'package:pg_sql_app/Login/auth.dart';
import 'package:pg_sql_app/Login/auth_screen.dart';
import 'package:pg_sql_app/Advertisement/advertisementOverviewScreen.dart';
import 'package:pg_sql_app/Login/profile_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthNotifier()),
          ChangeNotifierProxyProvider<AuthNotifier, Advertisements>(
            create: (context) => Advertisements("", []),
            update: (context, auth, previousAdv) => Advertisements(
              auth.username,
              previousAdv == null ? [] : previousAdv.items,
            ),
          ),
        ],
        child: Consumer<AuthNotifier>(
          builder: (context, auth, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'PetShop',
              theme: ThemeData(
                fontFamily: 'Lato',
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.blue,
                ).copyWith(
                  secondary: Colors.deepOrange,
                ),
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  },
                ),
              ),
              home: auth.isAuth ? AdvertisementOverviewScreen() : AuthScreen(),
              routes: {
                AuthScreen.routeName: (context) => AuthScreen(),
                AdvertisementOverviewScreen.routeName: (context) =>
                    AdvertisementOverviewScreen(),
                AddAdvertisementPage.routeName: (context) =>
                    AddAdvertisementPage(),
                ProfileScreen.routeName: (context) => ProfileScreen(),
              }),
        ));
  }
}
