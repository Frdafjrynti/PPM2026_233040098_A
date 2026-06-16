import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'galery_widget.dart';

// ============================================================
// LIGHT THEME CONSTANTS
// ============================================================
const _kBg       = Color(0xFFF5F6FA);
const _kSurface  = Colors.white;
const _kBorder   = Color(0xFFE8E8E8);
const _kPrimary  = Color(0xFF1A237E);
const _kAccent   = Color(0xFF3949AB);
const _kTextPri  = Color(0xFF1A1A1A);
const _kTextSec  = Color(0xFF757575);
const _kHeader   = Color(0xFF1A237E);

BoxDecoration _card({double r = 14}) => BoxDecoration(
  color: _kSurface,
  borderRadius: BorderRadius.circular(r),
  border: Border.all(color: _kBorder),
  boxShadow: [
    BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 2)),
  ],
);

InputDecoration _inputDeco(String label, IconData icon) => InputDecoration(
  labelText: label,
  labelStyle: const TextStyle(color: _kTextSec, fontSize: 13),
  prefixIcon: Icon(icon, color: _kAccent, size: 20),
  filled: true,
  fillColor: const Color(0xFFF8F9FF),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kBorder)),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kBorder)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kAccent, width: 2)),
);

// ============================================================
// MODEL
// ============================================================
class ProfileData {
  Uint8List? photoBytes;
  String name, subtitle, about, education, location, contact;
  List<String> skills;

  ProfileData({
    this.photoBytes,
    this.name = 'Nama Anda',
    this.subtitle = 'Mahasiswa Teknik Informatika',
    this.about = 'Saya suka belajar hal baru...',
    this.education = 'Universitas XYZ — Semester 6\nIPK: 3.75',
    this.location = 'Bandung, Jawa Barat',
    this.contact = 'email@example.com\n+62 812-3456-7890',
    List<String>? skills,
  }) : skills = skills ?? ['Flutter', 'Dart', 'Java'];
}

class ExperienceItem {
  Uint8List? imageBytes;
  String title, description;
  ExperienceItem(
      {this.imageBytes, required this.title, required this.description});
}

