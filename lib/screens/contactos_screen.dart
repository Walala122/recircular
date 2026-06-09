import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../models/app_state.dart';

class ContactosScreen extends StatefulWidget {
  final AppState appState;
  const ContactosScreen({super.key, required this.appState});

  @override
  State<ContactosScreen> createState() => _ContactosScreenState();
}

class _ContactosScreenState extends State<ContactosScreen> {
  String tab = 'todos';

  List<Contact> get filtered {
    if (tab == 'clientes') return widget.appState.contacts.where((c) => c.tipo == 'cliente').toList();
    if (tab == 'proveedores') return widget.appState.contacts.where((c) => c.tipo == 'proveedor').toList();
    return widget.appState.contacts;
  }

  @override
  Widget build(BuildContext context) {
    final all = widget.appState.contacts;
    final totalC = all.where((c) => c.tipo == 'cliente').length;
    final totalP = all.where((c) => c.tipo == 'proveedor').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.background,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 14, right: 14, bottom: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ReCircularLogo(fontSize: 26),
                    GestureDetector(
                      onTap: () => _showAddModal(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          children: [
                            Text('+ ', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w800)),
                            Text('Agregar', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: AppColors.surfaceBorder), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      _CTab(label: 'Todos', active: tab == 'todos', onTap: () => setState(() => tab = 'todos')),
                      _CTab(label: 'Clientes', active: tab == 'clientes', onTap: () => setState(() => tab = 'clientes')),
                      _CTab(label: 'Proveedores', active: tab == 'proveedores', onTap: () => setState(() => tab = 'proveedores')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFD0C8BC)),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Column(
                children: [
                  // Stats strip
                  Row(
                    children: [
                      _StripStat(label: 'Red circular', value: '${all.length}'),
                      const SizedBox(width: 8),
                      _StripStat(label: 'Clientes', value: '$totalC'),
                      const SizedBox(width: 8),
                      _StripStat(label: 'Proveedores', value: '$totalP'),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (filtered.isEmpty)
                    SectionCard(
                      padding: const EdgeInsets.all(30),
                      child: const Column(
                        children: [
                          Text('📋', style: TextStyle(fontSize: 32)),
                          SizedBox(height: 8),
                          Text('Sin contactos en esta categoría', style: TextStyle(fontSize: 13, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text('Usa el botón + para agregar', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  else
                    ...filtered.map((c) => _ContactCard(contact: c, context: context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddModal(BuildContext context) {
    final nombreCtrl = TextEditingController();
    final personaCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String rel = 'Proveedor de residuos';
    String tipo = 'proveedor';

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
                const Row(children: [Text('👤 ', style: TextStyle(fontSize: 16)), Text('Registrar contacto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary))]),
                const SizedBox(height: 3),
                const Text('Agregar a tu red circular', style: TextStyle(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                const SizedBox(height: 18),
                UInput(label: 'EMPRESA', placeholder: 'Nombre del negocio', controller: nombreCtrl),
                const SizedBox(height: 13),
                UInput(label: 'PERSONA DE CONTACTO', placeholder: 'Nombre y apellido', controller: personaCtrl),
                const SizedBox(height: 13),
                UInput(label: 'CORREO ELECTRÓNICO', placeholder: 'correo@empresa.cl', controller: emailCtrl, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 13),
                const Text('TIPO DE RELACIÓN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textLight, letterSpacing: 0.7)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: rel,
                  decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9A8A7A), width: 1.5)), isDense: true),
                  style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                  items: const [
                    DropdownMenuItem(value: 'Proveedor de residuos', child: Text('Proveedor de residuos')),
                    DropdownMenuItem(value: 'Comprador de residuos', child: Text('Comprador de residuos')),
                    DropdownMenuItem(value: 'Socio comercial', child: Text('Socio comercial')),
                    DropdownMenuItem(value: 'Cliente PYME', child: Text('Cliente PYME')),
                    DropdownMenuItem(value: 'Proveedor materia prima', child: Text('Proveedor materia prima')),
                  ],
                  onChanged: (v) {
                    if (v != null) setModalState(() {
                      rel = v;
                      tipo = (v == 'Proveedor de residuos' || v == 'Proveedor materia prima') ? 'proveedor' : 'cliente';
                    });
                  },
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
                          if (nombreCtrl.text.isNotEmpty) {
                            final colors = [0xFF8A5A2A, 0xFF3A6A8A, 0xFF5A7A4A, 0xFF7A2E2B, 0xFF4A8A5A];
                            widget.appState.addContact(Contact(
                              nombre: nombreCtrl.text,
                              persona: personaCtrl.text.isEmpty ? null : personaCtrl.text,
                              email: emailCtrl.text.isEmpty ? null : emailCtrl.text,
                              rel: rel,
                              tipo: tipo,
                              color: colors[widget.appState.contacts.length % colors.length],
                              initial: nombreCtrl.text[0].toUpperCase(),
                            ));
                            Navigator.pop(ctx);
                            showToast(context, '✅ Contacto guardado');
                            setState(() {});
                          }
                        },
                        child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text('✓ Guardar contacto', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white))),
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

class _CTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _CTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: active ? AppColors.primary : Colors.white, borderRadius: BorderRadius.circular(9)),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: active ? Colors.white : AppColors.textMid)),
        ),
      ),
    );
  }
}

class _StripStat extends StatelessWidget {
  final String label, value;
  const _StripStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 2),
            Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 0.4)),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final Contact contact;
  final BuildContext context;
  const _ContactCard({required this.contact, required this.context});

  @override
  Widget build(BuildContext ctx) {
    final c = contact;
    final tipoLabel = c.tipo == 'proveedor' ? 'Proveedor' : 'Cliente';
    final tipoBg = c.tipo == 'proveedor' ? const Color(0xFFE8F0FC) : const Color(0xFFE8F4ED);
    final tipoColor = c.tipo == 'proveedor' ? const Color(0xFF3A6A8A) : const Color(0xFF2D7A4F);
    final relIcons = {'Proveedor de residuos': '🏭', 'Comprador de residuos': '🛍️', 'Socio comercial': '🤝', 'Cliente PYME': '🏪', 'Proveedor materia prima': '📦'};
    final icon = relIcons[c.rel] ?? '👤';

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: const Color(0xFFD0C8BC)),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AvatarCircle(initial: c.initial, color: c.color),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(c.nombre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(color: tipoBg, borderRadius: BorderRadius.circular(6)),
                          child: Text(tipoLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: tipoColor)),
                        ),
                      ],
                    ),
                    if (c.persona != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text('👤 ${c.persona}', style: const TextStyle(fontSize: 11, color: AppColors.textMid, fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
              ),
              if (c.email != null)
                GestureDetector(
                  onTap: () => showToast(context, '📧 Copiado: ${c.email}'),
                  child: Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(color: const Color(0xFFD4CEC6), border: Border.all(color: const Color(0xFFC0B8AE)), borderRadius: BorderRadius.circular(7)),
                    child: const Icon(Icons.send, size: 13, color: AppColors.textMid),
                  ),
                ),
            ],
          ),
          if (c.rel.isNotEmpty || c.email != null) ...[
            const SizedBox(height: 9),
            Container(
              padding: const EdgeInsets.only(top: 9),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFCCC5BB)))),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFD8D0C6), borderRadius: BorderRadius.circular(7)),
                    child: Text('$icon ${c.rel}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMid)),
                  ),
                  if (c.email != null) ...[
                    const SizedBox(width: 6),
                    Text(c.email!, style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
