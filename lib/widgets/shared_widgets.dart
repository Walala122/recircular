import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ── Logo ──────────────────────────────────────
class ReCircularLogo extends StatelessWidget {
  final double fontSize;
  const ReCircularLogo({super.key, this.fontSize = 36});

  @override
  Widget build(BuildContext context) {
    return Text(
      'RE-CIRCULAR',
      style: GoogleFonts.permanentMarker(
        fontSize: fontSize,
        color: AppColors.primary,
        height: 1,
      ),
    );
  }
}

// ── Bottom Nav ────────────────────────────────
class ReCircularBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ReCircularBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      decoration: const BoxDecoration(
        color: AppColors.darkBrown,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.public, label: 'Descubrir', active: currentIndex == 0, onTap: () => onTap(0)),
          _NavItem(icon: Icons.shopping_bag_outlined, label: 'Pedidos', active: currentIndex == 1, onTap: () => onTap(1)),
          _NavItem(icon: Icons.notifications_none, label: 'Alertas', active: currentIndex == 2, onTap: () => onTap(2)),
          _NavItem(icon: Icons.phone_outlined, label: 'Contacto', active: currentIndex == 3, onTap: () => onTap(3)),
          _NavItem(icon: Icons.person_outline, label: 'Perfil', active: currentIndex == 4, onTap: () => onTap(4)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.navActive : AppColors.navInactive;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }
}

// ── Avatar Circle ─────────────────────────────
class AvatarCircle extends StatelessWidget {
  final String initial;
  final int color;
  final double size;

  const AvatarCircle({super.key, required this.initial, required this.color, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: Color(color), shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.permanentMarker(fontSize: size * 0.38, color: Colors.white),
      ),
    );
  }
}

// ── Section Card ──────────────────────────────
class SectionCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final EdgeInsets? padding;

  const SectionCard({super.key, required this.child, this.color, this.borderColor, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        border: Border.all(color: borderColor ?? AppColors.surfaceBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
}

// ── Green Card ────────────────────────────────
class GreenCard extends StatelessWidget {
  final Widget child;
  const GreenCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greenCard,
        border: Border.all(color: AppColors.greenBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }
}

// ── Underline Text Field ──────────────────────
class UInput extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool greenStyle;
  final Widget? prefix;

  const UInput({
    super.key,
    this.label,
    this.placeholder,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.greenStyle = false,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = greenStyle ? const Color(0xFF3A5A2A) : AppColors.primary;
    final borderColor = greenStyle ? const Color(0xFF7A9A6A) : const Color(0xFF9A8A7A);
    final focusColor = greenStyle ? const Color(0xFF3A6A2A) : AppColors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(label!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: labelColor, letterSpacing: 0.7)),
          ),
        Row(
          children: [
            if (prefix != null) ...[prefix!, const SizedBox(width: 8)],
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: obscureText,
                style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: borderColor, width: 1.5)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: focusColor, width: 1.5)),
                  isDense: true,
                  contentPadding: const EdgeInsets.only(bottom: 6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Custom Radio ──────────────────────────────
class CustomRadio extends StatelessWidget {
  final bool checked;
  final VoidCallback onTap;
  final String label;

  const CustomRadio({super.key, required this.checked, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              color: checked ? AppColors.primary : Colors.white,
            ),
            child: checked ? const Center(child: CircleAvatar(radius: 3.5, backgroundColor: Colors.white)) : null,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        ],
      ),
    );
  }
}

// ── Custom Checkbox ───────────────────────────
class CustomCheck extends StatelessWidget {
  final bool checked;
  final VoidCallback onTap;
  final String label;

  const CustomCheck({super.key, required this.checked, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: AppColors.greenDark, width: 2),
              color: checked ? AppColors.greenDark : Colors.white,
            ),
            alignment: Alignment.center,
            child: checked ? const Text('✕', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)) : null,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        ],
      ),
    );
  }
}

// ── Primary Button ────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;

  const PrimaryButton({super.key, required this.label, required this.onTap, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color ?? AppColors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor ?? Colors.white)),
      ),
    );
  }
}

// ── Toast ─────────────────────────────────────
void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
      backgroundColor: AppColors.darkBrown,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(milliseconds: 2300),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    ),
  );
}

// ── Status Badge ──────────────────────────────
class StatusBadge extends StatelessWidget {
  final String estado;
  const StatusBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (estado) {
      'done'    => ('Completada', const Color(0xFFE8F4ED), const Color(0xFF3A8A4A)),
      'pending' => ('Pendiente',  const Color(0xFFFFF3CD), const Color(0xFF8A6A2A)),
      'transit' => ('En tránsito',const Color(0xFFE8F0FC), const Color(0xFF3A6A8A)),
      _         => (estado, Colors.grey.shade100, Colors.grey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}
