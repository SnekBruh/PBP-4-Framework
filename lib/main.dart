import 'package:flutter/material.dart';
import 'package:crud_form/db/db_instance.dart';
//import 'package:crud_form/model/model.dart';
//import 'package:crud_form/screens/note_list.dart';
//import 'package:crud_form/screens/note_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD RUANGAN',
      theme: ThemeData(primarySwatch: Colors.red),
      home: MyHomePage(
        title: 'Database Ruangan',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController kodeController = TextEditingController();
  TextEditingController namaruanganController = TextEditingController();
  TextEditingController kapasitasController = TextEditingController();

  @override
  void initState() {
    loadRuang(); //refresh
    super.initState();
  }

  List<Map<String, dynamic>> ruangan = [];
  void loadRuang() async {
    final data = await DbInstance.getRuangan();
    setState(() {
      ruangan = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(ruangan);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: ruangan.length,
          itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(20),
                child: ListTile(
                    title: Text(ruangan[index]['kode_ruangan']),
                    subtitle: Text(ruangan[index]['nama_ruangan']),
                    trailing: Text(ruangan[index]['kapasitas']),
                    leading: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () =>
                                    ruangForm(ruangan[index]['id']),
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () =>
                                    deleteRuangan(ruangan[index]['id']),
                                icon: const Icon(Icons.delete))
                          ],
                        ))),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ruangForm(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> addRuangan() async {
    await DbInstance.addRuangan(kodeController.text, namaruanganController.text,
        kapasitasController.text);
    loadRuang();
  }

  Future<void> editRuangan(int id) async {
    await DbInstance.editRuangan(id, kodeController.text,
        namaruanganController.text, kapasitasController.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Data Berhasil diedit'))); //menampilkan pesan
    loadRuang();
  }

  void deleteRuangan(int id) async {
    await DbInstance.deleteRuangan(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Catatan berhasil dihapus'))); //menampilkan pesan
    loadRuang();
  }

  void ruangForm(int id) async {
    if (id != null) {
      final dataRuangan = ruangan.firstWhere((element) => element['id'] == id);
      kodeController.text = dataRuangan['kode_ruangan'];
      namaruanganController.text = dataRuangan['nama_ruangan'];
      kapasitasController.text = dataRuangan['kapasitas'];
    }
    //A modal bottom sheet is an alternative to a menu or a dialog and prevents
    //the user from interacting with the rest of the app.
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity, //menyesuaikan dengan parent
              height: 1600,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, //fit Children
                  crossAxisAlignment: CrossAxisAlignment
                      .end, //menempatkan children dibelakang cross axis
                  children: [
                    TextField(
                      controller: kodeController,
                      decoration:
                          const InputDecoration(hintText: 'Masukkan kode'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: namaruanganController,
                      decoration: const InputDecoration(
                          hintText: 'Masukkan nama ruangan'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: kapasitasController,
                      decoration: const InputDecoration(
                          hintText: 'Masukkan jumlah kapasitas ruangan'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            await addRuangan();
                          } else {
                            await editRuangan(id);
                          }
                          kodeController.text = '';
                          namaruanganController.text = '';
                          kapasitasController.text = '';
                          Navigator.pop(context);
                        },
                        child: Text(id == null ? 'Tambah' : 'Ubah'))
                  ],
                ),
              ),
            ));
  }
}
