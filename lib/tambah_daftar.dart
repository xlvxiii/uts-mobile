import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:daftar_belanja/home_page.dart';
import 'package:http/http.dart' as http;

class TambahDaftar extends StatefulWidget {
  const TambahDaftar({Key? key}) : super(key: key);

  @override
  _TambahDaftarState createState() => _TambahDaftarState();
}

class _TambahDaftarState extends State<TambahDaftar> {
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();

  Future tambahDaftar(String nama, String jumlah) async {
    String url = Platform.isAndroid
        ? 'http://10.98.5.205/belanja-api/daftar_belanja.php'
        : 'http://belanja-api.test/daftar_belanja.php';

    Map<String, String> header = {'Content-Type': 'application/json'};
    String body = '{"nama": "$nama", "jumlah": "$jumlah"}';

    var response = await http.post(Uri.parse(url), headers: header, body: body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Daftar'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(hintText: 'Nama'),
            ),
            TextField(
              controller: _jumlahController,
              decoration: const InputDecoration(hintText: 'jumlah'),
            ),
            ElevatedButton(
                onPressed: () {
                  String nama = _namaController.text;
                  String jumlah = _jumlahController.text;
                  tambahDaftar(nama, jumlah).then((result) {
                    if (result['pesan'] == 'Berhasil menambahkan') {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Berhasil menambahkan daftar'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage(),
                                          ));
                                    },
                                    child: const Text('OK'))
                              ],
                            );
                          });
                    }
                  });
                },
                child: const Text('Simpan'))
          ],
        ),
      ),
    );
  }
}
