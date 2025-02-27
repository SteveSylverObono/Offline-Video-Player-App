import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../models/video_model.dart';
import '../../routes/app_router.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage(name: 'VideoListScreenRoute')
class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    if (await Permission.storage.isGranted) {
      setState(() {
        _hasPermission = true;
      });
    } else {
      // Show a dialog to request permission
      final shouldRequest = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Storage Permission Required'),
          content: const Text(
              'To access your video files, we need storage permission. '
              'Would you like to grant it now?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Not Now'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      );

      if (shouldRequest == true) {
        final status = await Permission.storage.request();
        if (status.isGranted) {
          setState(() {
            _hasPermission = true;
          });
        } else {
          // If permission is still denied, show settings option
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Permission Denied'),
              content: const Text(
                  'Storage permission is required to access your videos. '
                  'You can grant it in app settings.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    openAppSettings();
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds - minutes * 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<List<Video>> _getDeviceVideos() async {
    final List<Video> videos = [];
    // Get videos from device storage
    final directory = Directory('/storage/emulated/0/DCIM/Camera'); // Adjust path as needed
    final files = directory.listSync();
    
    for (var file in files) {
      if (file is File) {
        try {
          // Get video duration
          final controller = VideoPlayerController.file(file);
          await controller.initialize();
          final duration = controller.value.duration.inSeconds;
          controller.dispose();
          
          videos.add(Video(
            id: file.path,
            filePath: file.path,
            title: file.path.split('/').last,
            duration: duration,
            thumbnailPath: '',
            addedDate: DateTime.now(),
            isDownloaded: false,
          ));
        } catch (e) {
          // Skip files that can't be initialized as videos
          continue;
        }
      }
    }
    return videos;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Storage permission is required'),
              ElevatedButton(
                onPressed: _checkAndRequestPermissions,
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.purple.shade900,
                      Colors.black,
                    ],
                  ),
                ),
              ),
              title: const Text(
                'Video Library',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search videos...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip('All', true),
                  _buildCategoryChip('Culture', false),
                  _buildCategoryChip('Music', false),
                  _buildCategoryChip('Dance', false),
                  _buildCategoryChip('Food', false),
                ],
              ),
            ),
          ),

          // Videos List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: FutureBuilder<List<Video>>(
              future: _getDeviceVideos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }

                final videos = snapshot.data ?? [];
                
                if (videos.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No videos available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final video = videos[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              context.router.push(VideoPlayerScreenRoute(videoId: video.id));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Thumbnail
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade800,
                                          borderRadius: BorderRadius.circular(8),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.purple.shade900,
                                              Colors.blue.shade900,
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          video.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          video.description ?? '',
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.grey.shade500,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _formatDuration(video.duration),
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Icon(
                                              video.isDownloaded
                                                  ? Icons.download_done
                                                  : Icons.download_outlined,
                                              color: Colors.grey.shade500,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: videos.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade400,
          ),
        ),
        backgroundColor: Colors.grey.shade900,
        selectedColor: Colors.purple.shade900,
        onSelected: (bool selected) {
          // Handle category selection
        },
      ),
    );
  }
}
