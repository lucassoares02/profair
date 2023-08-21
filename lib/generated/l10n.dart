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

  /// `Password`
  String get text_password {
    return Intl.message(
      'Password',
      name: 'text_password',
      desc: '',
      args: [],
    );
  }

  /// `Not have an account?`
  String get text_not_have_account {
    return Intl.message(
      'Not have an account?',
      name: 'text_not_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get text_register {
    return Intl.message(
      'Register',
      name: 'text_register',
      desc: '',
      args: [],
    );
  }

  /// `By clicking above you accept the`
  String get text_clicking_above {
    return Intl.message(
      'By clicking above you accept the',
      name: 'text_clicking_above',
      desc: '',
      args: [],
    );
  }

  /// `terms and conditions.`
  String get text_terms_conditions {
    return Intl.message(
      'terms and conditions.',
      name: 'text_terms_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get text_welcome {
    return Intl.message(
      'Welcome',
      name: 'text_welcome',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get text_balance {
    return Intl.message(
      'Balance',
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

  /// `Shared`
  String get text_shared {
    return Intl.message(
      'Shared',
      name: 'text_shared',
      desc: '',
      args: [],
    );
  }

  /// `Scan QrCode`
  String get text_scanner {
    return Intl.message(
      'Scan QrCode',
      name: 'text_scanner',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get text_notifications {
    return Intl.message(
      'Notifications',
      name: 'text_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Last Orders`
  String get text_last_orders {
    return Intl.message(
      'Last Orders',
      name: 'text_last_orders',
      desc: '',
      args: [],
    );
  }

  /// `Select the branch`
  String get text_select_branch {
    return Intl.message(
      'Select the branch',
      name: 'text_select_branch',
      desc: '',
      args: [],
    );
  }

  /// `Providers`
  String get text_select_provider {
    return Intl.message(
      'Providers',
      name: 'text_select_provider',
      desc: '',
      args: [],
    );
  }

  /// `Tradings`
  String get text_trading {
    return Intl.message(
      'Tradings',
      name: 'text_trading',
      desc: '',
      args: [],
    );
  }

  /// `Stores`
  String get text_store {
    return Intl.message(
      'Stores',
      name: 'text_store',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get text_products {
    return Intl.message(
      'Products',
      name: 'text_products',
      desc: '',
      args: [],
    );
  }

  /// `Orders placed`
  String get text_orders_placed {
    return Intl.message(
      'Orders placed',
      name: 'text_orders_placed',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get text_search {
    return Intl.message(
      'Search',
      name: 'text_search',
      desc: '',
      args: [],
    );
  }

  /// `Fair Schedule`
  String get text_schedule {
    return Intl.message(
      'Fair Schedule',
      name: 'text_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Avaiable products`
  String get text_avaiable_products {
    return Intl.message(
      'Avaiable products',
      name: 'text_avaiable_products',
      desc: '',
      args: [],
    );
  }

  /// `Customers`
  String get text_customers {
    return Intl.message(
      'Customers',
      name: 'text_customers',
      desc: '',
      args: [],
    );
  }

  /// `Requesting Clients`
  String get text_requesting_customers {
    return Intl.message(
      'Requesting Clients',
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
