import 'package:crud_app/model/User.dart';
import 'package:crud_app/services/UserService.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _userFirstNameController = TextEditingController();
  final _userLastNameController = TextEditingController();
  final _userContactController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userDobController = TextEditingController();

  String? _validateFirstName = null;
  String? _validateLastName = null;
  String? _validateContact = null;
  String? _validateDob = null;
  String? _validateEmail = null;

  String ContactPatttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  String emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  var _userService = UserService();

  late String birthDateInString;

  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();

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
                'Add New User',
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
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime.now(),);

                  if (pickedDate != null && pickedDate != DateTime.now()) {
                    String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);

                    setState(() {
                      _userDobController.text =
                          formattedDate; //set output date to TextField value.
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
                      if (_validateFirstName == false &&
                          _validateLastName == false &&
                          _validateContact == false &&
                          _validateEmail == false &&
                          _validateDob == false) {
                        // print("Good Data Can Save");
                        var _user = User();
                        _user.fName = _userFirstNameController.text;
                        _user.lName = _userFirstNameController.text;
                        _user.contact = _userContactController.text;
                        _user.email = _userEmailController.text;
                        var result = await _userService.saveUser(_user);
                        // print(result);
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
