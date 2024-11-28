enum GiftStatus { available, pledged, delivered }
enum GiftCategory { electronics, clothing, toys, home, other }

class Gift {
  String id; // Unique identifier for the gift
  String giftName;
  String description;
  double price;
  String? image; // Path to the gift image (optional)
  String ownerId; // Reference to the User who owns the gift
  String? pledgedById; // Reference to the User who pledged the gift (optional)
  GiftStatus status; // Enum for gift status
  bool isPledged; // Indicates whether the gift is pledged
  GiftCategory category; // Enum for gift type
  String? eventId;

  Gift({
    required this.id,
    required this.giftName,
    required this.description,
    required this.price,
    this.image,
    required this.ownerId,
    this.pledgedById,
    required this.status,
    this.isPledged = false,
    required this.category,
    this.eventId,
  });

  Gift copyWith({
    String? id,
    String? giftName,
    String? description,
    double? price,
    String? image,
    String? ownerId,
    String? pledgedById,
    GiftStatus? status,
    bool? isPledged,
    GiftCategory? category,
    String? eventId,
  }) {
    return Gift(
      id: id ?? this.id,
      giftName: giftName ?? this.giftName,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      ownerId: ownerId ?? this.ownerId,
      pledgedById: pledgedById ?? this.pledgedById,
      status: status ?? this.status,
      isPledged: isPledged ?? this.isPledged,
      category: category ?? this.category,
      eventId: eventId ?? this.eventId,
    );
  }
}
