import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LatihanHome(),
  ));
}

// ─── Navigator utama ──────────────────────────────────────────────
class LatihanHome extends StatefulWidget {
  const LatihanHome({super.key});
  @override
  State<LatihanHome> createState() => _LatihanHomeState();
}

class _LatihanHomeState extends State<LatihanHome> {
  int _index = 0;

  final _pages = const [
    Latihan1(),
    Latihan2(),
    Latihan3(),
    Latihan4(),
  ];

  final _labels = ['Text', 'Container', 'Row & Col', 'Icon'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latihan ${_index + 1} — ${_labels[_index]}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'Text'),
          BottomNavigationBarItem(icon: Icon(Icons.crop_square), label: 'Container'),
          BottomNavigationBarItem(icon: Icon(Icons.view_column), label: 'Row & Col'),
          BottomNavigationBarItem(icon: Icon(Icons.interests), label: 'Icon'),
        ],
      ),
    );
  }
}

// ─── Latihan 1: Text & Styling ────────────────────────────────────
class Latihan1 extends StatelessWidget {
  const Latihan1({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hello Flutter!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ini teks biasa dengan ukuran kecil',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ─── Latihan 2: Container & Decoration ───────────────────────────
class Latihan2 extends StatelessWidget {
  const Latihan2({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Box',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}

// ─── Latihan 3: Row & Column ──────────────────────────────────────
class Latihan3 extends StatelessWidget {
  const Latihan3({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // coba: start, center, end, spaceBetween, spaceAround
            children: [
              Container(width: 60, height: 60, color: Colors.blue,
                  child: const Center(child: Text('A', style: TextStyle(color: Colors.white)))),
              Container(width: 60, height: 60, color: Colors.green,
                  child: const Center(child: Text('B', style: TextStyle(color: Colors.white)))),
              Container(width: 60, height: 60, color: Colors.red,
                  child: const Center(child: Text('C', style: TextStyle(color: Colors.white)))),
            ],
          ),
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // coba: center, end, stretch
            children: [
              Container(height: 40, width: 120, color: Colors.purple,
                  child: const Center(child: Text('Item 1', style: TextStyle(color: Colors.white)))),
              const SizedBox(height: 8),
              Container(height: 40, width: 180, color: Colors.orange,
                  child: const Center(child: Text('Item 2', style: TextStyle(color: Colors.white)))),
              const SizedBox(height: 8),
              Container(height: 40, width: 80, color: Colors.teal,
                  child: const Center(child: Text('Item 3', style: TextStyle(color: Colors.white)))),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Latihan 4: Icon & Bottom Bar ────────────────────────────────
class Latihan4 extends StatelessWidget {
  const Latihan4({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, size: 32, color: Colors.blue),         // coba: Colors.red
              SizedBox(width: 16),
              Icon(Icons.receipt_long, size: 32, color: Colors.green),  // coba ganti ikon
              SizedBox(width: 16),
              Icon(Icons.person, size: 32, color: Colors.purple),      // coba ganti ikon
              SizedBox(width: 16),
              Icon(Icons.settings, size: 32, color: Colors.grey),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Coba ganti ikon dari fonts.google.com/icons',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}