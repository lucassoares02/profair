import 'dart:io';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:profair/firebase_options.dart';
import 'package:profair/src/app_module.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:profair/src/navigation/app_route_observer.dart';
import 'package:profair/src/theme/app_theme.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: Platform.isAndroid ? null : DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ModularApp(
    module: AppModule(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Modular.setInitialRoute('/splash');
    Modular.setObservers([appRouteObserver]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "profair",
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        S.delegate,
      ],
      debugShowCheckedModeBanner: false,
      supportedLocales: S.delegate.supportedLocales,
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.system,
      routerDelegate: Modular.routerDelegate,
      routeInformationParser: Modular.routeInformationParser,
      builder: (context, child) => _AssociateQrOverlay(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

class _AssociateQrOverlay extends StatefulWidget {
  const _AssociateQrOverlay({required this.child});

  final Widget child;

  @override
  State<_AssociateQrOverlay> createState() => _AssociateQrOverlayState();
}

class _AssociateQrOverlayState extends State<_AssociateQrOverlay> {
  Timer? _refreshTimer;
  String? _accessTargeting;
  String? _codAccess;
  bool _dialogOpen = false;

  bool get _canShowButton {
    final code = _codAccess?.trim();
    return _accessTargeting == "2" &&
        code != null &&
        code.isNotEmpty &&
        code != "null" &&
        !_dialogOpen;
  }

  String get _qrData => "0x9E89738274392874.$_codAccess.9327329847372939";

  @override
  void initState() {
    super.initState();
    _loadSession();
    _refreshTimer =
        Timer.periodic(const Duration(seconds: 2), (_) => _loadSession());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final nextAccessTargeting = prefs.getString("direct");
    final nextCodAccess = prefs.getString("codacesso");

    if (!mounted) return;
    if (nextAccessTargeting == _accessTargeting &&
        nextCodAccess == _codAccess) {
      return;
    }

    setState(() {
      _accessTargeting = nextAccessTargeting;
      _codAccess = nextCodAccess;
      if (nextAccessTargeting != "2" ||
          nextCodAccess == null ||
          nextCodAccess.trim().isEmpty ||
          nextCodAccess == "null") {
        _dialogOpen = false;
      }
    });
  }

  void _openQrCode() {
    if (!_canShowButton) return;
    setState(() => _dialogOpen = true);
  }

  void _closeQrCode() {
    setState(() => _dialogOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBackground = Theme.of(context).scaffoldBackgroundColor;
    final buttonColor = Color.lerp(
        scaffoldBackground, isDark ? Colors.white : Colors.black, 0.12)!;
    final iconColor = isDark ? colorWhite : colorTertiary;

    return Stack(
      children: [
        widget.child,
        if (_dialogOpen && _codAccess != null)
          _AssociateQrDialog(
            codAccess: _codAccess!,
            qrData: _qrData,
            onClose: _closeQrCode,
          ),
        if (_canShowButton)
          Align(
            alignment: Alignment.bottomRight,
            child: SafeArea(
              minimum: const EdgeInsets.only(right: 18, bottom: 18),
              child: Material(
                color: buttonColor,
                shape: const CircleBorder(),
                elevation: 6,
                shadowColor: Colors.black.withValues(alpha: 0.18),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _openQrCode,
                  child: SizedBox(
                    width: 58,
                    height: 58,
                    child:
                        Icon(Icons.qr_code_rounded, color: iconColor, size: 30),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AssociateQrDialog extends StatelessWidget {
  const _AssociateQrDialog(
      {required this.codAccess, required this.qrData, required this.onClose});

  final String codAccess;
  final String qrData;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final qrSize = width > 360 ? 260.0 : width - 96;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Positioned.fill(
      child: Stack(
        children: [
          ModalBarrier(
              color: Colors.black.withValues(alpha: 0.45),
              dismissible: true,
              onDismiss: onClose),
          Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: colorSecondary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.qr_code_rounded,
                              color: colorSecondary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "QR Code de Acesso",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Apresente ao fornecedor",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: onSurface.withValues(alpha: 0.55)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onClose,
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorLight,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: colorGreyLigth),
                      ),
                      child: QrImageView(
                        data: qrData,
                        size: qrSize,
                        version: QrVersions.auto,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [colorSecondary, colorPrimary]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        codAccess,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorWhite,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
