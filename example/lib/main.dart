import 'package:flutter/material.dart';
import 'package:static_route/static_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: routeTable.generateRoute,
      initialRoute: HomePage.route.name,
    );
  }
}

final routeTable = <StaticRoute>[
  HomePage.route,
  NextPage.route,
];

class HomePage extends StatelessWidget {
  static final route = StaticRoute(
    name: 'HomePage',
    builder: (RouteSettings settings) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => HomePage(),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HomePage')),
      body: Center(
        child: ElevatedButton(
          child: Text('Next page'),
          onPressed: () {
            Navigator.pushNamed(context, NextPage.route.name,
                arguments: 'from HomePage');
          },
        ),
      ),
    );
  }
}

class NextPage extends StatefulWidget {
  NextPage(this.content);

  final String content;

  static final route = StaticRouteFactory(
    name: 'NextPage',
    builder: (BuildContext context, Object? arguments) {
      return NextPage(arguments as String);
    },
  );

  @override
  State createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NextPage')),
      body: Center(
        child: Text(widget.content),
      ),
    );
  }
}
