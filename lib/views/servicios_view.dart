
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/app_viewmodel.dart';
import '../models/models.dart';

class ServiciosView extends StatefulWidget {
  final AppViewModel vm;
  const ServiciosView({required this.vm, super.key});

  @override
  State<ServiciosView> createState() => _ServiciosViewState();
}

class _ServiciosViewState extends State<ServiciosView> {
  CategoriaServicio? _catFiltro;

  @override

  Widget build(BuildContext context) {
    final serviciosFiltrados = widget.vm.servicios.where((s) {
      if (_catFiltro != null && s.categoria != _catFiltro) return false;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                ChoiceChip(label: const Text('Todas'), selected: _catFiltro == null, onSelected: (_) => setState(() => _catFiltro = null)),

                ...CategoriaServicio.values.map((cat) => Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ChoiceChip(label: Text(cat.name), selected: _catFiltro == cat, onSelected: (_) => setState(() => _catFiltro = cat)),
                )),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth < 600 ? 2 : (constraints.maxWidth <= 840 ? 3 : 4);
                return GridView.builder(
                  padding: const EdgeInsets.all(16),

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: serviciosFiltrados.length,
                  itemBuilder: (context, index) {
                    final s = serviciosFiltrados[index];
                    return Card(
                      child: InkWell(
                        onTap: () => context.push('/turno/nuevo', extra: {'servicio': s.id}),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)), child: const Center(child: Icon(Icons.content_cut, size: 40)))),
                              const SizedBox(height: 8),
                              Text(s.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('${s.duracionMinutos} min', style: const TextStyle(color: Colors.grey)),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Text('\$${s.precio}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                                  Chip(label: Text(s.publico.name, style: const TextStyle(fontSize: 10))),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );

  }
}
