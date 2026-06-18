class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({required this.name, required this.catchPhrase, required this.bs});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] as String,
      bs: json['bs'] as String,
      catchPhrase: json['catchPhrase'] as String,
    );
  }
}
