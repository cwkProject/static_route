library static_route;

import 'package:flutter/material.dart';

/// 用于生成静态路由页面widget的方法
///
/// 在[StaticRouteFactory]中提供，[arguments]为[Navigator.pushNamed]时传入的页面参数。
typedef StaticRouteWidgetBuilder = Widget Function(
    BuildContext context, Object? arguments);

/// 静态路由页面退出回调
///
/// [arguments]为进入页面时传递的参数，[result]为退出页面时[Navigator.pop]返回的参数。
typedef OnStaticRouteExit = void Function(
    BuildContext context, Object? arguments, dynamic result);

/// 静态路由构建器
///
/// 此路由构建器为[StaticRoute]的常用简单实现
///
/// 所有静态路由页面都必须提供此静态实例
/// 用于在[MaterialApp.onGenerateRoute]中注册，
/// [StaticRouteFactory]实例应当使用同一名称`route`。
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
///   static final route = StaticRouteFactory(
///     name: 'ExamplePage',
///     builder: (BuildContext context, Object? arguments) {
///       final args = arguments as List;
///
///       return ExamplePage(args[0], args[1]);
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
/// * [maintainState],
/// {@macro flutter.widgets.ModalRoute.maintainState}
/// * [fullscreenDialog],
/// {@macro flutter.widgets.PageRoute.fullscreenDialog}
/// * [allowSnapshotting],
/// {@macro flutter.widgets.TransitionRoute.allowSnapshotting}
/// * [barrierDismissible],
/// {@macro  flutter.widgets.ModalRoute.barrierDismissible}
class StaticRouteFactory extends StaticRoute {
  StaticRouteFactory({
    required super.name,
    required StaticRouteWidgetBuilder builder,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
    super.onExit,
  }) : super(
          builder: (settings) => MaterialPageRoute(
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            allowSnapshotting: allowSnapshotting,
            barrierDismissible: barrierDismissible,
            builder: (context) => builder(context, settings.arguments),
          ),
        );
}

/// 静态路由
///
/// 所有静态路由页面都必须提供此静态实例
/// 用于在[MaterialApp.onGenerateRoute]中注册，
/// [StaticRoute]实例应当使用同一名称`route`。
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
  const StaticRoute({required this.name, required this.builder, this.onExit});

  /// 页面名称
  ///
  /// 路由名称，用于[Navigator.pushNamed]等导航方法，
  /// 名称应当具有全局唯一的特性
  final String name;

  /// 路由构建器
  final RouteFactory builder;

  /// 静态路由页面退出回调
  final OnStaticRouteExit? onExit;
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
  String? getName(String? name) {
    if (name != null && name.startsWith('/') && name.length > 1) {
      return name.substring(1);
    }

    return name;
  }

  final table = {for (var route in routes) getName(route.name): route};

  return (settings) {
    final staticRoute = table[getName(settings.name)];
    if (staticRoute == null) {
      return null;
    }

    final route = staticRoute.builder(settings);

    if (route != null && staticRoute.onExit != null) {
      route.popped.then((value) {
        staticRoute.onExit
            ?.call(route.navigator!.context, settings.arguments, value);
      });
    }

    return route;
  };
}

/// 扩展[Iterable<StaticRoute>]增加路由器生成快捷方式
extension GenerateRouteFactoryExtension on Iterable<StaticRoute> {
  /// 静态路由工厂
  ///
  /// 将[Iterable<StaticRoute>]通过[generateRouteFactory]转换为页面路由器
  RouteFactory get generateRoute => generateRouteFactory(this);
}
