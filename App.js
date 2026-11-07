
 import React, { useState } from 'react';
import { View, Text, FlatList, TouchableOpacity, TextInput, Modal, StyleSheet, Alert } from 'react-native';

export default function App() {
  const [engines, setEngines] = useState([
    { id: '1', name: 'MWM TCG 2020', hours: '12,540h', status: 'Running', location: 'أمدرمان', color: '#4CAF50' },
    { id: '2', name: 'Caterpillar 3516', hours: '8,210h', status: 'Maintenance', location: 'أمدرمان', color: '#FF9800' },
    { id: '3', name: 'Toyota V8 1VD', hours: '0h', status: 'Running', location: 'أمدرمان', color: '#2196F3' },
  ]);

  const [modal, setModal] = useState(false);
  const [name, setName] = useState('');
  const [hours, setHours] = useState('');

  const addEngine = () => {
    if (!name) return Alert.alert('اكتب اسم المكنة');
    setEngines([...engines, { id: Date.now().toString(), name, hours: hours || '0h', status: 'Running', location: 'أمدرمان', color: '#4CAF50' }]);
    setName(''); setHours(''); setModal(false);
  };

  const deleteEngine = (id) => {
    setEngines(engines.filter(e => e.id !== id));
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Engine Management - Omdur...</Text>
      <FlatList
        data={engines}
        keyExtractor={item => item.id}
        renderItem={({ item }) => (
          <View style={styles.card}>
            <Text style={{ fontSize: 28 }}>⚙️</Text>
            <View style={{ flex: 1, marginLeft: 12 }}>
              <Text style={styles.name}>{item.name} - {item.hours}</Text>
              <Text style={styles.sub}>{item.status} - {item.location}</Text>
            </View>
            <TouchableOpacity onPress={() => deleteEngine(item.id)}>
              <Text style={{ fontSize: 20 }}>🗑️</Text>
            </TouchableOpacity>
            <Text style={{ fontSize: 18 }}> › </Text>
          </View>
        )}
      />
      <TouchableOpacity style={styles.fab} onPress={() => setModal(true)}>
        <Text style={{ fontSize: 28 }}>+</Text>
      </TouchableOpacity>

      <Modal visible={modal} transparent animationType="slide">
        <View style={styles.modalBg}>
          <View style={styles.modal}>
            <Text style={{ fontSize: 18, fontWeight: 'bold', marginBottom: 12 }}>إضافة مكنة جديدة</Text>
            <TextInput placeholder="اسم المكنة - مثلا Toyota V8" value={name} onChangeText={setName} style={styles.input} />
            <TextInput placeholder="عدد الساعات - مثلا 5000h" value={hours} onChangeText={setHours} style={styles.input} />
            <TouchableOpacity style={styles.btn} onPress={addEngine}><Text style={{ color: 'white', fontWeight: 'bold' }}>إضافة</Text></TouchableOpacity>
            <TouchableOpacity onPress={() => setModal(false)}><Text style={{ marginTop: 12, color: 'red' }}>إلغاء</Text></TouchableOpacity>
          </View>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff', padding: 12, paddingTop: 40 },
  title: { fontSize: 24, fontWeight: 'bold', marginBottom: 16 },
  card: { flexDirection: 'row', alignItems: 'center', backgroundColor: '#F5F5F5', padding: 14, borderRadius: 12, marginBottom: 10 },
  name: { fontSize: 18, fontWeight: '600' },
  sub: { fontSize: 14, color: '#555', marginTop: 2 },
  fab: { position: 'absolute', bottom: 30, right: 20, backgroundColor: '#E8D5FF', width: 60, height: 60, borderRadius: 18, alignItems: 'center', justifyContent: 'center' },
  modalBg: { flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 20 },
  modal: { backgroundColor: 'white', padding: 20, borderRadius: 16, alignItems: 'center' },
  input: { borderWidth: 1, borderColor: '#ddd', width: '100%', padding: 12, borderRadius: 8, marginBottom: 10 },
  btn: { backgroundColor: '#6200EE', padding: 12, borderRadius: 8, width: '100%', alignItems: 'center' },
});