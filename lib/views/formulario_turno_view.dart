
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/app_viewmodel.dart';
import '../models/models.dart';
import 'package:intl/intl.dart';

class FormularioTurnoView extends StatefulWidget {
  final AppViewModel vm;
  final String? turnoId;
  final Map<String, dynamic>? extra;

  const FormularioTurnoView({required this.vm, this.turnoId, this.extra, super.key});

  @override
  State<FormularioTurnoView> createState() => _FormularioTurnoViewState();
}

class _FormularioTurnoViewState extends State<FormularioTurnoView> {
  final _formKey = GlobalKey<FormState>();
  String? _clienteId;
  List<String> _serviciosIds = [];
  String? _estilistaId;
  DateTime? _fecha;
  DateTime? _horaInicio;

  @override
  void initState() {
    super.initState();
    if (widget.turnoId != null) {
      final t = widget.vm.turnos.firstWhere((t) => t.id == widget.turnoId);
      _clienteId = t.clienteId;
      _serviciosIds = List.from(t.serviciosIds);
      _estilistaId = t.estilistaId;
      _fecha = t.fechaHoraInicio;
      _horaInicio = t.fechaHoraInicio;
    } else if (widget.extra != null) {
      _clienteId = widget.extra!['clienteId'];

      if (widget.extra!['servicio'] != null) _serviciosIds.add(widget.extra!['servicio']);
      _fecha = widget.extra!['fecha'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final duracion = widget.vm.calcularDuracion(_serviciosIds);
    final precio = widget.vm.calcularPrecio(_serviciosIds);

    return Scaffold(
      appBar: AppBar(title: Text(widget.turnoId != null ? 'Editar turno' : 'Nuevo turno')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            DropdownButtonFormField<String>(
              value: _clienteId,
              decoration: const InputDecoration(labelText: 'Cliente'),
              items: widget.vm.clientes.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre))).toList(),
              onChanged: (v) => setState(() => _clienteId = v),
              validator: (v) => v == null ? 'Selecciona un cliente' : null,
            ),
            const SizedBox(height: 16),
            const Text('Servicios (al menos uno)'),
            Wrap(
              spacing: 8,
              children: widget.vm.servicios.map((s) => FilterChip(
                label: Text(s.nombre),
                selected: _serviciosIds.contains(s.id),

                onSelected: (selected) {
                  setState(() {
                    if (selected) { _serviciosIds.add(s.id); } else { _serviciosIds.remove(s.id); }
                    _estilistaId = null;
                    _horaInicio = null;
                  });
                },
              )).toList(),
            ),
            if (_serviciosIds.isEmpty) const Text('Elige al menos un servicio', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _estilistaId,
              decoration: const InputDecoration(labelText: 'Estilista'),
              items: widget.vm.estilistas.where((e) => _serviciosIds.every((id) => 

e.serviciosIds.contains(id))).map((e) => DropdownMenuItem(value: e.id, child: Text(e.nombre))).toList(),
              onChanged: (v) => setState(() => _estilistaId = v),
              validator: (v) => v == null ? 'Selecciona un estilista' : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(_fecha == null ? 'Selecciona una fecha' : DateFormat('yyyy-MM-dd').format(_fecha!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _fecha ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: 

DateTime.now().add(const Duration(days: 30)),
                  selectableDayPredicate: (day) => day.weekday != DateTime.sunday,
                );
                if (picked != null) setState(() { _fecha = picked; _horaInicio = null; });
              },
            ),
            if (_fecha == null) const Text('Elige una fecha válida (no domingos)', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            if (_fecha != null && _estilistaId != null && _serviciosIds.isNotEmpty) ...[
              const Text('Hora de inicio'),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const 

SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 20,
                itemBuilder: (context, index) {
                  final hour = 9 + (index ~/ 2);
                  final minute = (index % 2) * 30;
                  final slotTime = DateTime(_fecha!.year, _fecha!.month, _fecha!.day, hour, minute);
                  final finSlot = slotTime.add(Duration(minutes: duracion));
                  final isPast = slotTime.isBefore(DateTime.now());
                  final overflows = finSlot.hour > 19 || (finSlot.hour == 19 && finSlot.minute > 0);
                  final ocupado = 

widget.vm.haySolape(slotTime, duracion, _estilistaId!, _clienteId!, turnoIdExcluir: widget.turnoId);
                  final isSelected = _horaInicio == slotTime;
                  final isDisabled = isPast || overflows || ocupado;

                  return InkWell(
                    onTap: isDisabled ? null : () => setState(() => _horaInicio = slotTime),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).colorScheme.primary : (isDisabled ? Theme.of(context).disabledColor.withOpacity(0.2) : Colors.transparent),
                        border: Border.all(color: Theme.of(context).colorScheme.outline),
                        borderRadius: BorderRadius.circular(8),

                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                        style: TextStyle(color: isSelected ? Theme.of(context).colorScheme.onPrimary : (isDisabled ? Colors.grey : null)),
                      ),
                    ),
                  );
                },
              ),
              if (_horaInicio == null) const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Elige una hora para el turno', style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 16),
            ],

            TextFormField(
              maxLength: 500,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notas (opcional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duración: $duracion min'),

                Text('Fin: ${_horaInicio != null ? DateFormat('HH:mm').format(_horaInicio!.add(Duration(minutes: duracion))) : '--:--'}'),
                Text('Total: \$$precio'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => context.pop(), child: const Text('Cancelar'))),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _horaInicio != null) {
                        final nuevoTurno = Turno(
                          id: widget.turnoId ?? 

DateTime.now().millisecondsSinceEpoch.toString(),
                          clienteId: _clienteId!,
                          estilistaId: _estilistaId!,
                          serviciosIds: _serviciosIds,
                          fechaHoraInicio: _horaInicio!,
                          estado: EstadoTurno.programado,
                          fechaCreacion: widget.turnoId != null ? widget.vm.turnos.firstWhere((t) => t.id == widget.turnoId).fechaCreacion : DateTime.now(),
                          fechaModificacion: DateTime.now(),
                        );
                        
                        if (widget.turnoId != null) {
                          widget.vm.actualizarTurno(nuevoTurno);
                        } else {
                          

widget.vm.agregarTurno(nuevoTurno);
                        }
                        context.pop(true);
                      } else if (_horaInicio == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona una hora')));
                      }
                    },
                    child: const Text('Guardar turno'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
