import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../models/app_state.dart';

class FeedScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onProfile;

  const FeedScreen({super.key, required this.appState, required this.onProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top bar
          Container(
            color: AppColors.background,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 14, right: 14, bottom: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: onProfile, icon: const Icon(Icons.upload, color: AppColors.textMid, size: 22), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                    const ReCircularLogo(fontSize: 26),
                    const Icon(Icons.search, color: AppColors.textMid, size: 22),
                  ],
                ),
                const SizedBox(height: 10),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(label: 'Personalizados', active: true),
                      const SizedBox(width: 6),
                      _FilterChip(label: 'Catálogos cafetería'),
                      const SizedBox(width: 6),
                      _FilterChip(label: 'Plásticos Reciclados'),
                      const SizedBox(width: 6),
                      _FilterChip(label: 'Más Filtros...'),
                      const SizedBox(width: 6),
                      const Icon(Icons.filter_list, size: 18, color: AppColors.textMid),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Quick actions
                _QuickActions(appState: appState),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFD0C8BC)),

          // Feed list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: appState.posts.length,
              itemBuilder: (context, i) => _PostCard(post: appState.posts[i], context: context),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  const _FilterChip({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? AppColors.greenCard : const Color(0xFFE0DBD2),
        border: Border.all(color: active ? AppColors.greenBorder : const Color(0xFFC0B8AC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: active ? const Color(0xFF3A5A30) : AppColors.textMid, whiteSpace: null)),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final AppState appState;
  const _QuickActions({required this.appState});

  @override
  Widget build(BuildContext context) {
    final actions = appState.userType == 'empresa'
        ? [('+ Publicar residuo', AppColors.primary), ('+ Buscar catálogo', AppColors.greenDark)]
        : [('+ Publicar residuo', AppColors.primary), ('+ Ver catálogos', AppColors.greenDark), ('Mi catálogo', const Color(0xFF5A6A8A))];

    return Wrap(
      spacing: 6, runSpacing: 6,
      children: actions.map((a) => GestureDetector(
        onTap: () => showToast(context, '${a.$1} próximamente'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: a.$2, borderRadius: BorderRadius.circular(8)),
          child: Text(a.$1, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
      )).toList(),
    );
  }
}

class _PostCard extends StatefulWidget {
  final Post post;
  final BuildContext context;
  const _PostCard({required this.post, required this.context});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    final modeColor = p.mode == 'ofrece' ? const Color(0xFF5A7A4A) : const Color(0xFF6A3A8A);
    final modeBg = p.mode == 'ofrece' ? const Color(0xFFE8F4E0) : const Color(0xFFF0E8F8);
    final modeLabel = p.mode == 'ofrece' ? 'OFRECE' : 'BUSCA';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0xFFD5CEC5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Row(
              children: [
                AvatarCircle(initial: p.initial, color: p.color, size: 44),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                          if (p.verified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, size: 13, color: Color(0xFF5A8A4A)),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          Text(p.contact, style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: p.type == 'empresa' ? const Color(0xFFE8F0FC) : const Color(0xFFFFF3CD),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              p.type == 'empresa' ? 'Empresa' : 'PYME',
                              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: p.type == 'empresa' ? const Color(0xFF3A6A8A) : const Color(0xFF8A6A2A)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: modeBg, borderRadius: BorderRadius.circular(7)),
                  child: Text(modeLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: modeColor)),
                ),
              ],
            ),
          ),

          // Desc
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(p.desc, style: const TextStyle(fontSize: 12, color: AppColors.textMid, height: 1.4)),
          ),
          const SizedBox(height: 10),

          // Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 6, runSpacing: 6,
              children: List.generate(p.items.length, (i) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(p.itemColors[i]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${p.itemEmojis[i]} ${p.items[i]}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              )),
            ),
          ),
          const SizedBox(height: 10),

          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                _ActionBtn(icon: Icons.handshake_outlined, label: 'Conectar', onTap: () => showToast(context, '🤝 Solicitud enviada')),
                const SizedBox(width: 8),
                _ActionBtn(icon: Icons.chat_bubble_outline, label: 'Mensaje', onTap: () => showToast(context, '💬 Chat próximamente')),
                const Spacer(),
                if (p.hasCatalog)
                  GestureDetector(
                    onTap: () => showToast(context, '📦 Ver catálogo próximamente'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(8)),
                      child: const Text('Ver catálogo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFD8D4CC),
          border: Border.all(color: const Color(0xFFC4BDB4)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13, color: AppColors.textMid),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMid)),
          ],
        ),
      ),
    );
  }
}
