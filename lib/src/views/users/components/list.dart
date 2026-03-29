import 'package:profair/src/controllers/users_controller.dart';
import 'package:profair/src/models/users_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

String _formatCpf(String? doc) {
  if (doc == null || doc.length < 11) return doc ?? '-';
  final d = doc.replaceAll(RegExp(r'\D'), '');
  if (d.length != 11) return doc;
  return '${d.substring(0, 3)}.${d.substring(3, 6)}.${d.substring(6, 9)}-${d.substring(9)}';
}

String _formatCnpj(String? doc) {
  if (doc == null || doc.length < 14) return doc ?? '-';
  final d = doc.replaceAll(RegExp(r'\D'), '');
  if (d.length != 14) return doc;
  return '${d.substring(0, 2)}.${d.substring(2, 5)}.${d.substring(5, 8)}/${d.substring(8, 12)}-${d.substring(12)}';
}

String _initials(String? name) {
  if (name == null || name.isEmpty) return '?';
  final parts = name.trim().split(' ');
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
}

class _UserType {
  final String label;
  final Color color;
  const _UserType(this.label, this.color);
}

_UserType _typeInfo(int? type) {
  if (type == 1) return const _UserType('Vendedor', Color(0xFF1B8A4C));
  if (type == 2) return _UserType('Gestor', colorSecondary);
  return _UserType('Admin', colorPrimary);
}

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    this.description,
    required this.listItems,
    required this.state,
    required this.usersController,
  });

  Iterable<UsersModel> listItems;
  final String? description;
  final ValueListenable state;
  final UsersController usersController;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  void _showUserDialog(BuildContext context, UsersModel e, double width) {
    final info = _typeInfo(e.typeAcess);
    showDialog(
      context: context,
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final surfaceColor = isDark ? scheme.surface : Colors.white;
        final onSurface = isDark ? scheme.onSurface : const Color(0xFF1A1A2E);
        final subtleColor = isDark ? scheme.onSurface.withOpacity(0.5) : const Color(0xFF767676);
        final chipBg = isDark ? scheme.onSurface.withOpacity(0.06) : const Color(0xFFF4F4F8);

        return Dialog(
          backgroundColor: surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // — Header: avatar + nome + badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Avatar(name: e.nameUser, size: 48, color: info.color, present: e.present),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.nameUser ?? '-',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: onSurface,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _TypeBadge(label: info.label, color: info.color),
                              const SizedBox(width: 6),
                              _PresenceBadge(present: e.present),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () => Navigator.of(context).pop(),
                    //   icon: Icon(Icons.close_rounded, color: subtleColor, size: 20),
                    //   padding: EdgeInsets.zero,
                    //   constraints: const BoxConstraints(),
                    // ),
                  ],
                ),

                const SizedBox(height: 20),

                // — QR Code
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: RepaintBoundary(
                      key: GlobalKey(),
                      child: QrImageView(
                        data: e.codeAcess ?? '',
                        version: QrVersions.auto,
                        size: width * 0.68,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // — Info grid
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.badge_outlined,
                        label: 'CPF',
                        value: _formatCpf(e.documentUser),
                        onSurface: onSurface,
                        subtle: subtleColor,
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.tag_rounded,
                        label: 'Código do usuário',
                        value: '#${e.codeUser ?? '-'}',
                        onSurface: onSurface,
                        subtle: subtleColor,
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.storefront_outlined,
                        label: 'Fornecedor',
                        value: e.nameProvider ?? '-',
                        onSurface: onSurface,
                        subtle: subtleColor,
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.receipt_long_outlined,
                        label: 'CNPJ',
                        value: _formatCnpj(e.documentProvider),
                        onSurface: onSurface,
                        subtle: subtleColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(
        icon: Icons.groups_2_sharp,
        label: widget.description,
        loadingHeader: false,
      ),
      component: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: widget.usersController.stateUsers,
            builder: (context, value, child) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final subtleColor = isDark ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5) : const Color(0xFF767676);

              return Column(
                children: widget.listItems.map((e) {
                  final info = _typeInfo(e.typeAcess);
                  return InkWell(
                    onTap: () => _showUserDialog(context, e, width),
                    borderRadius: BorderRadius.circular(0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: appMargin + 4,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          _Avatar(name: e.nameUser, size: 44, color: info.color, present: e.present),
                          const SizedBox(width: 14),

                          // Body
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.nameUser ?? '-',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  e.nameProvider ?? '-',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: subtleColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          _TypeBadge(label: info.label, color: info.color),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// — Widgets auxiliares

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.size, required this.color, this.present});
  final String? name;
  final double size;
  final Color color;
  final bool? present;

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E2E) : Colors.white;

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(name),
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: present == true ? const Color(0xFF1B8A4C) : const Color(0xFFBDBDBD),
              shape: BoxShape.circle,
              border: Border.all(color: bg, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _PresenceBadge extends StatelessWidget {
  const _PresenceBadge({this.present});
  final bool? present;

  @override
  Widget build(BuildContext context) {
    final isPresent = present == true;
    final color = isPresent ? const Color(0xFF1B8A4C) : const Color(0xFF9E9E9E);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            isPresent ? 'Presente' : 'Ausente',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onSurface,
    required this.subtle,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color onSurface;
  final Color subtle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colorPrimary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: subtle, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
    );
  }
}
