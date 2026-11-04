import 'package:flutter/material.dart';
void main() => runApp(const EngineApp());
class EngineApp extends StatelessWidget {
  const EngineApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Engine Management - Omdurman'), centerTitle: true),
        body: ListView(
          children: const [
            ListTile(leading: Icon(Icons.settings, size: 40, color: Colors.green), title: Text('MWM TCG 2020 - 12,540h'), subtitle: Text('Running - أمدرمان')),
            ListTile(leading: Icon(Icons.settings, size: 40, color: Colors.orange), title: Text('Caterpillar 3516 - 8,210h'), subtitle: Text('Maintenance')),
            ListTile(leading: Icon(Icons.settings, size: 40, color: Colors.blue), title: Text('Cummins KTA50 - 15,300h'), subtitle: Text('Standby')),
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.add)),
      ),
    );
  }
}