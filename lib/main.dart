import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const EngineApp());

class Engine {
  final String name; final String hours; final String status; final String location; final Color color;
  Engine(this.name, this.hours, this.status, this.location, this.color);
  Map<String, dynamic> toJson() => {'name': name, 'hours': hours, 'status': status, 'location': location, 'color': color.value};
  factory Engine.fromJson(Map<String, dynamic> j) => Engine(j['name'], j['hours'], j['status'], j['location'], Color(j['color']));
}

class EngineApp extends StatelessWidget {
  const EngineApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'Engine Management', theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true), home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Engine> engines = [];
  @override void initState() { super.initState(); _loadEngines(); }
  Future<void> _loadEngines() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('engines');
    if (data != null) {
      final List list = jsonDecode(data);
      setState(() => engines = list.map((e) => Engine.fromJson(e)).toList());
    } else {
      setState(() { engines = [Engine('MWM TCG 2020', '12,540h', 'Running', 'أمدرمان', Colors.green), Engine('Caterpillar 3516', '8,210h', 'Maintenance', 'أمدرمان', Colors.orange), Engine('Cummins KTA50', '15,300h', 'Standby', 'الخرطوم', Colors.blue)]; });
    }
  }
  Future<void> _saveEngines() async { final p = await SharedPreferences.getInstance(); await p.setString('engines', jsonEncode(engines.map((e) => e.toJson()).toList())); }
  void _addEngine() {
    String name=''; String hours='';
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('إضافة مكنة جديدة'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(decoration: const InputDecoration(labelText: 'اسم المكنة'), onChanged: (v)=>name=v), TextField(decoration: const InputDecoration(labelText: 'عدد الساعات'), onChanged: (v)=>hours=v)]),
      actions: [TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('إلغاء')), ElevatedButton(onPressed: () async { if(name.isNotEmpty){ setState(()=>engines.add(Engine(name, hours.isEmpty?'0h':hours, 'Running', 'أمدرمان', Colors.green))); await _saveEngines(); } Navigator.pop(ctx); }, child: const Text('إضافة'))],
    ));
  }
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Engine Management - Omdurman'), centerTitle: true),
      body: ListView.builder(itemCount: engines.length, itemBuilder: (context,i){
        final e=engines[i];
        return Card(margin: const EdgeInsets.symmetric(horizontal:12, vertical:6), child: ListTile(
          leading: Icon(Icons.settings, size:40, color:e.color), title: Text('${e.name} - ${e.hours}'), subtitle: Text('${e.status} - ${e.location}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(icon: const Icon(Icons.delete, color:Colors.red, size:20), onPressed: () async { setState(()=>engines.removeAt(i)); await _saveEngines(); }), const Icon(Icons.arrow_forward_ios, size:16)]),
          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>Engine3DPage(engine:e))),
        ));
      }),
      floatingActionButton: FloatingActionButton(onPressed: _addEngine, child: const Icon(Icons.add)),
    );
  }
}

// ===== صفحة المكنة 3D =====
class EnginePart {
  final String name; final String desc; final String temp; final String status; final Color color; final double x; final double y;
  EnginePart(this.name, this.desc, this.temp, this.status, this.color, this.x, this.y);
}

class Engine3DPage extends StatefulWidget {
  final Engine engine; const Engine3DPage({super.key, required this.engine});
  @override State<Engine3DPage> createState() => _Engine3DPageState();
}

class _Engine3DPageState extends State<Engine3DPage> with SingleTickerProviderStateMixin {
  bool isRunning = false;
  int rpm = 0;
  EnginePart? selected;
  late AnimationController _ctrl;

