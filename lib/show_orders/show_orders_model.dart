class Company {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String? location; // nullable
  final String logo;

  Company({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    this.location,
    required this.logo,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? '',
      location: json['location'], // ممكن تكون null
      logo: json['logo'] ?? '',
    );
  }
}

class ShowOrder {
  final int id;
  final String status;
  final int costOfExamination;
  final String? location; // nullable
  final String? budget;   // nullable
  final String createdAt;
  final Company company;

  ShowOrder({
    required this.id,
    required this.status,
    required this.costOfExamination,
    this.location,
    this.budget,
    required this.createdAt,
    required this.company,
  });

  factory ShowOrder.fromJson(Map<String, dynamic> json) {
    return ShowOrder(
      id: json['id'],
      status: json['status'] ?? '',
      costOfExamination: json['cost_of_examination'] ?? 0,
      location: json['location'], // ممكن null
      budget: json['budget'],     // مو موجود أحياناً
      createdAt: json['created_at'] ?? '',
      company: Company.fromJson(json['company']),
    );
  }
}
