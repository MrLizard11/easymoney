class Savings {
  final String id;
  final String userId;
  final String period;
  final double amount;
  final String category;
  final double targetAmount;
  final double currentBalance;

  Savings({
    required this.id,
    required this.userId,
    required this.period,
    required this.amount,
    required this.category,
    required this.targetAmount,
    required this.currentBalance,
  });

  factory Savings.fromJson(Map<String, dynamic> json) {
    return Savings(
      id: json['id'],
      userId: json['userId'],
      period: json['period'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      targetAmount: json['targetAmount'].toDouble(),
      currentBalance: json['currentBalance'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'period': period,
      'amount': amount,
      'category': category,
      'targetAmount': targetAmount,
      'currentBalance': currentBalance,
    };
  }
}