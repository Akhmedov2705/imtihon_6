class Track {
  final int id;
  final String assetPath;
  final String title;
  final String? imagePath;
  bool isLiked;

  Track({
    required this.id,
    required this.assetPath,
    required this.title,
    this.imagePath,
    required this.isLiked,
  });
}
