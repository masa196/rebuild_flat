class PaymentMethodModel {
  final int id;
  final String name;
  final Map<String, dynamic> instructions;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.instructions,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'],
      name: json['name'],
      instructions: Map<String, dynamic>.from(json['instructions']),
    );
  }
}
