
import 'package:flutter/material.dart';
import '../viewmodels/app_viewmodel.dart';
import '../models/models.dart';

class ClientesView extends StatefulWidget {
  final AppViewModel vm;
  const ClientesView({required this.vm, super.key});

  @override
  State<ClientesView> createState() => _ClientesViewState();
}

class _ClientesViewState extends State<ClientesView> {
  String _searchQuery = '';
  Genero? _filtroGenero;

  String _normalize(String text) {
    return text.toLowerCase().replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u').replaceAll('ñ', 'n');
  }

  void _mostrarFormularioCliente([Cliente? cliente]) {
    final formKey = GlobalKey<FormState>();
    final nombreCtrl = TextEditingController(text: cliente?.nombre);
    final telCtrl = TextEditingController(text: cliente?.telefono);
    final correoCtrl = TextEditingController(text: cliente?.correo);
    Genero? generoSeleccionado = cliente?.genero;

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Form(
            key: formKey,
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cliente == null ? 'Nuevo cliente' : 'Editar cliente', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (v) => (v == null || 

v.length < 3 || v.length > 60) ? 'Escribe entre 3 y 60 caracteres' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: telCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Teléfono'),
                      validator: (v) {
                        if (v == null || v.length != 8) return 'Debe tener exactamente 8 dígitos';
                        final existe = widget.vm.clientes.any((c) => c.telefono == v && c.id != cliente?.id);
                        if (existe) return 'Este teléfono ya está registrado';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<Genero>(
                      value: generoSeleccionado,
                      decoration: const InputDecoration(labelText: 'Género'),
                      items: Genero.values.map((g) => DropdownMenuItem(value: g, child: Text(g.name))).toList(),
                      onChanged: (v) => setModalState(() => generoSeleccionado = v),
                      validator: (v) => v == null ? 'Selecciona un género' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: correoCtrl,
                      decoration: const InputDecoration(labelText: 'Correo (opcional)'),
                      validator: (v) {
                        if (v == null || v.isEmpty) 

return null;
                        final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        return regex.hasMatch(v) ? null : 'Escribe un correo válido';
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar'))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (cliente == null) {
                                  widget.vm.agregarCliente(Cliente(

                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    nombre: nombreCtrl.text,
                                    telefono: telCtrl.text,
                                    genero: generoSeleccionado!,
                                    correo: correoCtrl.text.isEmpty ? null : correoCtrl.text,
                                    fechaRegistro: DateTime.now(),
                                  ));
                                } else {
                                  widget.vm.actualizarCliente(Cliente(
                                    id: cliente.id,
                                    nombre: nombreCtrl.text,
                                    telefono: telCtrl.text,
                                    genero: 

generoSeleccionado!,
                                    correo: correoCtrl.text.isEmpty ? null : correoCtrl.text,
                                    fechaRegistro: cliente.fechaRegistro,
                                  ));
                                }
                                Navigator.pop(ctx);
                              }
                            },
                            child: const Text('Guardar cliente'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),

          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.vm,
      builder: (context, _) {
        final clientesFiltrados = widget.vm.clientes.where((c) {
          final matchesSearch = _normalize(c.nombre).contains(_normalize(_searchQuery)) || c.telefono.contains(_searchQuery);
          final matchesGenero = _filtroGenero == null || c.genero == _filtroGenero;
          return matchesSearch && matchesGenero;
        }).toList();


        return Scaffold(
          appBar: AppBar(title: const Text('Clientes')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Buscar por nombre o teléfono', prefixIcon: Icon(Icons.search)),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SegmentedButton<Genero?

>(
                  segments: const [
                    ButtonSegment(value: null, label: Text('Todos')),
                    ButtonSegment(value: Genero.mujer, label: Text('Mujeres')),
                    ButtonSegment(value: Genero.hombre, label: Text('Hombres')),
                  ],
                  selected: {_filtroGenero},
                  onSelectionChanged: (set) => setState(() => _filtroGenero = set.first),
                ),
              ),
              const SizedBox(height: 8),
              Text('${clientesFiltrados.length} clientes'),
              Expanded(
                child: ListView.separated(
                  itemCount: clientesFiltrados.length,
                  separatorBuilder: (_, __) => const Divider(),

                  itemBuilder: (context, index) {
                    final c = clientesFiltrados[index];
                    final turnosCount = widget.vm.turnos.where((t) => t.clienteId == c.id).length;
                    return ListTile(
                      leading: CircleAvatar(child: Text(c.nombre[0])),
                      title: Text(c.nombre),
                      subtitle: Text('${c.telefono} · ${c.genero.name}'),
                      trailing: Text('$turnosCount turnos'),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (ctx) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(title: Text(c.nombre), subtitle: Text(c.telefono)),

                              ListTile(leading: const Icon(Icons.edit), title: const Text('Editar'), onTap: () { Navigator.pop(ctx); _mostrarFormularioCliente(c); }),
                              ListTile(
                                leading: const Icon(Icons.delete, color: Colors.red),
                                title: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                onTap: () {
                                  final tieneProg = widget.vm.turnos.any((t) => t.clienteId == c.id && t.estado == EstadoTurno.programado);
                                  if (tieneProg) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se puede eliminar: tiene turnos programados.')));
                                  } else {

                                    widget.vm.eliminarCliente(c.id);
                                  }
                                  Navigator.pop(ctx);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _mostrarFormularioCliente(),
            label: const Text('Nuevo cliente'),
            icon: const Icon(Icons.person_add),

          ),
        );
      },
    );
  }
}
