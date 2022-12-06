class Profile {
  final String id;
  final String username;
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.username,
    required this.createdAt,
  });

  Profile.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      username = map['username'],
      createdAt = DateTime.parse(map['created_at']);

}