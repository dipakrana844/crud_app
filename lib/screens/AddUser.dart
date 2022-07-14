import 'package:crud_app/model/User.dart';
import 'package:crud_app/services/UserService.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddUser extends StatefulWidget {
  final User user;

  // const AddUser({Key? key}) : super(key: key);
  const AddUser({Key? key, required this.user}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _userFirstNameController = TextEditingController();
  final _userLastNameController = TextEditingController();
  final _userContactController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userDobController = TextEditingController();

  String? _validateFirstName;

  String? _validateLastName;
  String? _validateContact;
  String? _validateDob;
  String? _validateEmail;

  String ContactPatttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  String emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  var _userService = UserService();

  // late String birthDateInString;

  // DateTime selectedDate = DateTime.now();
  DateTime? date;

  @override
  void initState() {
    setState(() {
      _userFirstNameController.text = widget.user.fName ?? '';
      _userLastNameController.text = widget.user.lName ?? '';
      _userContactController.text = widget.user.contact ?? '';
      _userEmailController.text = widget.user.email ?? '';
      _userDobController.text = widget.user.dob ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite CRUD"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const Text(
                ('Add New User'),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _userFirstNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Colors.teal),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: 'Enter First Name',
                  labelText: 'First Name',
                  errorText: _validateFirstName,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _userLastNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Colors.teal),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: 'Enter Last Name',
                  labelText: 'Last Name',
                  errorText: _validateLastName,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _userContactController,
                  maxLength: 10,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone, color: Colors.teal),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: 'Enter Contact Number',
                    labelText: 'Contact',
                    errorText: _validateContact,
                  ),
                  // !RegExp(patttern).hasMatch(num)
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _userEmailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.teal),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: 'Enter Email',
                  labelText: 'Email',
                  errorText: _validateEmail,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () async {
                  final initialDate = DateTime.now();
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: date ?? initialDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    setState(() {
                      _userDobController.text = formattedDate;
                      date = pickedDate;
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _userDobController,
                    // keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      prefixIcon:
                          Icon(Icons.calendar_today, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: "Enter DOB",
                      hintText: 'Enter Date of Birth',
                    ),
                    // readOnly: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.teal,
                        textStyle: const TextStyle(fontSize: 15)),
                    onPressed: () async {
                      setState(() {
                        if (_userFirstNameController.text.isEmpty ||
                            _userLastNameController.text.isEmpty) {
                          _validateFirstName = "First value Can\'t Be Empty";
                          _validateLastName = "Last value Can\'t Be Empty";
                        } else {
                          _validateFirstName = null;
                          _validateLastName = null;
                        }

                        if (_userContactController.text.isEmpty) {
                          _validateContact = "Contact value Can\'t Be Empty";
                        } else if (_userContactController.text.length != 10) {
                          _validateContact = "Please Enter 10 Digit...";
                        } else {
                          _validateContact = null;
                        }

                        if (_userEmailController.text.isEmpty) {
                          _validateEmail = "Contact value Can\'t Be Empty";
                        } else if (!RegExp(emailPattern)
                            .hasMatch(_userEmailController.text)) {
                          _validateEmail = "Please enter valid email";
                        } else {
                          _validateEmail = null;
                        }
                      });
                      if (_userFirstNameController.text.isNotEmpty &&
                          _userLastNameController.text.isNotEmpty &&
                          _userContactController.text.isNotEmpty &&
                          _userEmailController.text.isNotEmpty &&
                          _userDobController.text.isNotEmpty) {
                        // debugPrint("Good Data Can Save");
                        var _user = User();
                        _user.fName = _userFirstNameController.text;
                        _user.lName = _userLastNameController.text;
                        _user.contact = _userContactController.text;
                        _user.email = _userEmailController.text;
                        _user.dob = _userDobController.text;
                        var result = await _userService.saveUser(_user);
                        // print("result -> $result ");
                        Navigator.pop(context, result);
                      }
                    },
                    child: const Text(
                      'Save Details',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _userFirstNameController.text = '';
                        _userLastNameController.text = '';
                        _userContactController.text = '';
                        _userEmailController.text = '';
                        _userDobController.text = '';
                      },
                      child: const Text('Clear Details'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
