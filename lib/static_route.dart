library static_route;

import 'package:flutter/material.dart';

/// 静态路由
///
/// 所有静态路由页面都必须提供此静态实例
/// 用于在[MaterialApp.onGenerateRoute]中注册，
/// [StaticRoute]实例应当使用同一名称[route]。
/// 页面导航时使用名称导航方法。
///
/// 典型用法
///
/// ```dart
///
/// class ExamplePage extends StatelessWidget {
///
///   ExamplePage(this.id, this.code);
///
///   final String id;
///
///   final int code;
///
///   /// 本页面路由器
///   static final route = StaticRoute(
///     name: 'ExamplePage',
///     builder: (RouteSettings settings) {
///       final arguments = settings.arguments as List;
///
///       return MaterialPageRoute(
///         settings: settings,
///         builder: (context) => ExamplePage(arguments[0], arguments[1]),
///       );
///     },
///   );
///
///   ...
/// }
///
/// final routeTable = <StaticRoute>[
///  ExamplePage.route,
///  ...
/// ];
///
/// MaterialApp(
///  onGenerateRoute: routeTable.generateRoute,
/// );
///
/// Navigator.pushNamed(context, ExamplePage.route.name, arguments: ['test', 123]);
///
/// ```
///
class StaticRoute {
  /// 页面名称
  ///
  /// 路由名称，用于[Navigator.pushNamed]等导航方法，
  /// 名称应当具有全局唯一的特性
  final String name;

  /// 路由构建器
  final RouteFactory builder;

  const StaticRoute({
    @required this.name,
    @required this.builder,
  })  : assert(name != null),
        assert(builder != null);
}

/// 生成静态路由工厂
///
/// 构建根[MaterialApp]时需要在[MaterialApp.onGenerateRoute]上绑定此方法后静态路由表才能生效
///
/// ```dart
///
/// final routeTable = <StaticRoute>[
///  ExamplePage.route,
///  ...
/// ];
///
/// MaterialApp(
///  onGenerateRoute: generateRouteFactory(routeTable),
/// );
///
/// ```
///
RouteFactory generateRouteFactory(Iterable<StaticRoute> routes) {
  assert(routes != null);

  final table = {for (var route in routes) route.name: route.builder};

  return (settings) =>
      table[settings.name]?.call(settings) ??
      MaterialPageRoute(
        settings: settings,
        builder: (context) => Center(child: Text('${settings.name} route unregistered')),
      );
}

/// 扩展[Iterable<StaticRoute>]增加路由器生成快捷方式
extension GenerateRouteFactoryExtension on Iterable<StaticRoute> {
  /// 静态路由工厂
  ///
  /// 将[Iterable<StaticRoute>]通过[generateRouteFactory]转换为页面路由器
  RouteFactory get generateRoute => generateRouteFactory(this);
}
