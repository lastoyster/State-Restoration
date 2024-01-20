import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      restorationScopeId: "root",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

  static Route<int> _buildRoute(BuildContext context, Object? params) {
    return MaterialPageRoute<int>(
      builder: (BuildContext context) => CounterPage(),
    );
  }
}

class _HomePageState extends State<HomePage> with RestorationMixin {
  int? _lastCounter;
  late RestorableRouteFuture<int> _counterRoute;

  @override
  void initState() {
    super.initState();
    _counterRoute = RestorableRouteFuture<int>(
        onPresent: (NavigatorState navigator, Object? arguments) {
      return Navigator.restorablePush(context, HomePage._buildRoute);
    }, onComplete: (int count) {
      setState(() {
        _lastCounter = count;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_lastCounter != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Last counter: $_lastCounter',
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton(
              child: const Text("Open counter screen"),
              onPressed: () => _onCounter(context),
            ),
          ],
        ),
      ),
    );
  }

  void _onCounter(BuildContext context) {
    _counterRoute.present();
  }

  @override
  String? get restorationId => "home_screen";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_counterRoute, "counter_route");
  }

  @override
  void dispose() {
    super.dispose();
    _counterRoute.dispose();
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> with RestorationMixin {
  final RestorableInt _counter = RestorableInt(0);

  void _incrementCounter() {
    setState(() {
      _counter.value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _counter.value);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Counter"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '${_counter.value}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          )),
    );
  }

  @override
  String? get restorationId => "counter_screen";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_counter, "counter");
  }

  @override
  void dispose() {
    super.dispose();
    _counter.dispose();
  }
}