// ============================================================
// PROFILE PAGE
// ============================================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileData _profile;
  List<ExperienceItem> _experiences = [];

  @override
  void initState() {
    super.initState();
    _profile = ProfileData(
      name: 'Ilham Anugrah',
      subtitle: 'Mahasiswa Teknik Informatika',
      about:
      'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi dan pengembangan aplikasi mobile.',
      education: 'Universitas Pasundan — Semester 6\nIPK: 3.75',
      location: 'Bandung, Jawa Barat',
      contact: 'ilham@student.ac.id\n+62 812-3456-7890',
      skills: ['Flutter', 'Dart', 'Java', 'Python', 'Git'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kSurface,
        foregroundColor: _kTextPri,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Profil Saya',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: _kTextPri)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _kBorder),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.search_rounded, color: _kTextPri),
              onPressed: () {}),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(_profile.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _kTextPri)),
                  const SizedBox(height: 4),
                  Text(_profile.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 13, color: _kTextSec)),
                  const SizedBox(height: 20),
                  _buildStats(),
                  const SizedBox(height: 14),
                  _InfoCard(
                    icon: Icons.info_outline_rounded,
                    iconColor: _kAccent,
                    iconBg: const Color(0xFFE8EAF6),
                    label: 'Tentang',
                    value: _profile.about,
                  ),
                  _InfoCard(
                    icon: Icons.school_rounded,
                    iconColor: const Color(0xFF2E7D32),
                    iconBg: const Color(0xFFE8F5E9),
                    label: 'Pendidikan',
                    value: _profile.education,
                  ),
                  _InfoCard(
                    icon: Icons.location_on_rounded,
                    iconColor: const Color(0xFFE65100),
                    iconBg: const Color(0xFFFFF3E0),
                    label: 'Lokasi',
                    value: _profile.location,
                  ),
                  _InfoCard(
                    icon: Icons.email_rounded,
                    iconColor: const Color(0xFF6A1B9A),
                    iconBg: const Color(0xFFF3E5F5),
                    label: 'Kontak',
                    value: _profile.contact,
                  ),
                  _buildSkillsCard(),
                  if (_experiences.isNotEmpty) _buildExpCard(),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _kPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        onPressed: () async {
          final updated = await Navigator.push<ProfileData>(
            context,
            MaterialPageRoute(
                builder: (_) => EditProfilePage(profile: _profile)),
          );
          if (updated != null) setState(() => _profile = updated);
        },
        icon: const Icon(Icons.edit_rounded, size: 18),
        label: const Text('Edit Profil',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 160,
          color: _kHeader,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              25,
                  (_) => Container(
                width: 1,
                height: double.infinity,
                color: Colors.white.withOpacity(0.05),
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -48,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFFE8EAF6),
              backgroundImage: _profile.photoBytes != null
                  ? MemoryImage(_profile.photoBytes!)
                  : null,
              child: _profile.photoBytes == null
                  ? const Icon(Icons.person_rounded,
                  size: 52, color: _kAccent)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: _card(),
      child: Row(
        children: [
          _StatItem(value: '12', label: 'Post'),
          Container(width: 1, height: 32, color: _kBorder),
          _StatItem(value: '128', label: 'Teman'),
          Container(width: 1, height: 32, color: _kBorder),
          _StatItem(value: '1.2K', label: 'Like'),
        ],
      ),
    );
  }

  Widget _buildSkillsCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.star_rounded,
                    color: Color(0xFFF9A825), size: 18),
              ),
              const SizedBox(width: 12),
              const Text('Skills',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _kTextPri)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _profile.skills
                .map((s) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAF6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: _kAccent.withOpacity(0.3)),
              ),
              child: Text(s,
                  style: const TextStyle(
                      color: _kAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.work_rounded,
                    color: Color(0xFF00838F), size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Pengalaman',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _kTextPri)),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(10)),
                child: Text('${_experiences.length}',
                    style: const TextStyle(
                        color: Color(0xFF00838F),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._experiences.map((exp) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: _kBg,
                    child: exp.imageBytes != null
                        ? Image.memory(exp.imageBytes!, fit: BoxFit.cover)
                        : const Icon(Icons.image_rounded,
                        color: _kTextSec),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exp.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: _kTextPri)),
                      const SizedBox(height: 2),
                      Text(exp.description,
                          style: const TextStyle(
                              fontSize: 12,
                              color: _kTextSec,
                              height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: _kSurface,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            color: _kHeader,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white24,
                  backgroundImage: _profile.photoBytes != null
                      ? MemoryImage(_profile.photoBytes!)
                      : null,
                  child: _profile.photoBytes == null
                      ? const Icon(Icons.person_rounded,
                      size: 36, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(_profile.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(height: 2),
                Text(_profile.subtitle,
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _DrawerItem(
              icon: Icons.person_rounded,
              label: 'Profil',
              onTap: () => Navigator.pop(context)),
          _DrawerItem(
            icon: Icons.widgets_rounded,
            label: 'Widget Gallery',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const GalleryHome()));
            },
          ),
          _DrawerItem(
            icon: Icons.upload_file_rounded,
            label: 'Upload Pengalaman',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditExperiencePage(
                    experiences: _experiences,
                    onSave: (u) => setState(() => _experiences = u),
                  ),
                ),
              );
            },
          ),
          Divider(color: _kBorder, indent: 16, endIndent: 16),
          _DrawerItem(
              icon: Icons.settings_rounded,
              label: 'Pengaturan',
              onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      child: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: _kPrimary,
        unselectedItemColor: _kTextSec,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded), label: 'Pesan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded), label: 'Setting'),
        ],
        onTap: (i) {},
      ),
    );
  }
}

