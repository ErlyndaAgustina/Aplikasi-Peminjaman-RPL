import 'package:flutter/material.dart';
import '../../profile/profile_page.dart';
import 'models/models.dart';
import '../kategori/widgets/kategori_card.dart';
import '../sidebar/sidebar_admin.dart';
import 'widgets/delete_confirm_dialog.dart';
import 'widgets/kategori_form_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String roboto = 'Roboto';

class ManajemenKategoriPage extends StatefulWidget {
  const ManajemenKategoriPage({super.key});
  
  @override
  State<ManajemenKategoriPage> createState() => _ManajemenKategoriPageState();
}

class _ManajemenKategoriPageState extends State<ManajemenKategoriPage> {
  String _searchQuery = "";
  List<KategoriModel> _kategoriList = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchKategori();
  }

  // --- REQUISITION DATA (READ) ---
  Future<void> _fetchKategori() async {
    try {
      // Query ini mengambil data kategori dan menghitung jumlah alat terkait
      final data = await Supabase.instance.client
          .from('kategori')
          .select('''
            id_kategori, 
            nama_kategori, 
            keterangan, 
            alat(count)
          ''')
          .order('nama_kategori', ascending: true);

      setState(() {
        _kategoriList = (data as List).map((e) => KategoriModel.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetch: $e");
      setState(() => _isLoading = false);
    }
  }

  // --- FUNGSI SIMPAN/UPDATE (CREATE & UPDATE) ---
  void _showKategoriForm({KategoriModel? kategori, int? index}) {
    final bool isEdit = kategori != null;
    final nameController = TextEditingController(text: isEdit ? kategori.nama : "");
    final descController = TextEditingController(text: isEdit ? kategori.deskripsi : "");

    showDialog(
      context: context,
      builder: (context) => KategoriFormDialog(
        isEdit: isEdit,
        nameController: nameController,
        descController: descController,
        onSave: () async {
          final client = Supabase.instance.client;
          final data = {
            'nama_kategori': nameController.text,
            'keterangan': descController.text,
          };

          try {
            if (isEdit) {
              await client.from('kategori').update(data).eq('id_kategori', kategori.id!);
            } else {
              await client.from('kategori').insert(data);
            }
            _fetchKategori(); // Refresh list
            Navigator.pop(context);
          } catch (e) {
            debugPrint("Error save: $e");
          }
        },
      ),
    );
  }

  // --- FUNGSI HAPUS (DELETE) ---
  void _showDeleteConfirmation(String id) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmDialog(
        onDelete: () async {
          try {
            await Supabase.instance.client
                .from('kategori')
                .delete()
                .eq('id_kategori', id);
            
            _fetchKategori(); // Refresh list
            Navigator.pop(context);
          } catch (e) {
            debugPrint("Error delete: $e");
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter list berdasarkan pencarian (Local filtering)
    final filteredList = _kategoriList.where((kat) {
      return kat.nama.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      drawer: const SidebarAdminDrawer(),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAddButton(),
            const SizedBox(height: 12),
            _buildSearchField(),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final kategori = filteredList[index];
                      return KategoriCard(
                        kategori: kategori,
                        onEdit: () => _showKategoriForm(kategori: kategori),
                        onDelete: () => _showDeleteConfirmation(kategori.id!),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Sub-Widget: Add Button
  Widget _buildAddButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: () => _showKategoriForm(),
      icon: const Icon(Icons.add, color: Colors.white, size: 22),
      label: const Text(
        'Tambah Kategori',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: roboto,
        ),
      ),
    );
  }

  // Sub-Widget: Search Field
Widget _buildSearchField() {
  return SizedBox(
    height: 40,
    child: TextField(
      controller: _searchController, // Tambahkan controller
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Cari Kategori...',
        prefixIcon: const Icon(
          Icons.search,
          color: Color.fromRGBO(72, 141, 117, 1),
        ),
        // --- TAMBAHAN ICON SILANG ---
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _searchController.clear(); // Hapus teks di field
                    _searchQuery = ""; // Reset filter
                  });
                },
              )
            : null,
        // ----------------------------
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0), // Biar teks rata tengah
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color.fromRGBO(205, 238, 226, 1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color.fromRGBO(72, 141, 117, 1),
          ),
        ),
      ),
    ),
  );
}

  // Sub-Widget: AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(216, 199, 246, 1),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Color.fromRGBO(62, 159, 127, 1),
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Manajemen Kategori',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: roboto,
                        ),
                      ),
                      Text(
                        'RPLKIT • SMK Brantas Karangkates',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(72, 141, 117, 1),
                          fontFamily: roboto,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePenggunaPage(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color.fromRGBO(217, 253, 240, 0.49),
                    child: Icon(
                      Icons.person,
                      color: Color.fromRGBO(62, 159, 127, 1),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
