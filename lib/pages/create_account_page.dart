import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helpers/login_session_helper.dart';
import '../models/allowed_user_model.dart';
import '../models/login_session_model.dart';
import '../services/database_service.dart';
import '../tools/encrypt.dart';
import '../tools/screen_size.dart';

class CreateAccountPage extends StatefulWidget {
  final List<QueryDocumentSnapshot<AllowedUserModel>>? docs;
  final DatabaseService databaseService;
  const CreateAccountPage({
    super.key,
    required this.docs,
    required this.databaseService,
  });

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

TextEditingController _emailCtrl = TextEditingController();
TextEditingController _passCtrl = TextEditingController();
final _formKey = GlobalKey<FormState>();
bool _passToggler = true;

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  void initState() {
    _emailCtrl.clear();
    _passCtrl.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<AllowedUserModel>? listOfAllowedAccounts =
        widget.docs?.map((e) {
          return e.data();
        }).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Account')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _form(listOfAllowedAccounts),
            SizedBox(height: 20.0),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _form(List<AllowedUserModel>? listOfAllowedAccounts) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _field(
            name: 'email',
            controller: _emailCtrl,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Field can not be empty!';
              }
              if (!value.contains('@')) {
                return 'Wrong email format!';
              }
              return null;
            },
          ),
          _field(
            name: 'password',
            controller: _passCtrl,
            obscureText: _passToggler,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _passToggler = !_passToggler;
                });
              },
              icon: Icon(
                _passToggler ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Field can not be empty!';
              }
              if (value.length < 8) {
                return 'At least 8 characters';
              }
              return null;
            },
          ),
          // SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              _createNewAccount(
                _emailCtrl.text.trim(),
                _passCtrl.text.trim(),
                listOfAllowedAccounts: listOfAllowedAccounts,
              );
            },
            child: Text('Create New Account'),
          ),
        ],
      ),
    );
  }

  Widget _field({
    String? name,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    BorderRadius radius = BorderRadius.circular(10.0);
    return Container(
      width: ScreenSize.width * 0.15,

      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: name,
          border: OutlineInputBorder(borderRadius: radius),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }

  void _createNewAccount(
    String email,
    String password, {
    required List<AllowedUserModel>? listOfAllowedAccounts,
  }) {
    if (_formKey.currentState!.validate()) {
      bool? emailExists = listOfAllowedAccounts?.any(
        (element) => element.email == email,
      );
      if (emailExists != null && emailExists) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Email already exists!')));
      } else {
        _addAccountToDB(email, password);
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Check inputs and try again')));
    }
  }

  _addAccountToDB(String email, String password) {
    widget.databaseService
        .createAllowedUserAccount(
          AllowedUserModel(
            email: email,
            password: Encrypt.encode(password),
            type: 'not set',
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
          ),
        )
        .then((value) {
          if (value.isSuccess) {
            LoginSessionHelper.createSession(
              LoginSessionModel(
                email: email,
                loggedIn: true,
                createdAt: DateTime.now().toString(),
                updatedAt: DateTime.now().toString(),
              ),
            );
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Account created successfully')),
              );
              // Navigator.pop(context);
            }
          }
        });
  }
}
