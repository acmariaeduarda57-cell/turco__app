
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../viewmodels/app_viewmodel.dart';
import '../models/models.dart';

class AgendaView extends StatefulWidget {
  final AppViewModel vm;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  const AgendaView({required this.vm, required this.themeMode, required this.onToggleTheme, super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends 

State<AgendaView> {
  DateTime _selectedDate = DateTime.now();
  String? _filtroEstilista;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.vm,
      builder: (context, _) {
        final turnos = widget.vm.turnosDelDia(_selectedDate).where((t) {
          if (_filtroEstilista != null && t.estilistaId != _filtroEstilista) return false;
          return true;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Turco', style: TextStyle(fontWeight: FontWeight.bold)),

            actions: [
              IconButton(
                icon: Icon(widget.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                onPressed: widget.onToggleTheme,
              )
            ],
          ),
          body: Column(
            children: [
              _buildDateStrip(),
              _buildResumen(),
              _buildFiltros(),
              Expanded(
                child: turnos.isEmpty
                    ? const Center(child: Text('No hay turnos para este día'))
                    : ListView.builder(
                        itemCount: turnos.length,
                        itemBuilder: (context, index) 

=> _buildTurnoCard(turnos[index]),
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await context.push('/turno/nuevo', extra: {'fecha': _selectedDate});
              if (result == true && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Turno guardado')));
              }
            },
            label: const Text('Nuevo turno'),
            icon: const Icon(Icons.add),
          ),
        );

      },
    );
  }

  Widget _buildDateStrip() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          final isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month;
          final isSunday = date.weekday == DateTime.sunday;
          return GestureDetector(
            onTap: isSunday ? null : () => setState(() => _selectedDate = date),

            child: Container(
              width: 60,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('E', 'es').format(date), style: TextStyle(color: isSelected ? Theme.of(context).colorScheme.onPrimary : null)),
                  Text(date.day.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Theme.of(context).colorScheme.onPrimary

 : (isSunday ? Colors.grey : null))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResumen() {
    final turnos = widget.vm.turnosDelDia(_selectedDate);
    final programados = turnos.where((t) => t.estado == EstadoTurno.programado).length;
    final completados = turnos.where((t) => t.estado == EstadoTurno.completado).length;
    final ingreso = turnos.where((t) => t.estado != EstadoTurno.cancelado).fold(0.0, (sum, t) 

=> sum + widget.vm.calcularPrecio(t.serviciosIds));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoCard('Programados', programados.toString()),
          _infoCard('Completados', completados.toString()),
          _infoCard('Ingreso est.', '\$$ingreso'),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String value) {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltros() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [

          ChoiceChip(label: const Text('Todos'), selected: _filtroEstilista == null, onSelected: (_) => setState(() => _filtroEstilista = null)),
          ...widget.vm.estilistas.map((e) => Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ChoiceChip(label: Text(e.nombre.split(' ')[0]), selected: _filtroEstilista == e.id, onSelected: (_) => setState(() => _filtroEstilista = e.id)),
          )),
        ],
      ),
    );
  }

  Widget _buildTurnoCard(Turno t) {
    final cliente = widget.vm.getCliente(t.clienteId);
    final estilista = 

widget.vm.getEstilista(t.estilistaId);
    final inicio = DateFormat('HH:mm').format(t.fechaHoraInicio);
    final fin = DateFormat('HH:mm').format(t.fechaHoraInicio.add(Duration(minutes: widget.vm.calcularDuracion(t.serviciosIds))));
    Color estadoColor = t.estado == EstadoTurno.programado ? Colors.green : (t.estado == EstadoTurno.completado ? Colors.blue : Colors.red);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: () => context.push('/turno/${t.id}'),
        leading: Container(width: 4, color: estadoColor),

        title: Row(
          children: [
            Text(inicio, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Text(cliente.nombre),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$inicio - $fin'),
            Text(t.serviciosIds.map((id) => widget.vm.getServicio(id).nombre).join(' + ')),
            Text('Estilista: ${estilista.nombre}'),
          ],
        ),
        trailing: Chip(label: Text(t.estado.name), backgroundColor: estadoColor.withOpacity(0.2)),

      ),
    );
  }
}
