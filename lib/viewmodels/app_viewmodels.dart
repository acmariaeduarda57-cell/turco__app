
import 'package:flutter/material.dart';
import '../models/models.dart';

class AppViewModel extends ChangeNotifier {
  final List<Servicio> _servicios = [];
  final List<Estilista> _estilistas = [];
  final List<Cliente> _clientes = [];
  final List<Turno> _turnos = [];

  List<Servicio> get servicios => _servicios;
  List<Estilista> get estilistas => _estilistas;
  List<Cliente> get clientes => _clientes;
  List<Turno> get turnos => _turnos;

  AppViewModel() {
    _cargarDatosPrueba();
  }

  Servicio getServicio(String id) => _servicios.firstWhere((s) => s.id == id);

  Estilista getEstilista(String id) => _estilistas.firstWhere((e) => e.id == id);
  Cliente getCliente(String id) => _clientes.firstWhere((c) => c.id == id);

  List<Turno> turnosDelDia(DateTime fecha) {
    return _turnos.where((t) => t.fechaHoraInicio.year == fecha.year && t.fechaHoraInicio.month == fecha.month && t.fechaHoraInicio.day == fecha.day).toList()
      ..sort((a, b) => a.fechaHoraInicio.compareTo(b.fechaHoraInicio));
  }

  double calcularPrecio(List<String> serviciosIds) {
    return serviciosIds.fold(0, (sum, id) => sum + getServicio(id).precio);
  }


  int calcularDuracion(List<String> serviciosIds) {
    return serviciosIds.fold(0, (sum, id) => sum + getServicio(id).duracionMinutos);
  }

  bool haySolape(DateTime inicio, int duracion, String estilistaId, String clienteId, {String? turnoIdExcluir}) {
    final fin = inicio.add(Duration(minutes: duracion));
    for (var t in _turnos) {
      if (t.estado == EstadoTurno.cancelado) continue;
      if (turnoIdExcluir != null && t.id == turnoIdExcluir) continue;
      final tInicio = t.fechaHoraInicio;
      final tFin = tInicio.add(Duration(minutes: calcularDuracion(t.serviciosIds)));
      final solapa = inicio.isBefore(tFin) && 

fin.isAfter(tInicio);
      if (solapa && (t.estilistaId == estilistaId || t.clienteId == clienteId)) return true;
    }
    return false;
  }

  void agregarTurno(Turno turno) { _turnos.add(turno); notifyListeners(); }
  void actualizarTurno(Turno turno) {
    final index = _turnos.indexWhere((t) => t.id == turno.id);
    if (index != -1) { _turnos[index] = turno; notifyListeners(); }
  }
  void agregarCliente(Cliente cliente) { _clientes.add(cliente); notifyListeners(); }
  void actualizarCliente(Cliente cliente) {
    final index = _clientes.indexWhere((c) => c.id == cliente.id);
    if (index != -1) { _clientes[index] = cliente; notifyListeners(); }

  }
  void eliminarCliente(String id) {
    _clientes.removeWhere((c) => c.id == id);
    _turnos.removeWhere((t) => t.clienteId == id);
    notifyListeners();
  }

