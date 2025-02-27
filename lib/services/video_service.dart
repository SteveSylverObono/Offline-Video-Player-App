
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../models/video_model.dart';
import 'database_service.dart';

class VideoService {
  final DatabaseService _db = DatabaseService();
  
  // Sample video data with online video URLs
  final List<Video> _sampleVideos = [
    Video(
      id: '1',
      title: 'Introduction to Flutter',
      description: 'A comprehensive introduction to Flutter development.',
      filePath: 'https://www.example.com/videos/flutter_intro.mp4',
      thumbnailPath: 'https://www.example.com/thumbnails/flutter_intro.jpg',
      duration: 180, // 3 minutes
      addedDate: DateTime.now().subtract(const Duration(days: 2)),
      isDownloaded: false,
    ),
    Video(
      id: '2',
      title: 'Advanced Flutter Techniques',
      description: 'Explore advanced techniques in Flutter for better app performance.',
      filePath: 'https://www.example.com/videos/advanced_flutter.mp4',
      thumbnailPath: 'https://www.example.com/thumbnails/advanced_flutter.jpg',
      duration: 240, // 4 minutes
      addedDate: DateTime.now().subtract(const Duration(days: 1)),
      isDownloaded: false,
    ),
    Video(
      id: '3',
      title: 'Flutter UI Design',
      description: 'Learn how to build aesthetically pleasing UIs with Flutter.',
      filePath: 'https://www.example.com/videos/flutter_ui.mp4',
      thumbnailPath: 'https://www.example.com/thumbnails/flutter_ui.jpg',
      duration: 300, // 5 minutes
      addedDate: DateTime.now(),
      isDownloaded: false,
    ),
  ];

  Future<String> generateThumbnail(String videoPath) async {
    // Simply return empty string - the UI will show a placeholder
    return '';
  }

  Future<void> saveVideo(Video video) async {
    await _db.insertVideo(video);
  }

  Future<List<Video>> getAllVideos() async {
    // Return the list of sample videos
    return _sampleVideos;
  }

  Future<Video?> getVideo(String videoId) async {
    return _sampleVideos.firstWhere((video) => video.id == videoId, orElse: () => Video(id: '', title: '', description: '', filePath: '', thumbnailPath: '', duration: 0, addedDate: DateTime.now(), isDownloaded: false));
  }

  Future<void> deleteVideo(String videoId) async {
    final video = await getVideo(videoId);
    if (video != null) {
      // Since these are online videos, we don't delete files, just remove from list
      _sampleVideos.removeWhere((v) => v.id == videoId);
    }
  }

  Future<String> downloadVideo(String url) async {
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: (await getApplicationDocumentsDirectory()).path,
      showNotification: true,
      openFileFromNotification: true,
    );
    
    return taskId ?? '';
  }

  Future<void> markVideoAsDownloaded(String videoId) async {
    final video = await getVideo(videoId);
    if (video != null) {
      final updatedVideo = video.copyWith(isDownloaded: true);
      await _db.updateVideo(updatedVideo);
    }
  }

  Future<bool> isVideoDownloaded(String videoId) async {
    final video = await getVideo(videoId);
    if (video == null) return false;
    return video.isDownloaded;
  }

  Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
  }
}
