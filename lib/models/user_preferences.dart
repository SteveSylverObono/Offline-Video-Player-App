class UserPreferences {
  final String userId;
  final bool darkMode;
  final bool autoDownload;
  final bool autoPlayNext;
  final List<String> favoriteVideos;
  final int videoQuality;

  UserPreferences({
    required this.userId,
    this.darkMode = false,
    this.autoDownload = false,
    this.autoPlayNext = true,
    List<String>? favoriteVideos,
    this.videoQuality = 720,
  }) : favoriteVideos = favoriteVideos ?? [];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'darkMode': darkMode,
      'autoDownload': autoDownload,
      'autoPlayNext': autoPlayNext,
      'favoriteVideos': favoriteVideos,
      'videoQuality': videoQuality,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      userId: map['userId'],
      darkMode: map['darkMode'] ?? false,
      autoDownload: map['autoDownload'] ?? false,
      autoPlayNext: map['autoPlayNext'] ?? true,
      favoriteVideos: List<String>.from(map['favoriteVideos'] ?? []),
      videoQuality: map['videoQuality'] ?? 720,
    );
  }

  UserPreferences copyWith({
    bool? darkMode,
    bool? autoDownload,
    bool? autoPlayNext,
    List<String>? favoriteVideos,
    int? videoQuality,
  }) {
    return UserPreferences(
      userId: this.userId,
      darkMode: darkMode ?? this.darkMode,
      autoDownload: autoDownload ?? this.autoDownload,
      autoPlayNext: autoPlayNext ?? this.autoPlayNext,
      favoriteVideos: favoriteVideos ?? this.favoriteVideos,
      videoQuality: videoQuality ?? this.videoQuality,
    );
  }
}
