/// UserModel represents an authenticated member of the ReThread community.
/// 
/// Privacy is a core requirement: exact home addresses are never stored
/// or displayed publicly — only `city` and `area` (neighborhood).
class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String city;
  final String area;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    required this.city,
    required this.area,
    required this.createdAt,
  });

  String get locationDisplay => area.isNotEmpty ? '$area, $city' : city;

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    String? city,
    String? area,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      city: city ?? this.city,
      area: area ?? this.area,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'city': city,
      'area': area,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Community Member',
      email: map['email'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      city: map['city'] as String? ?? 'Bengaluru',
      area: map['area'] as String? ?? 'Indiranagar',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
