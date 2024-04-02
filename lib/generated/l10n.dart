// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get text_login {
    return Intl.message(
      'Login',
      name: 'text_login',
      desc: '',
      args: [],
    );
  }

  /// `E-mail`
  String get text_email {
    return Intl.message(
      'E-mail',
      name: 'text_email',
      desc: '',
      args: [],
    );
  }

  /// `Senha`
  String get text_password {
    return Intl.message(
      'Senha',
      name: 'text_password',
      desc: '',
      args: [],
    );
  }

  /// `Nâo possuí conta?`
  String get text_not_have_account {
    return Intl.message(
      'Nâo possuí conta?',
      name: 'text_not_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Registro`
  String get text_register {
    return Intl.message(
      'Registro',
      name: 'text_register',
      desc: '',
      args: [],
    );
  }

  /// `Ao clicar acima você aceita os`
  String get text_clicking_above {
    return Intl.message(
      'Ao clicar acima você aceita os',
      name: 'text_clicking_above',
      desc: '',
      args: [],
    );
  }

  /// `termos e condições.`
  String get text_terms_conditions {
    return Intl.message(
      'termos e condições.',
      name: 'text_terms_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Bem vindo`
  String get text_welcome {
    return Intl.message(
      'Bem vindo',
      name: 'text_welcome',
      desc: '',
      args: [],
    );
  }

  /// `Saldo`
  String get text_balance {
    return Intl.message(
      'Saldo',
      name: 'text_balance',
      desc: '',
      args: [],
    );
  }

  /// `Popular`
  String get text_popular {
    return Intl.message(
      'Popular',
      name: 'text_popular',
      desc: '',
      args: [],
    );
  }

  /// `Compartilhado`
  String get text_shared {
    return Intl.message(
      'Compartilhado',
      name: 'text_shared',
      desc: '',
      args: [],
    );
  }

  /// `Escanear QrCode`
  String get text_scanner {
    return Intl.message(
      'Escanear QrCode',
      name: 'text_scanner',
      desc: '',
      args: [],
    );
  }

  /// `Notificações`
  String get text_notifications {
    return Intl.message(
      'Notificações',
      name: 'text_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Últimas pedidos`
  String get text_last_orders {
    return Intl.message(
      'Últimas pedidos',
      name: 'text_last_orders',
      desc: '',
      args: [],
    );
  }

  /// `Selecione a loja`
  String get text_select_branch {
    return Intl.message(
      'Selecione a loja',
      name: 'text_select_branch',
      desc: '',
      args: [],
    );
  }

  /// `Fornecedores`
  String get text_select_provider {
    return Intl.message(
      'Fornecedores',
      name: 'text_select_provider',
      desc: '',
      args: [],
    );
  }

  /// `Negociações`
  String get text_trading {
    return Intl.message(
      'Negociações',
      name: 'text_trading',
      desc: '',
      args: [],
    );
  }

  /// `Lojas`
  String get text_store {
    return Intl.message(
      'Lojas',
      name: 'text_store',
      desc: '',
      args: [],
    );
  }

  /// `Produtos`
  String get text_products {
    return Intl.message(
      'Produtos',
      name: 'text_products',
      desc: '',
      args: [],
    );
  }

  /// `Pedidos Realizados`
  String get text_orders_placed {
    return Intl.message(
      'Pedidos Realizados',
      name: 'text_orders_placed',
      desc: '',
      args: [],
    );
  }

  /// `Pesquisar`
  String get text_search {
    return Intl.message(
      'Pesquisar',
      name: 'text_search',
      desc: '',
      args: [],
    );
  }

  /// `Programação`
  String get text_schedule {
    return Intl.message(
      'Programação',
      name: 'text_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Produtos disponíveis`
  String get text_avaiable_products {
    return Intl.message(
      'Produtos disponíveis',
      name: 'text_avaiable_products',
      desc: '',
      args: [],
    );
  }

  /// `Clientes`
  String get text_customers {
    return Intl.message(
      'Clientes',
      name: 'text_customers',
      desc: '',
      args: [],
    );
  }

  /// `Pedidos de Clientes`
  String get text_requesting_customers {
    return Intl.message(
      'Pedidos de Clientes',
      name: 'text_requesting_customers',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
