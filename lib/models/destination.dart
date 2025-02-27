class Destination {
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String imageUrl;

  Destination({
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      imageUrl: json['image_url'],
    );
  }
} 