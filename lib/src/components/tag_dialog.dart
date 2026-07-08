import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';

/// Diálogo reutilizável para adicionar/remover a tag de um ou mais produtos.
///
/// Retorna via [Navigator.pop]:
/// - `null`  -> cancelado (nenhuma ação)
/// - `""`    -> remover a tag
/// - texto   -> salvar a tag informada
class TagDialog extends StatefulWidget {
  const TagDialog({super.key, required this.initialTag, required this.selectedCount, required this.suggestions});

  final String initialTag;
  final int selectedCount;
  final List<String> suggestions;

  @override
  State<TagDialog> createState() => _TagDialogState();
}

class _TagDialogState extends State<TagDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTag);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _text => _controller.text.trim();

  void _save() {
    if (_text.isEmpty) return;
    Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final bool hasInitial = widget.initialTag.trim().isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorSecondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.sell_rounded, color: colorSecondary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Adicionar tag", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(
                        "${widget.selectedCount} produto${widget.selectedCount == 1 ? '' : 's'} selecionado${widget.selectedCount == 1 ? '' : 's'}",
                        style: TextStyle(fontSize: 12, color: onSurface.withValues(alpha: 0.55)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Campo
            TextField(
              controller: _controller,
              autofocus: true,
              maxLength: 20,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                hintText: "Ex: Promoção",
                prefixIcon: const Icon(Icons.local_offer_outlined, size: 20),
                filled: true,
                fillColor: onSurface.withValues(alpha: 0.04),
                counterStyle: TextStyle(fontSize: 11, color: onSurface.withValues(alpha: 0.5)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: onSurface.withValues(alpha: 0.12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: colorSecondary, width: 1.5),
                ),
              ),
            ),
            // Sugestões
            if (widget.suggestions.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text("Sugestões", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: onSurface.withValues(alpha: 0.6))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.suggestions.map((tag) {
                  final bool selected = _text.toUpperCase() == tag.toUpperCase();
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      _controller.text = tag;
                      _controller.selection = TextSelection.collapsed(offset: tag.length);
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected ? colorSecondary.withValues(alpha: 0.15) : onSurface.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: selected ? colorSecondary : Colors.transparent, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sell_rounded, size: 12, color: selected ? colorSecondary : onSurface.withValues(alpha: 0.5)),
                          const SizedBox(width: 4),
                          Text(
                            tag,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: selected ? colorSecondary : onSurface.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),
            // Ações
            Row(
              children: [
                if (hasInitial)
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(""),
                    style: TextButton.styleFrom(foregroundColor: colorRed),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text("Remover"),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(foregroundColor: colorGreyDark),
                  child: const Text("Cancelar"),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  onPressed: _text.isEmpty ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorSecondary,
                    foregroundColor: colorWhite,
                    disabledBackgroundColor: colorSecondary.withValues(alpha: 0.3),
                    disabledForegroundColor: colorWhite,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("Salvar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