// ============================================================
// EDIT PROFILE PAGE
// ============================================================
class EditProfilePage extends StatefulWidget {
  final ProfileData profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameCtrl, _aboutCtrl, _eduCtrl,
      _locCtrl, _contactCtrl, _skillsCtrl;
  Uint8List? _photoBytes;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameCtrl    = TextEditingController(text: p.name);
    _aboutCtrl   = TextEditingController(text: p.about);
    _eduCtrl     = TextEditingController(text: p.education);
    _locCtrl     = TextEditingController(text: p.location);
    _contactCtrl = TextEditingController(text: p.contact);
    _skillsCtrl  = TextEditingController(text: p.skills.join(', '));
    _photoBytes  = p.photoBytes;
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _aboutCtrl, _eduCtrl,
      _locCtrl, _contactCtrl, _skillsCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _photoBytes = bytes);
    }
  }

  void _save() {
    Navigator.pop(context, ProfileData(
      photoBytes: _photoBytes,
      name:       _nameCtrl.text.trim(),
      subtitle:   widget.profile.subtitle,
      about:      _aboutCtrl.text.trim(),
      education:  _eduCtrl.text.trim(),
      location:   _locCtrl.text.trim(),
      contact:    _contactCtrl.text.trim(),
      skills: _skillsCtrl.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kHeader,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Edit Profil',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check_rounded,
                color: Colors.white, size: 18),
            label: const Text('Simpan',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Photo section
            Container(
              width: double.infinity,
              color: _kHeader,
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor: const Color(0xFFE8EAF6),
                          backgroundImage: _photoBytes != null
                              ? MemoryImage(_photoBytes!)
                              : null,
                          child: _photoBytes == null
                              ? const Icon(Icons.person_rounded,
                              size: 56, color: _kAccent)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: _kBorder, width: 2)),
                            child: const Icon(Icons.camera_alt_rounded,
                                color: _kAccent, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickImage,
                    child: const Text('Ganti Foto dari Galeri',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white54)),
                  ),
                ],
              ),
            ),

            // Form
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SectionLabel(label: 'Informasi Profil'),
                  const SizedBox(height: 14),
                  _field(_nameCtrl, 'Nama Lengkap *',
                      Icons.person_outline_rounded),
                  const SizedBox(height: 10),
                  _field(_aboutCtrl, 'Bio / Tentang',
                      Icons.info_outline_rounded, lines: 3),
                  const SizedBox(height: 10),
                  _field(_eduCtrl, 'Pendidikan',
                      Icons.school_rounded, lines: 2),
                  const SizedBox(height: 10),
                  _field(_locCtrl, 'Lokasi',
                      Icons.location_on_rounded),
                  const SizedBox(height: 10),
                  _field(_contactCtrl, 'Kontak',
                      Icons.email_rounded, lines: 2),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _skillsCtrl,
                    decoration: _inputDeco(
                        'Skills (pisahkan koma)',
                        Icons.star_outline_rounded),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_rounded, size: 18),
                      label: const Text('Simpan Perubahan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {int lines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: lines,
      decoration: _inputDeco(label, icon)
          .copyWith(alignLabelWithHint: lines > 1),
    );
  }
}

// ============================================================
// BONUS — Edit Experience Page
// ============================================================
class EditExperiencePage extends StatefulWidget {
  final List<ExperienceItem> experiences;
  final void Function(List<ExperienceItem>) onSave;

  const EditExperiencePage(
      {super.key, required this.experiences, required this.onSave});

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  Uint8List? _imageBytes;
  late List<ExperienceItem> _list;

  @override
  void initState() {
    super.initState();
    _list = List.from(widget.experiences);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  void _add() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Judul tidak boleh kosong!'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }
    setState(() {
      _list.add(ExperienceItem(
          imageBytes: _imageBytes,
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim()));
      _titleCtrl.clear();
      _descCtrl.clear();
      _imageBytes = null;
    });
    widget.onSave(_list);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Pengalaman ditambahkan!'),
      backgroundColor: Colors.green.shade700,
      behavior: SnackBarBehavior.floating,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kHeader,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Upload Pengalaman',
            style:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          TextButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.save_rounded,
                color: Colors.white, size: 18),
            label: const Text('Simpan',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 170,
                decoration: BoxDecoration(
                  color: _kSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _kBorder),
                ),
                clipBehavior: Clip.antiAlias,
                child: _imageBytes != null
                    ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EAF6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 32,
                          color: _kAccent),
                    ),
                    const SizedBox(height: 12),
                    const Text('Ketuk untuk pilih gambar',
                        style: TextStyle(
                            color: _kAccent,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    const Text('dari galeri perangkat kamu',
                        style: TextStyle(
                            color: _kTextSec, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel(label: 'Informasi Pengalaman'),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              decoration: _inputDeco('Judul *', Icons.title_rounded),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descCtrl,
              maxLines: 4,
              decoration: _inputDeco('Deskripsi', Icons.description_rounded)
                  .copyWith(alignLabelWithHint: true),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _add,
                icon: const Icon(Icons.save_rounded, size: 18),
                label: const Text('Simpan Pengalaman',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            if (_list.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Tersimpan (${_list.length})',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _kTextPri)),
              const SizedBox(height: 10),
              ..._list.asMap().entries.map((e) {
                final exp = e.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: _card(r: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: _kBg,
                        child: exp.imageBytes != null
                            ? Image.memory(exp.imageBytes!,
                            fit: BoxFit.cover)
                            : const Icon(Icons.image_rounded,
                            color: _kTextSec),
                      ),
                    ),
                    title: Text(exp.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: _kTextPri)),
                    subtitle: Text(exp.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: _kTextSec)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_rounded,
                          color: Colors.redAccent, size: 20),
                      onPressed: () {
                        setState(() => _list.removeAt(e.key));
                        widget.onSave(_list);
                      },
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HELPER WIDGETS
// ============================================================
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, value;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: _kTextSec,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: _kTextPri)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _kTextPri)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 11, color: _kTextSec)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
              color: _kAccent,
              borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: _kAccent)),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _DrawerItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: const Color(0xFFE8EAF6),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: _kAccent, size: 18),
      ),
      title: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: _kTextPri)),
      onTap: onTap,
    );
  }
}