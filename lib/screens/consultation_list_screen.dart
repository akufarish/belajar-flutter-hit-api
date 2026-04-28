import 'package:flutter/material.dart';
import 'package:flutter_hit_api/models/consultaion.dart';
import 'package:flutter_hit_api/screens/consultation_form_screen.dart';
import 'package:flutter_hit_api/services/api_service.dart';
import 'package:intl/intl.dart';

class ConsultationListScreen extends StatefulWidget {
  const ConsultationListScreen({super.key});

  @override
  State<ConsultationListScreen> createState() => _ConsultationListScreenState();
}

class _ConsultationListScreenState extends State<ConsultationListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Consultation>> consultaion;

  void refreshData() {
    setState(() {
      consultaion = apiService.getConsultation();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultaion = apiService.getConsultation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Antrian Klinik')),
      body: FutureBuilder<List<Consultation>>(
        future: consultaion,
        builder: (builder, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error ${snapshot.error}"));
          }

          final data = snapshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Card(
                child: ListTile(
                  isThreeLine: true,
                  contentPadding: EdgeInsets.all(10),
                  leading: Text(DateFormat("dd MMM").format(item.date)),
                  title: Text(item.name),
                  subtitle: Text("${item.poli} - ${item.complaint}"),
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
                    if (result == true) refreshData();
                  },
                ),
              );
            },
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
            refreshData();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
