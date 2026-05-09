import 'package:flutter/material.dart';
import 'package:hit_api/models/user.dart';
import 'package:hit_api/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DetailUserScreen extends StatefulWidget {
  final UserResponse? data;
  const DetailUserScreen({super.key, required this.data});

  @override
  State<DetailUserScreen> createState() => _DetailUserScreenState();
}

class _DetailUserScreenState extends State<DetailUserScreen> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _namaController.text = widget.data!.nama;
    _emailController.text = widget.data!.email;
  }

  void doUpdate() async {
    final UserProvider userProvider = context.read<UserProvider>();

    UserRequest userRequest = UserRequest(
      email: _emailController.text,
      nama: _namaController.text,
    );

    bool isSuccess = await userProvider.doUpdateUser(
      userRequest,
      widget.data!.id,
    );

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
            ElevatedButton(
              onPressed: userProvider.isLoading ? null : doUpdate,
              child: userProvider.isLoading
                  ? CircularProgressIndicator(color: Colors.blue)
                  : Text("Update Data User"),
            ),
          ],
        ),
      ),
    );
  }
}
