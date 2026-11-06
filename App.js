import React, { useState } from 'react';
import { 
 View, Text, FlatList, 
 TouchableOpacity, 
 StyleSheet, SafeAreaView 
} from 'react-native';

const ENGINES = [
 { id:'1', name:'Perkins 1104', 
  type:'ديزل - 4 بستم', 
  power:'100 HP', 
  price:'2,500,000 SDG' },
 { id:'2', name:'Cummins 6BT', 
  type:'ديزل - 6 بستم', 
  power:'180 HP', 
  price:'4,800,000 SDG' },
 { id:'3', name:'Yanmar TF120', 
  type:'ديزل - 1 بستم', 
  power:'12 HP', 
  price:'950,000 SDG' },
];

export default function App(){
 const [sel,setSel]=useState(null);
 
 if(sel){
  return(
   <SafeAreaView style={s.container}>
    <TouchableOpacity 
     onPress={()=>setSel(null)}
     style={s.back}>
     <Text style={s.backText}>← رجوع</Text>
    </TouchableOpacity>
    <Text style={s.title}>{sel.name}</Text>
    <Text>{sel.type}</Text>
    <Text>القدرة: {sel.power}</Text>
    <Text style={s.price}>{sel.price}</Text>
    
    <View style={s.box3d}>
     <Text style={s.boxText}>
      هنا حتظهر المكنة 3D
      لف بصباعك وتكبير
     </Text>
     <Text style={{fontSize:50}}>⚙️</Text>
    </View>
    
    <TouchableOpacity style={s.btn}>
     <Text style={s.btnText}>تشغيل المكنة</Text>
    </TouchableOpacity>
   </SafeAreaView>
  );
 }

 return(
  <SafeAreaView style={s.container}>
   <Text style={s.header}>
    سوق المكنات - السودان
   </Text>
   <FlatList
    data={ENGINES}
    keyExtractor={i=>i.id}
    renderItem={({item})=>(
     <TouchableOpacity 
      style={s.card}
      onPress={()=>setSel(item)}>
      <Text style={s.cardT}>⚙️ {item.name}</Text>
      <Text>{item.type}</Text>
      <Text>القدرة: {item.power}</Text>
      <Text style={s.price}>{item.price}</Text>
      <Text style={s.view}>عرض 3D ←</Text>
     </TouchableOpacity>
    )}
   />
  </SafeAreaView>
 );
}

const s = StyleSheet.create({
 container:{flex:1,padding:16,backgroundColor:'#fff'},
 header:{fontSize:22,fontWeight:'bold',textAlign:'center',marginBottom:16,color:'#ff6d00'},
 card:{backgroundColor:'#fff3e0',padding:16,borderRadius:12,marginBottom:12},
 cardT:{fontSize:18,fontWeight:'bold'},
 price:{color:'green',fontWeight:'bold',marginTop:4},
 view:{color:'blue',marginTop:6,fontWeight:'bold'},
 title:{fontSize:24,fontWeight:'bold'},
 back:{padding:8,marginBottom:8},
 backText:{color:'blue',fontWeight:'bold',fontSize:16},
 box3d:{flex:1,backgroundColor:'#eee',borderRadius:12,justifyContent:'center',alignItems:'center',marginTop:12},
 boxText:{textAlign:'center',fontSize:16},
 btn:{backgroundColor:'#2e7d32',padding:16,borderRadius:12,alignItems:'center',marginTop:12},
 btnText:{color:'#fff',fontWeight:'bold'}
});