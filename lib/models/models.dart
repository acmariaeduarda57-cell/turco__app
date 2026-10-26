enum Genero { mujer, hombre }
enum Publico { mujeres, hombres, unisex }
enum CategoriaServicio { corte, color, barba, peinado, tratamiento }
enum EstadoTurno { programado, completado, cancelado }

class Servicio {
  final String id;
  final String nombre;
  final CategoriaServicio categoria;
  final int duracionMinutos;

  final double precio;
  final Publico publico;

  Servicio({required this.id, required this.nombre, required this.categoria, required this.duracionMinutos, required this.precio, required this.publico});
}

class Estilista {
  final String id;
  final String nombre;
  final String avatarUrl;
  final List<String> serviciosIds;

  Estilista({required this.id, required this.nombre, required this.avatarUrl, required this.serviciosIds});
}

class Cliente {
  final String id;

  final String nombre;
  final String telefono;
  final Genero genero;
  final String? correo;
  final DateTime fechaRegistro;

  Cliente({required this.id, required this.nombre, required this.telefono, required this.genero, this.correo, required this.fechaRegistro});
}

class Turno {
  final String id;
  final String clienteId;
  final String estilistaId;
  final List<String> serviciosIds;
  final DateTime fechaHoraInicio;
  final String? notas;
  final EstadoTurno estado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;


  Turno({required this.id, required this.clienteId, required this.estilistaId, required this.serviciosIds, required this.fechaHoraInicio, this.notas, required this.estado, required this.fechaCreacion, required this.fechaModificacion});
}
