class Clinic {
  const Clinic({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.distanceMeters,
    this.phone,
    this.address,
  });

  final String name;
  final double latitude;
  final double longitude;
  final String category;
  final double distanceMeters;
  final String? phone;
  final String? address;

  String get distanceLabel {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '${distanceMeters.toStringAsFixed(0)} m';
  }
}
