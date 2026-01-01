class Register {
  String fullName;
  String email;
  int phoneNumber;
  String address;
  DateTime dateAndTime = DateTime.now();

  Register({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  factory Register.fromJson(Map<String, dynamic> json, String id) {
    return Register(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as int,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'dateAndTime': dateAndTime.toIso8601String(),
    };
  }

}