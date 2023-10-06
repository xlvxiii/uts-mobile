import 'package:daftar_belanja/edit_daftar.dart';
import 'package:daftar_belanja/tambah_daftar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> daftarBelanja = [];
  String url = Platform.isAndroid
      ? 'http://10.98.5.205/belanja-api/daftar_belanja.php'
      : 'http://belanja-api.test/daftar_belanja.php';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        daftarBelanja = List<Map<String, String>>.from(data.map((item) {
          return {
            'id': item['id'] as String,
            'nama': item['nama'] as String,
            'jumlah': item['jumlah'] as String,
          };
        }));
      });
    }
  }

  Future delete(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Belanja'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TambahDaftar(),
                  ),
                );
              },
              child: const Text('Tambah')),
          Expanded(
              child: ListView.builder(
                  itemCount: daftarBelanja.length,
                  itemBuilder: ((context, index) => Card(
                        margin: const EdgeInsets.all(5),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          title: Text(daftarBelanja[index]['nama']!),
                          subtitle: Text(daftarBelanja[index]['jumlah']!),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      // edit
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      delete(int.parse(
                                              daftarBelanja[index]['id']!))
                                          .then((result) {
                                        if (result['pesan'] ==
                                            'Berhasil menghapus') {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Barang berhasil dihapus'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          initState();
                                                        },
                                                        child: const Text('OK'))
                                                  ],
                                                );
                                              });
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                          ),
                        ),
                      ))))
        ],
      ),
    );
  }
}
