class UserModal {
  String userName;
  String password;

  UserModal(
    this.userName,
    this.password,
  );

  factory UserModal.fromMap({required Map data}) {
    return UserModal(
      data['userName'],
      data['password'],
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'username': userName,
      'password': password,
    };
  }
}
