import 'package:flutter/material.dart';

const _kBg      = Color(0xFFF5F6FA);
const _kSurface = Colors.white;
const _kBorder  = Color(0xFFE8E8E8);
const _kPrimary = Color(0xFF1A237E);
const _kAccent  = Color(0xFF3949AB);
const _kTextPri = Color(0xFF1A1A1A);
const _kTextSec = Color(0xFF757575);
const _kHeader  = Color(0xFF1A237E);

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

// ============================================================
// GALLERY HOME
// ============================================================
class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display',  Icons.image_rounded,        Color(0xFF1565C0), Color(0xFFE3F2FD)),
      ('Input',    Icons.edit_rounded,          Color(0xFF2E7D32), Color(0xFFE8F5E9)),
      ('Button',   Icons.smart_button_rounded,  Color(0xFFE65100), Color(0xFFFFF3E0)),
      ('Feedback', Icons.notifications_rounded, Color(0xFF6A1B9A), Color(0xFFF3E5F5)),
      ('Layout',   Icons.dashboard_rounded,     Color(0xFF00838F), Color(0xFFE0F7FA)),
    ];

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kHeader,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Widget Gallery',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final (name, icon, color, bg) = categories[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: _card(),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CategoryPage(
                          name: name, accent: color, bg: bg)),
                ),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: _kTextPri)),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 13, color: _kTextSec),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String name;
  final Color accent, bg;
  const CategoryPage(
      {super.key, required this.name, required this.accent, required this.bg});

  @override
  Widget build(BuildContext context) {
    final body = switch (name) {
      'Display'  => const _DisplayDemo(),
      'Input'    => const _InputDemo(),
      'Button'   => const _ButtonDemo(),
      'Feedback' => const _FeedbackDemo(),
      'Layout'   => const _LayoutDemo(),
      _          => const Center(child: Text('?')),
    };

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: accent,
        elevation: 0,
        title: Text(name,
            style: TextStyle(fontWeight: FontWeight.bold, color: accent)),
        iconTheme: IconThemeData(color: accent),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16), child: body),
    );
  }
}

Widget _label(String t) => Padding(
  padding: const EdgeInsets.only(bottom: 8, top: 4),
  child: Text(t,
      style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
          color: _kAccent,
          letterSpacing: 0.8)),
);

// ============================================================
// Demo Display
// ============================================================
class _DisplayDemo extends StatelessWidget {
  const _DisplayDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('CARD'),
        Container(
          decoration: _card(),
          child: const ListTile(
            leading: Icon(Icons.album_rounded, color: _kAccent),
            title: Text('Judul Item',
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('Sub-judul'),
          ),
        ),
        const SizedBox(height: 16),
        _label('CHIP'),
        Wrap(
          spacing: 8,
          children: ['Flutter', 'Dart', 'Mobile']
              .map((s) => Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(20),
              border:
              Border.all(color: _kAccent.withOpacity(0.3)),
            ),
            child: Text(s,
                style: const TextStyle(
                    color: _kAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ))
              .toList(),
        ),
        const SizedBox(height: 16),
        _label('DIVIDER'),
        const Divider(thickness: 1),
        const SizedBox(height: 16),
        _label('CIRCLE AVATAR & ICON'),
        const Row(children: [
          CircleAvatar(
              backgroundColor: Color(0xFFE8EAF6),
              child: Text('A', style: TextStyle(color: _kAccent))),
          SizedBox(width: 12),
          CircleAvatar(
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.check_rounded, color: Color(0xFF2E7D32))),
          SizedBox(width: 12),
          Icon(Icons.star_rounded, color: Color(0xFFF9A825), size: 36),
        ]),
      ],
    );
  }
}

// ============================================================
// Demo Input
// ============================================================
class _InputDemo extends StatefulWidget {
  const _InputDemo();

  @override
  State<_InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<_InputDemo> {
  bool _checked = false;
  bool _switched = true;
  double _slider = 0.5;
  String? _dropdown = 'Apel';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('TEXT FIELD'),
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8F9FF),
            labelText: 'Nama',
            prefixIcon:
            const Icon(Icons.person_outline, color: _kAccent),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _kBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _kBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: _kAccent, width: 2)),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: _card(),
          child: CheckboxListTile(
            title: const Text('Checkbox',
                style: TextStyle(fontWeight: FontWeight.w600)),
            value: _checked,
            activeColor: _kAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            onChanged: (v) => setState(() => _checked = v ?? false),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: _card(),
          child: SwitchListTile(
            title: const Text('Switch',
                style: TextStyle(fontWeight: FontWeight.w600)),
            value: _switched,
            activeColor: _kAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            onChanged: (v) => setState(() => _switched = v),
          ),
        ),
        const SizedBox(height: 12),
        _label('SLIDER'),
        Slider(
          value: _slider,
          activeColor: _kAccent,
          onChanged: (v) => setState(() => _slider = v),
        ),
        _label('DROPDOWN'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: _card(r: 12),
          child: DropdownButton<String>(
            value: _dropdown,
            isExpanded: true,
            underline: const SizedBox(),
            items: ['Apel', 'Jeruk', 'Mangga']
                .map((e) =>
                DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _dropdown = v),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// Demo Button
// ============================================================
class _ButtonDemo extends StatelessWidget {
  const _ButtonDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
            onPressed: () {},
            child: const Text('Elevated Button')),
        const SizedBox(height: 8),
        FilledButton(
            onPressed: () {}, child: const Text('Filled Button')),
        const SizedBox(height: 8),
        OutlinedButton(
            onPressed: () {},
            child: const Text('Outlined Button')),
        const SizedBox(height: 8),
        TextButton(
            onPressed: () {}, child: const Text('Text Button')),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.send_rounded),
          label: const Text('Dengan Icon'),
        ),
        const SizedBox(height: 8),
        Center(
          child: IconButton.filled(
            onPressed: () {},
            icon: const Icon(Icons.favorite_rounded),
            style: IconButton.styleFrom(backgroundColor: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// Demo Feedback
// ============================================================
class _FeedbackDemo extends StatelessWidget {
  const _FeedbackDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Halo dari SnackBar!'),
              backgroundColor: _kAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ));
          },
          icon: const Icon(Icons.notifications_rounded),
          label: const Text('Tampilkan SnackBar'),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: const Text('Konfirmasi',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                content: const Text('Yakin ingin lanjut?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ya'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.chat_bubble_rounded),
          label: const Text('Tampilkan Dialog'),
        ),
        const SizedBox(height: 20),
        _label('PROGRESS INDICATOR'),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: const LinearProgressIndicator(value: 0.6, minHeight: 7),
        ),
        const SizedBox(height: 20),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

// ============================================================
// Demo Layout
// ============================================================
class _LayoutDemo extends StatelessWidget {
  const _LayoutDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('STACK — widget bertumpuk'),
        SizedBox(
          height: 110,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xFFE8EAF6),
                    borderRadius: BorderRadius.circular(12)),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color: _kAccent,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const Positioned(
                bottom: 12,
                right: 12,
                child: Icon(Icons.star_rounded,
                    size: 38, color: Color(0xFFF9A825)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _label('WRAP — auto-pindah baris'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            8,
                (i) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAF6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Item ${i + 1}',
                  style: const TextStyle(
                      color: _kAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _label('GRID VIEW (3 kolom)'),
        SizedBox(
          height: 200,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(
              6,
                  (i) => Container(
                decoration: BoxDecoration(
                  color: _kAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text('${i + 1}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}