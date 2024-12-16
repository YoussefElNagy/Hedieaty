enum GiftCategory { electronics, clothing, toys, home, cosmetics, other }

class Gift {
  String id; // Unique identifier for the gift
  String giftName;
  String description;
  int price;
  String? image; // Path to the gift image (optional)
  String ownerId; // Reference to the User who owns the gift
  String? pledgedById; // Reference to the User who pledged the gift (optional)
  bool isPledged; // Indicates whether the gift is pledged
  GiftCategory category; // Enum for gift type
  String eventId;

  Gift({
    required this.id,
    required this.giftName,
    required this.description,
    required this.price,
    this.image,
    required this.ownerId,
    this.pledgedById,
    this.isPledged = false,
    required this.category,
    required this.eventId,
  });

  Gift copyWith({
    String? id,
    String? giftName,
    String? description,
    int? price,
    String? image,
    String? ownerId,
    String? pledgedById,
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
      isPledged: isPledged ?? this.isPledged,
      category: category ?? this.category,
      eventId: eventId ?? this.eventId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'giftName': giftName,
      'description': description,
      'price': price,
      'image': image,
      'ownerId': ownerId,
      'pledgedById': pledgedById,
      'isPledged': isPledged,
      'category': category.toString().split('.').last,
      'eventId': eventId
    };
  }

  factory Gift.fromMap(Map<String, dynamic> map, String id) {
    return Gift(
      id: id,
      giftName: map['giftName'],
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
      image: map['image'] ?? 0,
      ownerId: map['ownerId'],
      pledgedById: map['pledgedById'] ?? null,
      isPledged: map['isPledged'] ?? false,
      category: GiftCategory.values.firstWhere(
            (e) => e.name == map['category'],  // Compare with `name` instead of `toString()`
        orElse: () => GiftCategory.other,  // Default if no match
      ),
      eventId: map['eventId'],
    );
  }
}
