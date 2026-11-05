import 'package:flutter/material.dart';

void main() => runApp(const EngineApp());

class Engine {
  final String name;
  final String hours;
  final String status;
  final String location;
  final Color color;
  Engine(this.name, this.hours, this.status, this.location, this.color);
}

class EngineApp extends StatelessWidget {
  const EngineApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Engine Management',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Engine> engines = [
    Engine('MWM TCG 2020', '12,540h', 'Running', 'أمدرمان', Colors.green),
    Engine('Caterpillar 3516', '8,210h', 'Maintenance', 'أمدرمان', Colors.orange),
    Engine('Cummins KTA50', '15,300h', 'Standby', 'الخرطوم', Colors.blue),
  ];

  void _addEngine() {
    String name = '';
    String hours = '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة مكنة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'اسم المكنة'), onChanged: (v) => name = v),
            TextField(decoration: const InputDecoration(labelText: 'عدد الساعات - مثال: 5000h'), onChanged: (v) => hours = v),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (name.isNotEmpty) {
                setState(() => engines.add(Engine(name, hours.isEmpty ? '0h' : hours, 'Running', 'أمدرمان', Colors.green)));
              }
              Navigator.pop(ctx);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Engine Management - Omdurman'), centerTitle: true),
      body: ListView.builder(
        itemCount: engines.length,
        itemBuilder: (context, i) {
          final e = engines[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(Icons.settings, size: 40, color: e.color),
              title: Text('${e.name} - ${e.hours}'),
              subtitle: Text('${e.status} - ${e.location}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(engine: e)));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEngine,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Engine engine;
  const DetailPage({super.key, required this.engine});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(engine.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.settings, size: 80, color: engine.color),
            const SizedBox(height: 20),
            Text('المكنة: ${engine.name}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('الساعات: ${engine.hours}', style: const TextStyle(fontSize: 18)),
            Text('الحالة: ${engine.status}', style: const TextStyle(fontSize: 18)),
            Text('الموقع: ${engine.location}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            const Text('التفاصيل الكاملة هنا - الصيانة، الزيت، الوقود، التنبيهات', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}