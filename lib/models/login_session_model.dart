class LoginSessionModel {
  final String email;
  final bool loggedIn;
  final String createdAt;
  final String updatedAt;

  LoginSessionModel({
    required this.email,
    required this.loggedIn,
    required this.createdAt,
    required this.updatedAt,
  });

  LoginSessionModel copyWith({
    String? email,
    bool? loggedIn,
    String? createdAt,
    String? updatedAt,
  }) {
    return LoginSessionModel(
      email: email ?? this.email,
      loggedIn: loggedIn ?? this.loggedIn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'loggedIn': loggedIn,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
