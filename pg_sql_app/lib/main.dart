import 'package:flutter/material.dart';
import 'package:pg_sql_app/Helpers/custom_route.dart';
import 'package:pg_sql_app/Login/auth.dart';
import 'package:pg_sql_app/Login/auth_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthNotifier()),
        ],
        child: Consumer<AuthNotifier>(
          builder: (context, value, child) => MaterialApp(
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
            home: AuthScreen(),
          ),
        ));
  }
}
