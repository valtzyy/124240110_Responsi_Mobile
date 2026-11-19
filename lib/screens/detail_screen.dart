import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/favorite.dart';
import '../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final String showId;
  const DetailScreen({super.key, required this.showId});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? show;
  bool isLoading = true;
  final box = Hive.box<Favorite>('favorites');

  Future<void> fetchShow() async {
    try {
      final data = await getSingleShow(widget.showId);
      if (!mounted) return;
      setState(() {
        show = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchShow();
  }

  void _toggleFavorite() {
    if (box.containsKey(widget.showId)) {
      box.delete(widget.showId);
    } else {
      final attr = show!['attributes'];
      box.put(
        widget.showId,
        Favorite(
          id: widget.showId,
          title: attr['titles']?['en_jp'] ?? attr['canonicalTitle'] ?? '-',
          image: attr['posterImage']?['tiny'],
          rating: double.tryParse('${attr['averageRating']}'),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')), // tombol back otomatis
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : show == null
              ? const Center(child: Text('Gagal memuat data'))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final attr = show!['attributes'];
    final cover = attr['coverImage'];
    final String? coverUrl = cover?['small'] ?? cover?['tiny'];
    final title = attr['titles']?['en_jp'] ?? attr['canonicalTitle'] ?? '-';
    final isFav = box.containsKey(widget.showId);

    return ListView(
      children: [
        if (coverUrl != null)
          Image.network(
            coverUrl.replaceFirst('http://', 'https://'),
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const SizedBox(
              height: 120,
              child: Center(child: Icon(Icons.broken_image)),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  Text(' ${attr['averageRating'] ?? '-'}'),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${attr['ageRating'] ?? '-'} • ${attr['episodeCount'] ?? 'N/A'} Episodes',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Nonton'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _toggleFavorite,
                    style: IconButton.styleFrom(
                      backgroundColor:
                          isFav ? Colors.red : Colors.grey.shade800,
                    ),
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Overview',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(attr['synopsis'] ?? ''),
            ],
          ),
        ),
      ],
    );
  }
}
