import 'dart:async';
import 'package:crud_app/db_helper/repository.dart';
import 'package:crud_app/model/User.dart';
class UserService
{
  late Repository _repository;
  UserService(){
    _repository = Repository();
  }
  //Save User
  saveUser(User user) async{
    return await _repository.insertData('users', user.userMap());
  }
  //Read All Users
  readAllUsers() async{
    return await _repository.readData('users');
  }
  //Edit User
  updateUser(User user) async{
    return await _repository.updateData('users', user.userMap());
  }

  deleteUser(userId) async {
    return await _repository.deleteDataById('users', userId);
  }

}