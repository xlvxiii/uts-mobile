import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class EditDaftar extends StatefulWidget {
  final String id;
  final String nama;
  final String jumlah;

  EditDaftar({required this.id, required this.nama, required this.jumlah});

  @override
  _EditDaftarState createState() => _EditDaftarState();
}

class _EditDaftarState extends State<EditDaftar> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.nama;
    _jumlahController.text = widget.jumlah;
  }

  Future<void> editDaftar(String id, String nama, String jumlah) async {
    String url = Platform.isAndroid
        ? 'http://10.98.5.205/belanja-api/daftar_belanja.php'
        : 'http://belanja-api.test/daftar_belanja.php';

    Map<String, String> header = {'Content-Type': 'application/json'};
    Map<String, String> data = {
      'id': id,
      'nama': nama,
      'jumlah': jumlah
    };

    final response = await http.put(Uri.parse(url),
        headers: header, body: json.encode(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Daftar'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: 'Nama',
              ),
            ),
            TextField(
              controller: _jumlahController,
              decoration: InputDecoration(
                hintText: 'Jumlah',
              ),
            ),

            ElevatedButton(
                onPressed: () {
                  String id = widget.id;
                  String nama = _namaController.text;
                  String jumlah = _jumlahController.text;

                  editDaftar(id, nama, jumlah).then((_) {
                    Navigator.pop(context);
                  });
                },
                child: Text('Simpan'))
          ],
        ),
      ),
    );
  }
}
