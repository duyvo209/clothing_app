class UserInfor {
  final String userId;
  final String firstname;
  final String lastname;
  final String email;
  final String imageUser;

  UserInfor(
      {this.userId, this.firstname, this.lastname, this.email, this.imageUser});

  factory UserInfor.fromFireStore(Map<String, dynamic> json) {
    return UserInfor(
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      imageUser: json['imageUser'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'imageUser': imageUser,
    };
  }
}
