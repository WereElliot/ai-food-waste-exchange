enum SpoilageRisk { low, medium, high }

class Listing {
  final String id;
  final String title;
  final String description;
  final String photoUrl;
  final String quantity;
  final String itemType;
  final DateTime? expiryDate;
  final SpoilageRisk? spoilageRisk;
  final double latitude;
  final double longitude;
  final String donorId;
  final double? distance;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.photoUrl,
    required this.quantity,
    required this.itemType,
    this.expiryDate,
    this.spoilageRisk,
    required this.latitude,
    required this.longitude,
    required this.donorId,
    this.distance,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      photoUrl: json['photoUrl'],
      quantity: json['quantity'],
      itemType: json['itemType'],
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      spoilageRisk: json['spoilageRisk'] != null
          ? SpoilageRisk.values.firstWhere((e) => e.name.toUpperCase() == json['spoilageRisk'])
          : null,
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      donorId: json['donorId'],
      distance: json['distance']?.toDouble(),
    );
  }
}
