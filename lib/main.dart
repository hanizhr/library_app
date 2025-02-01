import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UI/login.dart';
import 'UI/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();
  runApp(MyApp(
    themeProvider: themeProvider,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  const MyApp({super.key, required this.themeProvider});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, themeProvider, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness:
                  themeProvider.dark ? Brightness.dark : Brightness.light,
              fontFamily: 'Oswald',
            ),
            home: SafeArea(child: LoginPage()),
          );
        },
      ),
    );
  }
}
