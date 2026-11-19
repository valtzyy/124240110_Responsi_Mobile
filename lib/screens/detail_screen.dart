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
      setState(() {
        show = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error: $e');
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
      box.put(
        widget.showId,
        Favorite(
          id: widget.showId,
          title: show!['attributes']['en'],
          image: show!['attributes']['coverImage']?['tiny'],
          rating: (show!['rating']?['average'] as num?)?.toDouble(),
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
              : ListView(
                  children: [
                    if (show!['attributes']['coverImage']['tiny'] != null)
                      Image.network(
                        show!['attributes']['coverImage']['tiny'],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                              child: Text(show!['attributes']['averageRating'],
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                            IconButton(
                              onPressed: _toggleFavorite,
                              icon: Icon(
                                box.containsKey(widget.showId)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                            ),
                          ]),
                          Text('⭐ ${show!['attributes']['averageRating'] ?? '-'}'),
                          Text((show!['attributes']['ageRating'] as List).join(', ')),
                          const SizedBox(height: 16),
                          const Text('Overview',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text((show!['attributes']['synopsis'] ?? '')
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}