import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

void main() {
  runApp(const MyApp());
}

class Engine {
  final String name;
  final String type;
  final String power;
  final String price;
  Engine({required this.name, required this.type, required this.power, required this.price});
}

final List<Engine> engines = [
  Engine(name: 'Perkins 1104', type: 'ديزل - 4 بستم', power: '100 HP', price: '2,500,000 SDG'),
  Engine(name: 'Cummins 6BT', type: 'ديزل - 6 بستم', power: '180 HP', price: '4,800,000 SDG'),
  Engine(name: 'Yanmar TF120', type: 'ديزل - 1 بستم', power: '12 HP', price: '950,000 SDG'),
  Engine(name: 'Deutz F4L912', type: 'ديزل - 4 بستم تبريد هواء', power: '80 HP', price: '3,200,000 SDG'),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'سوق المكنات',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سوق المكنات - السودان'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: engines.length,
        itemBuilder: (context, index) {
          final e = engines[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.settings, size: 40, color: Colors.orange),
              title: Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text('${e.type}\nالقدرة: ${e.power}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(e.price, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('عرض 3D', style: TextStyle(color: Colors.blue)),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Engine3DPage(engine: e)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class Engine3DPage extends StatefulWidget {
  final Engine engine;
  const Engine3DPage({super.key, required this.engine});
  @override
  State<Engine3DPage> createState() => _Engine3DPageState();
}

class _Engine3DPageState extends State<Engine3DPage> {
  bool isRunning = false;
  double speed = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.engine.name} - 3D حقيقي'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.orange.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.engine.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text('${widget.engine.type} | القدرة: ${widget.engine.power}'),
                Text('السعر: ${widget.engine.price}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: ModelViewer(
              src: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/main/2.0/2CylinderEngine/glTF-Binary/2CylinderEngine.glb',
              alt: 'مكنة 3D',
              ar: false,
              autoRotate: isRunning,
              cameraControls: true,
              autoPlay: true,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => setState(() => isRunning = !isRunning),
                      icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                      label: Text(isRunning ? 'إيقاف المكنة' : 'تشغيل المكنة'),
                      style: ElevatedButton.styleFrom(backgroundColor: isRunning ? Colors.red : Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('سرعة الدوران: '),
                    Expanded(
                      child: Slider(
                        value: speed,
                        min: 0.5,
                        max: 3.0,
                        onChanged: (v) => setState(() => speed = v),
                      ),
                    ),
                    Text('${speed.toStringAsFixed(1)}x'),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('لف المكنة بصباعك يمين وشمال، وكبر وصغر بي صباعين', textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}