class UserModel {
  final String id;
  final String country;
  final String phoneNo;
  final String gender;
  final String city;
  final String lastName;
  final String bio;
  final String profilePicture;
  final String state;
  final String firstName;
  final String fcmToken; // Optional, can be null if not set
  List<String> favorites;
  List<String> followers;
  List<String> following;

  UserModel({
    required this.id,
    required this.country,
    required this.phoneNo,
    required this.gender,
    required this.city,
    required this.lastName,
    required this.bio,
    required this.profilePicture,
    required this.state,
    required this.firstName,
    required this.favorites,
    required this.fcmToken,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'phoneNo': phoneNo,
      'gender': gender,
      'city': city,
      'lastName': lastName,
      'bio': bio,
      'profilePicture': profilePicture,
      'state': state,
      'firstName': firstName,
      'fcmToken': fcmToken,
      'favorites': favorites,
      'followers': followers,
      'following': following,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      country: json['country'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      gender: json['gender'] ?? '',
      city: json['city'] ?? '',
      lastName: json['lastName'] ?? '',
      bio: json['bio'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      state: json['state'] ?? '',
      firstName: json['firstName'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
      favorites: List<String>.from(json['favorites'] ?? []),
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
    );
  }
}
