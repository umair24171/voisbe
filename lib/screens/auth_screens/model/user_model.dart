class UserModel {
  String uid;
  String name;
  String username;
  String email;
  String photoUrl;
  List following;
  List followers;
  String bio;
  String link;
  String contact;
  bool isSubscriptionEnable;
  double price;
  List soundPacks;
  String token;
  List subscribedUsers = [];
  List subscribedSoundPacks = [];
  String pushToken;
  UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      required this.photoUrl,
      required this.following,
      required this.pushToken,
      required this.token,
      required this.bio,
      required this.subscribedUsers,
      required this.contact,
      required this.name,
      required this.subscribedSoundPacks,
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
      'token': token,
      'name': name,
      'followers': followers,
      'subscribedUsers': subscribedUsers, // Add this line
      'bio': bio,
      'subscribedSoundPacks': subscribedSoundPacks,
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
        token: map['token'] as String,
        following: List.from((map['following'] as List)),
        subscribedUsers: List.from((map['subscribedUsers'] as List)),
        subscribedSoundPacks: List.from((map['subscribedSoundPacks'] as List)),
        bio: map['bio'] as String,
        contact: map['contact'] as String,
        isSubscriptionEnable: map['isSubscriptionEnable'] as bool,
        name: map['name'] as String,
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
