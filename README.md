# static_route

Static page navigation router template library.

[![pub package](https://img.shields.io/pub/v/static_route.svg)](https://pub.dartlang.org/packages/static_route)

## Getting Started

* [添加 `static_route` 到 pubspec.yaml 文件](https://flutter.io/platform-plugins/).
* `import 'package:static_route/static_route.dart';`

在每个可导航页面中增加`StaticRouteFactory`类型的静态`route`变量

```
class HomePage extends StatelessWidget {

  static final route = StaticRouteFactory(
    name: 'HomePage',
    builder: (BuildContext context, Object? arguments) {
      return HomePage();
    },
  );

  ...
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
```

在某个dart文件中，如`pages.dart`中注册每个可导航页面的`route`列表

```
final routeTable = <StaticRoute>[
  HomePage.route,
  NextPage.route,
  ...
];
```

在应用入口点`MaterialApp`的`onGenerateRoute`中调用`Iterable<StaticRoute>`的扩展方法`generateRoute`注册`routeTable`中的路由器

```
MaterialApp(
      ...
      onGenerateRoute: routeTable.generateRoute,
      ...
    );
```

## Usage

```
 Navigator.pushNamed(context, NextPage.route.name, arguments: 'from HomePage');
```