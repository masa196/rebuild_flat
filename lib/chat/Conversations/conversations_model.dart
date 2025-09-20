class ConversationModel {
  final int id;
  final int customerId;
  final int employeeId;
  final String createdAt;
  final String updatedAt;
  final Employee employee;
  final List<Message> messages;

  ConversationModel({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.createdAt,
    required this.updatedAt,
    required this.employee,
    required this.messages,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      customerId: json['customer_id'],
      employeeId: json['employee_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      employee: Employee.fromJson(json['employee']),
      messages: (json['messages'] as List)
          .map((msg) => Message.fromJson(msg))
          .toList(),
    );
  }
}

class Employee {
  final int id;
  final int userId;
  final int companyId;
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;

  Employee({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      userId: json['user_id'],
      companyId: json['company_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      phone: json['phone'],
    );
  }
}

class Message {
  final int? id;
  final String? content;

  Message({this.id, this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
    );
  }
}
