class CreateConversationModel {
  final int id;
  final String createdAt;
  final CustomerModel customer;
  final EmployeeModel employee;

  CreateConversationModel({
    required this.id,
    required this.createdAt,
    required this.customer,
    required this.employee,
  });

  factory CreateConversationModel.fromJson(Map<String, dynamic> json) {
    return CreateConversationModel(
      id: json['data']['id'] ?? 0,
      createdAt: json['created_at'] ?? "",
      customer: CustomerModel.fromJson(json['data']['customer']),
      employee: EmployeeModel.fromJson(json['data']['employee']),
    );
  }
}

class CustomerModel {
  final int id;
  final String name;
  final String email;
  final String? image; // ✅ يقبل null

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      image: json['image'], // ممكن تكون null
    );
  }
}

class EmployeeModel {
  final int id;
  final String name;
  final String email;
  final String? phone; // ✅ ممكن تكون null إذا السيرفر ما بيرجعها

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'], // ممكن تكون null
    );
  }
}
