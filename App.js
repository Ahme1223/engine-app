import React, { useState } from 'react';
import { View, Text, FlatList, TouchableOpacity, StyleSheet, SafeAreaView } from 'react-native';
import { WebView } from 'react-native-webview';

const ENGINES = [
  { id: '1', name: 'Perkins 1104', type: 'ديزل - 4 بستم', power: '100 HP', price: '2,500,000 SDG' },
  { id: '2', name: 'Cummins 6BT', type: 'ديزل - 6 بستم', power: '180 HP', price: '4,800,000 SDG' },
  { id: '3', name: 'Yanmar TF120', type: 'ديزل - 1 بستم', power: '12 HP', price: '950,000 SDG' },
  { id: '4', name: 'Deutz F4L912', type: 'ديزل - 4 بستم تبريد هواء', power: '80 HP', price: '3,200,000 SDG' },
];

const MODEL_URL = 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/main/2.0/2CylinderEngine/glTF-Binary/2CylinderEngine.glb';

function getHtml(isRunning) {
  return `
  <html><head><meta name="viewport" content="width=device-width, initial-scale=1">
  <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
  <style>body{margin:0;background:#fff} model-viewer{width:100%;height:100%}</style>
  </head><body>
  <model-viewer src="${MODEL_URL}" alt="Engine 3D" auto-rotate="${isRunning ? '' : 'false'}" camera-controls auto-play></model-viewer>
  </body></html>
  `;
}

export default function App() {
  const [selected, setSelected] = useState(null);
  const [isRunning, setIsRunning] = useState(false);

  if (selected) {
    return (
      <SafeAreaView style={styles.container}>
        <TouchableOpacity onPress={() => setSelected(null)} style={styles.backBtn}>
          <Text style={styles.backText}>← رجوع</Text>
        </TouchableOpacity>
        <Text style={styles.title}>{selected.name}</Text>
        <Text style={styles.sub}>{selected.type} | القدرة: {selected.power}</Text>
        <Text style={styles.price}>السعر: {selected.price}</Text>
        <View style={{ flex: 1, marginTop: 10, borderRadius: 12, overflow: 'hidden' }}>
          <WebView originWhitelist={['*']} source={{ html: getHtml(isRunning) }} style={{ flex: 1 }} />
        </View>
        <TouchableOpacity onPress={() => setIsRunning(!isRunning)} style={[styles.btn, { backgroundColor: isRunning ? '#e53935' : '#2e7d32' }]}>
          <Text style={styles.btnText}>{isRunning ? 'إيقاف المكنة' : 'تشغيل المكنة - تدور'}</Text>
        </TouchableOpacity>
        <Text style={styles.hint}>لف المكنة بصباعك، وكبر وصغر بي صباعين</Text>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.header}>سوق المكنات - السودان</Text>
      <FlatList
        data={ENGINES}
        keyExtractor={item => item.id}
        renderItem={({ item }) => (
          <TouchableOpacity style={styles.card} onPress={() => setSelected(item)}>
            <Text style={styles.cardTitle}>⚙️ {item.name}</Text>
            <Text>{item.type}</Text>
            <Text>القدرة: {item.power}</Text>
            <Text style={styles.price}>{item.price}</Text>
            <Text style={styles.view3d}>عرض 3D ←</Text>
          </TouchableOpacity>
        )}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff', padding: 16 },
  header: { fontSize: 22, fontWeight: 'bold', textAlign: 'center', marginBottom: 16, color: '#ff6d00' },
  card: { backgroundColor: '#fff3e0', padding: 16, borderRadius: 12, marginBottom: 12, elevation: 2 },
  cardTitle: { fontSize: 18, fontWeight: 'bold' },
  price: { color: 'green', fontWeight: 'bold', fontSize: 16, marginTop: 4 },
  view3d: { color: 'blue', marginTop: 6, fontWeight: 'bold' },
  title: { fontSize: 24, fontWeight: 'bold' },
  sub: { fontSize: 16, marginTop: 4 },
  backBtn: { padding: 8, marginBottom: 8 },
  backText: { color: 'blue', fontSize: 16, fontWeight: 'bold' },
  btn: { padding: 16, borderRadius: 12, alignItems: 'center', marginTop: 12 },
  btnText: { color: '#fff', fontWeight: 'bold', fontSize: 16 },
  hint: { textAlign: 'center', marginTop: 8, color: '#666' },
});