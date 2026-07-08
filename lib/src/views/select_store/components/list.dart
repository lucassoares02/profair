import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/models/clients_select_stores_model.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  const ComponentList({
    super.key,
    this.description,
    required this.listItems,
    required this.state,
    required this.codeProvider,
    this.consult,
    required this.client,
  });

  final List<ClientsSelectStoreModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final int? consult;
  final LoginModel? client;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(icon: Icons.store_mall_directory_outlined, label: "Lojas"),
      component: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            _buildHeader(context, width),
            _buildStoreCountBadge(),
            _buildStoreList(width),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double width) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [colorSecondary, colorPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: _decorativeCircle(120, colorWhite, 0.06),
          ),
          Positioned(
            top: 40,
            right: 50,
            child: _decorativeCircle(60, colorWhite, 0.04),
          ),
          Positioned(
            bottom: 20,
            left: -20,
            child: _decorativeCircle(80, colorWhite, 0.05),
          ),
          // Content
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Quando a tela está sozinha na pilha (fluxo "Novo pedido"),
                      // não há para onde dar pop — voltar deve ir para a home,
                      // evitando a tela preta.
                      if (Navigator.of(context).canPop()) {
                        Navigator.pop(context);
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back_ios_new, color: colorWhite, size: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Avatar + greeting
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: appPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar circle with initials
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorWhite.withValues(alpha: 0.2),
                          border: Border.all(color: colorWhite.withValues(alpha: 0.5), width: 2),
                        ),
                        child: Center(
                          child: Text(
                            _initials(widget.client?.nameUser),
                            style: const TextStyle(
                              color: colorWhite,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Name + greeting
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: colorWhite.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.waving_hand_rounded, color: colorWhite, size: 13),
                                      SizedBox(width: 4),
                                      Text(
                                        "Boas-vindas",
                                        style: TextStyle(
                                          color: colorWhite,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.client?.nameUser ?? '',
                              style: const TextStyle(
                                color: colorWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 58),
                // Bottom wave clip
                ClipPath(
                  clipper: _WaveClipper(),
                  child: Container(
                    height: 28,
                    color: colorSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCountBadge() {
    final count = widget.listItems.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(appPadding, 16, appPadding, 4),
      child: Row(
        children: [
          const Text(
            "Selecione uma loja",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [colorSecondary, colorPrimary],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count ${count == 1 ? 'loja' : 'lojas'}',
              style: const TextStyle(
                color: colorWhite,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreList(double width) {
    return Column(
      children: widget.listItems.asMap().entries.map((e) {
        return _StoreCard(
          index: e.key,
          store: e.value,
          onTap: () {
            for (var i = 0; i < widget.listItems.length; i++) {
              widget.listItems[i].checked = (i == e.key);
            }
            Navigator.of(context).pushNamed(
              'selectnegotiation',
              arguments: {
                "new": 1,
                "codeProvider": widget.codeProvider,
                "nameBranch": e.value.nameCompany,
                "codeBranch": e.value.relationshipCode,
                "codeClient": widget.client!.userCode,
                "client": widget.client,
                "listBranchs": widget.listItems,
                "consult": widget.consult,
              },
            );
          },
        );
      }).toList(),
    );
  }

  Widget _decorativeCircle(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}

class _StoreCard extends StatefulWidget {
  const _StoreCard({required this.index, required this.store, required this.onTap});

  final int index;
  final ClientsSelectStoreModel store;
  final VoidCallback onTap;

  @override
  State<_StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<_StoreCard> {
  bool _pressed = false;

  // Cycles through gradient pairs for each store card
  static const List<List<Color>> _gradients = [
    [Color(0xFF6e41ff), Color(0xFFb16cff)],
    [Color(0xFF984063), Color(0xFFf64668)],
    [Color(0xFF28374D), Color(0xFF41436a)],
    [Color(0xFF731b53), Color(0xFF984063)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[widget.index % _gradients.length];
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colorGrey.withValues(alpha: 0.3)))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.store_mall_directory_outlined, color: colorWhite, size: 22),
              ),
            ),
            // Store info
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   widget.store.documentCompany ?? '',
                    //   style: const TextStyle(
                    //     fontSize: 11,
                    //     letterSpacing: 0.3,
                    //   ),
                    // ),
                    // const SizedBox(height: 3),
                    Text(
                      widget.store.documentCompany ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.store.city != null && widget.store.city!.trim().isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 13, color: colorGreyDark.withValues(alpha: 0.8)),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              widget.store.city!,
                              style: TextStyle(
                                fontSize: 12,
                                color: colorGreyDark.withValues(alpha: 0.9),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Chevron
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Icon(Icons.chevron_right_rounded, color: colors[0], size: 26),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.75, size.height * 1.2, size.width, size.height * 0.4);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
