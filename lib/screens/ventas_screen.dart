import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../models/app_state.dart';

class VentasScreen extends StatefulWidget {
  final AppState appState;
  const VentasScreen({super.key, required this.appState});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  String ventaTab = 'ventas';

  @override
  Widget build(BuildContext context) {
    final tipo = widget.appState.userType ?? 'pyme';
    final todas = widget.appState.ventas[tipo] ?? [];
    final items = ventaTab == 'ventas' ? todas.where((v) => v.tipo == 'venta').toList() : todas.where((v) => v.tipo == 'compra').toList();

    final totalVentas = todas.where((v) => v.tipo == 'venta').fold(0, (s, v) => s + (v.monto ?? 0));
    final totalCompras = todas.where((v) => v.tipo == 'compra').fold(0, (s, v) => s + (v.monto ?? 0));
    final totalPeso = todas.fold(0, (s, v) => s + (v.peso ?? 0));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 14, right: 14, bottom: 14),
              child: Column(
                children: [
                  const Center(child: ReCircularLogo(fontSize: 30)),
                  const SizedBox(height: 16),

                  // Chart
                  Container(
                    decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.all(14),
                    child: SizedBox(
                      height: 170,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            getDrawingHorizontalLine: (_) => const FlLine(color: Colors.white24, strokeWidth: 1),
                            drawVerticalLine: false,
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: const TextStyle(color: Colors.white70, fontSize: 9)))),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) {
                              final labels = ['2021', '2022', '2023', '2024', '2025'];
                              final i = v.toInt();
                              return i >= 0 && i < labels.length ? Text(labels[i], style: const TextStyle(color: Colors.white70, fontSize: 8)) : const SizedBox();
                            })),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [FlSpot(0, 10), FlSpot(1, 20), FlSpot(2, 25), FlSpot(3, 32), FlSpot(4, 38)],
                              isCurved: false,
                              color: const Color(0xFFA8D4E8),
                              barWidth: 2.5,
                              dotData: FlDotData(getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 4, color: Colors.white, strokeColor: const Color(0xFFA8D4E8), strokeWidth: 1.5)),
                            ),
                          ],
                          minY: 0, maxY: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Stats
                  Row(
                    children: [
                      _StatCard(label: 'Ventas', value: '\$${(totalVentas / 1000).toStringAsFixed(0)}k', color: const Color(0xFFE8F4ED), textColor: const Color(0xFF2D7A4F)),
                      const SizedBox(width: 8),
                      _StatCard(label: 'Compras', value: '\$${(totalCompras / 1000).toStringAsFixed(0)}k', color: const Color(0xFFFFF3CD), textColor: const Color(0xFF8A6A2A)),
                      const SizedBox(width: 8),
                      _StatCard(label: 'Reciclado', value: '${(totalPeso / 1000).toStringAsFixed(1)} kg', color: AppColors.greenCard, textColor: AppColors.greenDark),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.surfaceBorder),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _Tab(label: 'Ventas ↑', active: ventaTab == 'ventas', onTap: () => setState(() => ventaTab = 'ventas')),
                        _Tab(label: 'Compras ↓', active: ventaTab == 'compras', onTap: () => setState(() => ventaTab = 'compras')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Lista
                  ...items.map((v) => _VentaCard(venta: v)),
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: Text('Sin transacciones', style: TextStyle(color: AppColors.textLight, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),

                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _showNuevaVentaModal(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('+ ', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800)),
                          Text('Registrar nueva venta', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNuevaVentaModal(BuildContext context) {
    final prodCtrl = TextEditingController();
    final contraCtrl = TextEditingController();
    final montoCtrl = TextEditingController();
    final pesoCtrl = TextEditingController();
    String estado = 'done';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: const Color(0xFFE0D8D0), borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 18),
                const Row(children: [Text('📋 ', style: TextStyle(fontSize: 16)), Text('Registrar nueva venta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary))]),
                const SizedBox(height: 3),
                const Text('Nueva transacción circular', style: TextStyle(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                const SizedBox(height: 18),
                UInput(label: 'PRODUCTO / RESIDUO', placeholder: 'Ej: Borra de café 5kg', controller: prodCtrl),
                const SizedBox(height: 13),
                UInput(label: 'CONTRAPARTE', placeholder: 'Empresa o PYME', controller: contraCtrl),
                const SizedBox(height: 13),
                UInput(label: 'MONTO (CLP)', placeholder: '0', controller: montoCtrl, keyboardType: TextInputType.number),
                const SizedBox(height: 13),
                UInput(label: '♻️ PESO RECICLADO (GRAMOS)', placeholder: 'Ej: 5000 (= 5kg)', controller: pesoCtrl, keyboardType: TextInputType.number),
                const SizedBox(height: 13),
                const Text('ESTADO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textLight, letterSpacing: 0.7)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: estado,
                  decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9A8A7A), width: 1.5)), isDense: true),
                  style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                  items: const [
                    DropdownMenuItem(value: 'done', child: Text('Completada')),
                    DropdownMenuItem(value: 'pending', child: Text('Pendiente')),
                    DropdownMenuItem(value: 'transit', child: Text('En tránsito')),
                  ],
                  onChanged: (v) { if (v != null) setModalState(() => estado = v); },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF0EBE3), border: Border.all(color: const Color(0xFFD8D0C8)), borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textMid))),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          if (prodCtrl.text.isNotEmpty && contraCtrl.text.isNotEmpty) {
                            final tipo = widget.appState.userType ?? 'pyme';
                            widget.appState.addVenta(
                              Venta(icon: '♻️', nombre: '${prodCtrl.text} → ${contraCtrl.text}', monto: int.tryParse(montoCtrl.text), tipo: 'venta', estado: estado, fecha: '${DateTime.now().day}/${DateTime.now().month}', peso: int.tryParse(pesoCtrl.text)),
                              tipo,
                            );
                            Navigator.pop(ctx);
                            showToast(context, '✅ Venta registrada');
                            setState(() {});
                          }
                        },
                        child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text('✓ Registrar venta', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color, textColor;
  const _StatCard({required this.label, required this.value, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textColor)),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: textColor.withOpacity(0.75), letterSpacing: 0.4)),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: active ? Colors.white : AppColors.textMid)),
        ),
      ),
    );
  }
}

class _VentaCard extends StatelessWidget {
  final Venta venta;
  const _VentaCard({required this.venta});

  @override
  Widget build(BuildContext context) {
    final monto = venta.monto;
    final peso = venta.peso;
    final isVenta = venta.tipo == 'venta';
    final pesoStr = peso == null ? null : (peso >= 1000 ? '${(peso / 1000).toStringAsFixed(2)} kg' : '$peso g');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0xFFD0C8BC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: AppColors.greenCard, borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: Text(venta.icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(venta.nombre, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(venta.fecha, style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    StatusBadge(estado: venta.estado),
                    if (pesoStr != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.greenCard, borderRadius: BorderRadius.circular(5)),
                        child: Text('♻ $pesoStr', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF3A5A2A))),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (monto != null)
            Text(
              '${isVenta ? '+' : '-'}\$${(monto / 1000).toStringAsFixed(1)}k',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isVenta ? const Color(0xFF3A8A4A) : const Color(0xFF8A3A3A)),
            ),
        ],
      ),
    );
  }
}