  void _cargarDatosPrueba() {
    // Servicios
    _servicios.addAll([
      Servicio(id: 's1', nombre: 'Corte mujer', categoria: CategoriaServicio.corte, duracionMinutos: 60, precio: 30, publico: Publico.mujeres),
      Servicio(id: 's2', nombre: 'Corte caballero', categoria: CategoriaServicio.corte, duracionMinutos: 45, precio: 25, publico: Publico.hombres),
      Servicio(id: 's3', nombre: 'Corte clásico', categoria: CategoriaServicio.corte, duracionMinutos: 45, precio: 25, publico: 

Publico.unisex),
      Servicio(id: 's4', nombre: 'Color completo', categoria: CategoriaServicio.color, duracionMinutos: 120, precio: 70, publico: Publico.mujeres),
      Servicio(id: 's5', nombre: 'Barba', categoria: CategoriaServicio.barba, duracionMinutos: 45, precio: 20, publico: Publico.hombres),
      Servicio(id: 's6', nombre: 'Afeitado', categoria: CategoriaServicio.barba, duracionMinutos: 30, precio: 15, publico: Publico.hombres),
      Servicio(id: 's7', nombre: 'Peinado evento', categoria: CategoriaServicio.peinado, duracionMinutos: 60, precio: 40, publico: Publico.unisex),
      Servicio(id: 's8', nombre: 'Hidratación', categoria: CategoriaServicio.tratamiento, duracionMinutos: 45, precio: 28, publico: Publico.unisex),
      Servicio(id: 's9', nombre: 'Keratina', 

categoria: CategoriaServicio.tratamiento, duracionMinutos: 90, precio: 55, publico: Publico.mujeres),
      Servicio(id: 's10', nombre: 'Arreglo de barba', categoria: CategoriaServicio.barba, duracionMinutos: 30, precio: 15, publico: Publico.hombres),
      Servicio(id: 's11', nombre: 'Color raíces', categoria: CategoriaServicio.color, duracionMinutos: 60, precio: 40, publico: Publico.mujeres),
      Servicio(id: 's12', nombre: 'Peinado casual', categoria: CategoriaServicio.peinado, duracionMinutos: 30, precio: 20, publico: Publico.unisex),
    ]);
    // Estilistas
    _estilistas.addAll([
      Estilista(id: 'e1', nombre: 'Marta Salazar', avatarUrl: '', serviciosIds: ['s1', 's4', 's7', 's11']),

      Estilista(id: 'e2', nombre: 'Pedro Vega', avatarUrl: '', serviciosIds: ['s2', 's5', 's6', 's10']),
      Estilista(id: 'e3', nombre: 'Lucía Torres', avatarUrl: '', serviciosIds: ['s1', 's3', 's8', 's9']),
      Estilista(id: 'e4', nombre: 'Rafael Núñez', avatarUrl: '', serviciosIds: ['s2', 's3', 's5', 's10', 's12']),
      Estilista(id: 'e5', nombre: 'Carlos Ruiz', avatarUrl: '', serviciosIds: ['s1', 's2', 's3', 's5', 's7']),
    ]);
    // Clientes
    _clientes.addAll([
      Cliente(id: 'c1', nombre: 'Laura Gómez', telefono: '52111222', genero: Genero.mujer, correo: 'laura@correo.com', fechaRegistro: DateTime.now().subtract(const Duration(days: 100))),
      Cliente(id: 'c2', nombre: 'Carlos Ruiz', telefono: '52345678', genero: 

Genero.hombre, correo: 'carlos@correo.com', fechaRegistro: DateTime.now().subtract(const Duration(days: 80))),
      Cliente(id: 'c3', nombre: 'Ana Martín', telefono: '53220140', genero: Genero.mujer, fechaRegistro: DateTime.now().subtract(const Duration(days: 60))),
      Cliente(id: 'c4', nombre: 'Diego Pérez', telefono: '55908771', genero: Genero.hombre, fechaRegistro: DateTime.now().subtract(const Duration(days: 50))),
      Cliente(id: 'c5', nombre: 'Sofía Díaz', telefono: '54667310', genero: Genero.mujer, fechaRegistro: DateTime.now().subtract(const Duration(days: 40))),
      Cliente(id: 'c6', nombre: 'Javier Soto', telefono: '52774009', genero: Genero.hombre, fechaRegistro: 

DateTime.now().subtract(const Duration(days: 30))),
      Cliente(id: 'c7', nombre: 'Marta Peña', telefono: '53441902', genero: Genero.mujer, fechaRegistro: DateTime.now().subtract(const Duration(days: 20))),
      Cliente(id: 'c8', nombre: 'Luis Castro', telefono: '58123456', genero: Genero.hombre, fechaRegistro: DateTime.now().subtract(const Duration(days: 10))),
      Cliente(id: 'c9', nombre: 'Elena Ríos', telefono: '59987654', genero: Genero.mujer, fechaRegistro: DateTime.now().subtract(const Duration(days: 5))),
      Cliente(id: 'c10', nombre: 'Jorge Silva', telefono: '51234567', genero: Genero.hombre, fechaRegistro: DateTime.now()),
    ]);

    // Turnos
    final hoy = DateTime.now();
    final DateTime hoyInicio = DateTime(hoy.year, hoy.month, hoy.day);
    DateTime f(int daysOffset, int hour, int minute) => hoyInicio.add(Duration(days: daysOffset, hours: hour, minutes: minute));

    _turnos.addAll([
      Turno(id: 't1', clienteId: 'c1', estilistaId: 'e1', serviciosIds: ['s1'], fechaHoraInicio: f(0, 9, 0), estado: EstadoTurno.completado, fechaCreacion: f(-1, 10, 0), fechaModificacion: f(-1, 10, 0)),
      Turno(id: 't2', clienteId: 'c2', estilistaId: 'e2', serviciosIds: ['s2', 's5'], fechaHoraInicio: f(0, 10, 0), notas: 'Prefiere la máquina en el número 2 a los lados.', estado: EstadoTurno.programado, fechaCreacion: f(-2, 10, 0), fechaModificacion: f(-1, 10, 0)),
      Turno(id: 't3', clienteId: 'c3', estilistaId: 'e1', serviciosIds: ['s4', 's7'], fechaHoraInicio: f(0, 10, 30), estado: EstadoTurno.programado, fechaCreacion: f(-1, 10, 0), fechaModificacion: f(-1, 10, 0)),
      Turno(id: 't4', clienteId: 'c4', estilistaId: 'e2', serviciosIds: ['s10'], fechaHoraInicio: f(0, 12, 0), estado: EstadoTurno.cancelado, fechaCreacion: f(-1, 10, 0), fechaModificacion: f(-1, 10, 0)),
      Turno(id: 't5', clienteId: 'c5', estilistaId: 'e3', serviciosIds: ['s1', 's8'], fechaHoraInicio: f(-1, 9, 0), estado: EstadoTurno.completado, fechaCreacion: f(-2, 10, 0), fechaModificacion: f(-1, 10, 0)),
      Turno(id: 't8', clienteId: 'c8', estilistaId: 'e2', serviciosIds: ['s2', 's5'], fechaHoraInicio: f(1, 9, 0), estado: EstadoTurno.programado, fechaCreacion: f(0, 10, 0), fechaModificacion: f(0, 10, 0)),
      Turno(id: 't9', clienteId: 'c9', estilistaId: 'e3', serviciosIds: ['s1', 's4', 's9'], fechaHoraInicio: f(1, 14, 0), estado: EstadoTurno.programado, fechaCreacion:f(0, 10, 0), fechaModificacion: f(0, 10, 0)),
      Turno(id: 't13', clienteId: 'c3', estilistaId: 'e1', serviciosIds: ['s1'], fechaHoraInicio: f(5, 18, 0), estado: EstadoTurno.programado, fechaCreacion: f(0, 10, 0), fechaModificacion: f(0, 10, 0)),
    ]);
  }
}
