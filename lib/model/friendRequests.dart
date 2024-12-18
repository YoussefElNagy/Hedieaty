class FriendRequest {
  String id;
  String fromId;
  String toId;

  FriendRequest({
    required this.id,
    required this.fromId,
    required this.toId,
  });

  FriendRequest copyWith({
    String? id,
    String? fromId,
    String? toId,
  }) {
    return FriendRequest(
      id: id ?? this.id,
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromId': fromId,
      'toId': toId,
    };
  }

  factory FriendRequest.fromMap(Map<String, dynamic> map, String id) {
    return FriendRequest(
      id: id,
      fromId: map['fromId'],
      toId: map['toId'] ?? null,
    );
  }
}
