import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/venda_cnpj/cnpj_input_formatter.dart';
import 'package:profair/src/views/venda_cnpj/venda_cnpj_controller.dart';
import 'package:profair/src/views/venda_cnpj/venda_cnpj_model.dart';
import 'package:profair/src/views/venda_cnpj/venda_cnpj_repository.dart';

/// Tela de "Vendas com CNPJ": o fornecedor digita o CNPJ, consulta os dados na
/// BrasilAPI, informa o comprador e salva. Pode adicionar vários CNPJs e depois
/// seguir para a seleção de loja (selectstore) no fluxo normal de venda.
class VendaCnpj extends StatefulWidget {
  const VendaCnpj({super.key, required this.homeController});

  final HomeController homeController;

  @override
  State<VendaCnpj> createState() => _VendaCnpjState();
}

class _VendaCnpjState extends State<VendaCnpj> {
  final VendaCnpjController controller =
      VendaCnpjController(VendaCnpjRepository());

  final cnpjCtrl = TextEditingController();
  final nomeCtrl = TextEditingController();
  final telCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  String? _lastRequestedCnpj;

  @override
  void dispose() {
    cnpjCtrl.dispose();
    nomeCtrl.dispose();
    telCtrl.dispose();
    emailCtrl.dispose();
    controller.dispose();
    super.dispose();
  }

  void _onCnpjChanged(String value) {
    final digits = cnpjDigits(value);
    if (digits.length != 14) {
      _lastRequestedCnpj = null;
      controller.limparConsulta();
      return;
    }
    if (_lastRequestedCnpj == digits) return;

    _lastRequestedCnpj = digits;
    FocusScope.of(context).unfocus();
    controller.consultar(digits);
  }

  Future<void> _salvar() async {
    if (nomeCtrl.text.trim().isEmpty) {
      _toast("Informe o nome de quem está comprando.");
      return;
    }
    final ok = await controller.salvarCnpjConsultado(
      codAcessoFornecedor: widget.homeController.data?.codAccess,
      nome: nomeCtrl.text.trim(),
      telefone: telCtrl.text.trim(),
      email: emailCtrl.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      cnpjCtrl.clear();
      _lastRequestedCnpj = null;
      controller.limparConsulta();
      _toast("CNPJ adicionado com sucesso.");
    } else {
      _toast(controller.errorMessage ?? "Erro ao salvar.");
    }
  }

  Future<void> _continuar() async {
    if (controller.codAcesso == null) {
      _toast("Adicione ao menos um CNPJ antes de continuar.");
      return;
    }
    // Busca o client recém-criado (mesmo endpoint usado pelo scanner) e segue
    // para a selectstore com os mesmos argumentos do fluxo atual.
    final LoginModel? client =
        await widget.homeController.findClient(controller.codAcesso.toString());
    if (!mounted) return;
    if (client == null) {
      _toast("Não foi possível carregar o cliente cadastrado.");
      return;
    }
    Navigator.of(context).pushNamed("selectstore", arguments: {
      "client": client,
      "codeProvider": widget.homeController.data!.codCompany,
      "consult": widget.homeController.data!.userCode,
    });
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vendas com CNPJ"),
        backgroundColor: colorSecondary,
        foregroundColor: colorWhite,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(appPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==== CNPJ ====
              Text(
                "CNPJ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: appPadding),
              ValueListenableBuilder<StateApp>(
                valueListenable: controller.stateConsult,
                builder: (context, state, _) {
                  return TextField(
                    controller: cnpjCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: const [CnpjInputFormatter()],
                    onChanged: _onCnpjChanged,
                    decoration: _decoration("00.000.000/0000-00").copyWith(
                      helperText:
                          "A consulta será feita automaticamente ao completar o CNPJ.",
                      errorText: state == StateApp.error
                          ? controller.errorMessage
                          : null,
                      suffixIcon: state == StateApp.loading
                          ? const Padding(
                              padding: EdgeInsets.all(13),
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorSecondary,
                                ),
                              ),
                            )
                          : state == StateApp.success
                              ? const Icon(
                                  Icons.check_circle_outline,
                                  color: colorGreen,
                                )
                              : null,
                    ),
                  );
                },
              ),

              const SizedBox(height: appPadding),

              // ==== Resultado da consulta ====
              ValueListenableBuilder(
                valueListenable: controller.consulted,
                builder: (context, CnpjModel? cnpj, _) {
                  if (cnpj == null) return const SizedBox.shrink();
                  return _consultedCard(cnpj);
                },
              ),

              // ==== Lojas já adicionadas ====
              ValueListenableBuilder(
                valueListenable: controller.added,
                builder: (context, List<CnpjModel> lojas, _) {
                  if (lojas.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: appPadding),
                      Text("Lojas adicionadas (${lojas.length})",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface)),
                      const SizedBox(height: 8),
                      ...lojas.map((l) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading:
                                const Icon(Icons.store, color: colorSecondary),
                            title:
                                Text(l.razaoSocial ?? l.nomeFantasia ?? l.cnpj),
                            subtitle: Text(_formatCnpj(l.cnpj)),
                          )),
                    ],
                  );
                },
              ),

              const SizedBox(height: appPadding * 2),

              // ==== Continuar ====
              ValueListenableBuilder(
                valueListenable: controller.added,
                builder: (context, List<CnpjModel> lojas, _) {
                  if (lojas.isEmpty) return const SizedBox.shrink();
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _continuar,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: colorSecondary),
                        foregroundColor: colorSecondary,
                      ),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Continuar para a venda"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _consultedCard(CnpjModel cnpj) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(appRadius),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _info("Razão social", cnpj.razaoSocial),
          _info("Nome fantasia", cnpj.nomeFantasia),
          _info("Código", cnpj.codigoNatureza),
          _info(
              "Cidade",
              [cnpj.municipio, cnpj.uf]
                  .where((e) => e != null && e.isNotEmpty)
                  .join(" - ")),
          _info("Telefone", cnpj.telefone),
          _info("Situação cadastral", cnpj.situacaoCadastral),
          _info(
              "Capital social",
              cnpj.capitalSocial != null
                  ? _formatCurrency(cnpj.capitalSocial!)
                  : null),
          _info("E-mail", cnpj.email),
          const Divider(height: appPadding * 2),
          Text(
            "Quem está comprando",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: appPadding),
          _field(nomeCtrl, "Nome", TextInputType.name),
          const SizedBox(height: 10),
          _field(
            telCtrl,
            "Telefone",
            TextInputType.phone,
            inputFormatters: const [PhoneInputFormatter()],
          ),
          const SizedBox(height: 10),
          _field(emailCtrl, "E-mail", TextInputType.emailAddress),
          const SizedBox(height: appPadding),
          ValueListenableBuilder(
            valueListenable: controller.stateSave,
            builder: (context, state, _) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state == StateApp.loading ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorSecondary,
                    foregroundColor: colorWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: state == StateApp.loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: colorWhite))
                      : const Icon(Icons.add),
                  label: const Text("Adicionar loja"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _info(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: cs.onSurface.withValues(alpha: 0.55))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    TextInputType type, {
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      inputFormatters: inputFormatters,
      decoration: _decoration(label),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(appRadius)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  String _formatCnpj(String digits) {
    if (digits.length != 14) return digits;
    return "${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8, 12)}-${digits.substring(12)}";
  }

  String _formatCurrency(num amount) {
    final v = amount.toDouble().toStringAsFixed(2).replaceAll('.', ',');
    return "R\$ $v";
  }
}
