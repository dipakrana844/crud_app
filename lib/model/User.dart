class User {
  int? id;
  String? fName;
  String? lName;
  String? contact;
  String? email;
  String? dob;

  userMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['fName'] = fName!;
    mapping['lName'] = lName!;
    mapping['contact'] = contact!;
    mapping['email'] = email!;
    mapping['dob'] = dob!;
    return mapping;
  }
}
