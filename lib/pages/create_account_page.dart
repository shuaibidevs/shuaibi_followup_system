// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import '../helpers/login_session_helper.dart';
// import '../models/allowed_user_model.dart';
// import '../models/login_session_model.dart';
// import '../services/database_service.dart';
// import '../tools/consts.dart';
// import '../tools/data_builder.dart';
// import '../tools/encrypt.dart';
// import '../tools/screen_size.dart';

// class CreateAccountPage extends StatefulWidget {
//   final DatabaseService databaseService;
//   const CreateAccountPage({super.key, required this.databaseService});

//   @override
//   State<CreateAccountPage> createState() => _CreateAccountPageState();
// }

// TextEditingController _emailCtrl = TextEditingController();
// // TextEditingController _roleCtrl = TextEditingController();
// TextEditingController _passCtrl = TextEditingController();
// TextEditingController _confirmPassCtrl = TextEditingController();
// final _formKey = GlobalKey<FormState>();
// bool _passToggler = true;
// String? _role;
// BorderRadius _radius = BorderRadius.circular(10.0);

// class _CreateAccountPageState extends State<CreateAccountPage> {
//   @override
//   void initState() {
//     _emailCtrl.clear();
//     _passCtrl.clear();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Register new account')),
//       body: Center(
//         child: DataBuilder.streamBuilder(
//           stream: widget.databaseService.readAllowedUserAccount(),

//           builder: (cx, snapshot) {
//             List<QueryDocumentSnapshot<AllowedUserModel>> docs =
//                 snapshot.data!.data!.docs;
//             List<AllowedUserModel> listOfAllowedAccounts =
//                 docs.map((e) => e.data()).toList();
//             return _form(listOfAllowedAccounts);
//           },
//         ),
//       ),
//     );
//   }

//   Widget _form(List<AllowedUserModel> listOfAllowedAccounts) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _field(
//             name: '* email',
//             controller: _emailCtrl,
//             validator: (String? value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Field can not be empty!';
//               }
//               if (!value.contains('@')) {
//                 return 'Wrong email format!';
//               }
//               return null;
//             },
//           ),

//           _dropdown(),
//           _field(
//             name: '* password',
//             controller: _passCtrl,
//             obscureText: _passToggler,
//             suffixIcon: IconButton(
//               onPressed: () {
//                 setState(() {
//                   _passToggler = !_passToggler;
//                 });
//               },
//               icon: Icon(
//                 _passToggler ? Icons.visibility_off : Icons.visibility,
//               ),
//             ),
//             validator: (String? value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Field can not be empty!';
//               }
//               if (value.length < 8) {
//                 return 'At least 8 characters';
//               }
//               return null;
//             },
//           ),
//           _field(
//             name: '* confirm password',
//             controller: _confirmPassCtrl,
//             obscureText: _passToggler,

//             validator: (String? value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Field can not be empty!';
//               }
//               if (value.length < 8) {
//                 return 'At least 8 characters';
//               }
//               if (value.trim() != _passCtrl.text.trim()) {
//                 return 'Password not matching';
//               }
//               return null;
//             },
//           ),
//           SizedBox(height: 10.0),
//           ElevatedButton(
//             onPressed: () {
//               _createNewAccount(
//                 _emailCtrl.text.trim(),
//                 _passCtrl.text.trim(),
//                 // _roleCtrl.text.trim(),
//                 listOfAllowedAccounts: listOfAllowedAccounts,
//               );
//             },
//             child: Text('Register new account'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _field({
//     String? name,
//     TextEditingController? controller,
//     String? Function(String?)? validator,
//     bool obscureText = false,
//     Widget? suffixIcon,
//   }) {
//     return Container(
//       width: ScreenSize.width * (ScreenSize.isMobile ? 0.6 : 0.15),

//       margin: EdgeInsets.all(10.0),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           hintText: name,
//           border: OutlineInputBorder(borderRadius: _radius),
//           suffixIcon: suffixIcon,
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   void _createNewAccount(
//     String email,
//     String password, {
//     // String? role,
//     required List<AllowedUserModel>? listOfAllowedAccounts,
//   }) {
//     if (_formKey.currentState!.validate()) {
//       bool? emailExists = listOfAllowedAccounts?.any(
//         (element) => element.email == email,
//       );
//       if (emailExists != null && emailExists) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Email already exists!')));
//       } else {
//         _addAccountToDB(email, password);
//       }
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Check inputs and try again')));
//     }
//   }

//   _addAccountToDB(String email, String password) {
//     widget.databaseService
//         .createAllowedUserAccount(
//           AllowedUserModel(
//             email: email,
//             password: Encrypt.encode(password),
//             type: _role ?? "not set",
//             createdAt: Timestamp.now(),
//             updatedAt: Timestamp.now(),
//           ),
//         )
//         .then((value) {
//           if (value.isSuccess) {
//             LoginSessionHelper.createSession(
//               LoginSessionModel(
//                 email: email,
//                 loggedIn: true,
//                 createdAt: DateTime.now().toString(),
//                 updatedAt: DateTime.now().toString(),
//               ),
//             );
//             if (mounted) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Account created successfully')),
//               );
//               // Navigator.pop(context);
//             }
//           }
//         });
//   }

//   Widget _dropdown() {
//     List<DropdownMenuItem> l =
//         Consts.roles
//             .map((role) => DropdownMenuItem(value: role, child: Text(role)))
//             .toList();
//     return SizedBox(
//       width: ScreenSize.width * (ScreenSize.isMobile ? 0.6 : 0.15),
//       child: DropdownButtonFormField(
//         decoration: InputDecoration(
//           hintText: 'role',
//           border: OutlineInputBorder(borderRadius: _radius),
//         ),
//         value: _role,
//         items: l,
//         onChanged: (value) {
//           setState(() {
//             _role = value;
//           });
//         },
//       ),
//     );
//   }
// }
