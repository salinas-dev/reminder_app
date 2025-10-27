// lib/JsonModels/users.dart

class Users {
  int? usrId;
  String usrName;
  String usrPassword;
  String? birthdate;

  Users({
    this.usrId,
    required this.usrName,
    required this.usrPassword,
    this.birthdate,
  });

  Map<String, dynamic> toMap() {
    return {
      'usr_name': usrName,
      'usr_password': usrPassword,
      'birthdate': birthdate,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      usrId: map['usr_id'],
      usrName: map['usr_name'],
      usrPassword: map['usr_password'],
      birthdate: map['birthdate'],
    );
  }
}
