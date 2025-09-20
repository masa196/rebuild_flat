class CompanyResponse {
  final List<Company> data;
  final bool success;
  final String message;

  CompanyResponse({required this.data, required this.success, required this.message});

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    return CompanyResponse(
      data: (json['data'] as List).map((e) => Company.fromJson(e)).toList(),
      success: json['success'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'success': success,
    'message': message,
  };
}

class Company {
  final int id;
  final String name;
  final String location;
  final String phone;
  final String about;
  final String logo;
  final double averageRating;
  final List<Service> services;
  final bool isFavorited; // أضفنا هذا
  final String costOfExamination; // أضفنا هذا


  Company({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.about,
    required this.logo,
    required this.averageRating,
    required this.services,
    required this.isFavorited,
    required this.costOfExamination, // أضفنا هذا

  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      phone: json['phone'],
      about: json['about'],
      logo: json['logo'],
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      services: (json['services'] as List).map((e) => Service.fromJson(e)).toList(),
      isFavorited: json['is_favorited'], // أضفنا هذا
      costOfExamination: json['cost_of_examination'] ?? "", // أضفنا هذا

    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'phone': phone,
    'about': about,
    'logo': logo,
    'average_rating': averageRating,
    'services': services.map((e) => e.toJson()).toList(),
    'is_favorited': isFavorited,
    'cost_of_examination': costOfExamination, // أضفنا هذا

  };
}

class Service {
  final int id;
  final int companyId;
  final String name;
  final String description;
  final String image;
  final String createdAt;
  final String updatedAt;

  Service({
    required this.id,
    required this.companyId,
    required this.name,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      companyId: json['company_id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'company_id': companyId,
    'name': name,
    'description': description,
    'image': image,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
