import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class YourLibraryScreen extends StatefulWidget {
  const YourLibraryScreen({super.key});

  @override
  State<YourLibraryScreen> createState() => _YourLibraryScreenState();
}

class _YourLibraryScreenState extends State<YourLibraryScreen> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = 'All';
  List<VideoItem> allVideos = [];
  List<VideoItem> filteredVideos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadVideos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVideos() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate a network or database call
    if (mounted) {
      setState(() {
        allVideos = [
          VideoItem(id: 'video_1', title: 'Big Buck Bunny', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
          VideoItem(id: 'video_2', title: 'Elephant Dream', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
          VideoItem(id: 'video_3', title: 'For Bigger Blazes', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'),
          VideoItem(id: 'video_4', title: 'For Bigger Escape', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4'),
          VideoItem(id: 'video_5', title: 'For Bigger Fun', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'),
          VideoItem(id: 'video_6', title: 'For Bigger Joyrides', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4'),
          VideoItem(id: 'video_7', title: 'For Bigger Meltdowns', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4'),
          VideoItem(id: 'video_8', title: 'Sintel', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4'),
          VideoItem(id: 'video_9', title: 'Subaru Outback On Street And Dirt', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4'),
          VideoItem(id: 'video_10', title: 'Tears of Steel', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4')
        ];
        filteredVideos = allVideos;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.purple.shade800,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search videos...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _filterVideos();
                },
              )
            : Text(
                'Your Video Library',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            color: Colors.white,
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  _searchController.clear();
                  _filterVideos();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(height: 1, color: Colors.purple.shade800),
          Expanded(
            child: filteredVideos.isEmpty
                ? Center(
                    child: Text(
                      'No videos found',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredVideos.length,
                    itemBuilder: (context, index) {
                      final videoItem = filteredVideos[index];
                      return ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.purple.shade800,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          videoItem.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          videoItem.url,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        onTap: () => _playVideo(videoItem),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _filterVideos() {
    logger.d('Filtering videos with query: ${_searchController.text}');
    // Implement your filtering logic here
  }

  Future<void> _playVideo(VideoItem videoItem) async {
    // Logic to play video
    logger.i('Playing video: ${videoItem.title}');
  }
}

class VideoItem {
  final String id;
  final String title;
  final String url;

  VideoItem({
    required this.id,
    required this.title,
    required this.url,
  });
}