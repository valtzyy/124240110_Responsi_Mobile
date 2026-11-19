import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/favorite.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Favorite>('favorites');
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Favorit')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Favorite> b, _) {
          if (b.isEmpty) return const Center(child: Text('Belum ada favorit'));
          final items = b.values.toList();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final f = items[i];
              return ListTile(
                leading: f.image == null
                    ? const Icon(Icons.movie)
                    : Image.network(f.image!.replaceFirst('http://', 'https://'),
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(Icons.movie)),
                title: Text(f.title),
                subtitle: Text('⭐ ${f.rating ?? '-'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => b.delete(f.id),     // hapus
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen(showId: f.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}