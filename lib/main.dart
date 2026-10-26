
import 'package:flutter/material.dart';
import'package:go_router/go_router.dart;
import 'theme/app_theme.dart';
import 'viewmodels/app_viewmodel.dart';
import 'views/agenda_view.dart';
import 'views/clientes_view.dart';
import 'views/servicios_view.dart';
import 'views/estilistas_view.dart';
import 'views/detalle_turno_view.dart';
import'views/formulario_turno_view.dart';

void main() {
  runApp(const TurcoApp());
}


class TurcoApp extends StatefulWidget {
  const TurcoApp({super.key});
  @override
  State<TurcoApp> createState() => _TurcoAppState();
}

class _TurcoAppState extends State<TurcoApp> {
  final AppViewModel _vm = AppViewModel();
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : (_themeMode == ThemeMode.dark ? ThemeMode.system : ThemeMode.light);
    });

  }

  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  late final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/agenda',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/agenda', builder: (c, s) => AgendaView(vm: _vm, themeMode: _themeMode, onToggleTheme: 

_toggleTheme))]),
          StatefulShellBranch(routes: [GoRoute(path: '/clientes', builder: (c, s) => ClientesView(vm: _vm))]),
          StatefulShellBranch(routes: [GoRoute(path: '/servicios', builder: (c, s) => ServiciosView(vm: _vm))]),
          StatefulShellBranch(routes: [GoRoute(path: '/estilistas', builder: (c, s) => EstilistasView(vm: _vm))]),
        ],
      ),
      GoRoute(path: '/turno/nuevo', parentNavigatorKey: _rootNavigatorKey, builder: (c, s) => FormularioTurnoView(vm: _vm, extra: s.extra as Map<String, dynamic>?)),
      GoRoute(path: '/turno/:id', parentNavigatorKey: _rootNavigatorKey, builder: (c, s) => DetalleTurnoView(vm: _vm, turnoId: s.pathParameters['id']!)),
      GoRoute(path: '/turno/:id/editar', 

parentNavigatorKey: _rootNavigatorKey, builder: (c, s) => FormularioTurnoView(vm: _vm, turnoId: s.pathParameters['id'])),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Turco',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell 

navigationShell;
  const MainScaffold({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Agenda'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Clientes'),
          NavigationDestination(icon: Icon(Icons.content_cut), label: 'Servicios'),

          NavigationDestination(icon: Icon(Icons.person), label: 'Estilistas'),
        ],
      ),
    );
  }
}
