
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/app_viewmodel.dart';
import '../models/models.dart';

class EstilistasView extends StatelessWidget {
  final AppViewModel vm;
  const EstilistasView({required this.vm, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,

            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Estilistas', style: TextStyle(color: Colors.white)),
              background: Container(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final e = vm.estilistas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(e.nombre[0])),
                    title: Text(e.nombre),
                    subtitle: Wrap(
                      spacing: 4,

                      children: e.serviciosIds.take(2).map((id) => Chip(label: Text(vm.getServicio(id).categoria.name), visualDensity: VisualDensity.compact)).toList(),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/agenda'),
                  ),
                );
              },
              childCount: vm.estilistas.length,
            ),
          ),
        ],
      ),
    );
  }
}
