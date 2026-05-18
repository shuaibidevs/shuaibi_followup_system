import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shuaibi_followup_system/main.dart';

import '../helpers/login_session_helper.dart';
import '../models/allowed_user_model.dart';
import '../services/database_service.dart';
import '../tools/data_builder.dart';
import '../tools/encrypt.dart';
import '../tools/navigate.dart';
import '../tools/screen_size.dart';
import 'create_account_page.dart';

class LoginPage extends StatefulWidget {
  final DatabaseService databaseService;
  const LoginPage({super.key, required this.databaseService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

TextEditingController _emailCtrl = TextEditingController();
TextEditingController _passCtrl = TextEditingController();
final _formKey = GlobalKey<FormState>();
bool _passToggler = true;

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _emailCtrl.clear();
    _passCtrl.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: DataBuilder.streamBuilder(
        stream: widget.databaseService.readAllowedUserAccount(),
        builder: (cx, sanpshot) {
          List<QueryDocumentSnapshot<AllowedUserModel>>? docs =
              sanpshot.data?.data?.docs;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _form(docs),
                SizedBox(height: 20.0),
                TextButton(
                  onPressed: () async {
                    Navigate(context).to(
                      page: CreateAccountPage(
                        databaseService: widget.databaseService,
                        docs: docs,
                      ),
                    );
                  },
                  child: const Text('Create New Account'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _form(List<QueryDocumentSnapshot<AllowedUserModel>>? docs) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _field(
            name: 'email',
            controller: _emailCtrl,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
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
              if (value == null || value.isEmpty) {
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
              _login(_emailCtrl.text.trim(), _passCtrl.text.trim(), docs);
            },
            child: Text('Login'),
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

  void _login(
    String email,
    String password,
    List<QueryDocumentSnapshot<AllowedUserModel>>? docs,
  ) async {
    if (_formKey.currentState!.validate()) {
      List<AllowedUserModel>? allowedUsers =
          docs?.map((e) => e.data()).toList();
      AllowedUserModel? currentUSer = allowedUsers?.firstWhere(
        (element) => element.email == email,
        orElse:
            () => AllowedUserModel(
              email: 'null',
              password: 'null',
              type: 'null',
              createdAt: Timestamp.now(),
              updatedAt: Timestamp.now(),
            ),
      );
      if (currentUSer != null) {
        String currentUSerEmail = currentUSer.email;
        String currentUSerPassword = Encrypt.decode(currentUSer.password);
        if (currentUSerEmail != email) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('account does not exist!')));
        } else if (currentUSerPassword != password) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('wrong passowrd!')));
        } else {
          bool updated = await LoginSessionHelper.updateSession(
            loggedIn: true,
            updatedAt: DateTime.now().toString(),
          );

          if (updated) {
            if (mounted) Navigate(context).to(page: MyApp());
          }
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('user == null')));
      }
    }
  }
}