  List<EnginePart> parts = [
    EnginePart('التيربو', 'شاحن توربيني - يزيد قوة المكنة', '180°C', 'ممتاز', Colors.orange, 0.72, 0.18),
    EnginePart('البستم', '6 بساتم - حركة ترددية', '95°C', 'جيد', Colors.blue, 0.45, 0.38),
    EnginePart('فلتر الزيت', 'فلتر زيت - آخر تغيير قبل 120 ساعة', '65°C', 'يحتاج تغيير قريب', Colors.red, 0.15, 0.55),
    EnginePart('الراديتر', 'تبريد المياه - مستوى المياه 90%', '80°C', 'ممتاز', Colors.teal, 0.75, 0.60),
    EnginePart('البطارية', 'بطارية 24V - شحن 98%', '30°C', 'ممتاز', Colors.green, 0.18, 0.20),
    EnginePart('مضخة الوقود', 'مضخة ديزل - ضغط 4.2 بار', '45°C', 'جيد', Colors.purple, 0.45, 0.70),
  ];

  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(); }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  void _toggle() { setState(() { isRunning = !isRunning; rpm = isRunning ? 1500 : 0; }); }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.engine.name} - 3D')),
      body: Column(children: [
        // عداد RPM + زر تشغيل
        Container(padding: const EdgeInsets.all(12), color: isRunning ? Colors.green.shade50 : Colors.grey.shade100, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(isRunning ? '● شغالة' : '○ واقفة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isRunning ? Colors.green : Colors.grey)), Text('RPM: $rpm  |  ${widget.engine.hours}', style: const TextStyle(fontSize: 16))]),
          ElevatedButton.icon(onPressed: _toggle, icon: Icon(isRunning ? Icons.stop : Icons.play_arrow), label: Text(isRunning ? 'إيقاف' : 'تشغيل'), style: ElevatedButton.styleFrom(backgroundColor: isRunning ? Colors.red : Colors.green, foregroundColor: Colors.white)),
        ])),
        // المكنة 3D التفاعلية
        Expanded(child: AnimatedBuilder(animation: _ctrl, builder: (ctx, _) {
          double shake = isRunning ? math.sin(_ctrl.value * math.pi * 4) * 2 : 0;
          return Stack(children: [
            // جسم المكنة
            Positioned(left: 40 + shake, top: 40, right: 40, bottom: 20, child: Container(decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))]), child: Stack(children: [
              // تروس بتدور لما تشتغل
              Positioned(left: 110, top: 30, child: AnimatedBuilder(animation: _ctrl, builder: (_,__) => Transform.rotate(angle: isRunning ? _ctrl.value * math.pi * 2 : 0, child: Icon(Icons.settings, size: 90, color: isRunning ? Colors.blue : Colors.grey)))),
              Positioned(left: 190, top: 90, child: AnimatedBuilder(animation: _ctrl, builder: (_,__) => Transform.rotate(angle: isRunning ? -_ctrl.value * math.pi * 2 : 0, child: Icon(Icons.settings, size: 70, color: isRunning ? Colors.orange : Colors.grey)))),
              const Center(child: Text('ENGINE\nV8 DIESEL', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black54))),
            ]))),
            // أجزاء قابلة للمس
            ...parts.map((p) => Positioned(left: MediaQuery.of(context).size.width * p.x - 25, top: 180 * p.y + 60, child: GestureDetector(onTap: ()=>setState(()=>selected=p), child: Container(width: 50, height: 50, decoration: BoxDecoration(color: selected==p ? Colors.yellow : p.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3), boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 6)]), child: Icon(Icons.circle, color: Colors.white, size: 18))))),
          ]);
        })),
        // قائمة الجزء المختار
        if (selected != null) Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)], borderRadius: const BorderRadius.vertical(top: Radius.circular(20))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [CircleAvatar(backgroundColor: selected!.color, radius: 18), const SizedBox(width: 10), Text(selected!.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const Spacer(), IconButton(icon: const Icon(Icons.close), onPressed: ()=>setState(()=>selected=null))]),
          const SizedBox(height: 8), Text(selected!.desc, style: const TextStyle(fontSize: 16)), Text('الحرارة: ${selected!.temp}  |  الحالة: ${selected!.status}', style: const TextStyle(fontSize: 15, color: Colors.grey)),
          const SizedBox(height: 8), LinearProgressIndicator(value: 0.85, backgroundColor: Colors.grey.shade200, color: selected!.color),
        ])) else Container(padding: const EdgeInsets.all(12), child: const Text('👆 المس أي دائرة ملونة في المكنة عشان تشوف تفاصيل الجزء براهو', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey))),
      ]),
    );
  }
}