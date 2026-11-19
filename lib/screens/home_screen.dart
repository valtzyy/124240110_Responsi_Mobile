import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> shows = [];
  bool isLoading = true;

  Future<void> fetchShows() async {
    try {
      final data = await getShows();
      setState(() {
        shows = data;
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
    fetchShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KeripikRoll!')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.65,
              ),
              itemCount: shows.length,
              itemBuilder: (context, index) {
                final show = shows[index];
                final img =
                    show!['attributes']['posterImage']?['medium'] ?? '-';
                final rating = show['attributes']['averageRating'];
                final agerating = show['attributes']['ageRating'];
                final averagerating = show['attributes']['averageRating'];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(showId: show['id']),
                    ),
                  ),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: img == null
                              ? const Center(child: Icon(Icons.movie))
                              : Image.network(
                                  img.replaceFirst('http://', 'https://'),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                show['attributes']['titles']['en'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  Text(' ${rating ?? '-'}'),
                                  Text(' ${agerating ?? '-'}'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.rate_review,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  Text(' ${agerating ?? '-'}'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.rate_review,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  Text(' ${averagerating ?? '-'}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
