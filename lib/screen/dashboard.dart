import 'dart:io';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../services/location_service.dart';
import '../services/video_service.dart';
import '../models/video_model.dart';
import '../models/destination.dart';
import '../routes/app_router.dart';

@RoutePage(name: 'DashBoardScreenRoute')
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String userName = "loading";
  String userLocation = "Loading location...";
  final String currentDate = DateFormat('EEEE, MMMM d').format(DateTime.now());



  List<Destination> popularDestinations = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();
      final locationName = await locationService.getLocationName(
        position.latitude,
        position.longitude,
      );
      
      if (mounted) {
        setState(() {
          userLocation = locationName;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userLocation = "Unable to get location";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple.shade900, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good ${_getGreeting()}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSearchField(),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Videos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.router.push(const VideoListScreenRoute());
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 180,
                    child: FutureBuilder<List<Video>>(
                      future: VideoService().getAllVideos(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        
                        final videos = snapshot.data ?? [];
                        if (videos.isEmpty) {
                          return const Center(
                            child: Text(
                              'No videos yet',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            final video = videos[index];
                            return GestureDetector(
                              onTap: () {
                                context.router.push(
                                  VideoPlayerScreenRoute(videoId: video.id),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                margin: const EdgeInsets.only(right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[800],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.play_circle_outline,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      video.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Added: ${_formatDate(video.addedDate)}',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
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
            ),
          ),
          // Additional sections can be updated similarly
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles(
            type: FileType.video,
            allowMultiple: false,
          );
          
          if (result != null && result.files.isNotEmpty) {
            final file = File(result.files.first.path!);
            final fileName = result.files.first.name;
            
            final videoService = VideoService();
            
            // Generate thumbnail
            final thumbnailPath = await videoService.generateThumbnail(file.path);
            
            // Create video object
            final video = Video(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: fileName,
              filePath: file.path,
              thumbnailPath: thumbnailPath,
              duration: 0, // You might want to get actual duration
              addedDate: DateTime.now(),
              isDownloaded: true,
            );
            
            // Save video
            await videoService.saveVideo(video);
            
            // Navigate to video player
            if (mounted) {
              context.router.push(VideoPlayerScreenRoute(videoId: video.id));
            }
          }
        },
        backgroundColor: Colors.purple.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search songs, artists, albums...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

 final jsonString = '''
      [
        {
          "name": "Mefou National Park",
          "description": "A wildlife reserve home to various primate species, including gorillas and chimpanzees, located approximately an hour's drive from Yaoundé.",
          "latitude": 3.6333,
          "longitude": 11.5000,
          "image_url": "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/05/55/e6/42/mefou-national-park.jpg?w=900&h=500&s=1"
        },
        {
          "name": "Monument de la Réunification",
          "description": "A monument symbolizing the reunification of British and French Cameroons, situated in Yaoundé.",
          "latitude": 3.8480,
          "longitude": 11.5021,
          "image_url": "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/09/8e/7d/e0/monument-de-la-reunification.jpg?w=800&h=500&s=1"
        },
        {
          "name": "Musée Ethnographique des Peuples de la Fôret",
          "description": "A museum showcasing the cultures and histories of Central African forest peoples, located in Yaoundé.",
          "latitude": 3.8715,
          "longitude": 11.5240,
          "image_url": "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/52/b0/f1/musee-ethnographique.jpg?w=900&h=-1&s=1"
        },
        {
          "name": "National Museum of Yaoundé",
          "description": "Housed in the former presidential palace, this museum offers insights into Cameroon's history and traditions.",
          "latitude": 3.8667,
          "longitude": 11.5167,
          "image_url": "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0d/80/38/a0/you-can-only-take-photos.jpg?w=900&h=500&s=1"
        },
        {
          "name": "Ebogo Ecotourism Site",
          "description": "An ecotourism site approximately 35 km from Yaoundé, offering forest walks and canoeing on the Nyong River.",
          "latitude": 3.5167,
          "longitude": 11.5000,
          "image_url": "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/18/9d/9b/1a/fluss.jpg?w=1200&h=900&s=1"
        },
        {
          "name": "Nachtigal Waterfalls",
          "description": "A picturesque waterfall located in the Batchenga area, named after the explorer Nachtigal.",
          "latitude": 4.4500,
          "longitude": 11.7000,
          "image_url": "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/18/ad/b0/a3/monument-nachtigal-1.jpg?w=900&h=500&s=1"
        },
        {
          "name": "Akok Bekoe Caves",
          "description": "A series of impressive caves located in the village of Bikoe, on the road from Mbalmayo to Akono.",
          "latitude": 3.4167,
          "longitude": 11.3500,
          "image_url": "https://www.ongola.com/wp-content/uploads/2024/09/akok-bekoe.jpg"
        },
        {
          "name": "Sanaga River Rapids",
          "description": "Spectacular rapids near the presidential residence of Ndjore in the Batchenga district.",
          "latitude": 4.4500,
          "longitude": 11.7000,
          "image_url": "https://images.westend61.de/0001310581pw/cameroon-aerial-view-of-sanaga-river-in-landscape-VEGF01406.jpg"
        },
        {
          "name": "Mbam Minkom Mountain",
          "description": "A prominent mountain offering hiking opportunities and panoramic views of the surrounding region.",
          "latitude": 4.0000,
          "longitude": 11.5000,
          "image_url": "https://peakvisor.com/photo/8/88/Mount_Cameroon_craters.jpg"
        },
        {
          "name": "Nyong River",
          "description": "A major river in the Centre Region, popular for canoeing and observing diverse flora and fauna along its banks.",
          "latitude": 3.7667,
          "longitude": 11.7333,
          "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Nyong_river_Cameroon.jpg/800px-Nyong_river_Cameroon.jpg?20160926201150"
        }
      ]
      ''';