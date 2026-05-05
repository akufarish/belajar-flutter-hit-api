import 'package:flutter/material.dart';
import 'package:flutter_hit_api/models/consultaion.dart';
import 'package:flutter_hit_api/providers/consultation_provider.dart';
import 'package:flutter_hit_api/screens/consultation_form_screen.dart';
import 'package:flutter_hit_api/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConsultationListScreen extends StatefulWidget {
  const ConsultationListScreen({super.key});

  @override
  State<ConsultationListScreen> createState() => _ConsultationListScreenState();
}

class _ConsultationListScreenState extends State<ConsultationListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      context.read<ConsultationProvider>().fetchConsultation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConsultationProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Antrian Klinik')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.data.length,
              itemBuilder: (context, index) {
                final item = provider.data[index];

                return Card(
                  color: Colors.white,
                  child: ListTile(
                    isThreeLine: true,
                    contentPadding: EdgeInsets.all(10),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.person, size: 50.0)],
                    ),
                    trailing: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No.",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                          Text(
                            "${item.queueNumber}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name),
                        Text("${item.poli} - ${item.complaint}"),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Icon(Icons.calendar_month_outlined),
                        SizedBox(width: 5),
                        Text(DateFormat("E d, h:mm a").format(item.date)),
                      ],
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ConsultationFormScreen(
                            id: item.id,
                            complaint: item.complaint,
                            date: DateFormat("yyyy-mm-dd").format(item.date),
                            name: item.name,
                            poli: item.poli,
                          ),
                        ),
                      );
                      if (result == true) await provider.fetchConsultation();
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
                              await provider.delete(item.id);

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
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ConsultationFormScreen()),
          );

          if (result == true) {
            await provider.fetchConsultation();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
