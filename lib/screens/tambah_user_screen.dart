import 'package:flutter/material.dart';
import 'package:hit_api/models/user.dart';
import 'package:hit_api/providers/user_provider.dart';
import 'package:provider/provider.dart';

class TambahUserScreen extends StatelessWidget {
  const TambahUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FormTambahUser();
  }
}

class FormTambahUser extends StatefulWidget {
  const FormTambahUser({super.key});

  @override
  State<FormTambahUser> createState() => FormTambahUserState();
}

class FormTambahUserState extends State<FormTambahUser> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void doCreate() async {
    final UserProvider userProvider = context.read<UserProvider>();

    UserRequest userRequest = UserRequest(
      email: _emailController.text,
      nama: _namaController.text,
      password: _passwordController.text,
    );

    bool isSuccess = await userProvider.doCreateUser(userRequest);

    if (!mounted) return;

    if (isSuccess) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Samting Wong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.watch<UserProvider>();
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(30),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(child: Text("Tambah User")),
            SizedBox(height: 20),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: userProvider.isLoading ? null : doCreate,
              child: userProvider.isLoading
                  ? CircularProgressIndicator(color: Colors.blue)
                  : Text("Buat User"),
            ),
          ],
        ),
      ),
    );
  }
}
