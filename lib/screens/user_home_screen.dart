import 'package:flutter/material.dart';
import 'package:hit_api/providers/user_provider.dart';
import 'package:hit_api/screens/detail_user_screen.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserProvider>().getAllUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.watch<UserProvider>();
    return Scaffold(
      body: userProvider.isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : ListView.builder(
              itemCount: userProvider.data?.length,
              itemBuilder: (context, index) {
                final item = userProvider.data?[index];

                return Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text("Nama: ${item!.nama}"),
                    subtitle: Text("Email ${item.email}"),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailUserScreen(data: item),
                        ),
                      );
                      if (result == true) await userProvider.getAllUser();
                    },
                    onLongPress: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Apakah kamu mau menghapus data ini?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await userProvider.delete(item.id);

                              return Navigator.pop(context);
                            },
                            child: Text("Hapus"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, "/tambah-user");

          if (result == true) await userProvider.getAllUser();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
