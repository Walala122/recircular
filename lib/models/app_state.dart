import 'package:flutter/foundation.dart';

class Contact {
  final String nombre;
  final String? persona;
  final String? email;
  final String rel;
  final String tipo; // 'cliente' | 'proveedor'
  final int color;
  final String initial;

  const Contact({
    required this.nombre,
    this.persona,
    this.email,
    required this.rel,
    required this.tipo,
    required this.color,
    required this.initial,
  });
}

class Venta {
  final String icon;
  final String nombre;
  final int? monto;
  final String tipo; // 'venta' | 'compra'
  final String estado; // 'done' | 'pending' | 'transit'
  final String fecha;
  final int? peso;

  const Venta({
    required this.icon,
    required this.nombre,
    this.monto,
    required this.tipo,
    required this.estado,
    required this.fecha,
    this.peso,
  });
}

class Post {
  final int id;
  final String name;
  final String contact;
  final String type;
  final bool verified;
  final int color;
  final String initial;
  final String desc;
  final String mode; // 'ofrece' | 'busca'
  final bool hasCatalog;
  final List<String> items;
  final List<String> itemEmojis;
  final List<int> itemColors;

  const Post({
    required this.id,
    required this.name,
    required this.contact,
    required this.type,
    required this.verified,
    required this.color,
    required this.initial,
    required this.desc,
    required this.mode,
    required this.hasCatalog,
    required this.items,
    required this.itemEmojis,
    required this.itemColors,
  });
}

class AppState extends ChangeNotifier {
  String? userType; // 'empresa' | 'pyme'
  String contactTab = 'todos';
  String ventaTab = 'ventas';

  List<Contact> contacts = [
    const Contact(nombre: 'Cafetería KEI', persona: 'María González', email: 'maria@kei.cl', rel: 'Cliente PYME', tipo: 'cliente', color: 0xFF8A5A2A, initial: 'K'),
    const Contact(nombre: 'EcoFlex SpA', persona: 'Jorge Molina', email: 'jorge@ecoflex.cl', rel: 'Proveedor de residuos', tipo: 'proveedor', color: 0xFF3A6A8A, initial: 'E'),
    const Contact(nombre: 'Katankura', persona: 'Ana Torres', email: 'ana@katankura.cl', rel: 'Comprador de residuos', tipo: 'cliente', color: 0xFF5A7A4A, initial: 'K'),
  ];

  Map<String, List<Venta>> ventas = {
    'empresa': [
      const Venta(icon: '♻️', nombre: 'Cartones 12kg → Cafetería KEI', monto: 24000, tipo: 'venta', estado: 'done', fecha: '28/05', peso: 12000),
      const Venta(icon: '🌱', nombre: 'Fertilizante 20L → Sol&Luna', monto: 38000, tipo: 'venta', estado: 'transit', fecha: '31/05', peso: 20000),
      const Venta(icon: '🥤', nombre: 'Vasos x500 → Corp. XY', monto: 91000, tipo: 'venta', estado: 'done', fecha: '15/05', peso: 3500),
    ],
    'pyme': [
      const Venta(icon: '☕', nombre: 'Borra café 5kg → Katankura', monto: 8500, tipo: 'venta', estado: 'done', fecha: '30/05', peso: 5000),
      const Venta(icon: '♻️', nombre: 'Compra plástico ← EcoFlex', monto: 15000, tipo: 'compra', estado: 'pending', fecha: '01/06', peso: 8000),
      const Venta(icon: '👕', nombre: 'Merch eco x30 ← Katankura', monto: 42000, tipo: 'compra', estado: 'done', fecha: '22/05', peso: 2500),
    ],
  };

  final List<Post> posts = [
    const Post(id: 1, name: 'BIO ARTE', contact: 'Sofía Rodríguez', type: 'empresa', verified: true, color: 0xFF5A7A4A, initial: 'B', desc: 'Empresa de economía circular especializada en reciclaje de materiales orgánicos y plásticos post-consumo. Certificada por entidades ambientales.', mode: 'ofrece', hasCatalog: true, items: ['Vasos de cartón', 'Fertilizantes', 'Merch eco'], itemEmojis: ['🥤', '🌱', '👕'], itemColors: [0xFFC8D8B8, 0xFFB8D8B0, 0xFFD8C8A8]),
    const Post(id: 2, name: 'ANDESITA', contact: 'Felipe Vidal', type: 'empresa', verified: true, color: 0xFF3A6A8A, initial: 'A', desc: 'Procesamos residuos industriales y los transformamos en nuevos insumos para la cadena productiva. Trabajamos con PYMEs de toda la región.', mode: 'busca', hasCatalog: false, items: ['Plásticos', 'Cartones', 'Vidrio'], itemEmojis: ['🧴', '📦', '🍾'], itemColors: [0xFFB8D4E8, 0xFFD8C8A8, 0xFFC8E8D8]),
    const Post(id: 3, name: 'CAFETERÍA KEI', contact: 'María González', type: 'pyme', verified: true, color: 0xFF8A5A2A, initial: 'K', desc: 'Cafetería con enfoque sustentable. Ofrecemos nuestros residuos para que otros los aprovechen en la cadena circular.', mode: 'ofrece', hasCatalog: false, items: ['Borra de café', 'Tetrapack', 'Plásticos'], itemEmojis: ['☕', '📦', '♻️'], itemColors: [0xFFC8A870, 0xFFE8D8A8, 0xFFB8D8C8]),
    const Post(id: 4, name: 'SOL & LUNA', contact: 'Carolina Paz', type: 'pyme', verified: false, color: 0xFF4A8A5A, initial: 'S', desc: 'PYME de productos naturales. Buscamos proveedores de materia prima reciclada para nuestros procesos productivos.', mode: 'busca', hasCatalog: false, items: ['Plásticos', 'Cartones'], itemEmojis: ['🧴', '📦'], itemColors: [0xFFB8D4E8, 0xFFD8C8A8]),
  ];

  void addContact(Contact c) {
    contacts = [...contacts, c];
    notifyListeners();
  }

  void addVenta(Venta v, String type) {
    final list = List<Venta>.from(ventas[type] ?? [])..insert(0, v);
    ventas = {...ventas, type: list};
    notifyListeners();
  }

  void setUserType(String t) {
    userType = t;
    notifyListeners();
  }
}
