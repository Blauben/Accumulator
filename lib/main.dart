import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accumulator.dart';

void main() {
  runApp(const RootRestorationScope(restorationId: "root", child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accumulator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              iconTheme: IconThemeData(color: Colors.white, size: 30),
              centerTitle: true,
              elevation: 15,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 30)
          ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with RestorationMixin {
  final RestorableAppState _restorableAppState = RestorableAppState();

  @override
  String get restorationId => 'acc';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_restorableAppState, 'acc');
  }

  @override
  void dispose() {
    _restorableAppState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: _restorableAppState.value,
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Accumulator"),
          leading: const Icon(Icons.numbers),
          toolbarHeight: 80,
        ),
        body: const Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              AccumulatorWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  int acc = 0;
  int numberField = 0;

  AppState() {
    loadAcc();
  }

  void loadAcc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    acc = prefs.getInt("acc") ?? 0;
    notifyListeners();
  }

  void increment() async {
    acc += numberField;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("acc", acc);
    notifyListeners();
  }

  void decrement() async {
    acc -= numberField;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("acc", acc);
    notifyListeners();
  }

  void updateNumberField(int number) {
    numberField = number;
    notifyListeners();
  }

  void resetAcc() async {
    acc = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("acc", acc);
    notifyListeners();
  }
}

class RestorableAppState extends RestorableChangeNotifier<AppState> {
  @override
  AppState createDefaultValue() {
    return AppState();
  }

  @override
  AppState fromPrimitives(Object? data) {
    var state = AppState();
    state.acc = data as int? ?? 0;
    return state;
  }

  @override
  Object? toPrimitives() {
    return value.acc;
  }
}
