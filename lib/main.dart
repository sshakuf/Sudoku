import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_app/sudoku_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Sudoku App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 120, 185, 243),
              Color.fromARGB(255, 147, 200, 245)
            ],
          ),
        ),
        child: const SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SudokuScreen(),
            ],
          ),
        ),
      ),

      // Column(
      //   children: [SudokuScreen()],
      // ),
    );
  }
}
