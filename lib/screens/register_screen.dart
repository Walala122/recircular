import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../models/app_state.dart';

class RegisterScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onSave;

  const RegisterScreen({super.key, required this.appState, required this.onSave});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? tipo;
  String? ubicacion;
  String? transporte;
  Set<String> serviciosChecked = {};

  List<String> _getServicios() {
    if (tipo == 'empresa') return ['Venta de residuos', 'Buscar productos y proveedores'];
    if (tipo == 'pyme') return ['Buscar materia prima', 'Vender productos', 'Crear catálogo de productos'];
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 28, 15, 20),
          child: Column(
            children: [
              const Center(child: ReCircularLogo(fontSize: 36)),
              const SizedBox(height: 14),

              // Avatar header
              SectionCard(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: const BoxDecoration(color: Color(0xFFB0A898), shape: BoxShape.circle),
                          child: const Icon(Icons.person_outline, size: 28, color: Color(0xFF6A5A4A)),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            width: 16, height: 16,
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                            child: const Icon(Icons.edit, size: 9, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Comienza creando tu perfil en Re-Circular',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMid, height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Nombre / Descripción
              SectionCard(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  children: [
                    UInput(label: 'NOMBRE DEL NEGOCIO', placeholder: 'Solecito SpA'),
                    const SizedBox(height: 12),
                    UInput(label: 'DESCRIPCIÓN DEL NEGOCIO', placeholder: '¿A qué te dedicas?'),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Tipo negocio
              SectionCard(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tipo de negocio', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        CustomRadio(checked: tipo == 'empresa', label: 'Empresa', onTap: () { setState(() { tipo = 'empresa'; widget.appState.setUserType('empresa'); serviciosChecked = {}; }); }),
                        const SizedBox(width: 28),
                        CustomRadio(checked: tipo == 'pyme', label: 'Pyme', onTap: () { setState(() { tipo = 'pyme'; widget.appState.setUserType('pyme'); serviciosChecked = {}; }); }),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Servicios
              if (tipo != null) ...[
                SectionCard(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Servicios a ocupar:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12, runSpacing: 10,
                        children: _getServicios().map((s) => CustomCheck(
                          checked: serviciosChecked.contains(s),
                          label: s,
                          onTap: () => setState(() {
                            if (serviciosChecked.contains(s)) serviciosChecked.remove(s);
                            else serviciosChecked.add(s);
                          }),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Ubicación (green card)
              GreenCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A6B3F), size: 18),
                        SizedBox(width: 6),
                        Text('Ubicación comercial', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF3A5A2A))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('¿Cuenta con ubicación física?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF5A5A4A))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CustomRadio(checked: ubicacion == 'si', label: 'Sí', onTap: () => setState(() => ubicacion = 'si')),
                        const SizedBox(width: 24),
                        CustomRadio(checked: ubicacion == 'no', label: 'No', onTap: () => setState(() => ubicacion = 'no')),
                      ],
                    ),
                    if (ubicacion == 'si') ...[
                      const SizedBox(height: 10),
                      UInput(label: 'DIRECCIÓN', placeholder: 'Calle 1234', greenStyle: true),
                    ],
                    if (ubicacion == 'no') ...[
                      const SizedBox(height: 10),
                      const Text('¿Requiere algún servicio de transporte?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF5A5A4A))),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CustomRadio(checked: transporte == 'si', label: 'Sí', onTap: () => setState(() => transporte = 'si')),
                          const SizedBox(width: 24),
                          CustomRadio(checked: transporte == 'no', label: 'No', onTap: () => setState(() => transporte = 'no')),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Datos contacto (green card)
              GreenCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A6B3F), size: 18),
                        SizedBox(width: 6),
                        Text('Datos de Contacto', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF3A5A2A))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    UInput(label: 'NOMBRE DEL CONTACTO DIRECTO', placeholder: 'Nombre y Apellidos', greenStyle: true),
                    const SizedBox(height: 11),
                    UInput(
                      label: 'NÚMERO DE TELÉFONO',
                      greenStyle: true,
                      keyboardType: TextInputType.phone,
                      prefix: const Text('+56', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4A5A3A))),
                    ),
                    const SizedBox(height: 11),
                    UInput(
                      label: 'NÚMERO DE TELÉFONO FIJO',
                      greenStyle: true,
                      keyboardType: TextInputType.phone,
                      prefix: const Text('+56 72 2', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4A5A3A))),
                    ),
                    const SizedBox(height: 11),
                    UInput(label: 'CORREO ELECTRÓNICO', placeholder: 'correo@algo.com', greenStyle: true, keyboardType: TextInputType.emailAddress),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              PrimaryButton(label: 'Guardar e Ingresar', onTap: widget.onSave),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
