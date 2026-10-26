
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../viewmodels/app_viewmodel.dart';
import '../models/models.dart';

class DetalleTurnoView extends StatelessWidget {
  final AppViewModel vm;
  final String turnoId;
  const DetalleTurnoView({required this.vm, required this.turnoId, super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        final turno = vm.turnos.where((t) => t.id == turnoId).firstOrNull;
        

        if (turno == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalle del turno')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No encontramos este turno', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: () => context.go('/agenda'), child: const Text('Volver a la agenda')),
                ],
              ),
            ),

          );
        }

        final cliente = vm.getCliente(turno.clienteId);
        final estilista = vm.getEstilista(turno.estilistaId);
        final inicio = DateFormat('HH:mm').format(turno.fechaHoraInicio);
        final duracion = vm.calcularDuracion(turno.serviciosIds);
        final fin = DateFormat('HH:mm').format(turno.fechaHoraInicio.add(Duration(minutes: duracion)));

        return Scaffold(
          appBar: AppBar(title: const Text('Detalle del turno')),
          body: ListView(
            padding: const EdgeInsets.all(16),

            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(cliente.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Chip(label: Text(turno.estado.name)),
                        ],
                      ),
                      const Divider(),
                      Text('Fecha: ${DateFormat('dd/

MM/yyyy').format(turno.fechaHoraInicio)}'),
                      Text('Hora: $inicio a $fin ($duracion min)'),
                      Text('Estilista: ${estilista.nombre}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Servicios', style: TextStyle(fontWeight: FontWeight.bold)),
              ...turno.serviciosIds.map((id) {
                final s = vm.getServicio(id);
                return ListTile(title: Text(s.nombre), trailing: Text('\$${s.precio}'));
              }),
              const Divider(),
              ListTile(title: const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), trailing: Text('\$$

{vm.calcularPrecio(turno.serviciosIds)}', style: const TextStyle(fontWeight: FontWeight.bold))),
              if (turno.notas != null && turno.notas!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Notas', style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(8)),
                  child: SingleChildScrollView(child: Text(turno.notas!)),
                ),
              ]
            ],
          ),
          bottomNavigationBar: turno.estado 

== EstadoTurno.programado ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => context.push('/turno/${turno.id}/editar'), child: const Text('Editar'))),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final t = Turno(id: turno.id, clienteId: turno.clienteId, estilistaId: turno.estilistaId, serviciosIds: turno.serviciosIds, fechaHoraInicio: turno.fechaHoraInicio, notas: turno.notas, estado: EstadoTurno.completado, fechaCreacion: turno.fechaCreacion, fechaModificacion: DateTime.now());
                      vm.actualizarTurno(t);
                    }, 

                    child: const Text('Completar')
                  )
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                    onPressed: () {
                      final t = Turno(id: turno.id, clienteId: turno.clienteId, estilistaId: turno.estilistaId, serviciosIds: turno.serviciosIds, fechaHoraInicio: turno.fechaHoraInicio, notas: turno.notas, estado: EstadoTurno.cancelado, fechaCreacion: turno.fechaCreacion, fechaModificacion: DateTime.now());
                      vm.actualizarTurno(t);
                    }, 
                    child: const Text('Cancelar')
                  )

                ),
              ],
            ),
          ) : null,
        );
      },
    );
  }
}
