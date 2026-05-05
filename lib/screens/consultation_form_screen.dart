import 'package:flutter/material.dart';
import 'package:flutter_hit_api/providers/consultation_provider.dart';
import 'package:flutter_hit_api/services/api_service.dart';
import 'package:provider/provider.dart';

class ConsultationFormScreen extends StatefulWidget {
  final int? id;
  final String? name;
  final String? date;
  final String? poli;
  final String? complaint;
  final int? queueNumber;
  const ConsultationFormScreen({
    super.key,
    this.id,
    this.name,
    this.date,
    this.poli,
    this.complaint,
    this.queueNumber,
  });

  @override
  State<ConsultationFormScreen> createState() => _ConsultationFormScreenState();
}

class _ConsultationFormScreenState extends State<ConsultationFormScreen> {
  final _nameController = TextEditingController();
  final _complaintController = TextEditingController();
  final ApiService apiService = ApiService();

  String? selectedPoli;
  DateTime? selectedDate;

  final List<String> poliList = [
    "Sakit kepala",
    "Tolong aku",
    "Poli Umum",
    "Poli Gigi",
    "Poli Anak",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.name ?? "";
    _complaintController.text = widget.complaint ?? "";
    selectedPoli = widget.poli;

    if (widget.date != null) {
      selectedDate = DateTime.parse(widget.date!);
    }

    Future.microtask(() {
      context.read<ConsultationProvider>().fetchConsultation();
    });
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void submit() async {
    final provider = context.read<ConsultationProvider>();
    setState(() => provider.isLoading = true);

    try {
      if (widget.id == null) {
        await provider.create(
          _nameController.text,
          selectedDate!,
          selectedPoli!,
          _complaintController.text,
        );
      } else {
        await provider.update(
          widget.id!,
          _nameController.text,
          selectedDate!,
          selectedPoli!,
          _complaintController.text,
        );
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConsultationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? "Daftar antrian" : "Edit antrian"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama Pasien",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? "Pilih tanggal"
                        : selectedDate.toString().split(" ")[0],
                  ),
                ),
                ElevatedButton(
                  onPressed: pickDate,
                  child: Text("Pilih tanggal"),
                ),
              ],
            ),
            SizedBox(height: 12),
            DropdownButtonFormField(
              value: selectedPoli,
              decoration: InputDecoration(
                labelText: "Pilih poli",
                border: OutlineInputBorder(),
              ),
              items: poliList.map((poli) {
                return DropdownMenuItem(child: Text(poli), value: poli);
              }).toList(),
              onChanged: (value) {
                selectedPoli = value!;
              },
            ),
            SizedBox(height: 12),
            TextField(
              controller: _complaintController,
              decoration: InputDecoration(
                labelText: "Keluhan",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: provider.isLoading ? null : submit,
              child: provider.isLoading
                  ? CircularProgressIndicator()
                  : Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
