import 'dart:convert';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  final List following;
  final List followers;
  final String bio;
  final String link;
  final String contact;
  final bool isSubscriptionEnable;
  final double price;
  final List soundPacks;
  final String pushToken;
  UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      required this.photoUrl,
      required this.following,
      required this.pushToken,
      required this.bio,
      required this.contact,
      required this.isSubscriptionEnable,
      required this.link,
      required this.price,
      required this.soundPacks,
      required this.followers});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'email': email,
      'pushToken': pushToken,
      'photoUrl': photoUrl,
      'following': following,
      'followers': followers,
      'bio': bio,
      'link': link,
      'price': price,
      'contact': contact,
      'isSubscriptionEnable': isSubscriptionEnable,
      'soundPacks': soundPacks
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        uid: map['uid'] as String,
        username: map['username'] as String,
        email: map['email'] as String,
        pushToken: map['pushToken'] as String,
        photoUrl: map['photoUrl'] as String,
        following: List.from((map['following'] as List)),
        bio: map['bio'] as String,
        contact: map['contact'] as String,
        isSubscriptionEnable: map['isSubscriptionEnable'] as bool,
        link: map['link'] as String,
        price: map['price'] as double,
        soundPacks: List.from(
          (map['soundPacks'] as List),
        ),
        followers: List.from(
          (map['followers'] as List),
        ));
  }

  // String toJson() => json.encode(toMap());

  // factory UserModel.fromJson(String source) =>
  //     UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
